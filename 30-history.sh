if [ -f ~/.sync-history.sh ]; then
  . ~/.sync-history.sh
fi

# Delete a section of history. The delete line itself can be deleted by counting one more at the end. The highest value is first:

hist_del() {
  for i in {930..923}; do history -d $i ; done
}


