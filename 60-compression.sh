# Compression

# Uncompress without chance of tarbombs
#alias unzip="echo Use dtrx"
#alias z="dtrx"

# TODO: This pattern gives a nice progress bar while compressing. Make a / alias.
# tar -c dot-minders | xz -vv --lzma2=dict=192MiB big_foo.tar

# atool
atool_setup() {
  sudo apt install lbzip2 arc arj lzip nomarch rar rpm unace unalz atool
}



