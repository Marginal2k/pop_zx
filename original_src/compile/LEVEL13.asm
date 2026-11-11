PTOMAN  EQU     230;230
PBLK    EQU     150
PKICK   EQU     235;240

CURLEV  EQU     13
STARTPOS EQU    #0103
STARTLEV EQU    0
STAPOS  EQU     30
STADIR  EQU     0
HEIGHT  EQU     6
LENGHT  EQU     32
WIDTH   DEFB    32
HEIGH   DEFB    6
WDTH    DEFB    4
HGHT    DEFB    2
NLEV    DEFB    "LEVEL 12",0
GATES
LDRINKG
LDRINKS
STEELS  DEFW    #FFFF,#FFFF
EENEMY  DEFB    1,0,27,0,6
        DEFB    0,0,0,0,#FE
AGATEIN DEFW    #FFFF
AGATE   DEFW    #0000,#A508,#A689
        DEFB    14,9,1
FIRES   DEFW    #A606,#A610,#A101,#A11F,#A101,#A11E,#A805,#A81E
        DEFW    #A81E,#A81E,#A801,#A81A,#A803,#A81A,#A803,#A11A
UNDO
        ORG     39600
LEVELE  ;          1       ;    2      ;     3     ;     4     ;     5     ;     6     ;     7
        DEFB    "@                                "
        DEFB    "@     _:___:_______     __@@@@@@@"
        DEFB    "@____.I @@@     @@@     @@@@@@@@@"
        DEFB    "@@@@@@I @@@     @@@     @@       "
        DEFB    "@@@@@@I @@@     @@@     @@   ____"
        DEFB    "@@@@@@I___I_____I_I_____I__  @   "
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@..@   "
        ORG     UNDO
