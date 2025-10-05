# Build Configuration Notes

## Protobuf and Bazel Version Update

This repository has been updated to use:
- **Protobuf**: 31.1 (via bzlmod MVS) / 29.3 (in WORKSPACE)
- **Bazel**: 8.4.2
- **Abseil**: 20250512.1 (via bzlmod MVS) / 20240116.0 (in WORKSPACE)

### Build Modes

#### Bzlmod Mode (Recommended)

Bzlmod is the recommended build mode and is enabled by default in `.bazelrc`.

```bash
# Build with bzlmod (default)
bazel build //...

# Or explicitly
bazel build --enable_bzlmod //...
```

**Bzlmod mode features:**
- Uses Bazel Central Registry (BCR) for dependency management
- Automatic dependency version resolution via Minimum Version Selection (MVS)
- Full compatibility with Bazel 8.4.2
- Protobuf 31.1 (latest available in BCR)
- All C++ targets compile successfully

#### WORKSPACE Mode

⚠️ **WORKSPACE mode has known compatibility issues with Bazel 8 and Protobuf 29.3+**

Due to breaking changes in Bazel 8 (removal of native `java_proto_library`) and incompatibilities with `rules_java` 7.12.x, WORKSPACE mode cannot currently build with Bazel 8 and Protobuf 29.3.

**Workarounds:**
1. **Recommended**: Use bzlmod mode (see above)
2. Use an older version of this codebase with Bazel 7.6.1 and Protobuf 21.5

**Technical details:**
- Protobuf 29.3 requires Bazel 8+ (uses `paths.is_normalized()` introduced in Bazel 8)
- Bazel 8 removed `native.java_proto_library`
- `rules_java` 7.12.x (required by Protobuf) tries to reference the removed native rule
- Patching protobuf's WORKSPACE to skip Java setup causes downstream dependency issues

**Note:** Since Bazel itself is deprecating WORKSPACE mode in favor of bzlmod (removal planned for Bazel 9 in late 2025), migrating to bzlmod is the recommended path forward.

### Dependencies

#### Bzlmod Dependencies (MODULE.bazel)
- protobuf 31.1
- abseil-cpp 20250512.1
- googletest 1.17.0
- grpc 1.74.1
- rules_cc 0.1.1
- rules_python 1.0.0
- rules_pkg 1.0.1
- bazel_skylib 1.7.1

#### WORKSPACE Dependencies (ocpdiag/build_deps.bzl)
- protobuf 29.3
- abseil-cpp 20240116.0 (LTS)
- googletest (pinned)
- grpc 1.51.3
- rules_cc 0.0.16
- rules_java 7.12.5

### Changes Made

1. **BUILD files**: Removed explicit protobuf rule imports
   - `proto_library` and `cc_proto_library` are now built-in rules
   - No longer need to load from `@com_google_protobuf//bazel:...`

2. **Protobuf version**: Updated from 21.5 to 29.3+
   - API compatibility maintained
   - No C++ code changes required

3. **Abseil version**: Updated to LTS 20240116.0
   - Required by protobuf 29.3
   - Removed old patch (already fixed in new version)

4. **Bazel version**: Updated from 7.6.1 to 8.4.2
   - Required for protobuf 29.3 (uses `paths.is_normalized()`)
   - Bzlmod is recommended by Bazel team for version 8+

### Migration Path

For existing users:
1. **Recommended**: Migrate to bzlmod mode for best compatibility
2. Update Bazel to 8.4.2
3. Clean build: `bazel clean --expunge`
4. Build: `bazel build //...`

### Troubleshooting

If you encounter build issues:

1. **Clean the build cache**:
   ```bash
   bazel clean --expunge
   ```

2. **Verify Bazel version**:
   ```bash
   bazel version
   # Should show: Build label: 8.4.2
   ```

3. **Check which mode is active**:
   ```bash
   bazel info | grep bzlmod
   ```

4. **For WORKSPACE mode issues**:
   - Consider migrating to bzlmod
   - Or use Bazel 7.6.1 with the old dependencies (pre-update)

### Future Work

- Complete WORKSPACE mode fixes for Bazel 8 compatibility
- Add remaining dependencies not yet in BCR to MODULE.bazel
- Complete migration of all project dependencies to bzlmod
