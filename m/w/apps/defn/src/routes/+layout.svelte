<script>
  import { Page } from 'ui';
  import { NavLi } from 'flowbite-svelte';
</script>

<Page>
  <span slot="nav">
    <NavLi href="/about">About</NavLi>
  </span>
  <slot />
</Page>
