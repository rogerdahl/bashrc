# Konsole

# Copy settings for konsole to another machine.
konsole_sync() {
  [[ -n "$1" ]] || {
    echo "Usage: $1 <ssh server name without \":\">"
    return 1
  }
  [[ -n "$RSYNC_ARGS" ]] || {
    echo "Missing RSYNC_ARGS"
    return 1
  }
  rsync $RSYNC_ARGS .config/konsole* "$1":.config/
  rsync $RSYNC_ARGS .local/share/konsole "$1":.local/share/
}

# Automatically set up Konsole with predefined tabs with titles and executes.
#source ~/bin/konsole-tabs.sh
#load-dev(){
#    local sessions=(
#        oak           Shell        'clear; cd ~/git/apache/oak'
#        sling         Shell        'clear; cd ~/git/apache/sling'
#        felix         Shell        'clear; cd ~/git/apache/felix'
#     )
#    start_sessions sessions[@]
#}


# This works best when sudo doesn't require a password. If it does, have to go to each
# sudo tab and type it in.
#tab_tup = (
#    ('vpn',     ('m', 'sudo bin/vpn.sh')),
#    ('root',    ('m', 'cd dev', 'sudo -s')),
#    ('pycharm', ('m', 'cd dev', '. activate', 'pycharm')),
#    ('webapp',  ('m', 'cd dev', '. activate', '#python mms/webapp/app.wsgi --threaded')),
#    ('dev',     ('m', 'cd dev', '. activate')),
#    ('dev2',    ('m', 'cd dev', '. activate')),
#    ('tmp',     ('m', 'cd dev', '. activate', 'cd tmp')),
#)
