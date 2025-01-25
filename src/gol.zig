const std = @import("std");

const zjb = @import("zjb");

pub const MAX_X: u32 = 250;
pub const MAX_Y: u32 = 250;

pub const Gol = extern struct {
    cells: *[MAX_X][MAX_Y]Cell,
    config: extern struct {
        x: u32 = 0,
        y: u32 = 0,
    },

    const Self = @This();

    const Cell = enum(u1) {
        Dead,
        Alive,

        pub fn display(self: *const Cell) bool {
            return switch (self.*) {
                .Alive => true,
                .Dead => false,
            };
        }
    };

    pub fn init(x: u32, y: u32) !Self {
        const self = Self{
            .config = .{
                .x = @min(x, MAX_X),
                .y = @min(y, MAX_Y),
            },
            .cells = try std.heap.wasm_allocator.create([MAX_X][MAX_Y]Cell),
            // .cells = [_][MAX_Y]Cell{[_]Cell{.Dead} ** MAX_Y} ** MAX_X,
        };

        return self;
    }

    pub fn deinit(self: *Self) void {
        std.heap.wasm_allocator.destroy(self.cells);
    }

    pub fn get_cell(self: *Self, x: u32, y: u32) bool {
        return self.cells[x][y].display();
    }

    // pub fn get_cells(self: *Self) [MAX_X][MAX_Y]bool {
    //     var cells_copy = [MAX_X][MAX_Y]bool{[MAX_Y]bool{false} ** MAX_Y} ** MAX_X;
    //
    //     for (0..self.config.x) |x| {
    //         for (0..self.config.y) |y| {
    //             cells_copy[x][y] = self.cells[x][y].display();
    //         }
    //     }
    //
    //     return cells_copy;
    // }

    pub fn randomize_cells(self: *Self, seed: u64) void {
        var xoshiro = std.rand.DefaultPrng.init(seed);
        const random = xoshiro.random();

        for (0..self.config.x) |x| {
            for (0..self.config.y) |y| {
                switch (random.intRangeAtMost(u3, 0, 4) == 0) {
                    true => self.cells[x][y] = Cell.Alive,
                    false => self.cells[x][y] = Cell.Dead,
                }
            }
        }
    }

    // Any live cell with fewer than two live neighbours dies, as if by underpopulation.
    // Any live cell with two or three live neighbours lives on to the next generation.
    // Any live cell with more than three live neighbours dies, as if by overpopulation.
    // Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
    pub fn next_gen(self: *Self) !void {
        const cells_copy = try std.heap.wasm_allocator.create([MAX_X][MAX_Y]Cell);
        defer std.heap.wasm_allocator.destroy(cells_copy);
        @memcpy(cells_copy, self.cells);

        for (0..(self.config.x * self.config.y)) |i| {
            const x = i / self.config.y;
            const y = i % self.config.y;

            self.cells[x][y] = switch (cells_copy[x][y]) {
                .Alive => cell_blk: {
                    break :cell_blk switch (get_alive_neighbors_count(cells_copy, x, y)) {
                        0, 1 => Cell.Dead,
                        2, 3 => Cell.Alive,
                        else => Cell.Dead,
                    };
                },
                .Dead => cell_blk: {
                    if (get_alive_neighbors_count(cells_copy, x, y) == 3) {
                        break :cell_blk Cell.Alive;
                    }

                    break :cell_blk Cell.Dead;
                },
            };
        }
    }

    fn get_alive_neighbors_count(cells_copy: *[MAX_X][MAX_Y]Cell, _x: usize, _y: usize) u8 {
        const offsets = [_]i8{ -1, 0, 1 };
        var count: u8 = 0;

        const x: i8 = @intCast(_x);
        const y: i8 = @intCast(_y);

        for (offsets) |x_offset| {
            for (offsets) |y_offset| {
                const n_x = x_offset + x;
                const n_y = y_offset + y;

                if ((n_x < 0) or (n_y < 0)) {
                    continue;
                }

                count += if (cells_copy[@intCast(n_x)][@intCast(n_y)] == Cell.Alive) 1 else 0;
            }
        }

        return count;
    }
};
