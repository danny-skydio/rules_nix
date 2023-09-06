def _impl(ctx):
    # args = ctx.actions.args()
    # args.add("--dir", intermediate_dir.path)
    # args.add_all("--derivation", [ctx.files.derivation])
    # args.add_all(ctx.files.srcs)
    output_file = ctx.actions.declare_file(ctx.label.name + ".output")

    args = [
        "build",
        ctx.file.derivation.path,
        "--output",
        output_file.path,
    ] + [f.path for f in ctx.files.srcs]

    args_file = ctx.actions.declare_file(ctx.label.name + ".args")
    ctx.actions.write(
        output = args_file,
        content = "\n".join(args),
    )

    ctx.actions.run(
        mnemonic = "NixWorker",
        inputs = ctx.files.srcs + [args_file],
        outputs = [output_file],
        arguments = ["@" + args_file.path],
        executable = ctx.executable.worker,
        execution_requirements = {
            "supports-workers": "1",
            "requires-worker-protocol": "json",
        },
    )

    return DefaultInfo(
        files = depset([output_file]),
    )

nix_worker = rule(
    implementation = _impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "derivation": attr.label(allow_single_file = True, mandatory = True),
        "worker": attr.label(
            executable = True,
            cfg = "exec",
            allow_files = True,
            default = Label("//private:persistent_worker"),
        ),
    },
)
