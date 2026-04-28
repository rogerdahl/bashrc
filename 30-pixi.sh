# Pixi package manager

padd "$HOME/.pixi/bin"

if command -v pixi &> /dev/null; then
    source <(pixi completion --shell bash)
fi
