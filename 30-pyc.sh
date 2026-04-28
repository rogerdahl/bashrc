# Run pyc tasks with Pixi

pyc() {
    pixi run --manifest-path ~/pyc/pyproject.toml "$@"
}

