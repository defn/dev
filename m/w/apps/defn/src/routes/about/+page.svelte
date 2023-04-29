<script>
  import { Alert } from "flowbite-svelte";
</script>

<svelte:head>
  <title>About</title>
  <meta name="description" content="About this app" />
</svelte:head>

<div class="text-column">
  <Alert>
    <span class="font-medium">Info alert!</span> Change a few things up and try submitting
    again.
  </Alert>

  <h1>About this app</h1>

  <p>
    This is a <a href="https://kit.svelte.dev">SvelteKit</a> app. You can make your
    own by typing the following into your command line and following the prompts:
  </p>

  <code>npm create svelte@latest</code>

  <p>
    The page you're looking at is purely static HTML, with no client-side
    interactivity needed. Because of that, we don't need to load any JavaScript.
    Try viewing the page's source, or opening the devtools network panel and
    reloading.
  </p>
</div>
