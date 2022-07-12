workspace(name = "com_datadoghq_dd_analytics")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "com_datadoghq_datacenter_config",
    commit = "e211edb22a5949f59a009f3a5f72c9ff6ab29045",
    remote = "https://github.com/DataDog/datacenter-config.git",
)

git_repository(
    name = "rules_oci_bootstrap",
    commit = "bab1f71790b74ee78c1d308854ca8e1f23265f94",
    remote = "https://github.com/DataDog/rules_oci_bootstrap.git",
)

# The list of current releases can be found here: https://github.com/DataDog/cnab-tools/wiki/releases
load("@rules_oci_bootstrap//:defs.bzl", "oci_blob_pull")

oci_blob_pull(
    name = "com_datadoghq_cnab_tools",
    digest = "sha256:033acbe763da084abe9ed1475fa0ffa0f6c83a1a76df79cc6da58d6f0d5f3ba4",
    extract = True,
    registry = "registry.ddbuild.io",
    repository = "cnab-tools/rules_cnab",
    type = "tar.gz",
)

load("@com_datadoghq_datacenter_config//rules:deps.bzl", "datacenter_config_dependencies")

datacenter_config_dependencies()

load("@com_datadoghq_cnab_tools//rules:deps.bzl", "cnab_tools_dependencies")

cnab_tools_dependencies()

load("@com_datadoghq_cnab_tools//rules/setup:cnab_tools.bzl", "cnab_tools_setup")

cnab_tools_setup()

load("@com_datadoghq_cnab_tools//rules/setup:rules_go.bzl", "rules_go_setup")

rules_go_setup()

load("@com_datadoghq_cnab_tools//rules/setup:rules_docker.bzl", "rules_docker_setup")

rules_docker_setup()

load("@com_datadoghq_cnab_tools//rules/setup:gazelle.bzl", "gazelle_setup")

gazelle_setup()

load(
    "@com_datadoghq_cnab_tools//rules/artifact:artifact.bzl",
    "artifact_pull",
)

artifact_pull(
    name = "pull-provider-from-registry",
    build_file_content = """exports_files(["terraform-provider-mortar"])""",
    digest = "sha256:2e6c2104310f098108d1fb2d2ef3623ac020b00c9f412d67ca55c37c8c658c89",
    registry = "",
    repository = "mortar-terraform/provider",
)
