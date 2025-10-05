# Build Configuration Notes

## Protobuf and Bazel Version Update

This repository has been updated to use:
- **Protobuf**: 28.3 (compatible with both Bazel 7.6.1 and bzlmod)
- **Bazel**: 7.6.1 (maintaining compatibility with existing setups)
- **Abseil**: 20240116.2 (via bzlmod MVS) / 20240116.0 (in WORKSPACE)

### Build Modes

Both WORKSPACE and bzlmod modes are fully supported and compatible with Bazel 7.6.1.

#### WORKSPACE Mode (Default)

WORKSPACE mode is the default build mode:

```bash
# Build with WORKSPACE mode (default)
bazel build //...
```

**Features:**
- Uses traditional WORKSPACE file for dependency management
- Full compatibility with Bazel 7.6.1
- Protobuf 28.3 with explicit proto_library and cc_proto_library imports
- All C++ targets compile successfully

#### Bzlmod Mode (Optional)

Bzlmod mode is available for users who want to use the modern dependency system:

```bash
# Build with bzlmod mode
bazel build --enable_bzlmod //...
```

**Bzlmod mode features:**
- Uses Bazel Central Registry (BCR) for dependency management
- Automatic dependency version resolution via Minimum Version Selection (MVS)
- Full compatibility with Bazel 7.6.1
- Protobuf 28.3 (may be upgraded by MVS)
- All C++ targets compile successfully

### Dependencies

#### Bzlmod Dependencies (MODULE.bazel)
- protobuf 28.3 (minimum, may be higher via MVS)
- abseil-cpp 20240116.2 (minimum, may be higher via MVS)
- googletest 1.15.2 (minimum, may be higher via MVS)
- grpc 1.74.1
- rules_cc 0.0.16
- rules_python 0.28.0
- rules_pkg 1.0.1
- bazel_skylib 1.7.0

#### WORKSPACE Dependencies (ocpdiag/build_deps.bzl)
- protobuf 28.3
- abseil-cpp 20240116.0 (LTS)
- googletest (pinned)
- grpc 1.51.3
- rules_cc 0.0.16
- rules_java 7.12.5

### Changes Made

1. **BUILD files**: Kept explicit protobuf rule imports
   - Load statements for `proto_library` and `cc_proto_library` from `@com_google_protobuf//bazel:...`
   - This is the recommended approach for protobuf 28.3 and maintains compatibility

2. **Protobuf version**: Updated from 21.5 to 28.3
   - API compatibility maintained
   - No C++ code changes required
   - Compatible with Bazel 7.6.1

3. **Abseil version**: Updated to LTS 20240116.0
   - Required by protobuf 28.3
   - Removed old patch (already fixed in new version)

4. **Bazel version**: Maintained at 7.6.1
   - Ensures compatibility with existing workflows
   - Both WORKSPACE and bzlmod modes work correctly

### Migration Path

For existing users:
1. **No changes required** - WORKSPACE mode is still the default
2. Clean build: `bazel clean --expunge`
3. Build: `bazel build //...`
4. *Optional*: Try bzlmod mode with `--enable_bzlmod` flag

### Troubleshooting

If you encounter build issues:

1. **Clean the build cache**:
   ```bash
   bazel clean --expunge
   ```

2. **Verify Bazel version**:
   ```bash
   bazel version
   # Should show: Build label: 7.6.1
   ```

3. **For bzlmod mode**:
   - Use `--enable_bzlmod` flag explicitly
   - MVS may select higher versions of dependencies

### Why Keep proto_library Load Statements?

In protobuf 28.3, the `proto_library.bzl` and `cc_proto_library.bzl` files are compatibility shims that re-export the native Bazel rules. Loading these explicitly:

1. **Future-proofs** the code for potential protobuf changes
2. **Documents** the dependency on protobuf's proto rules
3. **Maintains consistency** with protobuf's recommended usage patterns
4. **Works identically** to using native rules directly (they just re-export `native.proto_library` and `native.cc_proto_library`)

This approach is recommended in protobuf's documentation and provides a smooth migration path for future versions.
