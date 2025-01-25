const std = @import("std");

const zjb = @import("zjb");
const gol = @import("gol.zig");

const Gol = gol.Gol;

export fn add(x: i32, y: i32) i32 {
    zjb.global("console").call("log", .{zjb.constString("Hi from Zig")}, void);
    return x + y;
}

export fn new_gol(x: u32, y: u32) *Gol {
    const gol_ptr = std.heap.wasm_allocator.create(Gol) catch unreachable;
    gol_ptr.* = Gol.init(x, y) catch unreachable;
    return gol_ptr;
}

export fn free_gol(self: *Gol) void {
    self.deinit();
    std.heap.wasm_allocator.destroy(self);
}

export fn randomize_cells(self: *Gol, seed: u64) void {
    Gol.randomize_cells(self, seed);
}

export fn next_gen(self: *Gol) void {
    Gol.next_gen(self) catch unreachable;
}

export fn get_cell(self: *Gol, x: u32, y: u32) bool {
    return self.get_cell(x, y);
}
