# Skip the not really helping Ubuntu global compinit
skip_global_compinit=1

# Cargo
. "$HOME/.cargo/env"

# Add locally installed binaries
export PATH="$PATH:$HOME/.local/bin"