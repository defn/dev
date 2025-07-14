# Build the game project
# Dependencies: make command
# Outputs: Executes build target
default:
	$(MAKE) build

-include ../common/Makefile.coder

game ?= sunny

# Open level editor with specified game
# Dependencies: phaser-editor directory with Makefile, make command, pwd command, $(game) variable
# Outputs: Opened Phaser level editor with specified game directory path
level:
	cd phaser-editor && $(MAKE) game="$(shell pwd)/$(game)"

# Open sound effects editor
# Dependencies: jsfxr directory with Makefile, make command
# Outputs: Opened JSFXR sound effects editor
sound:
	cd jsfxr && $(MAKE)

# Open pixel art editor
# Dependencies: piskel directory with Makefile, make command
# Outputs: Opened Piskel pixel art editor
pixel:
	cd piskel && $(MAKE)

