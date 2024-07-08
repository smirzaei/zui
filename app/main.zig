const js = struct {
    extern "js" fn log(arg: [*]const u8) void;
};

pub export fn greet() void {
    js.log("Hello from Zig!");
}

pub export fn add(a: i32, b: i32) i32 {
    return a + b;
}
