# Rust

cargo_dir="$HOME/.cargo"
padd "${cargo_dir}/bin/"
is_file "${cargo_dir}/bin/env" && . "${cargo_dir}/bin/env"
is_file "${cargo_dir}/env"     && . "${cargo_dir}/env"

# Build rust binaries

binary_arr=(
  alacritty
  bandwhich
  bat
  cargo
  cargo-add
  cargo-clippy
  cargo-expand
  cargo-fmt
  cargo-install-update
  cargo-install-update-config
  cargo-lbench
  cargo-lbuild
  cargo-lcheck
  cargo-lclippy
  cargo-lfix
  cargo-lrun
  cargo-ltest
  cargo-miri
  cargo-rm
  cargo-upgrade
  cargo-watch
  clippy-driver
  ddh
  delta
  diskonaut
  dua
  du-dust
  exa
  fd-find
  git-delta
  gix
  gixp
  grex
  kondo
  kondo-ui
  navi
  parallel
  procs
  rg
  ripgrep
  rls
  rmesg
  rustc
  rustdoc
  rustfmt
  rust-gdb
  rust-lldb
  rustup
  sd
  sk
  sn
  tldr
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

alias fd='fd --no-ignore'
