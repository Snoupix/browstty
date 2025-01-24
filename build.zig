const std = @import("std");

const out_dir = std.Build.InstallDir.bin;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{ .default_target = .{ .ofmt = .wasm, .os_tag = .freestanding, .cpu_arch = .wasm32 } });
    const optimize = b.standardOptimizeOption(.{});

    const zjb = b.dependency("zjb", .{});

    const exe = b.addExecutable(.{
        .name = "browstty",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe.root_module.addImport("zjb", zjb.module("zjb"));

    exe.entry = .disabled;
    exe.rdynamic = true;

    const extract_js = b.addRunArtifact(zjb.artifact("generate_js"));
    const extract_exe_out = extract_js.addOutputFileArg("zjb_extract.js");
    extract_js.addArg("Zjb");
    extract_js.addArtifactArg(exe);

    const exe_step = b.step("js", "Build the JS file");
    exe_step.dependOn(&b.addInstallArtifact(exe, .{
        .dest_dir = .{ .override = out_dir },
    }).step);
    exe_step.dependOn(&b.addInstallFileWithDir(extract_exe_out, out_dir, "zjb_extract.js").step);
}
