const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // ========== main.c (Hello World) ==========
    const main_module = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    main_module.addCSourceFile(.{ .file = b.path("main.c") });

    const main_exe = b.addExecutable(.{
        .name = "c_lang",
        .root_module = main_module,
    });
    b.installArtifact(main_exe);

    // Run step
    const main_run = b.addRunArtifact(main_exe);
    const main_step = b.step("run", "Run c_lang");
    main_step.dependOn(&main_run.step);
}
