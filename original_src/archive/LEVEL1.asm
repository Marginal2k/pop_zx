PTOMAN  EQU     250;230
PBLK    EQU     130
PKICK   EQU     247;240
CURLEV  EQU     1
STARTPOS EQU    #0006
STARTLEV EQU    0
STAPOS  EQU     5
STADIR  EQU     #FF
HEIGHT  EQU     9
LENGHT  EQU     72
WIDTH   DEFB    72
HEIGH   DEFB    9
WDTH    DEFB    9
HGHT    DEFB    3
NLEV    DEFB    "LEVEL 1",0
GATES   DEFW    #0006,#0100
        DEFW    #0005,#0105
        DEFW    #0102,#0100
        DEFW    #0104,#0100
        DEFW    #0105,#0100
        DEFW    #0105,#0100
        DEFW    #FEFE,#FEFE
        DEFW    #0102,#0100
        DEFW    #0104,#0100
        DEFW    #FFFF,#FFFF
LDRINKS DEFW    #0005,#0303
        DEFW    #0203,#0105
        DEFW    #0000,#0106
STEELS
LDRINKG DEFB    #FFFF,#FFFF
EENEMY  DEFB    7,1,24,1,3
        DEFB    4,0,20,0,3
        DEFB    0,0,0,0,#FE
AGATEIN DEFW    #FFFF
AGATE   DEFW    #0108
        DEFW    #A50E,#A68F
        DEFB    20,15
        DEFB    1
FIRES   DEFW    #A117,#A11D,#AF1D,#AF17,#AF02,#AF0F,#A111,#A119,#A107,#A11B,#A107,#A110,#A110,#A119,0,0,0,0
        DEFW    #A819,#A119,#A105,#A10E,#A807,#A81C,#A109,#A115,#A807,#A11B,#A105,#A119,#A81A,#A80C,#A807,#A81B,#A60C,#A616
        DEFW    #A10F,#A117,#A808,#A80F,#AF10,#AF16,#A113,#A119,#AF0B,#AF12,0,0,0,0,0,0,0,0
UNDO
        ORG     39600
LEVELE
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        DEFB    "@@   I___I @@@@@@@@@@@@@@@  ____II______II_b_#a #  _____@@@@@@@@@@@@@@@@@"
        DEFB    "@I   @@@@@!I @@@@@@@  I_II__I::@@@@@@@@@@@@@@@I @__I @@@@@@@@@@@@@@@@@@@@"
        DEFB    "@I   @@@@@@@_I!____I..@@@@I:I__@@@@@@@@@@@___:I.@@@@.I:_@@@@@@@@@@@@@@@@@"
        DEFB    "@I   I____::c  I#         d_I::I#     e_#_f I____ @@@@  @@@@@@@@@g      @"
        DEFB    "@I   I___I__@  @@____:_h__I_I  @@__: _Ii@@@ @@@@@_I__I__II______II______@"
        DEFB    "@@___I @@@@@@! @@@@@@ @@@@@:I__I@@@  @@@@@@!!@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        DEFB    "@@  _I_I @@@@@ @@@@@@ @@@@@_I__ @@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        DEFB    "@@  @@@@.I___I!I_I_I   @@@@@@@I @@@   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        DEFB    "@@!!@@@@@@@@@@@@@@@@__.@@@@@@@@!III___@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        ORG     UNDO
