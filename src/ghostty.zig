const ghostty = @cImport({
    @cInclude("ghostty.h");
});

pub fn init() void {
    const config = ghostty.ghostty_runtime_config_s{};
    ghostty.ghostty_app_new(@ptrCast(&config), ghostty.ghostty_config_t);
}
