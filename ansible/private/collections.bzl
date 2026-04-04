def _ansible_collections_impl(ctx):
    # Declare the output directory (TreeArtifact)
    output_dir = ctx.actions.declare_directory(ctx.label.name)
    
    tmp_dir = ctx.actions.declare_directory(ctx.label.name + "_tmp")
    cache_dir = ctx.actions.declare_directory(ctx.label.name + "_cache")

    args = ctx.actions.args()
    args.add("collection")
    args.add("install")
    args.add_all(ctx.files.collections)
    # -p specifies the destination. ansible-galaxy automatically
    # appends /ansible_collections to the path provided.
    args.add("-p", output_dir.path)

    ctx.actions.run(
        outputs = [output_dir, tmp_dir, cache_dir],
        inputs = ctx.files.collections,
        executable = ctx.executable._ansible_galaxy,
        arguments = [args],
        mnemonic = "AnsibleGalaxyInstall",
        progress_message = "Installing Ansible collections (%s)" % ctx.label.name,
        env = {
            "ANSIBLE_LOCAL_TEMP": tmp_dir.path,
            "ANSIBLE_GALAXY_CACHE_DIR": cache_dir.path,
        },
    )

    return [DefaultInfo(files = depset([output_dir]))]

ansible_collections = rule(
    implementation = _ansible_collections_impl,
    attrs = {
        "collections": attr.label_list(allow_files = True),
        "_ansible_galaxy": attr.label(
            default = Label("//ansible:ansible-galaxy"),
            executable = True,
            cfg = "exec",
        ),
    },
)
