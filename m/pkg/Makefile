latest:
	@for a in */; do if grep ghrepo "$$a/flake.json" >/dev/null 2>/dev/null; then (cd "$$a" && echo "$$a $$(cat VENDOR) $$(../az/bin/n-latest)"); fi; done | while read -r slug current latest; do if [[ "$$current" != "$$latest" ]]; then echo "$$slug $$current $$latest"; fi; done

upgrade:
	@make | grep -v 'ibazel/ 0.22.0 0.23.0' | grep -v 'gh/ 2.27.0' | while read -r slug current latest; do (cd "$$slug" && n bump "$$latest" && n reset && n sha && n release "$$slug $$current -> $$latest"); done
