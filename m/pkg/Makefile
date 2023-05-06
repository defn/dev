latest:
	@for a in */; do if grep ghrepo "$$a/flake.json" >/dev/null 2>/dev/null; then (cd "$$a" && echo "$$a $$(cat VENDOR) $$(../az/bin/n-latest)"); fi; done | while read -r slug current latest; do if [[ "$$current" != "$$latest" ]]; then echo "$$slug $$current $$latest"; fi; done | (grep -v 'ibazel/ 0.22.0 0.23.1' || true)

upgrade:
	@set -x; make 2>&1 | grep -v ^make | while read -r slug current latest; do (mark "$$slug"; cd "$$slug" && n bump "$$latest" && n reset && n sha && n release "$$slug $$current -> $$latest"); done
