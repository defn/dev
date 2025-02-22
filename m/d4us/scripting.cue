package d4us

#Tool: {
	description: string
	website:     string
	project?:    string
	install:     string
	demo:        string
}

scripting: {
	description: """
		    Scripting is running cli programs and tool specific functions.  A script
		    takes input, uses variables, structures code in building blocks, and
		    runs commands to do something.
		"""

	tools: [string]: #Tool
	tools: {
		bash: {
			description: """
				    bash is a popular shell.  It can run commands, takes command
				    line arguments, use environment and bash variables, create bash
				    functions and script files.
				"""
			website: "https://www.gnu.org/software/bash/"
			install: """
				    Ubuntu operating systems usually have bash installed.
				    Refer to your operation systems for how to install a package.

				    Ubuntu apt package: bash
				"""
			demo: "./test.sh"
		}
		make: {
			description: """
				    make is a popular build tool.  It can run commands, takes
				    command line settings, use environment and make variables,
				    create make targets and Makefiles.
				"""
			website: "https://www.gnu.org/software/make/"
			install: """
				    Ubuntu operating systems usually don't have make installed.
				    Refer to your operation systems for how to install a package.

				    Ubuntu apt package: make
				"""
			demo: "make test"
		}
		just: {
			description: """
				    just is a new tool that resembles make.  It can run commands,
				    take command line arguments, uses environment and just
				    variables, creates just targets and Justfiles.
				"""
			website: "https://just.systems/"
			project: "https://github.com/casey/just"
			install: """
				   Install just using mise: `mise use`
				"""
			demo: "just test"
		}
		mise: {
			description: """
				    mise is a new kind of tool.  It can run commands, take command
				    line arguments, uses environment variables, creates mise tasks
				    can use script files.  Mise can inherit configuration and
				    scripts from parent directories.
				"""
			website: "https://mise.jdx.dev/"
			project: "https://github.com/jdx/mise"
			install: """
				   Install mise using these instructions: https://mise.jdx.dev/getting-started.html
				"""
			demo: "mise run test"
		}
	}
}
