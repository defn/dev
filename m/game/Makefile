build:
	rm -rf gen
	mkdir gen
	godot -v project.godot --export HTML5 gen/index.html

serve:
	cd gen && python -m http.server

all:
	$(MAKE) build serve