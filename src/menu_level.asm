;==============================================================================
; PRINCE OF PERSIA  (ZX Spectrum 128, TR-DOS)
; Menu background "level" (original STALEV)
;
; Converted from the original TASM 3 sources to sjasmplus.
; Copy protection removed, disk positions are symbols from disk.inc.
;==============================================================================
PTOMAN  EQU     230
PBLK    EQU     120
PKICK   EQU     230

CURLEV  EQU     2
STARTPOS EQU    #0001
STARTLEV EQU    1
STAPOS  EQU     17
STADIR  EQU     #FF
HEIGHT  EQU     6
LENGHT  EQU     24
WIDTH   DEFB    24
HEIGH   DEFB    6
WDTH    DEFB    3
HGHT    DEFB    2
NLEV    DEFB    "    ",0
GATES
LDRINKS
LDRINKG DEFW    #FFFF,#FFFF
STEELS  DEFW    #FFFF
EENEMY  DEFB    0,0,0,0,#FE
AGATEIN DEFW    #FFFF
AGATE   DEFW    #FFFF
FIRES   DEFW    #A81E,#A81E,#A801,#A81E,#A807,#A816
UNDO
        ORG     39600
LEVELE
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@"
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@"
        DEFB    "_I_____________________@@"
        DEFB    "@@@@@@@@@@@@@@@@@@@@@@@@@"
        ORG     UNDO
