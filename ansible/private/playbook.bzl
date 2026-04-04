# Aspect's `py_binary` gives us `venv`, which ensures that the Python that
# Ansible spawns when doing local tasks can load deps.
load("@aspect_rules_py//py:defs.bzl", aspect_py_binary = "py_binary")
load("@rules_python//python/entry_points:py_console_script_binary.bzl", "py_console_script_binary")

def _ansible_playbook_impl(name, visibility, src, collections, data, deps, env, inventory, _pkg):
    addl_data = [src, inventory]
    addl_env = {
        "ANSIBLE_INVENTORY": "$(location {})".format(inventory),
    }

    if collections:
        addl_env["COLLECTIONS_PATH"] = "$(location {})".format(collections)
        addl_data.append(collections)
    
    py_console_script_binary(
        name = name,
        pkg = _pkg,
        script = "ansible-playbook",
        binary_rule = aspect_py_binary,
        args = [
            "$(location {})".format(src),
        ],
        data = addl_data + data,
        deps = deps,
        env = addl_env | env,
    )

ansible_playbook = macro(
    implementation = _ansible_playbook_impl,
    attrs = {
        "src": attr.label(
            doc = "Playbook YAML file.",
            allow_single_file = [".yaml", ".yml"],
            mandatory = True,
            configurable = False,
        ),
        "inventory": attr.label(
            doc = "Inventory YAML file.",
            allow_single_file = [".yaml", ".yml"],
            mandatory = True,
            configurable = False,
        ),
        "collections": attr.label(
            doc = "Collections to use.",
            configurable = False,
        ),
        "data": attr.label_list(
            doc = "Other files which are loaded by the playbook.",
            allow_files = True,
            configurable = False,
        ),
        "deps": attr.label_list(
            doc = "Dependencies, such as collections and Python libraries which they may need.",
        ),
        "env": attr.string_dict(
            doc = "Environment variables to set when running the playbook.",
        ),
        "_pkg": attr.label(
            default = Label("@pypi_ansible//ansible_core"),
            configurable = False,
        ),
    },
)
