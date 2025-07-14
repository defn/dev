# Build the WireGuard application
# Dependencies: make command
# Outputs: Executes build target
default:
	$(MAKE) build

-include ../common/Makefile.coder

# Build and watch for changes using Bazel
# Dependencies: b binary, Bazel BUILD files
# Outputs: Built application with continuous watching for file changes
build:
	b watch

# Ensure WireGuard binary is built
# Dependencies: build target
# Outputs: WireGuard binary at ../bazel-bin/wg/wg_/wg
../bazel-bin/wg/wg_/wg: build
	@true

# Start WireGuard server
# Dependencies: ../bazel-bin/wg/wg_/wg binary
# Outputs: Started WireGuard server process
server:
	../bazel-bin/wg/wg_/wg server

# Start WireGuard client
# Dependencies: ../bazel-bin/wg/wg_/wg binary
# Outputs: Started WireGuard client process
client:
	../bazel-bin/wg/wg_/wg client
