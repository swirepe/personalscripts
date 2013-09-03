
# completion for commands we don't have  and use a cache for completion
# http://dotfiles.org/~buttons/.zshrc
# http://dotfiles.org/~chimpyw/.zshrc

zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST


