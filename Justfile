@run:
    cd {{ justfile_dir() }} && \
    zig build
    cp zig-out/bin/* browstty/public/
