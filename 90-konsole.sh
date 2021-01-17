function konsole-sync() {
  rs .config/konsole* "$1":.config/
  rs .local/share/konsole "$1":.local/share/
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


- Take out EDI links
- entityName or objectName

