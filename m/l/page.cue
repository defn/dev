package l

html: #HTML
page: #PageContent

#HTML: """
<!doctype html>
<html>
\(#Head)
\(#Body)
</html>
"""

#Head: """
	<head>
	<script src="https://cdn.tailwindcss.com"></script>
	<script src="https://unpkg.com/@phosphor-icons/web"></script>
	
	<link rel="stylesheet" type="text/css" href="https://defn.github.io/webfonts/concourse_2_caps.css" />
	<link rel="stylesheet" type="text/css" href="https://defn.github.io/webfonts/concourse_3.css" />
	<link rel="stylesheet" type="text/css" href="https://defn.github.io/webfonts/valkyrie_a.css" />
	<link rel="stylesheet" type="text/css" href="https://defn.github.io/webfonts/hermes_maia_4.css" />
	
	<style>
		body {
			font-family: valkyrie_a;
		}
	</style>
	</head>
	"""

#Body: """
	<body class="bg-white px-6 lg:px-8">
	\(page.html)
	</body >
	"""
