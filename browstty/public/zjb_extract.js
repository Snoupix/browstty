const Zjb = class {
    new_handle(value) {
        if (value === null) {
            return 0;
        }
        const result = this._next_handle;
        this._handles.set(result, value);
        this._next_handle++;
        return result;
    }
    dataView() {
        if (this._cached_data_view.buffer.byteLength !== this.instance.exports.memory.buffer.byteLength) {
            this._cached_data_view = new DataView(this.instance.exports.memory.buffer);
        }
        return this._cached_data_view;
    }
    constructor() {
        this._decoder = new TextDecoder();
        this.imports = {
            call_o_v_log: (arg0, id) => {
                this._handles.get(id).log(this._handles.get(arg0));
            },
            get_o_console: id => {
                return this.new_handle(this._handles.get(id).console);
            },
            string: (ptr, len) => {
                return this.new_handle(
                    this._decoder.decode(new Uint8Array(this.instance.exports.memory.buffer, ptr, len)),
                );
            },
        };
        this.exports = {};
        this.instance = null;
        this._cached_data_view = null;
        this._export_reverse_handles = {};
        this._handles = new Map();
        this._handles.set(0, null);
        this._handles.set(1, window);
        this._handles.set(2, "");
        this._handles.set(3, this.exports);
        this._next_handle = 4;
    }
    setInstance(instance) {
        this.instance = instance;
        const initialView = new DataView(instance.exports.memory.buffer);
        this._cached_data_view = initialView;
    }
};
