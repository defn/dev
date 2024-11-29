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
			    <i class="fa-solid  fa-bookmark"></i>
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
	}]
}
