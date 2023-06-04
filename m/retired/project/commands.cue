package project

import (
	"text/template"
	"tool/file"
	"tool/exec"
	"strings"
	"github.com/defn/dev/m/boot/input"
)

#ProjectConfig: codeowners: [...string]

#Project: ctx={
	input.#Input
	#ProjectConfig

	config: {
		configureProjectGithubDir: exec.Run & {
			cmd: ["mkdir", "-p", ".github"]
		}

		configureProjectCodeOwners: file.Create & {
			$after: configureProjectGithubDir
			_data: owners: strings.Join(ctx.codeowners, " ")
			_template: """
				* {{ .owners }}

				"""
			filename: ".github/CODEOWNERS"
			contents: template.Execute(_template, _data)
		}

		configureProjectPreCommitConfig: file.Create & {
			$after: configureProjectGithubDir
			_data: {
			}
			_template: """
				repos:
				  - repo: https://github.com/pre-commit/pre-commit-hooks
				    rev: v4.3.0
				    hooks:
				      - id: trailing-whitespace
				        exclude: ^(provider|cdktf.out|.local)/|\\.lock|charts
				      - id: end-of-file-fixer
				        exclude: ^(provider|cdktf.out|.local)/|\\.lock|charts
				      - id: check-json
				        exclude: ^(provider|cdktf.out|.local)/
				      - id: check-yaml
				        args: [--allow-multiple-documents, --unsafe]
				        exclude: ^(provider|cdktf.out|.local)/|charts
				      - id: check-toml
				        exclude: ^(provider|cdktf.out|.local)/|charts
				      - id: check-shebang-scripts-are-executable

				"""
			filename: ".pre-commit-config.yaml"
			contents: template.Execute(_template, _data)
		}
		configureProjectPreCommitInstall: exec.Run & {
			$after: configureProjectPreCommitConfig
			cmd: ["pc", "install"]
		}

		configureProjectMakefile: file.Create & {
			_data: {
			}
			_template: """
				SHELL := /bin/bash

				menu: # This menu
					@perl -ne 'printf("%20s: %s\\n","$$1","$$2") if m{^([\\w+-]+):[^#]+#\\s(.+)$$}' $(shell ls -d GNUmakefile Makefile.* 2>/dev/null)

				-include Makefile.site

				"""
			filename: "GNUmakefile"
			contents: template.Execute(_template, _data)
		}
	}
}
