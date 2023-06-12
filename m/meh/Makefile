wrappers:
	 grep profile ~/.aws/config | grep 'sso-source' | awk '{print $$2}' | cut -d- -f1-2 | grep -v sso | runmany 4 'bazel run --script_path=bin/$$1 //meh:aws_cli $$1'