def _nixpkgs_git_repository_impl(repository_ctx):
    repository_ctx.file(
        "BUILD",
        content = """
load("@rules_nix//:defs.bzl", "nix_package_repository")

filegroup(name = "srcs", srcs = glob(["**"]), visibility = ["//visibility:public"])

nix_package_repository(
    name = "nixpkgs",
    derivation = "default.nix",
    visibility = ["//visibility:public"],
)
""",
    )

    # Make "@nixpkgs" (syntactic sugar for "@nixpkgs//:nixpkgs") a valid
    # label for default.nix.
    repository_ctx.symlink("default.nix", repository_ctx.name)

    repository_ctx.download_and_extract(
        url = "%s/archive/%s.tar.gz" % (repository_ctx.attr.remote, repository_ctx.attr.revision),
        stripPrefix = "nixpkgs-" + repository_ctx.attr.revision,
        sha256 = repository_ctx.attr.sha256,
    )

nixpkgs_git_repository = repository_rule(
    implementation = _nixpkgs_git_repository_impl,
    attrs = {
        "revision": attr.string(
            mandatory = True,
            doc = "Git commit hash or tag identifying the version of Nixpkgs to use.",
        ),
        "remote": attr.string(
            default = "https://github.com/NixOS/nixpkgs",
            doc = "The URI of the remote Git repository. This must be a HTTP URL. There is currently no support for authentication. Defaults to [upstream nixpkgs](https://github.com/NixOS/nixpkgs).",
        ),
        "sha256": attr.string(doc = "The SHA256 used to verify the integrity of the repository."),
    },
    doc = """Name a specific revision of Nixpkgs on GitHub or a local checkout.""",
)
