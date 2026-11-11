;==============================================================================
; PRINCE OF PERSIA  (ZX Spectrum 128, TR-DOS)
; Level 6: tables and map
;
; Converted from the original TASM 3 sources to sjasmplus.
; Copy protection removed, disk positions are symbols from disk.inc.
;==============================================================================
PTOMAN  EQU     250;230
PBLK    EQU     130
PKICK   EQU     247;240

CURLEV  EQU     6
STARTPOS EQU    #0005
STARTLEV EQU    1
STAPOS  EQU     9
STADIR  EQU     0
HEIGHT  EQU     6
LENGHT  EQU     56
WIDTH   DEFB    56
HEIGH   DEFB    6
WDTH    DEFB    7
HGHT    DEFB    2
NLEV    DEFB    "LEVEL 6",0
GATES   DEFW    #0005,#0200
        DEFW    #0005,#0200
        DEFW    #0003,#0200
        DEFW    #0000,#0203
        DEFW    #0000,#0203
LDRINKG
LDRINKS
STEELS  DEFW    #FFFF,#FFFF
EENEMY  DEFB    2,0,5,1,5
        DEFB    0,0,4,1,0
        DEFB    0,0,0,0,#FE
AGATEIN DEFW    #0005
        DEFW    #A506
AGATE   DEFW    #FFFF
FIRES   DEFW    #A806,#A81E,#A801,#A81D,#A805,#A81D,#A805,#A81E,#A801,#A81D,#A604,#A60E,#A101,#A101
        DEFW    #0000,#0000,#AF0F,#AF0F,#AF17,#AF17,#AF11,#AF11,#0000,#0000,#0000,#0000,#AF0A,#AF1D
UNDO
        ORG     39600
LEVELE  ;          1       ;    2      ;     3     ;     4     ;     5     ;     6     ;     7
        DEFB    "@________________________________________________________"
        DEFB    "@  $            $       $               $    ______      "
        DEFB    "I_e#   d____ ___'_____:_#_!_  _c__ __ _b#___aI  @@@      "
        DEFB    "@@@@   @@@@@ @@@@@@@@@ @@@@@  @@@@!@@!@@@@@@@@__@@@      "
        DEFB    "@@@@   @@@@@ @@@@@@@@@ @@@@@  @@@@@@@@@@@@@@@@@@@@@      "
        DEFB    "@@@@   @@@@@ @@@@@@@@@ @@@@@  @@@@@@@@@@@@@@@@@@@@@      "
        DEFB    "@@@@...@@@@@.@@@@@@@@@.@@@@@..@@@@@@@@@@@@@@@@@@@@@..__._"
        ORG     UNDO
