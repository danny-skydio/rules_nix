load("//private:actions.bzl", "nix_build", "nix_collect_cc", "nix_layer", "nix_wrapper")

NixInfo = provider(
    doc = "NixInfo provides information about the nix toolchain",
    fields = {
        "nix_build_bin_path": "Path to nix-build executable",
        "nix_store_bin_path": "Path to nix-store executable",
        "nix_bin_path": "Path to nix executable",
    },
)

def _nix_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        # Public interface of toolchain
        build = nix_build,
        wrap = nix_wrapper,

        # File collection
        collect_cc = nix_collect_cc,

        # Docker helper actions
        layer = nix_layer,

        # Providers for toolchain actions
        nixinfo = NixInfo(
            nix_build_bin_path = ctx.attr.nix_build_bin_path,
            nix_store_bin_path = ctx.attr.nix_store_bin_path,
            nix_bin_path = ctx.attr.nix_bin_path,
        ),
    )
    return [toolchain_info]

nix_toolchain = rule(
    implementation = _nix_toolchain_impl,
    attrs = {
        "nix_build_bin_path": attr.string(),
        "nix_store_bin_path": attr.string(),
        "nix_bin_path": attr.string(),
    },
)

def _auto_nix_toolchain(repository_ctx):
    repository_ctx.file(
        "BUILD.bazel",
        content = """
load("@rules_nix//toolchains:nix.bzl", "nix_toolchain")
load("@rules_nix//:defs.bzl", "nix_package_repository")

nix_toolchain(
    name = "nix_toolchain",
    nix_build_bin_path = "{nix_build_bin_path}",
    nix_store_bin_path = "{nix_store_bin_path}",
    nix_bin_path = "{nix_bin_path}",
    visibility = ["//visibility:public"],
)

toolchain(
    name = "toolchain",
    toolchain = ":nix_toolchain",
    toolchain_type = "@rules_nix//:toolchain_type",
)
""".format(
            nix_build_bin_path = repository_ctx.which("nix-build"),
            nix_store_bin_path = repository_ctx.which("nix-store"),
            nix_bin_path = repository_ctx.which("nix"),
        ),
    )

auto_nix_toolchain = repository_rule(
    implementation = _auto_nix_toolchain,
    local = True,
    attrs = {},
)
