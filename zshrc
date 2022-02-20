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

# - - - - - - - - - - - - - - - - - - - -
# Annexes
# - - - - - - - - - - - - - - - - - - - -

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# - - - - - - - - - - - - - - - - - - - -
# OMZ Libs and Plugins
# - - - - - - - - - - - - - - - - - - - -

# Load these plugins ASAP without Turbo. Explanation:
# - Loading tmux first, to prevent jumps when tmux is loaded after .zshrc
# - History plugin is loaded early (as it has some defaults) to prevent empty history stack for other plugins
zinit lucid for \
    atinit"HIST_STAMPS=dd.mm.yyyy" \
        OMZL::history.zsh \

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
    OMZP::aliases \
    OMZP::command-not-found \
    OMZP::dirhistory \
    OMZP::git \
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
    atpull'zinit creinstall -q .' blockf \
        zsh-users/zsh-completions 

# - - - - - - - - - - - - - - - - - - - -
# FZF
# - - - - - - - - - - - - - - - - - - - -

# # Taken from https://github.com/zdharma-continuum/zinit-configs/blob/master/vladdoster/.zshrc#L81

# zinit wait'0b' lucid from"gh-r" as"program" for \
#     @junegunn/fzf
# zinit ice wait'0a' lucid; zi snippet https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
# zinit ice wait'1a' lucid; zi snippet https://github.com/junegunn/fzf/blob/master/shell/completion.zsh
# zinit wait'1a' lucid pick"fzf-extras.zsh"        light-mode for \
#     @atweiden/fzf-extras
# zinit wait'0c' lucid pick"fzf-finder.plugin.zsh" light-mode for \
#     @leophys/zsh-plugin-fzf-finder

# - - - - - - - - - - - - - - - - - - - -
# Binaries
# - - - - - - - - - - - - - - - - - - - -

zinit wait'1a' depth'1' lucid from"gh-r" as'program' for \
  pick"delta*/delta"             dandavison/delta        \
  pick'git-sizer'                @github/git-sizer       \
  pick'grex'                     pemistahl/grex          \
  pick'shfmt'  bpick"${bpick}"   @mvdan/sh

zinit wait'1b' depth'1' lucid from'gh-r' as"command" for \
  mv'bat* bat'             sbin'**/bat -> bat'             @sharkdp/bat       \
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
  sbin'**/exa -> exa'      atclone'cp -vf completions/exa.zsh _exa' \
  atload"alias ls='exa --git --group-directories-first'
         alias l='ls -blF'
         alias la='ls -abghilmu'
         alias ll='ls -al'
         alias tree='exa --tree'" \
    ogham/exa

# - - - - - - - - - - - - - - - - - - - -
# End Profiling Script
# - - - - - - - - - - - - - - - - - - - -

if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
    zprof > ~/zshprofile$(date +'%s')
fi
