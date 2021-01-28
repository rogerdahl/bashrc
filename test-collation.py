#!/usr/bin/env python

"""Generate some random strings and sort them using the current LC_COLLATE"""
import locale
import logging
import pathlib
import random
import sys

log = logging.getLogger(__name__)


voc_str = '    ._$@01234A5BODEabcde'
def main():
    rnd_str = [
        ''.join(random.choices(list(voc_str), k=5))
        for _ in range(100)
    ]

    for s in rnd_str:
        pathlib.Path('t', s).touch()

    print('\n'.join(sorted(rnd_str, key=lambda x: locale.strxfrm(x))))


if __name__ == '__main__':
    sys.exit(main())
