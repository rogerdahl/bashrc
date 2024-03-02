# Rust

cargo_dir="$HOME/.cargo"
padd "${cargo_dir}/bin/"
is_file "${cargo_dir}/bin/env" && . "${cargo_dir}/bin/env"
is_file "${cargo_dir}/env"     && . "${cargo_dir}/env"

# Build rust binaries

binary_arr=(
  bandwhich
  bat
  cargo-add
  cargo-expand
  cargo-rm
  cargo-install-update
  cargo-install-update-config
  cargo-watch
  ddh
  diskonaut
  dust
  dua
  exa
  fd
  delta
  gix
  gixp
  grex
  kondo
  procs
  rg
  rip
  rmesg
  sd
  tokei
  viu
  ytop
  zoxide
)

rust-install-all() {
 for b in "${binary_arr[@]}"; do
   cargo install "$b"
 done
}

