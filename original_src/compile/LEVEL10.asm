PTOMAN  EQU     230;230
PBLK    EQU     120
PKICK   EQU     240;240

CURLEV  EQU     10
STARTPOS EQU    #0100
STARTLEV EQU    1
STAPOS  EQU     21
STADIR  EQU     0
HEIGHT  EQU     9
LENGHT  EQU     72
WIDTH   DEFB    72
HEIGH   DEFB    9
WDTH    DEFB    9
HGHT    DEFB    3
NLEV    DEFB    "LEVEL 10",0
GATES   DEFW    #0104,#0207
        DEFW    #FEFE,#FEFE
        DEFW    #FFFF,#FFFF
LDRINKG DEFW    #0100,#0102
        DEFW    #FFFF,#FFFF
LDRINKS DEFW    #0101,#0307
        DEFW    #0003,#0305
        DEFW    #FFFF,#FFFF
STEELS  DEFW    #0102,#0102
        DEFW    #FFFF,#FFFF
EENEMY  DEFB    2,1,25,0,6
        DEFB    5,1,25,0,6
        DEFB    7,1,27,0,5
        DEFB    0,0,0,0,#FE
AGATEIN DEFW    #0100,#A512
AGATE   DEFW    #0106
        DEFW    #A516,#A697
        DEFB    #17+5,#17,1
FIRES   DEFW    #AF05,#AF1E,#AF01,#AF1E,#AF01,#AF1E,#AF01,#AF15,#AF07,#AF1A,#AF06,#AF1A,#AF11,#AF03,#AF11,#A81E,#A101,#AF04
        DEFW    #A610,#A61A,#A101,#A11E,#A101,#A11E,#A101,#A810,#A801,#A814,#A104,#A11A,#A614,#A61E,#A801,#A11E,#A101,#A80B
        DEFW    #0000,#0000,#AF0E,#AF12,#0000,#0000,#0000,#0000,#AF0E,#AF12,#0000,#0000,#AF08,#AF0E,#AF10,#AF14,#A801,#AF12
UNDO
        ORG     39600
LEVELE  ;          1       ;    2      ;     3     ;     4     ;     5     ;     6     ;     7     ;     8     ;     9
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        DEFB    "@                              @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        DEFB    "@                              @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        DEFB    "@ _____________:_______________@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        DEFB    "@__     ___   I___+_______I   $        $  _:____          ___________:@@@"
        DEFB    "@@@ ____@@I   @@@@@@@@@@@aI __'____:::_#__I @@@@   ::_____I    @@@b_I_@@@"
        DEFB    "@@@ @@@@@@@_::I_@@@@@@@@@@@ @@@@@@     @@@@_@@@@!!  _@@@@@@    @@@@@@@@@@"
        DEFB    "@@@ @@@@@@@     @@@@@@@@@@@ @@@@@@     @@@@@@@@@@@   @@@@@@    @@@@@@@@@@"
        DEFB    "@@@ @@@@@@@     @@@@@@@@@@@ @@@@@@     @@@@@@@@@@@   @@@@@@    @@@@@@@@@@"
        DEFB    "@@@.@@@@@@@!..!!@@@@@@@@@@@.@@@@@@.....@@@@@@@@@@@!.!@@@@@@....@@@@@@@@@@"
        ORG     UNDO
