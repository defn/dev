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
		html, body {
		margin: 0;
		padding: 0;
		height: 100%;
		display: flex;
		flex-direction: column;
		font-family: valkyrie_a;
		}

		.content {
		padding: 20px;
		}

		.iframe-container {
		flex: 1;
		}

		iframe {
		width: 100%;
		height: 100%;
		border: none;
		}
	</style>
	</head>
	"""

#Body: """
	<body class="bg-white">
	\(page.html)
	\(page.iframe)
	</body >
	"""
