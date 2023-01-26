# Skip the not really helping Ubuntu global compinit
skip_global_compinit=1

# Cargo
. "$HOME/.cargo/env"

# Add locally installed binaries
export PATH="$PATH:$HOME/.local/bin"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
