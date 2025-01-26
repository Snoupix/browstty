@run:
    cd {{ justfile_dir() }} && \
    zig build all && \
    cp zig-out/bin/* browstty/public/

# My Ghostty build file config:
#   var config = try buildpkg.Config.init(b);

#   config.wasm_shared = true;
#   config.wasm_target = .browser;
#   config.app_runtime = .none;
#   config.optimize = .Debug;

@build-ghostty:
    cd {{ justfile_dir() / "lib/ghostty" }} && \
    zig build && \
    cp zig-out/include/ghostty.h zig-out/lib/libghostty* {{ justfile_dir() / "lib-built" }}
