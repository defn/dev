package l

tutorial: #TutorialContent & {
	title:  "Upgrade nix flakes"
	iframe: "https://5001--main--pc--admin.local.defn.run/check"
	steps: [{
		title: "Run the tutorial with Tilt"
		desc:  "j up"
	}, {
		title: "List GitHub version updates for nix flakes"
		desc:  "j list"
	}, {
		title: "Bump versions in nix flakes to match GitHub releases"
		desc:  "j latest"
	}, {
		title: "Build everything with Bazel"
		desc:  "j build"
	}]
}
