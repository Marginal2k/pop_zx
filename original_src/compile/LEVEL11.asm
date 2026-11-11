PTOMAN  EQU     230;230
PBLK    EQU     120
PKICK   EQU     240;240

CURLEV  EQU     11
STARTPOS EQU    #0102
STARTLEV EQU    1
STAPOS  EQU     17
STADIR  EQU     0
HEIGHT  EQU     12
LENGHT  EQU     64
WIDTH   DEFB    64
HEIGH   DEFB    12
WDTH    DEFB    8
HGHT    DEFB    4
NLEV    DEFB    "LEVEL 11",0
GATES   DEFW    #0101,#0100
        DEFW    #0102,#0100
        DEFW    #0102,#0300
        DEFW    #0102,#0107
        DEFW    #0102,#0307
        DEFW    #0106,#0200
        DEFW    #FEFE,#FEFE
        DEFW    #FFFF,#FFFF
LDRINKS DEFW    #0007,#0304
        DEFW    #0103,#0105
LDRINKG DEFW    #FFFF,#FFFF
STEELS  DEFW    #0105,#0204
        DEFW    #0105,#0205
        DEFW    #0105,#0206
        DEFW    #0106,#0103
        DEFW    #FFFF,#FFFF
EENEMY  DEFB    0,1,5,2,6
        DEFB    3,1,25,2,6
        DEFB    4,1,25,0,5
        DEFB    6,1,28,0,5
        DEFB    0,0,0,0,#FE
AGATEIN DEFW    #0102,#A50E
AGATE   DEFW    #0100
        DEFW    #AC0E,#AD8F
        DEFB    #F+5,#F,2
FIRES   DEFW    #0000,#0000,#AF05,#AF05,#0000,#0000,#0000,#0000,#AF08,#AF1E,#AF01,#AF1E,#AF04,#AF1E,#AF01,#AF14
        DEFW    #AD0C,#AD16,#A110,#AF10,#A60C,#A616,#A110,#AF10,#AF07,#AF1E,#A110,#A118,#A804,#A104,#A103,#A114
UNDO
        ORG     39600
LEVELE  ;          1       ;    2      ;     3     ;     4     ;     5     ;     6     ;     7     ;     8
        DEFB    "@________________________________________________________________"
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                  @@@@@@@@@@@@@"
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                  @@@@@@@@@@@@@"
        DEFB    "@@@@@@@@@:a@@@@@@@@@@@@@@@@@@@@@@@:_______________:_@@@:_______@@"
        DEFB    "@ g_____#_I____I#__    #_dI___bI_I______   I____@  +____I______@@"
        DEFB    "@ @    @$@@@@@@@@ I____@@@@@@@@@@@@@@@@I   I____#__I  @@@@@@@@@@@"
        DEFB    "@_I____I'_I___cI#_Ic_e_#__I____I_I____'I__fI_@@@@@@@!!@@@@@@@@@@@"
        ORG     UNDO
