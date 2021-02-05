# Perl 5

#PERL_ROOT="$HOME/perl5"
#padd "$PERL_ROOT/bin"
#PERL5LIB="$PERL_ROOT/lib/perl5/${PERL5LIB:+:$PERL5LIB})"; export PERL5LIB
#PERL_LOCAL_LIB_ROOT="$PERL_ROOT/${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT
#PERL_MB_OPT="--install_base $PERL_ROOT"; export PERL_MB_OPT
#PERL_MM_OPT="INSTALL_BASE=$PERL_ROOT"; export PERL_MM_OPT

# We remove all duplicates in a single call to dedup here because it's an expensive
# operation. Calling dedup within padd() doubles the time it takes to source this script
# on my machine. Also, this catches duplicates created by sourcing this script multiple
# times or adding to paths outside of padd().
#
# Once a variable has been exported, changes to it are automatically visible everywhere
# -- it doesn't have to be exported again.

#for p in PATH PERL5LIB PERL_LOCAL_LIB_ROOT; do
#  eval v=\$$p
#  v=$(dedup "$v")
#  eval $p=\$v
#done

#for v in PATH PERL5LIB PERL_LOCAL_LIB_ROOT; do eval v=\$$v; echo $v; done

#for v in PATH PERL5LIB PERL_LOCAL_LIB_ROOT; do v=$(dedup "${!v}"); export v; done

#PERL5LIB="$(dedup "PERL5LIB")"; export PERL5LIB
#PERL_LOCAL_LIB_ROOT="$(dedup "PERL_LOCAL_LIB_ROOT")"; export PERL_LOCAL_LIB_ROOT

# Check stuff
#print \\nPATH\\n; path
#printf \\nPERL5LIB\\n; path "$PERL5LIB"
#printf \\nPERL_LOCAL_LIB_ROOT\\n; path "$PERL_LOCAL_LIB_ROOT"

#PATH="/home/dahl/perl5/bin${PATH:+:${PATH}}"; export PATH;
#PERL5LIB="/home/dahl/local/lib/perl5:/home/dahl/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
#PERL_LOCAL_LIB_ROOT="/home/dahl/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
#PERL_MB_OPT="--install_base \"/home/dahl/perl5\""; export PERL_MB_OPT;
#PERL_MM_OPT="INSTALL_BASE=/home/dahl/perl5"; export PERL_MM_OPT;

#source ~/perl5/perlbrew/etc/bashrc
