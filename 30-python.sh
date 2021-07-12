# Print details about the Python interpreter that starts starts when runnng 'python' in
# the current shell.
py_check() {
  python "${BASHRC_DIR}/bin/py_which.py"
}
# Python

# Aliases are only available in interactive commands and sourced scripts.

alias black='black --skip-string-normalization'

# Run tests with debugging and sample updating
#  --pycharm
#alias p='cls && pytest --exitfirst --random-order-bucket=none --sample-diff'
alias p='cls && pytest --exitfirst --sample-diff'
# Same as p, but disable capture
# --pycharm
alias pc='cls && pytest --exitfirst --sample-diff --capture=no'
# Run tests and coverage in parallel
alias pn='pytest -n auto --cov-report=term --cov-report=xml'

alias clean-pyc='find . -name "*.pyc" -delete'

alias p='pytest -vvv --capture=no --failed-first --exitfirst --reuse-db --sample-ask --pycharm'

# pytest
# with coverage
alias pc='pytest -vvv --capture=no --failed-first --exitfirst --reuse-db --sample-ask --pycharm --cov=. --cov-report=term --cov-report=xml'
alias p='pytest -xvs --sample-ask --pycharm'

alias pyc="\$HOME/bin/JetBrains/pycharm.sh"

alias yapf="yapf -i"

# systemd
alias sys='sudo systemctl'
alias sysj='sudo journalctl'
alias sysu='systemctl --user'
alias sysju='journalctl --user'
# todo: move systemd aliases to better location
