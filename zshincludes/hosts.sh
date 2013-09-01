# This adds remote hostnames for 'ssh' and other network commands to the autocomplete suggestions, based on the contents of your ~/.ssh/known_hosts lists.
# http://stackoverflow.com/questions/171563/whats-in-your-zshrc
zstyle -e ':completion::*:hosts' hosts 'reply=($(sed -e "/^#/d" -e "s/ .*\$//" -e "s/,/ /g" /etc/ssh_known_hosts(N) ~/.ssh/known_hosts(N) 2>/dev/null | xargs) $(grep \^Host ~/.ssh/config(N) | cut -f2 -d\  2>/dev/null | xargs))'
