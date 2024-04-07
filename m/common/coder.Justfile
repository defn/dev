default:
	@while true; do just coder::code-server; sleep 5; done

code-server:
	@pkill -9 trunk || true
	@cd ${JUST_WORKDIR} && export STARSHIP_NO= && while true; do source ~/.bash_profile; code-server --auth none; sleep 5; done
