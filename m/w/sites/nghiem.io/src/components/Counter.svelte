<script lang="ts">
  let { children, start, label } = $props();

  let count = $state(Number(start));

  function add() {
    count += 1;
  }

  function subtract() {
    count -= 1;
  }
</script>

<div class="counter">
  {label}
  {count}
  <button onclick={subtract}>-</button>
  <button onclick={add}>+</button>
  {@render children()}
</div>
