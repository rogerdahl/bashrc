#!/usr/bin/env python

import logging
import pathlib
import re
import shutil
import subprocess

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
        is_modified = False
        for s in SYS_COMMON_PATH.open():
            is_modified = False
            el_list, pri_list = split_line(s)
            if pri_list:
                # if not pri_list:
                #     mod.write(s)
                #     continue
                is_modified |= separate_upper_lower_case(el_list, pri_list)
                # is_modified |= significant_full_stop(el_list, pri_list)
                # is_modified |= significant_underscore(el_list, pri_list)
            if is_modified:
                print(f'old: {s}', end='')
                s = merge_line(el_list, pri_list) + '\n'
                print(f'new: {s}', end='')
                # print()
            mod.write(s)

"""
% First-level

Symbols
collating-symbol <S0009>..<S327F> % Alphabetics, syllabics, general symbols
collating-symbol <S4DC0>..<S4DFF> % Yijing hexagram symbols
collating-symbol <SA000>..<SABFF> % Alphabetics, syllabics, general symbols
collating-symbol <SFD3E>..<SFD3F> % Ornate parentheses (Arabic)
collating-symbol <SFBB2>..<SFBC1> % Some Symbols (Arabic)
collating-symbol <SFDFD>          % Bismillah symbol (Arabic)

Weights
<S0009> % HORIZONTAL TABULATION (in ISO 6429)
<S000A> % LINE FEED (in ISO 6429)
<S000B> % VERTICAL TABULATION (in ISO 6429)
<S000C> % FORM FEED (in ISO 6429)
<S000D> % CARRIAGE RETURN (in ISO 6429)
<S0085> % NEXT LINE (in ISO 6429)
<S2028> % LINE SEPARATOR
<S2029> % PARAGRAPH SEPARATOR
<S0020> % SPACE
<S203E> % OVERLINE
<S005F> % LOW LINE

% Second-level
Symbols
collating-symbol <BASE>
collating-symbol <LOWLINE>  % COMBINING LOW LINE
collating-symbol <PSILI>  % COMBINING COMMA ABOVE
collating-symbol <DASIA>  % COMBINING REVERSED COMMA ABOVE
collating-symbol <AIGUT>  % COMBINING ACUTE ACCENT
collating-symbol <GRAVE>  % COMBINING GRAVE ACCENT

Weights
<BASE>
<LOWLINE>  % COMBINING LOW LINE
<PSILI>  % COMBINING COMMA ABOVE
<DASIA>  % COMBINING REVERSED COMMA ABOVE
<AIGUT>  % COMBINING ACUTE ACCENT
<GRAVE>  % COMBINING GRAVE ACCENT
<BREVE>  % COMBINING BREVE
<CIRCF>  % COMBINING CIRCUMFLEX ACCENT

% Third-level collating symbols

Symbols
collating-symbol <RES-1>  % unused in table
collating-symbol <BLK>  % unused in table
collating-symbol <MIN>
collating-symbol <WIDE>
collating-symbol <COMPAT>

Weights
<RES-1>  % unused in table
<BLK>  % unused in table
<MIN>
<WIDE>
<COMPAT>
<FONT>




% Special fourth-level collating symbol

collating-symbol <PLAIN> % Maximal level 4 weight

collating-element <U004C_00B7> from "<U004C><U00B7>" % decomposition of LATIN CAPITAL LETTER L WITH MIDDLE DOT
collating-element <U004C_0387> from "<U004C><U0387>" % decomposition of LATIN CAPITAL LETTER L WITH MIDDLE DOT
collating-element <U006C_00B7> from "<U006C><U00B7>" % decomposition of LATIN SMALL LETTER L WITH MIDDLE DOT
collating-element <U006C_0387> from "<U006C><U0387>" % decomposition of LATIN SMALL LETTER L WITH MIDDLE DOT
collating-element <U0418_0306> from "<U0418><U0306>" % decomposition of CYRILLIC CAPITAL LETTER SHORT I


<Uxxxx> <Base>;<Accent>;<Case>;<Special>


"""

def separate_upper_lower_case(el_list, pri_list):
    """Modify priorities in the collation for a-z and A-Z so that they are sorted
    separately.
    """
    try:
        asc_int = int(el_list[0].strip('U<>'), base=16)
    except ValueError:
        return False
    if asc_A <= asc_int <= asc_Z or asc_a <= asc_int <= asc_z:

        if asc_int == 79:
            pri_list[0] = 'IGNORE'
            pri_list[1] = 'IGNORE'
            pri_list[2] = 'IGNORE'
            # pri_list[3] = 'IGNORE'
        # print(el_list, pri_list)
        # base_idx = pri_list.index('<BASE>')
        # pri_list.pop(base_idx)
        # pri_list.insert(base_idx + 1, '<BASE>')
        # pri_list[2] = '<MIN>'
        return True
    return False


def significant_full_stop(el_list, pri_list):
    """
    Set "." (FULL STOP) to be significant (not ignored) and set its sort order to be
    in front of everything else.
       % <U002E> IGNORE;IGNORE;IGNORE;<U002E> % FULL STOP
    -> % <U002E> <RES-1>;IGNORE;IGNORE;<U002E> % FULL STOP
    """
    if el_list[0] == '<U002E>':
        print(el_list, pri_list)
        pri_list[:] = ['<RES-1>']*4
        return True
    return False


def significant_underscore(el_list, pri_list):
    """Handle "_" (LOW LINE) like ".", with sort order just below ".".
    """
    if el_list[0] == '<U005F>':
        print(el_list, pri_list)
        pri_list[0] = '<BEFORE-LATIN>'
        # pri_list[1] = '<RES-1>'
        # pri_list[2] = '<RES-1>'
        # pri_list[3] = '<RES-1>'
        return True
    return False


def split_line(s):
    """
       <U002E> IGNORE;IGNORE;IGNORE;<U002E> % FULL STOP
    -> ['<U002E>'. 'IGNORE', 'IGNORE', 'IGNORE', '<U002E>', ' % FULL STOP']
    """
    el_list = s.split(' ')
    if len(el_list) >= 2:
        pri_list = el_list[1].split(';')
    else:
        pri_list = []
    return el_list, pri_list

    # s = s.strip()
    # return re.split(r'[ ;]', s, maxsplit=4)
    # m = regex.match('(?:(?:\s|;)*(<.*?>))+(.*)', s.strip(), regex.IGNORECASE)
    # if m:
    #     return [*m.captures(1), m.group(2)]


def merge_line(el_list, pri_list):
    if len(el_list) >= 2 and pri_list:
        el_list[1] = ';'.join(pri_list)
    return ' '.join(el_list)


def encode(s):
    return ''.join(f"<U{ord(c):04X}>" for c in sys.argv[1])


if __name__ == '__main__':
    sys.exit(main())
