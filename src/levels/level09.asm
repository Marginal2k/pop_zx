;==============================================================================
; PRINCE OF PERSIA  (ZX Spectrum 128, TR-DOS)
; Level 9: tables and map
;
; Converted from the original TASM 3 sources to sjasmplus.
; Copy protection removed, disk positions are symbols from disk.inc.
;==============================================================================
PTOMAN  EQU     230;230
PBLK    EQU     120
PKICK   EQU     240;240

CURLEV  EQU     9
STARTPOS EQU    #0305
STARTLEV EQU    1
STAPOS  EQU     21
STADIR  EQU     0
HEIGHT  EQU     12
LENGHT  EQU     64
WIDTH   DEFB    64
HEIGH   DEFB    12
WDTH    DEFB    8
HGHT    DEFB    4
NLEV    DEFB    "LEVEL 9",0
GATES   DEFW    #0304,#0200
        DEFW    #0204,#0100
        DEFW    #0201,#0202
        DEFW    #0201,#0106
        DEFW    #0106,#0200
        DEFW    #0002,#0300
        DEFW    #0005,#0202
        DEFW    #FEFE,#FEFE
        DEFW    #FFFF,#FFFF
LDRINKG DEFW    #0001,#0104
        DEFW    #0000,#0304
        DEFW    #0100,#0207
        DEFW    #FFFF,#FFFF
LDRINKS DEFW    #0206,#0102
        DEFW    #0103,#0201
        DEFW    #0003,#0307
        DEFW    #FFFF,#FFFF
STEELS  DEFW    #0304,#0201
        DEFW    #0201,#0206
        DEFW    #0202,#0105
        DEFW    #0205,#0303
        DEFW    #0102,#0204
        DEFW    #0102,#0206
        DEFW    #0107,#0201
        DEFW    #FFFF,#FFFF
EENEMY  DEFB    5,2,25,2,5
        DEFB    3,2,25,0,5
        DEFB    7,1,15,0,5
        DEFB    4,0,3,1,5
        DEFB    0,0,0,0,#FE
AGATEIN DEFW    #0305,#A512
AGATE   DEFW    #0204
        DEFW    #AC0A,#AD8B
        DEFB    14,11,2
FIRES   DEFW    #A10A,#A116,#A10C,#AF1D,#A105,#A11A,#A81E,#A806,#A801,#A81E,#A801,#A817,#0000,#0000,#0000,#0000
        DEFW    #A111,#A811,#A804,#A81B,#A807,#A80A,#A803,#A803,#0010,#0010,#A81D,#A81D,#A11E,#A10C,#A101,#A80A
        DEFW    #0000,#0000,#A111,#A811,#A103,#A11A,#A103,#A11D,#AD08,#AD12,#A103,#AF03,#A111,#AF11,#0000,#0000
        DEFW    #0000,#0000,#0000,#0000,#0000,#0000,#A81D,#A810,#A81A,#A810,#A610,#A61A,#A810,#A816,#0000,#0000
UNDO
        ORG     39600
LEVELE  ;          1       ;    2      ;     3     ;     4     ;     5     ;     6     ;     7     ;     8
        DEFB    "@________________________________________________________________"
        DEFB    "@  _____I::___@@@f    __II              @@@@@@@@@@@@@@@@@@@@@@@@@"
        DEFB    "@__I  @@@_ @@@@@@@    @@@I ______________g#_  g @@@@@@@@@@@@@@@@@"
        DEFB    "@@:I__I @@_I  If#__!!_I_II!I  I_I       @@@I  @!@@@@@@@@@@@@@@@@@"
        DEFB    "@@ I__I_@  I__@@@@@@@@@@@@@@  @@@       @@@I  @@@  _:::______I e@"
        DEFB    "@@_I  I_@..I  I_II__I_I_I__@  @@@       @@@I  Ie#__I   I_I___I @@"
        DEFB    "@@@@..@@@@@I  @@@@@@@@@@@@@@  @@@       @@@I  @@@@@I   @@@@@@@!@@"
        DEFB    "@@@@@@@@@@@I  #_I_d__I__I__I..I_#h    _:I__I..@@@__I   @@@@@@@@@@"
        DEFB    "@@@@@@@@@d#I__I_c@@@@@@@@@@@@@@@@@    @ @@@@@@@@@@@I   @@@@@@@@@@"
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@I  I_II____IbI__+____II_I   @@@@@@@@@@"
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@I  @@@@@@@@@@@@@@    @@@@   @@@@@@@@@@"
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@I__I_#I_____aII_I____II_I___@@@@@@@@@@"
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        ORG     UNDO
