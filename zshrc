#!usr/bin/env zsh

# - - - - - - - - - - - - - - - - - - - -
# Profiling Tools
# - - - - - - - - - - - - - - - - - - - -

PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    zmodload zsh/zprof
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$HOME/startlog.$$
    setopt xtrace prompt_subst
fi

# - - - - - - - - - - - - - - - - - - - -
# Zsh Core Configuration
# - - - - - - - - - - - - - - - - - - - -

export XDG_CONFIG_HOME="$HOME/.config"

export CACHEDIR="$HOME/.local/share"
[[ -d "$CACHEDIR" ]] || mkdir -p "$CACHEDIR"

# Load The Prompt System And Completion System And Initilize Them.
autoload -Uz compinit promptinit

# Load And Initialize The Completion System Ignoring Insecure Directories With A
# Cache Time Of 20 Hours, So It Should Almost Always Regenerate The First Time A
# Shell Is Opened Each Day.
# See: https://gist.github.com/ctechols/ca1035271ad134841284
_comp_files=(${ZDOTDIR:-$HOME}/.zcompdump(Nm-20))
if (( $#_comp_files )); then
    compinit -i -C
else
    compinit -i
fi
unset _comp_files
promptinit
setopt prompt_subst

# - - - - - - - - - - - - - - - - - - - -
# ZSH Settings
# - - - - - - - - - - - - - - - - - - - -

autoload -U colors && colors    # Load Colors.
unsetopt case_glob              # Use Case-Insensitve Globbing.
setopt extendedglob             # Use Extended Globbing.
setopt autocd                   # Automatically Change Directory If A Directory Is Entered.

# Smart URLs.
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# General.
setopt brace_ccl                # Allow Brace Character Class List Expansion.
setopt combining_chars          # Combine Zero-Length Punctuation Characters ( Accents ) With The Base Character.
setopt rc_quotes                # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
unsetopt mail_warning           # Don't Print A Warning Message If A Mail File Has Been Accessed.

# Jobs.
setopt long_list_jobs           # List Jobs In The Long Format By Default.
setopt auto_resume              # Attempt To Resume Existing Job Before Creating A New Process.
setopt notify                   # Report Status Of Background Jobs Immediately.
unsetopt bg_nice                # Don't Run All Background Jobs At A Lower Priority.
unsetopt hup                    # Don't Kill Jobs On Shell Exit.
unsetopt check_jobs             # Don't Report On Jobs When Shell Exit.

setopt correct                  # Turn On Corrections

# Completion Options.
setopt complete_in_word         # Complete From Both Ends Of A Word.
setopt always_to_end            # Move Cursor To The End Of A Completed Word.
setopt auto_menu                # Show Completion Menu On A Successive Tab Press.
setopt auto_list                # Automatically List Choices On Ambiguous Completion.
setopt auto_param_slash         # If Completed Parameter Is A Directory, Add A Trailing Slash.
setopt no_complete_aliases

setopt menu_complete            # Do Not Autoselect The First Completion Entry.
unsetopt flow_control           # Disable Start/Stop Characters In Shell Editor.

# Zstyle.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$HOME/.zcompcache"
zstyle ':completion:*' list-colors $LS_COLORS
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*' rehash true

# History.
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=100000
SAVEHIST=5000
setopt appendhistory notify
unsetopt beep nomatch

setopt bang_hist                # Treat The '!' Character Specially During Expansion.
setopt inc_append_history       # Write To The History File Immediately, Not When The Shell Exits.
setopt share_history            # Share History Between All Sessions.
setopt hist_expire_dups_first   # Expire A Duplicate Event First When Trimming History.
setopt hist_ignore_dups         # Do Not Record An Event That Was Just Recorded Again.
setopt hist_ignore_all_dups     # Delete An Old Recorded Event If A New Event Is A Duplicate.
setopt hist_find_no_dups        # Do Not Display A Previously Found Event.
setopt hist_ignore_space        # Do Not Record An Event Starting With A Space.
setopt hist_save_no_dups        # Do Not Write A Duplicate Event To The History File.
setopt hist_verify              # Do Not Execute Immediately Upon History Expansion.
setopt extended_history         # Show Timestamp In History.

# - - - - - - - - - - - - - - - - - - - -
# Zinit Configuration
# - - - - - - - - - - - - - - - - - - - -

if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# - - - - - - - - - - - - - - - - - - - -
# Theme
# - - - - - - - - - - - - - - - - - - - -

# Most Themes Use This Option.
setopt promptsubst

# Provide A Simple Prompt Till The Theme Loads
PS1="READY >"

# Load starship
zinit ice from"gh-r" as"command" atload'eval "$(starship init zsh)"'
zinit load starship/starship

# Load LS_COLORS
zinit ice wait"0c" lucid reset \
    atclone"local P=${${(M)OSTYPE:#*darwin*}:+g}
            \${P}sed -i \
            '/DIR/c\DIR 38;5;63;1' LS_COLORS; \
            \${P}dircolors -b LS_COLORS > c.zsh" \
    atpull'%atclone' pick"c.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS

# - - - - - - - - - - - - - - - - - - - -
# Annexes
# - - - - - - - - - - - - - - - - - - - -

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust \
    NICHOLAS85/z-a-linkman \
    NICHOLAS85/z-a-linkbin

# - - - - - - - - - - - - - - - - - - - -
# Plugins
# - - - - - - - - - - - - - - - - - - - -

# Load these plugins ASAP without Turbo. Explanation:
# - Loading tmux first, to prevent jumps when tmux is loaded after .zshrc
# - History plugin is loaded early (as it has some defaults) to prevent empty history stack for other plugins
zinit lucid for \
    atinit"HIST_STAMPS=dd.mm.yyyy" \
        OMZL::history.zsh \

# Trigger-load block
 zinit wait depth'3' lucid light-mode for \
    trigger-load'!x' svn \
        OMZ::plugins/extract \
    trigger-load'!man' \
        ael-code/zsh-colored-man-pages \
    trigger-load'!z' \
        agkozak/zsh-z

# Load OMZ plugins in Turbo mode
zinit wait lucid for \
  OMZL::clipboard.zsh \
  OMZL::compfix.zsh \
  OMZL::completion.zsh \
  OMZL::correction.zsh \
  OMZL::directories.zsh \
  OMZL::functions.zsh \
  OMZL::git.zsh \
  OMZL::grep.zsh \
  OMZL::key-bindings.zsh \
  OMZL::misc.zsh \
  OMZL::spectrum.zsh \
  OMZL::termsupport.zsh \
  OMZP::command-not-found \
  OMZP::debian \
  OMZP::dirhistory \
  OMZP::git \
  OMZP::git-extras \
  OMZP::rust \
  OMZP::sudo \
  djui/alias-tips

# Load important plugins
zinit wait lucid light-mode for \
        zdharma-continuum/history-search-multi-word \
    atinit"ZINIT[COMPINIT_OPTS]='-i' zpcompinit; zpcdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions

# - - - - - - - - - - - - - - - - - - - -
# FZF
# - - - - - - - - - - - - - - - - - - - -

# Taken from https://github.com/zdharma-continuum/zinit-configs/blob/master/vladdoster/.zshrc#L81

zinit wait'0b' lucid from"gh-r" as"program" for @junegunn/fzf

# zinit ice wait'0a' lucid; zi snippet https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
zinit ice wait'1a' lucid; zi snippet https://github.com/junegunn/fzf/blob/master/shell/completion.zsh

# Handy plugins built on top of fzf
zinit wait'2' lucid for \
    atinit"forgit_ignore='fgi'" \
        wfxr/forgit

# - - - - - - - - - - - - - - - - - - - -
# Binaries
# - - - - - - - - - - - - - - - - - - - -

zinit wait'0c' depth'3' lucid light-mode binary from'gh-r' lman lbin for \
    lbin'**/gh' atclone'./**/gh completion --shell zsh > _gh' atpull'%atclone' \
        cli/cli \
    atclone'./just --completions zsh > _just' atpull'%atclone' \
        casey/just \

zinit wait'1a' depth'1' lucid from"gh-r" as'program' for \
  pick"delta*/delta"             dandavison/delta        \
  pick'git-sizer'                @github/git-sizer       \
  pick'grex'                     pemistahl/grex          \
  pick'shfmt'  bpick"${bpick}"   @mvdan/sh

zinit wait'1b' depth'1' lucid from'gh-r' as"command" for \
  mv'bat* bat'             sbin'**/bat -> bat'          \
  atload'export BAT_THEME="Dracula"' \
    @sharkdp/bat       \
  mv'fd* fd'               sbin'**/fd -> fd'               @sharkdp/fd        \
  mv'hyperfine* hyperfine' sbin'**/hyperfine -> hyperfine' @sharkdp/hyperfine \
  mv'rip* ripgrep'         sbin'**/rg -> rg'               BurntSushi/ripgrep \
  mv'nvim* nvim'           sbin"**/bin/nvim -> nvim"       bpick"${bpick}"    \
  atload'export EDITOR="nvim"
         alias v="${EDITOR}"
         alias vi="${EDITOR}"
         alias vim="${EDITOR}"
         ' \
    neovim/neovim \
  sbin'**/exa -> exa'      atclone'cp -vf completions/exa.zsh _exa'  atpull"%atclone" \
  atload"alias ls='exa --git --group-directories-first'
         alias l='ls -blF'
         alias la='ls -abghilmu'
         alias ll='ls -al'
         alias tree='exa --tree'" \
    ogham/exa

# - - - - - - - - - - - - - - - - - - - -
# Git extensions
# - - - - - - - - - - - - - - - - - - - -
zinit as"null" wait"3" lucid for \
    sbin Fakerr/git-recall \
    sbin paulirish/git-open \
    sbin paulirish/git-recent \
    sbin davidosomething/git-my \
    sbin atload"export _MENU_THEME=legacy" \
      arzzen/git-quick-stats \
    make"PREFIX=$ZPFX" atclone'cp -vf etc/git-extras-completion.zsh _git-extras' atpull"%atclone" \
      tj/git-extras

# - - - - - - - - - - - - - - - - - - - -
# Managers 
# - - - - - - - - - - - - - - - - - - - -

# pyenv
zinit ice atclone'PYENV_ROOT="$PWD" ./libexec/pyenv init --path > zpyenv.zsh
                  PYENV_ROOT="$PWD" ./libexec/pyenv init - >> zpyenv.zsh
    ' \
    atinit'export PYENV_ROOT="$PWD"' atpull"%atclone" \
    as'command' pick'bin/pyenv' src"zpyenv.zsh" nocompile'!'
zinit light pyenv/pyenv

# - - - - - - - - - - - - - - - - - - - -
# End Profiling Script
# - - - - - - - - - - - - - - - - - - - -

if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
    zprof > ~/zshprofile$(date +'%s')
fi
