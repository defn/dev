[no-cd]
default:
	@just tilt::open &
	@just tilt::run

[no-cd]
run:
	@cd ${JUST_WORKDIR} && unset DOCKER_HOST && tilt up --stream

[no-cd]
open:
	@while true; do if curl -s -o /dev/null 127.0.0.1:10350; then break; fi; sleep 1; done
	@open http://127.0.0.1:10350
