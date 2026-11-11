;==============================================================================
; PRINCE OF PERSIA  (ZX Spectrum 128, TR-DOS)
; Level 3: tables and map
;
; Converted from the original TASM 3 sources to sjasmplus.
; Copy protection removed, disk positions are symbols from disk.inc.
;==============================================================================
PTOMAN  EQU     250;230
PBLK    EQU     130
PKICK   EQU     247;240

CURLEV  EQU     3
STARTPOS EQU    #0204
STARTLEV EQU    2
STAPOS  EQU     15
STADIR  EQU     0
HEIGHT  EQU     12
LENGHT  EQU     72
WIDTH   DEFB    72
HEIGH   DEFB    12
WDTH    DEFB    9
HGHT    DEFB    4
NLEV    DEFB    "LEVEL 3",0
GATES   DEFW    #FEFE,#FEFE
        DEFW    #0101,#0100
        DEFW    #0103,#0100
        DEFW    #FFFF,#FFFF
LDRINKG DEFW    #0008,#0104,#FFFF
LDRINKS DEFW    #0207,#0303
        DEFW    #0302,#0105
        DEFW    #0102,#0107
        DEFB    #FF
STEELS  DEFW    #0203,#0305
        DEFW    #0100,#0104
        DEFW    #0008,#0302
        DEFW    #0008,#0303
        DEFW    #0008,#0304
        DEFW    #FFFF
EENEMY  DEFB    1,1,21,1,0
        DEFB    0,0,0,0,#FE
AGATEIN DEFW    #0204
        DEFW    #AC0C
AGATE   DEFW    #0200
        DEFW    #AC0E,#AD8F
        DEFB    20,15,2
FIRES   DEFW    #0000,#0000,#0000,#0000,#0000,#0000,#0000,#0000,#0000,#0000,#0000,#0000,#0000,#0000,#AF16,#AF1C,#A10C,#A114
        DEFW    #A108,#A11A,#A80B,#A817,#A10E,#A11D,#A114,#A11E,#A101,#A11E,#A101,#A117,#A101,#A111,#A106,#A10B,#0000,#0000
        DEFW    #AC0C,#AC16,#A810,#A816,#A114,#AF14,#AF0A,#AF1A,#AF03,#AF1B,#AF08,#AF1D,#AF0D,#AF19,#AF03,#AF19,0,0
UNDO
        ORG     39600
LEVELE  ;          1       ;    2      ;     3     ;     4     ;     5     ;     6     ;     7     ;     8     ;     9
        DEFB    "@________________________________________________________________________"
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@____ @"
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@I @"
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@I:___I____I_@"
        DEFB    "@ b_____#_b    I_:I_____#   :______   _________  __::_:c_ __I_  @@@@@@@@@"
        DEFB    "@_I @@@@@ I____I  @@@@@@@    @@@@@@   @@@@@@@@I  @@  @ @@ @@@@  @@@@@@@@@"
        DEFB    "@ I.@@@@@ @@@@@I  @@I  @@!   @@@@@@   @@@I  @@I  @@  @  @ @@@@  @@@@@@@@@"
        DEFB    "@.I____a@ @@@@@@  @ I__I_I   @@@@@@   @@@I  I_I  @@  @  @ @@@@  @@@@@@@@@"
        DEFB    "@@@    @@ I:___I__I_I  @@I   @@@@@@   @@@I  @@I  @@  @  @ @  @  @@@@@@@@@"
        DEFB    "@@@____I__@ @@@@@@@ I..@@@.._I__I_I__.I_II..@@@..II_.I_.I.I_.@__@@@@@@@@@"
        DEFB    "@@@@@@@@@@@ @@@@@@@ I_@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        DEFB    "@@@@@@@@@@@ @@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        DEFB    "@@@@@@@@@@@!@@@@@@@_@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        ORG     UNDO
