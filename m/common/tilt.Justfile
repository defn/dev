# Runs Tilt and opens in browser
[no-cd]
default:
	@just tilt::open &
	@just tilt::run

# Runs Tilt in streaming mode
[no-cd]
run:
	@unset DOCKER_HOST && tilt up --stream

# Opens Tilt in a browser
[no-cd]
open:
	@while true; do if curl -s -o /dev/null 127.0.0.1:10350; then break; fi; sleep 1; done
	@open http://127.0.0.1:10350
