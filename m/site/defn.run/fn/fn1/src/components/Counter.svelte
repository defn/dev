<script lang="ts">
  import type { Snippet } from "svelte";

  interface Props {
    children?: Snippet;
  }

  let { children }: Props = $props();
  let count = $state(0);

  function add() {
    count += 1;
  }

  function subtract() {
    count -= 1;
  }
</script>

<div>
  <span><i class="fas fa-kiwi-bird" onclick={subtract} /></span>
  <span>
    <pre>{count}</pre>
    <div>
      {@render children?.()}
    </div>
  </span>
  <span><i class="fas fa-kiwi-bird" onclick={add} /></span>
</div>
