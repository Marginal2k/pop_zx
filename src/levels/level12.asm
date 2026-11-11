;==============================================================================
; PRINCE OF PERSIA  (ZX Spectrum 128, TR-DOS)
; Level 12: tables and map
;
; Converted from the original TASM 3 sources to sjasmplus.
; Copy protection removed, disk positions are symbols from disk.inc.
;==============================================================================
PTOMAN  EQU     255;230
PBLK    EQU     100
PKICK   EQU     245;240

CURLEV  EQU     12
STARTPOS EQU    #0501
STARTLEV EQU    2
STAPOS  EQU     15
STADIR  EQU     0
HEIGHT  EQU     24
LENGHT  EQU     32
WIDTH   DEFB    32
HEIGH   DEFB    24
WDTH    DEFB    4
HGHT    DEFB    8
NLEV    DEFB    "LEVEL 12",0
GATES   DEFW    #0101,#0101
LDRINKG DEFW    #FFFF,#FFFF
STEELS
LDRINKS DEFW    #FFFF
EENEMY  DEFB    1,0,2,1,0
        DEFB    0,0,0,0,#FE
AGATEIN DEFW    #0501,#AC0C
AGATE   DEFW    #FFFF
FIRES   DEFW    #A11E,#A11E,#A101,#A11E,#A804,#A81E,#0000,#0000
        DEFW    #A11E,#A11E,#A101,#A101,#A104,#A11A,#0000,#0000
        DEFW    #0000,#0000,#A110,#AE10,#A105,#A105,#A803,#A803
        DEFW    #0000,#0000,#A801,#A801,#A803,#A803,#A813,#A818
        DEFW    #0000,#0000,#A103,#A103,#A104,#A104,#0000,#0000
        DEFW    #AE02,#AE1D,#AC0A,#AC14,#AE03,#AE18,#0000,#0000
UNDO
        ORG     39600
LEVELE  ;          1       ;    2      ;     3     ;     4     ;     5     ;     6     ;     7     ;     8
        DEFB    "                         ________"
        DEFB    "       __________        @@@@@@@@"
        DEFB    "       @@@@    @@_::::___@@@@@@@@"
        DEFB    "       @@aI    @I   __  @@@@@@@@@"
        DEFB    "      aI_#_    II:::II  @@@@@@@@@"
        DEFB    "      @@@@I    @@   @@  @@@@@@@@@"
        DEFB    "      @@@@I    II   II  @@@@@@@@@"
        DEFB    "      @@@@I   :II   II  @@@@@@@@@"
        DEFB    "      @@@@@    @@   @I  I_I @@@@@"
        DEFB    "      @@@@@    @@   @@  @@I:@@@@@"
        DEFB    "      @@@@@    @@   @@  @@I @@@@@"
        DEFB    "      @@__I   :II  :II  III_I___@"
        DEFB    "      @@@@I    II   @@  @@@@@@@@@"
        DEFB    "      @@@_I   :II  _II  @@@@@@@@@"
        DEFB    "      @@@@@    @@  @@I  @@@@@@@@@"
        DEFB    "      @@@I     II  I_I  @@@@@@@@@"
        DEFB    "      @@@I     II  I_I  @@@@@@@@@"
        DEFB    "      @@@I     @@  I@I  @@@@@@@@@"
        DEFB    "______@@@I_____II__@@@_.@@@@@@@@@"
        ORG     UNDO
