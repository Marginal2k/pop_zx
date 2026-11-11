;==============================================================================
; PRINCE OF PERSIA  (ZX Spectrum 128, TR-DOS)
; Level 8: tables and map
;
; Converted from the original TASM 3 sources to sjasmplus.
; Copy protection removed, disk positions are symbols from disk.inc.
;==============================================================================
PTOMAN  EQU     230;230
PBLK    EQU     120
PKICK   EQU     240;240

CURLEV  EQU     8
STARTPOS EQU    #0002
STARTLEV EQU    1
STAPOS  EQU     25
STADIR  EQU     0
HEIGHT  EQU     12
LENGHT  EQU     88
WIDTH   DEFB    88
HEIGH   DEFB    12
WDTH    DEFB    11
HGHT    DEFB    4
NLEV    DEFB    "LEVEL 8",0
GATES   DEFW    #0001,#0100
        DEFW    #0104,#0101
        DEFW    #0105,#0100
        DEFW    #0107,#0100
        DEFW    #0108,#0100
        DEFW    #0109,#0100
        DEFW    #FEFE,#FEFE
LDRINKG DEFW    #FFFF,#FFFF
LDRINKS DEFW    #0000,#0206
        DEFW    #0006,#0307
        DEFW    #0108,#0202
        DEFW    #000A,#0302
        DEFW    #FFFF,#FFFF
STEELS  DEFW    #0100,#0204
        DEFW    #0103,#0101
        DEFW    #0103,#0102
        DEFW    #0105,#0105
        DEFW    #0108,#0103
        DEFW    #0108,#0106
        DEFW    #FFFF,#FFFF
EENEMY  DEFB    1,0,16,0,4
        DEFB    5,1,7,0,4
        DEFB    7,1,27,2,4
        DEFB    9,1,20,0,4
        DEFB    0,0,0,0,#FE
AGATEIN DEFW    #0002,#A500+22
AGATE   DEFW    #0102
        DEFW    #AC06,#AD87
        DEFB    12,07,2
FIRES   DEFW    #A11A,#A81A,#A810,#A81B,#A614,#A61E,#A802,#A80A,#0000,#0000,#0000,#0000,#A804,#A8FA,#0000,#0000,#A804,#A81D
        DEFW    #0000,#0000,#A112,#AF12
        DEFW    #A808,#A81B,#A807,#A81A,#AC04,#AC0E,#A102,#A11B,#AF18,#A118,#A10E,#AF0E,#A10B,#A11B,#AF0C,#AF19,#A107,#AF07
        DEFW    #AF07,#AF1D,#A104,#AF04
        DEFW    #0000,#0000,#A8A8,#A8B2,#AF07,#AF1B,#A808,#A81D,#A80D,#A817,#A81E,#A813,#A802,#A81B,#A808,#A81D,#AF1E,#AF11
        DEFW    #0000,#0000,#AF10,#AF1A
UNDO
        ORG     39600
LEVELE  ;          1       ;    2      ;     3     ;     4     ;     5     ;     6     ;     7     ;     8     ;     9
        DEFB    "@________________________________________________________________________________________"
        DEFB    "@@   ___#  a____I__:I        @@@@@@@@@@@@@@@@@@@@       @@@@@@@@@  @@@@  @@@@@@@@@@@    @"
        DEFB    "@I  _I__@  I____I_  I________I_@@@@@@@@@@@@@@@@@@__     @@@@@@@@@  @@@@  @@@@@@@@@@@    @"
        DEFB    "@I  @@@@@!!@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   __@@@@@@@@@  @@@@e @@@@@@@@__I    @"
        DEFB    "@I  @@@@@@@@@@@@@@   @g_________I#   b__#____I+cI_I:  I_#   _d_I#__I__I_#_  f______I   _@"
        DEFB    "@I..I___II__!!__I    @@@@@@@@@@@@@   @@@@@@@@@@@@@@   @@@    @@@@__I  @@@@  @@@@@@@@   _@"
        DEFB    "@@@@@@@@@@@@@@@@@____I___I__!_!_II...I___I___I__I_I...I_I..._I__I__I!_I_II..I______I   _@"
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   @@"
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    @"
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@...!@"
        ORG     UNDO
