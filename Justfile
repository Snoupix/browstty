@run:
    cd {{ justfile_dir() }} && \
    zig build all && \
    cp zig-out/bin/* browstty/public/

@build-ghostty:
    cd {{ justfile_dir() / "lib/ghostty" }} && \
    zig build && \
    cp zig-out/include/ghostty.h zig-out/lib/libghostty* {{ justfile_dir() / "lib-built" }}
