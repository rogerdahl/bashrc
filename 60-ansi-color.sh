#! /usr/bin/perl

# Strip ANSI escape codes
# From Term::ANSIColor
strip_ansi() {
  perl -pe '
    use strict;
    use warnings;
    while (<>) {
      s/\e\[?.*?[\@-~]//g;
      print;
    }
  '
}
