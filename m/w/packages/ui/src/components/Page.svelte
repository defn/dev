<script>
  import '../components.postcss';
  import { Navbar, NavBrand, NavLi, NavUl, NavHamburger, Button } from 'flowbite-svelte';
</script>

<header>
  <div class="app">
    <Navbar let:hidden let:toggle>
      <NavBrand href="/">
        <img src="https://flowbite.com/docs/images/logo.svg" class="mr-3 h-6 sm:h-9" alt="logo" />
        <span class="self-center whitespace-nowrap text-xl font-semibold dark:text-white">
          DEFN
        </span>
      </NavBrand>
      <div class="flex md:order-2">
        <Button size="sm">Get started</Button>
        <NavHamburger on:click={toggle} />
      </div>
      <NavUl {hidden} class="order-1">
        <NavLi href="/">Home</NavLi>
        <slot name="nav"/>
      </NavUl>
    </Navbar>

    <main>
      <slot />
    </main>
  </div>
</header>

<style>
  header {
    display: flex;
    justify-content: space-between;
  }
  header .app {
    display: flex;
    flex-direction: column;
    min-height: 100vh;
  }
  header main {
    flex: 1;
    display: flex;
    flex-direction: column;
    padding: 1rem;
    width: 100%;
    max-width: 64rem;
    margin: 0 auto;
    box-sizing: border-box;
  }
</style>
