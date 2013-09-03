# http://dotfiles.org/~buttons/.zshrc

# Remove uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
    adm alias apache at bin cron cyrus daemon ftp games gdm guest \
    haldaemon halt mail man messagebus mysql named news nobody nut \
    lp operator portage postfix postgres postmaster qmaild qmaill \
    qmailp qmailq qmailr qmails shutdown smmsp squid sshd sync \
    uucp vpopmail xfs


# Remove uninteresting hosts
zstyle ':completion:*:*:*:hosts-host' ignored-patterns \
    '*.*' loopback localhost
zstyle ':completion:*:*:*:hosts-domain' ignored-patterns \
    '<->.<->.<->.<->' '^*.*' '*@*'
zstyle ':completion:*:*:*:hosts-ipaddr' ignored-patterns \
    '^<->.<->.<->.<->' '127.0.0.<->'
zstyle -e ':completion:*:(ssh|scp):*' hosts 'reply=(
   ${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) \
   /dev/null)"}%%[# ]*}//,/ }
   )'

# SSH Completion
zstyle ':completion:*:scp:*' tag-order \
    files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order \
    files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
    users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order \
    hosts-domain hosts-host users hosts-ipaddr

