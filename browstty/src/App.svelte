<script lang="ts">
    import Gol from "./components/gol.svelte";

    import "$/main.css";

    const SelectedModule = {
        None: 0,
        GameOfLife: 1,
        Ghostty: 2,
    } as const;

    let selected_module: typeof SelectedModule[keyof typeof SelectedModule] = $state(SelectedModule.None);
</script>

<main>
    <h1>WASM Playground</h1>
    <nav>
        <button onclick={() => selected_module = SelectedModule.None}>None</button>
        <button onclick={() => selected_module = SelectedModule.GameOfLife}>Game Of Life</button>
        <button onclick={() => selected_module = SelectedModule.Ghostty}>Ghostty</button>
    </nav>

    {#if selected_module == SelectedModule.GameOfLife}
        <Gol />
    {:else if selected_module == SelectedModule.Ghostty}
        <h1>x</h1>
    {/if}
</main>

<!-- Maybe a missconfiguration but the TS import and the CSS import are necessary -->
<style>
    :global(:root) {
        @import "tailwindcss";
    }

    :global(*) {
        margin: 0;
        padding: 0;
    }

    main {
        @apply w-screen min-h-screen max-h-screen bg-[#606060] overflow-y-scroll;

        h1 {
            @apply text-center text-amber-600 py-12 font-bold text-3xl;
        }

        nav {
            @apply w-full flex flex-row justify-around items-center;

            button {
                @apply rounded-lg text-gray-600 bg-amber-600 border-none py-2 px-4 cursor-pointer;
            }
        }
    }
</style>
