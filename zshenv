# Skip the not really helping Ubuntu global compinit
skip_global_compinit=1

# Add locally installed binaries
export PATH="$PATH:$HOME/.local/bin"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
