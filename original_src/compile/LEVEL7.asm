PTOMAN  EQU     230;230
PBLK    EQU     120
PKICK   EQU     240;240

CURLEV  EQU     7
STARTPOS EQU    #0101
STARTLEV EQU    0
STAPOS  EQU     7
STADIR  EQU     0
HEIGHT  EQU     9
LENGHT  EQU     72
WIDTH   DEFB    72
HEIGH   DEFB    9
WDTH    DEFB    9
HGHT    DEFB    3
NLEV    DEFB    "LEVEL 7",0
GATES   DEFW    #0201,#0306
        DEFW    #0103,#0306
        DEFW    #0204,#0202
        DEFW    #0106,#0200
        DEFW    #0107,#0101
        DEFW    #0107,#0301
        DEFW    #0107,#0107
        DEFW    #0107,#0307
        DEFW    #FEFE,#FEFE
        DEFW    #FFFF,#FFFF
LDRINKG DEFW    #0101,#0307
        DEFW    #0203,#0305
        DEFW    #FFFF,#FFFF
LDRINKS DEFW    #0006,#0303
        DEFB    #FFFF,#FFFF
STEELS  DEFW    #0102,#0106
        DEFW    #0004,#0304
        DEFW    #0104,#0301
        DEFW    #0104,#0303
        DEFW    #FFFF,#FFFF
EENEMY  DEFB    2,1,20,0,4
        DEFB    5,0,25,2,4
        DEFB    5,1,02,0,4
        DEFB    0,0,0,0,#FE
AGATEIN DEFW    #FFFF
AGATE   DEFW    #0201
        DEFW    #AC0A,#AD8B
        DEFB    16,11,2
FIRES   DEFW    #0000,#0000,#0000,#0000,#0000,#0000,#0000,#0000,#AF07,#AF1A,#AF06,#AF1A,#AF11,#AF03,#AF11,#A81E,#A101,#AF04
        DEFW    #A80C,#A11E,#A101,#A11A,#A108,#AF08,#A107,#A11E,#A116,#A11E,#A101,#A110,#A110,#AF10,#A110,#AF10,#A103,#AF03
        DEFW    #0000,#0000,#AC08,#AC12,#AF07,#AF1B,#A808,#AF08,#AF0E,#AF0E,#A81E,#A813,#A801,#A810,#A81E,#A807,#A801,#AF12
UNDO
        ORG     39600
LEVELE  ;          1       ;    2      ;     3     ;     4     ;     5     ;     6     ;     7     ;     8     ;     9
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        DEFB    "@@              @@@@@@@@@@@@@@@@@I:I____I_______I I___@@@@@@@@@@@@@@@@@@@"
        DEFB    "@@   _____   ___II____I_II___:___I_@ _________ $@_I__eI_I#_g_!!#___f     "
        DEFB    "@@...I_@@@   @@@@@@@@@@@@@@@I $@@@@@_I @  I__I_'# @@@@@@@@@@@@@@@@@@     "
        DEFB    "@@@@@@@@@     I_II____I_I__'I_#b_I_I_I_@  I @@@@@dI   IfI#_____#_h_I     "
        DEFB    "@@@@@@@@@     $@@@@@@@@@@@@@@@@@@@@@@@@@  I @@@@@@@   @@@@@@@@@@@@@@    !"
        DEFB    "@@@@@@@@@     $@@@@@  I_II_:I_I__I#  I_I  I.I_____I!!!I_II_ I _____I    @"
        DEFB    "@@@@@@@@@a____#iII_I__I_IIc_I_@@@@@!_@@@!!@@@@@@@@@@@@@@@@@!@!@@@@@@....@"
        ORG     UNDO
