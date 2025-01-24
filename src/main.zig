const std = @import("std");

const zjb = @import("zjb");

export fn add(x: i32, y: i32) i32 {
    zjb.global("console").call("log", .{zjb.constString("Hi from Zig")}, void);
    return x + y;
}
