# Python

# Aliases are only available in interactive commands and sourced scripts.

# Reminder to use specific 2to3.
alias 2to3='Use a version of 2to3 that is specific to the target version of Python'

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
alias pyc-clean="echo Use pyclean"

alias p='pytest -vvv --capture=no --failed-first --exitfirst --reuse-db --sample-ask --pycharm'

# pytest
# with coverage
alias pc='pytest -vvv --capture=no --failed-first --exitfirst --reuse-db --sample-ask --pycharm --cov=. --cov-report=term --cov-report=xml'
alias p='pytest -xvs --sample-ask --pycharm'

alias pyc="\$HOME/bin/JetBrains/pycharm.sh"
alias pyc-clean="echo Use pyclean"

alias yapf="yapf -i"

# systemd
alias sys='sudo systemctl'
alias sysj='sudo journalctl'
alias sysu='systemctl --user'
alias sysju='journalctl --user'
