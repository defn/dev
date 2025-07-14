# Show system information
# Description: Displays system information using uname -a
# Dependencies: uname
# Outputs: Kernel name, version, architecture, and hostname
game:
    @uname -a