# C-Lang Project

C 语言学习项目，同时探索使用 Zig 构建 C 代码的可行性。

## 项目目的

本项目作为一个学习实验平台，用于：

1. **C 语言学习** - 基础 C 语言语法和编程实践
2. **Zig 构建 C 代码探索** - 研究 Zig 作为 C/C++ 构建工具的可行性

## 项目结构

```
c-lang/
├── main.c              # 主源文件 (Hello World 示例)
├── CMakeLists.txt      # CMake 构建配置
├── build.zig          # Zig 构建脚本 (实验性)
└── .github/workflows/
    └── cmake.yml      # GitHub Actions CI
```

## 构建方式

### CMake (主要)

```bash
# 配置
cmake -B build

# 构建
cmake --build build

# 运行
./build/bin/c_lang
```

### Zig (实验性)

```bash
# 构建
zig build

# 运行
zig build run
```

## Zig 构建 C 代码探索

本项目包含 `build.zig` 脚本，用于探索 Zig 0.15+ 作为 C 构建工具的能力。

### 构建原理

Zig 内置了 C 编译器（基于 Clang），可以直接编译 C/C++ 代码而无需外部工具链：

```
Zig → Clang → 目标代码
```

### 当前支持

- ✅ C 源文件编译
- ✅ libc 链接（使用 `-lc`）
- ✅ C 标志传递（编译选项、预处理器宏）
- ✅ 包含路径配置
- ✅ 标准目标平台
- ✅ 优化级别选择

### 构建脚本结构

```zig
const c_module = b.createModule(.{
    .target = target,
    .optimize = optimize,
    .link_libc = true,           // 链接 C 标准库
});
c_module.addCSourceFile(.{ .file = b.path("main.c") });

const exe = b.addExecutable(.{
    .name = "c_lang",
    .root_module = c_module,
});
```

### 使用方法

```bash
zig build              # Debug 构建
zig build -Doptimize=ReleaseFast  # Release 优化
zig build run         # 构建并运行
zig build install     # 安装到本地
zig build -Dtarget=x86_64-linux-gnu  # 交叉编译
```

### 进阶配置

**C 编译标志：**
```zig
exe.addCSourceFile(.{
    .file = b.path("main.c"),
    .flags = &.{"-Wall", "-Wextra", "-O3"},
});
```

**预处理器宏：**
```zig
exe.addCMacro("MY_MACRO", "1");
exe.addCMacro(.{"DEBUG", null});  // -DDEBUG
```

**包含路径：**
```zig
exe.addIncludePath(b.path("include"));
```

### 局限性

- 复杂 C 项目支持仍在探索中
- 某些平台特定 API 需额外配置
- 大型 C 代码库需验证兼容性

### 相关项目参考

- [raylib](https://github.com/raysan5/raylib) - 游戏引擎，使用 Zig 构建
- [translate-c](https://github.com/ziglang/translate-c) - C → Zig 转译工具
- [zig-project-starter](https://github.com/muhammad-fiaz/zig-project-starter) - 模板项目

## 技术栈

- **语言**: C11
- **构建工具**: CMake, Zig 0.15+
- **平台**: macOS, Linux, Windows

## 许可证

MIT License