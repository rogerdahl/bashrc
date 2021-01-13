# Rust

cargo_dir="$HOME/.cargo"
padd "${cargo_dir}/bin/"
is_file "${cargo_dir}/bin/env" && . "${cargo_dir}/bin/env"
