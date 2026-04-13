const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Build flags for Lua
    const lua_cflags = &[_][]const u8{
        "-std=c99",
        "-DLUA_USE_MACOSX",
        "-DLUA_COMPAT_5_3",
        "-O2",
        "-Wall",
    };

    // Lua core source files
    const core_files = &[_]struct { path: []const u8 }{
        .{ .path = "lapi.c" },    .{ .path = "lcode.c" },
        .{ .path = "lctype.c" },  .{ .path = "ldebug.c" },
        .{ .path = "ldo.c" },     .{ .path = "ldump.c" },
        .{ .path = "lfunc.c" },   .{ .path = "lgc.c" },
        .{ .path = "llex.c" },    .{ .path = "lmem.c" },
        .{ .path = "lobject.c" }, .{ .path = "lopcodes.c" },
        .{ .path = "lparser.c" }, .{ .path = "lstate.c" },
        .{ .path = "lstring.c" }, .{ .path = "ltable.c" },
        .{ .path = "ltm.c" },     .{ .path = "lundump.c" },
        .{ .path = "lvm.c" },     .{ .path = "lzio.c" },
    };

    // Lua auxiliary library
    const aux_files = &[_]struct { path: []const u8 }{
        .{ .path = "lauxlib.c" },
    };

    // Lua standard libraries
    const lib_files = &[_]struct { path: []const u8 }{
        .{ .path = "lbaselib.c" }, .{ .path = "lcorolib.c" },
        .{ .path = "ldblib.c" },   .{ .path = "liolib.c" },
        .{ .path = "lmathlib.c" }, .{ .path = "loslib.c" },
        .{ .path = "lstrlib.c" },  .{ .path = "ltablib.c" },
        .{ .path = "lutf8lib.c" }, .{ .path = "linit.c" },
        .{ .path = "loadlib.c" },
    };

    // Create module for Lua core
    const lua_core = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    for (core_files) |f| {
        lua_core.addCSourceFile(.{ .file = b.path(f.path), .flags = lua_cflags });
    }

    for (aux_files) |f| {
        lua_core.addCSourceFile(.{ .file = b.path(f.path), .flags = lua_cflags });
    }

    for (lib_files) |f| {
        lua_core.addCSourceFile(.{ .file = b.path(f.path), .flags = lua_cflags });
    }

    // Build Lua interpreter executable
    const lua_exe = b.addExecutable(.{
        .name = "lua",
        .root_module = lua_core,
    });

    lua_exe.addCSourceFile(.{ .file = b.path("lua.c"), .flags = lua_cflags });

    b.installArtifact(lua_exe);

    // Run step
    const run_cmd = b.addRunArtifact(lua_exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run Lua interpreter");
    run_step.dependOn(&run_cmd.step);
}
