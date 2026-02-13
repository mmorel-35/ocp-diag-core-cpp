# Module extension for non-BCR dependencies

def _six_impl(repository_ctx):
    """Download and setup six Python library."""
    repository_ctx.download_and_extract(
        url = "https://pypi.python.org/packages/source/s/six/six-1.16.0.tar.gz",
        stripPrefix = "six-1.16.0",
        sha256 = "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926",
    )
    repository_ctx.file("BUILD.bazel", """
py_library(
    name = "six",
    srcs = ["six.py"],
    visibility = ["//visibility:public"],
)
""")

_six_archive = repository_rule(
    implementation = _six_impl,
)

def _non_bcr_deps_impl(mctx):
    """Module extension to provide non-BCR dependencies."""
    _six_archive(name = "six_archive")
    return mctx.extension_metadata(
        root_module_direct_deps = ["six_archive"],
        root_module_direct_dev_deps = [],
    )

non_bcr_deps = module_extension(
    implementation = _non_bcr_deps_impl,
)
