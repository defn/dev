# README Creation Plan

This document outlines which directories will receive README.md files based on their git-tracked content.

## Priority 1: Core Infrastructure Directories

These directories contain essential project infrastructure and should get READMEs first:

1. **Root (.)** - Main project files (Makefile, Justfile, configs)
2. **bin/** - Executable scripts and utilities
3. **m/** - Main project workspace with build system
4. **.buildkite/** - CI/CD pipeline configuration
5. **.github/** - GitHub workflows and issue templates
6. **m/common/** - Shared utilities and configurations
7. **m/cache/** - Caching infrastructure setup
8. **m/game/** - Game development tools and applications

## Priority 2: Application-Specific Directories

Focused application directories:

9. **m/aws/** - AWS utilities and configuration scripts
10. **m/infra/** - Infrastructure as code
11. **m/d4us/** - CUE scripting tools
12. **m/f/** - Fly.io deployment configurations
13. **m/coder/template/** - Coder workspace templates
14. **m/db/** - Database utilities
15. **m/dc/** - Docker compose configurations
16. **m/ch/** - Cloud-init configurations

## Priority 3: Build System Directories

Bazel build system components:

17. **m/b/cue/** - CUE build rules
18. **m/b/earthly/** - Earthly build integration
19. **m/b/nix/** - Nix build integration
20. **m/b/oci/** - OCI container build rules
21. **m/b/lib/** - Build library utilities
22. **m/b/out/** - Build output utilities
23. **m/b/tutorial/** - Tutorial build rules

## Priority 4: Configuration Directories

Configuration-only directories and single-file directories:

24. **.aws/** - AWS configuration
25. **.bin/** - Binary utilities directory
26. **.cargo/** - Rust cargo configuration
27. **.config/** - Starship shell configuration
28. **.docker/** - Docker configuration
29. **.earthly/** - Earthly configuration
30. **.caddy.d/** - Caddy web server configuration
31. **cue.mod/** - CUE module configuration
32. **.kube/** - Kubernetes configuration
33. **bin/blackhole/** - Docker blackhole utility
34. **bin/Linux/** - Linux-specific binaries
35. **.buildkite/bin/** - Buildkite build scripts
36. **m/aws/bin/** - AWS utility scripts
37. **m/cache/docker/certs/** - Docker registry certificates
38. **m/cache/proxy/** - Proxy configuration
39. **m/cue.mod/** - CUE module files
40. **m/cue-demo/** - CUE demonstration files
41. **m/cue-demo/cue.mod/** - CUE demo module
42. **m/command/** - Go command structure
43. **m/command/api/** - API command
44. **m/command/gollm/** - LLM command
45. **m/command/infra/** - Infrastructure command
46. **m/command/root/** - Root command
47. **m/command/tui/** - TUI command
48. **m/cv/etc/** - CV configuration
49. **m/cv/.joyride/scripts/** - Joyride scripts
50. **m/etc/openvpn/** - OpenVPN configuration
51. **m/f/brie/** - Brie fly app
52. **m/f/defn/** - Defn fly app
53. **m/f/so/** - So fly app
54. **m/f/the/** - The fly app
55. **m/feh/.devcontainer/** - Feh devcontainer config

## Priority 5: Tool Configuration Directories

Tool-specific configuration directories:

56. **.config/direnv/** - Direnv configuration
57. **.config/joyride/scripts/** - Joyride scripts
58. **.config/joyride/src/** - Joyride source
59. **.config/k9s/** - K9s configuration
60. **.config/mise/** - Mise configuration
61. **.config/mise/tasks/** - Mise tasks
62. **.config/nix/** - Nix configuration
63. **.config/nushell/** - Nushell configuration
64. **.config/pypoetry/** - Poetry configuration
65. **.config/zellij/** - Zellij configuration
66. **.gnupg/** - GPG configuration
67. **.joyride/scripts/** - Joyride scripts
68. **Library/Application Support/Code/User/** - VSCode user settings
69. **.local/share/code-server/** - Code server configuration
70. **.local/share/code-server/User/** - Code server user settings

## Priority 6: Development Environment Directories

Mise tool configuration directories (single files):

71. **m/a/** - Base mise configuration
72. All **m/a/chamber/[a-z0-9]/** directories - Chamber configurations
73. All **m/a/circus/** subdirectories - Circus configurations
74. All **m/a/coil/** subdirectories - Coil configurations
75. All **m/a/curl/** subdirectories - Curl configurations
76. All **m/a/defn/** subdirectories - Defn configurations
77. All **m/a/fogg/** subdirectories - Fogg configurations
78. All **m/a/gyre/** subdirectories - Gyre configurations
79. All **m/a/helix/** subdirectories - Helix configurations
80. All **m/a/imma/** subdirectories - Imma configurations
81. All **m/a/immanent/** subdirectories - Immanent configurations
82. All **m/a/jianghu/** subdirectories - Jianghu configurations
83. All **m/a/spiral/** subdirectories - Spiral configurations
84. All **m/a/vault/** subdirectories - Vault configurations
85. All **m/a/whoa/** subdirectories - Whoa configurations

## Inclusions

ALL directories with git-tracked files will get READMEs, including:
- Asset/resource directories (images, fonts, css) - to document what assets are available
- Deep nested paths with single files - to explain their purpose
- Configuration-only directories - to document configuration purposes
- Third-party library directories - to document what libraries are included

## Implementation Strategy

1. Start with Priority 1-3 directories (core functionality)
2. Continue with Priority 4-5 directories (configuration)
3. Finally handle Priority 6 directories (environment configs)
4. Focus on files directly in each directory (not subdirectories)
5. Create concise READMEs describing purpose and listing key files
6. **PRESERVE existing README.md files** - if a directory already has a README.md, preserve its contents as the first section
7. Use consistent format across all README files

## README File Structure

For directories that already have README.md files:
```markdown
# [Existing README Title]

[Existing README content preserved exactly as-is]

---

## Directory Contents

[New generated content describing the directory and its files]
```

For directories without existing README.md files:
```markdown
# [Directory Name]

[Generated content describing the directory purpose and files]
```

## File Naming

All READMEs will be named `README.md` and placed directly in the target directory.