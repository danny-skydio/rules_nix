load("@//:deps.bzl", "rules_nix_deps")

# We need rules_python and com_google_protobuf, if you have other versions it should be okay.
# If you want other versions, load them before calling rules_nix_deps!
rules_nix_deps()

load("@rules_python//python:repositories.bzl", "python_register_toolchains")

# Python 3.8+ should work.
python_register_toolchains(
    name = "python_3_11",
    python_version = "3.11",
)
