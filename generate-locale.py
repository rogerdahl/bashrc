#!/usr/bin/env python

import logging
import pathlib
import shutil
import subprocess

import regex
import sys

log = logging.getLogger(__name__)

asc_0 = 48
asc_9 = 57
asc_A = 65
asc_Z = 90
asc_a = 97
asc_z = 122


HERE_PATH = pathlib.Path(__file__).parent.resolve()
LOCALE_PATH = HERE_PATH / 'locale'

SYS_COLLATE_PATH = pathlib.Path('/usr/share/i18n/locales/iso14651_t1')
SYS_COMMON_PATH = pathlib.Path('/usr/share/i18n/locales/iso14651_t1_common')
SYS_EN_US_PATH = pathlib.Path('/usr/share/i18n/locales/en_US')

CUSTOM_COMMON_PATH = pathlib.Path(LOCALE_PATH / (SYS_COMMON_PATH.name + '.custom'))
CUSTOM_EN_US_PATH = pathlib.Path(LOCALE_PATH / (SYS_EN_US_PATH.name + '.custom'))


def main():
    create_custom_common()
    subprocess.run(
        [
            'localedef',
            '--quiet',
            '--verbose',
            '--force',
            '--inputfile',
            CUSTOM_EN_US_PATH,
            '--charmap',
            'UTF-8',
            LOCALE_PATH,
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        cwd=HERE_PATH,
    )


def create_custom_common():
    shutil.copy(SYS_EN_US_PATH, CUSTOM_EN_US_PATH)

    with CUSTOM_COMMON_PATH.open('w') as mod:
        for s in SYS_COMMON_PATH.open():
            cap_list = split_line(s)
            if not cap_list:
                mod.write(s)
                continue
            separate_upper_lower_case(cap_list)
            significant_full_stop(cap_list)
            mod.write(merge_line(cap_list) + '\n')


def separate_upper_lower_case(cap_list):
    """Modify priorities in the collation for a-z and A-Z so that they are sorted
    separately.
    """
    try:
        asc_int = int(cap_list[0].strip('U<>'), base=16)
    except ValueError:
        return
    if asc_A <= asc_int <= asc_Z or asc_a <= asc_int <= asc_z:
        base_idx = cap_list.index('<BASE>')
        cap_list.pop(base_idx)
        cap_list.insert(base_idx + 1, '<BASE>')


def significant_full_stop(cap_list):
    """
    Set the FULL STOP symbol to top priority, which causes dot-files to be sorted
    separately and at the top of the list.
       % <U002E> IGNORE;IGNORE;IGNORE;<U002E> % FULL STOP
    -> % <U002E> <RES-1>;IGNORE;IGNORE;<U002E> % FULL STOP
    """
    if cap_list[0] == '<U002E>':
        cap_list[1] = '<RES-1>'


def split_line(s):
    """
       <U002E> IGNORE;IGNORE;IGNORE;<U002E> % FULL STOP
    -> ['<U002E>'. 'IGNORE', 'IGNORE', 'IGNORE', '<U002E>', ' % FULL STOP']
    """
    s = s.strip()
    m = regex.match('(?:(?:\s|;)*(<.*?>))+(.*)', s.strip(), regex.IGNORECASE)
    if m:
        return [*m.captures(1), m.group(2)]


def merge_line(cap_list):
    return f'{cap_list[0]} {";".join(cap_list[1:-1])}{cap_list[-1]}'


def encode(s):
    return ''.join(f"<U{ord(c):04X}>" for c in sys.argv[1])


if __name__ == '__main__':
    sys.exit(main())
