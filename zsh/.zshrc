fpath=($ZDOTDIR/external $fpath)

source "$XDG_CONFIG_HOME/zsh/aliases"

autoload -Uz compinit; compinit
# Autocomplete hidden files
_comp_options+=(globdots)
source ~/dotfiles/zsh/external/completion.zsh

autoload -Uz prompt_purification_setup; prompt_purification_setup

# Push the current directory visited on to the stack.
setopt AUTO_PUSHD
# Do not store duplicate directories in the stack
setopt PUSHD_IGNORE_DUPS
# Do not print the directory stack after using
setopt PUSHD_SILENT

# vi mode in zsh
bindkey -v
export KEYTIMEOUT=1

# beam for INSERT mode and block for NORMAL mode in zsh
autoload -Uz cursor_mode && cursor_mode

# vim mapping for zsh completion
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# multiple options regarding history

setopt EXTENDED_HISTORY
# share history across multiple zsh sessions
setopt SHARE_HISTORY
# append to history
setopt APPEND_HISTORY
# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST
# do not store duplications
setopt HIST_IGNORE_DUPS
#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
# allow comments in interactive shell
setopt INTERACTIVE_COMMENTS

#edit zsh commands in neovim
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

#
# fzf and ripgrep
#
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
export FZF_COMPLETION_TRIGGER='~~'
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs \
		-g "!{.git,renv}/*" 2> /dev/null'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

# Quickly jump to a parent directory
source ~/dotfiles/zsh/external/bd.zsh

# Clearing the shell is now done with CTRL+g 
# because c-l is used to navigate panes in tmux
bindkey -r '^l'
bindkey -r '^g'
bindkey -s '^g' 'clear\n'

if [ $(command -v "fzf") ]; then
    source /usr/share/fzf/completion.zsh
    source /usr/share/fzf/key-bindings.zsh
fi

if [ "$(tty)" = "/dev/tty1" ];
then
    pgrep i3 || exec startx "$XDG_CONFIG_HOME/X11/.xinitrc"
fi

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#
# ruby
#
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$PATH:$GEM_HOME/bin"
