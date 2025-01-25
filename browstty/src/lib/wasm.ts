export async function load() {
    let instance: WebAssembly.Instance | null = null;

    try {
        const res = await fetch("./browstty.wasm");
        const wasmBuffer = await res.arrayBuffer();

        // @ts-ignore
        const zjb = new Zjb();

        const wasmModule = await WebAssembly.instantiate(wasmBuffer, {
            env: {
                memory: new WebAssembly.Memory({ initial: 100, maximum: 1024, shared: true }),
                __stack_pointer: 0,
                abort: () => console.log("Aborted"),
            },
            zjb: zjb.imports,
        });
        instance = wasmModule.instance;
        zjb.setInstance(instance);
    } catch (e: unknown) {
        console.error(e);
    }

    return instance;
}
