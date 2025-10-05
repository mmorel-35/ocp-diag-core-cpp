# Copyright 2022 Google LLC
#
# Use of this source code is governed by an MIT-style
# license that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

"""Workaround for rules_java compatibility with Bazel 8 in WORKSPACE mode."""

# This is a workaround for the fact that protobuf_deps() expects to call
# rules_java_dependencies() and rules_java_toolchains(), but rules_java 7.12.x
# is not fully compatible with Bazel 8 (tries to use native.java_proto_library).
#
# Since this project doesn't use Java, we provide stub implementations.

def rules_java_dependencies():
    """Stub implementation - does nothing as we don't use Java."""
    pass

def rules_java_toolchains():
    """Stub implementation - does nothing as we don't use Java."""
    pass
