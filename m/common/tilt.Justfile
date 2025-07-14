# Runs Tilt and opens in browser
# Description: Starts Tilt in streaming mode and opens browser UI
# Dependencies: tilt, curl, browser
# Outputs: Tilt running in streaming mode with browser UI open
[no-cd]
default:
	@just tilt::open &
	@just tilt::run

# Runs Tilt in streaming mode
# Description: Starts Tilt with streaming output, clearing DOCKER_HOST
# Dependencies: tilt
# Outputs: Streaming Tilt logs to console
[no-cd]
run:
	@unset DOCKER_HOST && tilt up --stream

# Opens Tilt in a browser
# Description: Waits for Tilt UI to be ready then opens it in browser
# Dependencies: curl, browser (open command)
# Outputs: Opens Tilt UI at http://127.0.0.1:10350 in default browser
[no-cd]
open:
	@while true; do if curl -s -o /dev/null 127.0.0.1:10350; then break; fi; sleep 1; done
	@open http://127.0.0.1:10350
