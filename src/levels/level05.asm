;==============================================================================
; PRINCE OF PERSIA  (ZX Spectrum 128, TR-DOS)
; Level 5: tables and map
;
; Converted from the original TASM 3 sources to sjasmplus.
; Copy protection removed, disk positions are symbols from disk.inc.
;==============================================================================
PTOMAN  EQU     230;230
PBLK    EQU     120
PKICK   EQU     240;240

CURLEV  EQU     5
STARTPOS EQU    #0106
STARTLEV EQU    2
STAPOS  EQU     15
STADIR  EQU     0
HEIGHT  EQU     9
LENGHT  EQU     72
WIDTH   DEFB    72
HEIGH   DEFB    9
WDTH    DEFB    9
HGHT    DEFB    3
NLEV    DEFB    "LEVEL 5",0
GATES   DEFW    #0101,#0200
        DEFW    #0105,#0200
        DEFW    #0105,#0306
        DEFW    #0005,#0303
        DEFW    #0006,#0200
        DEFW    #0106,#0307
        DEFW    #0008,#0102
        DEFW    #0008,#0302
        DEFW    #FEFE,#FEFE
        DEFW    #0106,#0107
        DEFW    #FFFF,#FFFF
LDRINKG DEFW    #0008,#0104,#FFFF,#FFFF
LDRINKS DEFW    #0106,#0107
        DEFW    #0005,#0206
        DEFW    #0203,#0106
        DEFB    #FF,#FF
STEELS  DEFW    #0201,#0204
        DEFW    #0202,#0201
        DEFW    #0202,#0203
        DEFW    #0203,#0104
        DEFW    #FFFF,#FFFF
EENEMY  DEFB    2,1,2,1,5
        DEFB    4,1,3,1,5
        DEFB    5,1,16,0,4
        DEFB    7,1,22,1,4
        DEFB    0,0,0,0,#FE
AGATEIN DEFW    #0106
        DEFW    #AC0B
AGATE   DEFW    #0100
        DEFW    #A50D,#A68E
        DEFB    19,14,1
FIRES   DEFW    #A10C,#A11C,#A805,#A81B,#A805,#A81B,#A805,#A81B,#A60D,#0000,#A81D,#A814,#A815,#A808,#A801,#A81E,#A101,#AF04
        DEFW    #A60B,#A615,#A806,#A81D,#A801,#A81E,#A801,#A81E,#A801,#A81D,#A806,#A11D,#AC09,#AC13,#AF01,#A101,#0000,#0000
        DEFW    #0000,#0000,#A814,#A81E,#A801,#A813,#A109,#A11A,#A101,#A11E,#A101,#A11E,#A101,#A10F,#AF0C,#AF11,#0000,#0000
UNDO
        ORG     39600
LEVELE  ;          1       ;    2      ;     3     ;     4     ;     5     ;     6     ;     7     ;     8     ;     9
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        DEFB    "@                                       @_:eI   $      $    ______#____ @"
        DEFB    "@                                       @I $I___#__   _'____I I__ $  gI_@"
        DEFB    "@                                       @I_#d   $      $ @@@@_I @h#__@@@@"
        DEFB    "@       $                               $   I___'__   _#__I   I_@@@@@@@@@"
        DEFB    "@______i#_  _______a__:___  ____________#__bI $ $      $  I___I @@@@@@@@@"
        DEFB    "@@@@@@@@@@  I@@@@@@@@@ @@@  I_@@@@@@@@@@@@@@@c#b'_f____#__I_  @ @@@@@@@@@"
        DEFB    "@@@@@@@@@@  I@@@@@@@@@  @@  I___@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @ @@@@@@@@@"
        DEFB    "@@@@@@@@@@  I___________@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   @ @@@@@@@@@"
        DEFB    "@@@@@@@@@@!!@@@@@@@@@@@@@@!!@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@!!.@!@@@@@@@@@"
        ORG     UNDO
