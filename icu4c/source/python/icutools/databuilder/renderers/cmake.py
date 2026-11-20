# Copyright (C) 2026 and later: Unicode, Inc. and others.
# License & terms of use: http://www.unicode.org/copyright.html

# Python 2/3 Compatibility (ICU-20299)
# TODO(ICU-20301): Remove this.
from __future__ import print_function

from . import *
from .. import *
from .. import utils
from ..request_types import *

CMakeStringVar = namedtuple("CMakeStringVar", ["name", "content"])
CMakeCmd = namedtuple("CMakeCmd", ["cmds"])

def get_cmake_rules(build_dirs, requests, cmake_vars, **kwargs):
    cmake_string = ""

    cmake_rules = []
    for request in requests:
        cmake_rules += get_cmake_rules_helper(request, **kwargs)

    # Main Commands
    for rule in cmake_rules:
        if isinstance(rule, CMakeStringVar):
            cmake_string += "set({NAME}\n[[{CONTENT}\n]]\n)\n\n".format(
                NAME=rule.name, CONTENT=rule.content
            )
            continue
        if isinstance(rule, CMakeCmd):
            cmake_string += "\n".join(rule.cmds)
            continue

    return cmake_string


def files_to_cmake(files, common_vars, wrap=False, **kwargs):
    if len(files) == 0:
        return ""
    dirnames = [utils.dir_for(file).format(**common_vars) for file in files]
    join_str = "\t\t\n"
    if len(files) == 1:
        return "%s/%s" % (dirnames[0], files[0].filename)
    elif len(set(dirnames)) == 1:
        out_list = ""
        for file in files:
            out_list += dirnames[0] + "/" + file.filename + "\n\t\t"
        return out_list
    else:
        return join_str.join("%s/%s" % (d, f.filename) for d, f in zip(dirnames, files))


def get_cmake_tool_var(name):
    return "${ICU_TOOL_PREFIX}%s" % name

def get_cmake_rules_helper(request, common_vars, **kwargs):
    if isinstance(request, PrintFileRequest):
        var_name = "%s_CONTENT" % request.name.upper()
        cmds = []
        # use CONFIGURE avoid rebuild
        cmds.append(
            'file(CONFIGURE OUTPUT "{OUT}" CONTENT "${{{CONTENT}}}")\n'.format(
                OUT=files_to_cmake([request.output_file], common_vars), CONTENT=var_name
            )
        )
        return [
            CMakeStringVar(name=var_name, content=request.content),
            CMakeCmd(cmds=cmds),
        ]

    if isinstance(request, VariableRequest):
        return [
            CMakeCmd(
                cmds=[
                    "set({NAME} {CONTENT})\n".format(
                        NAME=request.name.upper(),
                        CONTENT=files_to_cmake(request.input_files, common_vars),
                    )
                ]
            )
        ]

    if isinstance(request, CopyRequest):
        return [
            CMakeCmd(
                cmds=[
                    """add_custom_command(
    OUTPUT {OUTPUT}
    COMMAND ${{CMAKE_COMMAND}} -E copy_if_newer {INPUT} {OUTPUT}
    DEPENDS {INPUT}
)\n""".format(
                        INPUT=files_to_cmake([request.input_file], common_vars),
                        OUTPUT=files_to_cmake([request.output_file], common_vars),
                    )
                ]
            )
        ]

    if isinstance(request, SingleExecutionRequest):
        args = utils.format_single_request_command(request, "{ARGS}", common_vars)
        cmd = """add_custom_command(
    OUTPUT {OUTPUT}
    COMMAND
        {TOOL} {ARGS}
    DEPENDS
        {INPUT}
)\n""".format(
            OUTPUT=files_to_cmake(request.output_files, common_vars),
            TOOL=get_cmake_tool_var(request.tool.name),
            ARGS=args,
            INPUT=files_to_cmake(request.input_files, common_vars)
        )

        return [CMakeCmd(cmds=[cmd])]

    if isinstance(request, RepeatedExecutionRequest):
        rules = []
        cmd_template = "{ARGS}"
        dep_var_name = ""
        # To keep from repeating the same dep files many times, make a variable.
        if len(request.common_dep_files) > 0:
            dep_var_name = request.name.upper()
            rules += [
                CMakeCmd(
                    cmds=[
                        "set({NAME} {DEPS})\n".format(
                            NAME=dep_var_name,
                            DEPS=files_to_cmake(request.common_dep_files, common_vars),
                        )
                    ]
                )
            ]
        else:
            dep_var_name = ""

        # Add a rule for each individual file.
        for loop_vars in utils.repeated_execution_request_looper(request):
            (_, specific_dep_files, input_file, output_file) = loop_vars
            name_suffix = input_file[
                input_file.filename.rfind("/") + 1 : input_file.filename.rfind(".")
            ]
            cmd = get_cmake_tool_var(request.tool.name) + " " + utils.format_repeated_request_command(
                request, cmd_template, loop_vars, common_vars
            )
            deps = files_to_cmake(specific_dep_files, common_vars)
            if dep_var_name != "":
                deps += " ${%s}" % dep_var_name
            if deps != "":
                deps = "DEPENDS " + deps
            rules += [
                CMakeCmd(
                    cmds=[
                        """add_custom_command(
    OUTPUT {OUTPUT}
    COMMAND {CMD}
    {DEPS}
)
""".format(
                            OUTPUT=files_to_cmake([output_file], common_vars),
                            CMD=cmd,
                            DEPS=deps
                        )
                    ]
                )
            ]
        return rules

    return []
