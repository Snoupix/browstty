<script lang="ts">
    import { onDestroy, onMount } from "svelte";

    import * as wasm from "$/lib/wasm";

    let wasm_instance: Awaited<ReturnType<(typeof wasm)["load"]>> & { exports: any } | null = $state(null);
    let gol_ptr: number | null = $state(null);
    let cells: Array<Array<boolean>> = $state(Array(50).fill(Array(75).fill(false)));
    let timer: number | null = $state(null);
    let ongoing = $state(true);

    onMount(async () => {
        wasm_instance = await wasm.load();

        if (wasm_instance == null) return;

        gol_ptr = wasm_instance.exports.new_gol(cells.length, cells[0].length);

        randomize_cells();

        next_gen();

        timer = setInterval(next_gen, 100);
    });

    onDestroy(() => {
        if (timer != null) {
            clearInterval(timer);
        }

        if (wasm_instance == null || gol_ptr == null) return;

        wasm_instance?.exports.free_gol(gol_ptr);
        gol_ptr = null;
    });

    function pause() {
        if (timer != null) {
            clearInterval(timer);
        }

        ongoing = false;
    }

    function resume() {
        next_gen();

        timer = setInterval(next_gen, 150);

        ongoing = true;
    }

    function next_gen() {
        if (wasm_instance == null || gol_ptr == null) {
            return;
        }

        wasm_instance.exports.next_gen(gol_ptr);

        update_cells();
    }

    function randomize_cells() {
        if (wasm_instance == null || gol_ptr == null) {
            return;
        }

        wasm_instance.exports.randomize_cells(gol_ptr, BigInt(Date.now()));

        update_cells();
    }

    function update_cells() {
        if (wasm_instance == null || gol_ptr == null) {
            return;
        }

        for (let x = 0; x < cells.length; x += 1) {
            for (let y = 0; y < cells[x].length; y += 1) {
                cells[x][y] = wasm_instance.exports.get_cell(gol_ptr, x, y);
            }
        }
    }
</script>

<section>
    {#if ongoing}
        <button onclick={pause}>pause</button>
    {:else}
        <button onclick={resume}>resume</button>
    {/if}

    {#if !ongoing}
        <button onclick={next_gen}>next gen</button>
    {/if}
    <button onclick={randomize_cells}>reset</button>

    {#each cells as row}
        <div class="row">
        {#each row as cell}
            <span class={`cell ${cell ? "alive" : "dead"}`}></span>
        {/each}
        </div>
    {/each}
</section>

<style lang="postcss">
    section {
        width: 100%;
        height: 100%;

        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;

        .row {
            display: flex;
            flex-direction: row;
            justify-content: center;
            align-items: center;

            .cell {
                width: 10px;
                height: 10px;
                background-color: lightcoral;
                opacity: .5;
                border: 1px solid #0000001f;
            }

            .cell.dead {
                background-color: darkmagenta;
            }
        }
    }
</style>
