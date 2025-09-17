alias stl='echo use fstl'

mk_stl_thumbnails() {
  if [ ! -d thumb ] ; then
    mkdir thumb
  fi

  for e in stl STL ; do
    for i in *.$e  ; do
      j=$(basename "$i" .$e)
      if [ ! -f thumb/"$j".png -o "$i" -nt thumb/"$j".png ] ; then
        echo $j
        echo "import(\"$i\");" > x.scad
        openscad -o thumb/"$j".png --imgsize=100,100 x.scad
      fi
    done
  done

  rm -f x.scad
}
