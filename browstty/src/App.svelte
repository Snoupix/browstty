<script lang="ts">
    import { onMount } from "svelte";

    import * as wasm from "./lib/wasm";

    let wasm_instance: Awaited<ReturnType<(typeof wasm)["load"]>> = $state(null);

    onMount(async () => {
        wasm_instance = await wasm.load();
    });

    $effect(() => {
        if (wasm_instance == null) {
            return;
        }

        console.log(wasm_instance.exports?.add(4, 4));
    });
</script>

<main></main>

<style lang="postcss">
    :global(*) {
        margin: 0;
        padding: 0;
    }

    main {
        width: 100vw;
        height: 100vh;
        background-color: #606060;
    }
</style>
