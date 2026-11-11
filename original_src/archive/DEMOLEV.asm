PTOMAN  EQU     230
PBLK    EQU     120
PKICK   EQU     230

CURLEV  EQU     15
STARTPOS EQU    #0002
STARTLEV EQU    0
STAPOS  EQU     30
STADIR  EQU     0
HEIGHT  EQU     6
LENGHT  EQU     24
WIDTH   DEFB    24
HEIGH   DEFB    6
WDTH    DEFB    3
HGHT    DEFB    2
NLEV    DEFB    "DEMO",0
GATES   DEFW    #0002,#0100
        DEFW    #FFFF,#FFFF
LDRINKG
LDRINKS
STEELS  DEFW    #FFFF
EENEMY  DEFB    0,0,4,0,3
        DEFB    0,0,0,0,#FE
AGATEIN DEFW    #FFFF
AGATE   DEFW    #FFFF
FIRES   DEFW    #A107,#A11E,#A107,#A11B,#A107,#A116
        DEFW    #A807,#A80D,#0000,#0000,#0000,#0000
UNDO
        ORG     39600
LEVELE
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@"
        DEFB    "_I_____:_I_   __#I_  _a_I"
        DEFB    "@@@@@@@  @@  !@@@@@! @@@@"
        DEFB    "@@@@@@@  @@! @@@@@@@  @@@"
        DEFB    "@@@@@@@  @@@ @@@@@@@  @@@"
        DEFB    "II____I__@@@_@@@@@@@__@@@"
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@"
        ORG     UNDO
