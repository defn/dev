build:
	rm -rf gen
	mkdir gen
	./bin/godot -v project.godot --export HTML5 gen/index.html

serve:
	cd gen && python -m http.server

install:
	mkdir -p bin
	curl -sSL -O https://github.com/godotengine/godot/releases/download/3.5.3-stable/Godot_v3.5.3-stable_linux_headless.64.zip
	curl -sSL -O https://github.com/godotengine/godot/releases/download/3.5.3-stable/Godot_v3.5.3-stable_export_templates.tpz
	unzip Godot_v3.5.3-stable_linux_headless.64.zip
	unzip Godot_v3.5.3-stable_export_templates.tpz 
	rm -f Godot_v3.5.3-stable_linux_headless.64.zip
	rm -f Godot_v3.5.3-stable_export_templates.tpz 
	mkdir -p bin
	mv Godot_v3.5.3-stable_linux_headless.64 bin/godot
	mkdir -p ~/.local/share/godot/templates/3.5.3.stable
	mv templates/* ~/.local/share/godot/templates/3.5.3.stable/

all:
	$(MAKE) build serve