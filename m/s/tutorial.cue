package l

tutorial: #TutorialContent & {
	title:  "Tutorial : <a href=\"/?folder=/home/ubuntu\">TOC</a>"
	iframe: "https://3030--main--pc--admin.local.defn.run"
	steps: [{
		title: "Run the slide-show with Tilt"
		desc:  "tilt up --stream --port 0"
	}, {
		title: "Load the slide-show"
		desc:  "Once the slide-show is running, cick on retry below to load the slide-show"
	}, {
		title: "Edit slides.md file, change \"Welcome to Slidev\"."
		desc:  "Watch slide-show update."
	}, {
		title: "Font Awesome"
		desc: """
			<br>
			<div class="fa-4x">
				<span class="fa-layers fa-fw" style="background:MistyRose">
				<i class="fa-solid  fa-circle" style="color:Tomato"></i>
				<i class="fa-inverse fa-solid  fa-times" data-fa-transform="shrink-6"></i>
				</span>
			
				<span class="fa-layers fa-fw" style="background:MistyRose">
				<i class="fa-solid fa-bookmark"></i>
				<i class="fa-inverse fa-solid  fa-heart" data-fa-transform="shrink-10 up-2" style="color:Tomato"></i>
				</span>
				
				<span class="fa-layers fa-fw" style="background:MistyRose">
					<i class="fa-solid  fa-play" data-fa-transform="rotate--90 grow-4"></i>
					<i class="fa-solid  fa-sun fa-inverse" data-fa-transform="shrink-10 up-2"></i>
					<i class="fa-solid  fa-moon fa-inverse" data-fa-transform="shrink-11 down-4.2 left-4"></i>
					<i class="fa-solid  fa-star fa-inverse" data-fa-transform="shrink-11 down-4.2 right-4"></i>
				</span>
				
				<span class="fa-layers fa-fw" style="background:MistyRose">
					<i class="fa-solid  fa-calendar"></i>
					<span class="fa-layers-text fa-inverse" data-fa-transform="shrink-8 down-3" style="font-weight:900">27</span>
					</span>
					
					<span class="fa-layers fa-fw" style="background:MistyRose">
						<i class="fa-solid  fa-envelope"></i>
						<span class="fa-layers-counter" style="background:Tomato">1,419</span>
					</span>
			</div>
			"""
	}, {
		title: "Tailwind UI"
		desc: """
			<div class="flex min-h-full flex-col justify-center px-6 lg:px-8">
				<div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
					<form class="space-y-6" action="#" method="POST">
					<div>
						<label for="email" class="block text-sm/6 font-medium text-gray-900">Email address</label>
						<div class="mt-2">
						<input type="email" name="email" id="email" autocomplete="email" required class="block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6">
						</div>
					</div>
			
					<div>
						<div class="flex items-center justify-between">
						<label for="password" class="block text-sm/6 font-medium text-gray-900">Password</label>
					<div class="text-sm">
						<a href="#" class="font-semibold text-indigo-600 hover:text-indigo-500">Forgot password?</a>
					</div>
					</div>
					<div class="mt-2">
					<input type="password" name="password" id="password" autocomplete="current-password" required class="block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6">
					</div>
				</div>
			
				<div>
					<button type="submit" class="flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm/6 font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">Sign in</button>
				</div>
			</form>
			</div>
			</div>
			"""
	}]
}
