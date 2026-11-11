PTOMAN  EQU     230;230
PBLK    EQU     120
PKICK   EQU     240;240

CURLEV  EQU     4
STARTPOS EQU    #0004
STARTLEV EQU    1
STAPOS  EQU     18
STADIR  EQU     0
HEIGHT  EQU     6
LENGHT  EQU     96
WIDTH   DEFB    96
HEIGH   DEFB    6
WDTH    DEFB    12
HGHT    DEFB    2
NLEV    DEFB    "LEVEL 4",0
GATES   DEFW    #0004,#0200
        DEFW    #0005,#0200
        DEFW    #0003,#0200
        DEFW    #0001,#0100
        DEFW    #0102,#0102
        DEFW    #0103,#0106
        DEFW    #FEFE,#FEFE
        DEFW    #010A,#0100
        DEFW    #FFFF,#FFFF
LDRINKG DEFW    #0000,#0104,#FFFF
LDRINKS DEFW    #0104,#0206
        DEFW    #0009,#0306
        DEFB    #FFFF
STEELS  DEFW    #0000,#0105
        DEFW    #0105,#0104
        DEFW    #000B,#0201
        DEFW    #010A,#0101
        DEFW    #FFFF
EENEMY  DEFB    2,1,19,0,4
        DEFB    5,0,15,1,4
        DEFB    5,1,30,0,3
        DEFB    8,0,25,1,3
        DEFB    0,0,0,0,#FE
AGATEIN DEFW    #0004
        DEFW    #A50F
AGATE   DEFW    #0008
        DEFW    #A50F,#A690
        DEFB    21,16,1
FIRES   DEFW    #A10C,#A11C,#A805,#A81B,#A805,#A81B,#A805,#A81B,#A60D,#A617,#A805,#A81B,#A801,#A81E,#A801,#A81D,#A60D,#A617
        DEFW    #A804,#A81D,#A804,#A81E,#A101,#A801
        DEFW    #A108,#A110,#A108,#A11D,#A104,#A11D,#A101,#A11E,#A101,#A11E,#A101,#A11E,#A101,#A10F,#A106,#A10B,#A108,#A11F
        DEFW    #A101,#A11D,#A10A,#A11F,#A106,#A112
UNDO
        ORG     39600
LEVELE  ;          1       ;    2      ;     3     ;     4     ;     5     ;     6     ;     7     ;     8     ;     9
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        DEFB    "@@@_____#       $       $____   $       $                       $       $       $   ________    @"
        DEFB    "@@@@@@@@@_:____:':_c____#   I__a#______a#_b_________  ________!_'_______'___:___'___@gI____I_   @"
        DEFB    "@@@@@@@@@@ I__I $  @@@@@@__cI $@@@@@@@@@@@@@@@@@@@@I  @@@@@@@@@@@@ I@@@@@@@@_I_@@@@@@@@@@@@@I   @"
        DEFB    "@@@@@@@@@@dI  I_'f# e_______I_#____I _____I +______I__@@@@@@@@@@@@.I __I__I_h_I_#___I hI_I__I_  @"
        DEFB    "@@@@@@@@@@@@  @@@@@ @@@@@@@@@@@@@@@@.I_@@_I.@@@@@@@@@@@@@@@@@@@@@@@@!@@@@@@@@@@@@@@@@_I@@@@@@@  @"
        DEFB    "@@@@@@@@@@@@!!@@@@@!@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@!!@"
        ORG     UNDO
