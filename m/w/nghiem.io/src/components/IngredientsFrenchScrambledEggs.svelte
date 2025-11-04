<script lang="ts">
  let { children } = $props();

  let eggs = $state(3);

  let butter = $derived(2 * eggs);

  let salt = $derived(2 * eggs);

  function add() {
    eggs += 1;
  }

  function subtract() {
    eggs -= 1;
  }
</script>

<li>
  Eggs
  {eggs}
  <button onclick={subtract}>-</button>
  <button onclick={add}>+</button>
  {@render children?.()}
</li>
<li>Butter {butter} Tbsp</li>
<li>Salt {salt} g</li>
