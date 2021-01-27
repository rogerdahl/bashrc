#!/usr/bin/env python

"""Generate some random strings and sort them using the current LC_COLLATE"""
import locale
import logging
import random
import sys

log = logging.getLogger(__name__)


voc_str = '    ._$@01234A5BCDEabcde'
def main():
    rnd_str = [
        ''.join(random.choices(list(voc_str), k=random.randint(1, 10)))
        for _ in range(100)
    ]
    print('\n'.join(sorted(rnd_str, key=lambda x: locale.strxfrm(x))))


if __name__ == '__main__':
    sys.exit(main())
