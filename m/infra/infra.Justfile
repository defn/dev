# Show infrastructure information
# Description: Displays system information for infrastructure context
# Dependencies: uname
# Outputs: Kernel name, version, architecture, and hostname
infra:
    @uname -a