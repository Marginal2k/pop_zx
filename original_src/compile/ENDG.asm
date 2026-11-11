        ORG     #A000+6144
BUF     DEFS    300
BUF1    DEFS    300
ROOM    DEFS    300
ROTT    DEFS    256
        ORG     39600
LEVELE  ;          1       ;    2      ;     3     ;     4     ;     5     ;     6     ;     7
        DEFB    "        $       $       $            @@@@"
        DEFB    "        $       $       $            @@@@"
        DEFB    "________#_____a_#_____b_#______c_____@@@@"
        DEFB    "        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
_______
        ORG     29300
        DI
        LD      HL,STAX
        LD      BC,11000
        LD      A,#6B
        LD      R,A
XLOOP   LD      A,R
        XOR     (HL)
        XOR     B
        XOR     C
        LD      (HL),A
        INC     HL
        DEC     BC
        LD      A,B
        OR      C
        JR      NZ,XLOOP
STAX    LD      A,19
        CALL    SETPAGE
        LD      HL,59282
        LD      DE,#1D0A
        LD      BC,#0305
        CALL    #3D13
        LD      HL,60050
        LD      DE,#0500
        LD      BC,#0505
        CALL    #3D13
        LD      HL,61200
        LD      DE,#0B07
        LD      BC,#1105
        CALL    #3D13
        LD      HL,#C000
        LD      DE,#1B08
        LD      BC,#2205
        CALL    #3D13
        LD      A,20
        CALL    SETPAGE
        LD      HL,#C000
        LD      DE,#1D0D
        LD      BC,#0905
        CALL    #3D13
        LD      A,16
        CALL    SETPAGE
        CALL    READ
        LD      HL,#A000
        LD      BC,7000
PSEAR   DEC     BC
        LD      A,B
        OR      C
        JP      Z,0
        LD      A,(HL)
        INC     HL
        CP      #A1
        JR      NZ,PSEAR
        LD      A,(HL)
        INC     HL
        CP      #A1
        JR      NZ,PSEAR
        LD      A,(HL)
        INC     HL
        CP      #FB
        JR      NZ,PSEAR
        LD      A,(HL)
        INC     HL
        CP      #18
        JR      NZ,PSEAR
        LD      A,(HL)
        INC     HL
        CP      CURLEV
        JR      NZ,PSEAR
        LD      A,(HL)
        INC     HL
        CP      #AA
        JR      NZ,PSEAR
BEGIN   CALL    TIMEON
        LD      A,23
        CALL    SETPAGE
        LD      HL,#C000
        LD      DE,#C001
        LD      (HL),L
        LD      BC,#1AFF
        LDIR
        LD      HL,LEVEL1
        LD      DE,#C000
        LD      BC,2000
        LDIR
        LD      A,16
        CALL    SETPAGE
        LD      HL,#C000
        LD      DE,#C001
        LD      (HL),0
        LD      BC,6144
        LDIR
        LD      A,LENGHT+1
        LD      (AHEI+1),A
        LD      HL,LENGHT+10
        LD      (AHEI1+1),HL
        LD      A,(ALLIV)
        LD      (BEGLIV1),A
        LD      HL,GATES
        LD      (AGATES),HL
        LD      A,CURLEV
        CP      1
        JR      NZ,NOSTAR
        LD      HL,#B4A9
        LD      (PST1+1),HL
NOSTAR  LD      A,CURLEV
        CP      12
        JR      NZ,START
        LD      HL,#A6A7
        LD      (PST1+1),HL
START   LD      HL,#5B00
        LD      A,#FF
        LD      B,0
MALP    LD      (HL),A
        INC     HL
        DJNZ    MALP
        CALL    CLS
        LD      (IY+55),0
        LD      (IY+71),0
        LD      (IY+118),0
        CALL    5633
        LD      HL,#5800+(32*22)
        LD      A,#42
        LD      B,8
GRID    LD      (HL),A
        INC     HL
        DJNZ    GRID
        LD      B,16
        LD      A,7
GRID1   LD      (HL),A
        INC     HL
        DJNZ    GRID1
        LD      A,#06
        LD      B,8
GRID2   LD      (HL),A
        INC     HL
        DJNZ    GRID2
        CALL    FROT
        CALL    INIT
        LD      (STACK),SP
        LD      A,16
        CALL    SETPAGE
        LD      HL,NLEV
        LD      DE,#B60B
        CALL    MESS
        XOR     A
        LD      (23673),A
        LD      (23672),A
        CALL    PLACE
        CALL    MAKEDE
        XOR     A
        LD      (FLAG),A
WAIT    LD      B,0
        CALL    PUTMAN
        XOR     A
        LD      (KIND),A
        LD      A,(SCREEN)
        AND     A
        JP      Z,ENDGAM
        CALL    INJOY1
        CP      #FF
        JR      Z,WAIT
        BIT     0,A
        JP      Z,FIRE
        LD      HL,FLAG
        RES     2,(HL)
        BIT     2,A
        JP      Z,GODOWN
        BIT     1,A
        JP      Z,GOJUMP1
        BIT     4,A
        JR      NZ,NLEFT
        LD      A,(DIR)
        AND     A
        JP      Z,RUNN
        JP      ROTATION
NLEFT   BIT     3,A
        JR      NZ,NRIG
        LD      A,(DIR)
        AND     A
        JP      Z,ROTATION
        JP      RUNN
NRIG    JR      WAIT

STACK   DEFW    0
;KIND 0-Stand,1-Run,2-Jump1,3-Jump2
;4-Battle 5-Dead,6-Care,7-ToUp
FLAG    DEFB    0
BEGLIV  DEFB    0
BEGLIV1 DEFB    0
FFLAG   DEFB    0
CFLAG   DEFB    0
MCOUNT  DEFB    0
ROTATION
        LD      IX,ROT
        LD      B,4
        CALL    LOOP
        LD      A,(DIR)
        CPL
        LD      (DIR),A
        LD      IX,STOP+8
        LD      B,5
        CALL    LOOP
        JP      WAIT

RUNN    LD      IX,RUN
        LD      A,1
        LD      (KIND),A
        LD      B,4
M1      PUSH    BC
        CALL    LP
        POP     BC
        CALL    INJOY1
        CALL    TJUMP
        JP      C,GOJUMP
        DJNZ    M1
        LD      B,4
CONT    CALL    LOOP
CONT2   CALL    INJOY1
        CALL    TBACK
        JR      C,GOBACK
        CP      #FF
        JR      NZ,NSTAND
STAND   LD      IX,STOP
        LD      B,9
        XOR     A
        LD      (KIND),A
        CALL    LOOP
        JP      WAIT
NSTAND  BIT     1,A
        JP      Z,GOJUMP2
CONT3   LD      IX,RUN+16
        LD      B,4
        CALL    LOOP
CONT1   CALL    INJOY1
        CALL    TBACK
        JR      C,GOBACK
        CP      #FF
        JR      Z,STAND
        BIT     1,A
        JP      Z,GOJUMP2
        LD      IX,RUN+24
        LD      B,4
        JR      CONT

GOBACK  LD      IX,BACK
        LD      B,13
        CALL    LOOP
        LD      A,(DIR)
        CPL
        LD      (DIR),A
        LD      B,3
        CALL    LOOP
        JR      CONT1

GOJUMP  LD      IX,JUMP
        LD      A,2
        LD      (KIND),A
        LD      B,1
        CALL    MVE
        LD      HL,FLAG
        SET     0,(HL)
        LD      B,8
        CALL    LOOP
        LD      B,2
        CALL    MVE
        LD      B,2
        LD      C,200
LONG    PUSH    BC
        LD      B,C
        CALL    PUTLONG
        LD      A,(POS)
        LD      B,A
        CALL    DECB
        CALL    DECB
        LD      A,B
        LD      (POS),A
        POP     BC
        INC     C
        DJNZ    LONG
        LD      B,1
        CALL    MVE
        LD      C,2
        LD      A,(POS)
        LD      B,A
LLOOP   CALL    DECB
        DEC     C
        JR      NZ,LLOOP
        LD      A,B
        LD      (POS),A
        LD      B,202
        CALL    PUTLONG
        LD      B,2
        CALL    MVE
        LD      HL,FLAG
        RES     0,(HL)
        LD      B,8
        CALL    LOOP
        JP      WAIT

GODOWN  XOR     A
GODOWN2 LD      B,1
        LD      IX,DOWN
        CALL    LOOP
NOBEAT  LD      B,1
        LD      A,1
        LD      (KIND),A
        CALL    LOOP
DWAIT   LD      B,53
        CALL    PUTMAN
        CALL    INJOY1
        BIT     2,A
        JP      NZ,GOUP
        CALL    TFORW
        JR      NC,DWAIT
        LD      IX,UP
        LD      B,3
        CALL    LOOP
        LD      B,1
        CALL    MVE
        LD      A,(POS)
        LD      B,A
        CALL    DECB
        CALL    DECB
        LD      A,B
        LD      (POS),A
        CALL    TSTSCR
        LD      IX,DOWN+2
        LD      B,1
        CALL    LOOP
TAG     LD      B,53
        CALL    PUTMAN
        CALL    INJOY1
        CALL    TFORW
        JR      C,TAG
        JR      DWAIT
GOUP    LD      IX,UP
        LD      B,11
        CALL    LOOP
        JP      WAIT

FIRE    CALL    TFORW
        JR      C,GOCARE
        CALL    INJOY1
        BIT     0,A
        JP      NZ,WAIT
        LD      B,0
        CALL    PUTMAN
        CALL    INJOY1
        JP      FIRE

GOCARE  LD      A,6
        LD      (KIND),A
        CALL    HOW
        CP      3
        JR      NC,GOCARE1
        CP      2
        JR      Z,GOCARE2
        CP      1
        JR      Z,GOCARE3
        LD      IX,CARE4
        LD      HL,FLAG
        BIT     2,(HL)
        JR      NZ,GOCARE1
        LD      B,9
        CALL    LOOP
        LD      B,1
        CALL    MVE1
        LD      B,2
        CALL    LOOP
        LD      HL,FLAG
        SET     2,(HL)
        JR      WWW
GOCARE1 LD      IX,CARE
        LD      B,12
        CALL    LOOP
WWW     LD      B,0
        XOR     A
        LD      (KIND),A
        CALL    PUTMAN
        CALL    INJOY1
        CALL    TFORW
        JR      C,WWW
        JP      WAIT
GOCARE2 LD      IX,CARE2
        LD      B,8
        CALL    LOOP
        LD      A,(POS)
        LD      B,A
        CALL    DECB
        CALL    DECB
        LD      A,B
        LD      (POS),A
        JR      WWW
GOCARE3 LD      IX,CARE3
        LD      B,7
        CALL    LOOP
        CALL    DECPOS
        JR      WWW
GOJUMP1 LD      IX,JUMP1
        CALL    TFORW
        JP      C,GOJUMP
        LD      B,4
        CALL    LOOP
        CALL    INJOY1
        CALL    TFORW
        JP      C,GOJUMP
        LD      B,7
        CALL    LOOP
        LD      HL,FLAG
        SET     0,(HL)
        PUSH    DE
        LD      C,8
        CALL    DECDE
        LD      B,0
        CALL    PUTHIGH
        LD      B,1
        LD      C,8
        CALL    DECDE
        CALL    PUTHIGH
        LD      A,(LEV)
        DEC     A
        LD      (LEV),A
        LD      A,(POS)
        LD      B,A
        CALL    DECB
        CALL    RETRIEV
        RES     7,A
        PUSH    AF
        LD      A,(LEV)
        INC     A
        LD      (LEV),A
        POP     AF
        CP      "$"
        JR      Z,LONGJ
        CP      " "
        JR      NZ,NOLONG
LONGJ   LD      C,5
        CALL    DECDE
        LD      B,1
        CALL    PUTHIGH
        LD      C,2
        CALL    DECDE
        LD      B,1
        CALL    PUTHIGH
        LD      B,1
        CALL    PUTHIGH
        LD      C,2
        CALL    INCDE
        LD      B,1
        CALL    PUTHIGH
        LD      C,5
        CALL    INCDE
        LD      B,2
        CALL    PUTHIGH
        JR      NOTST
NOLONG  CP      ":"
        JR      NZ,NJF
        LD      A,(POS)
        LD      B,A
        CALL    DECB
        LD      A,B
        ADD     A,3
        SRL     A
        SRL     A
        LD      C,A
        LD      A,(LEV)
        LD      B,A
NJF     LD      A,(LEV)
        LD      B,A
        CALL    TSTFAL
NOTST   POP     DE
        LD      HL,FLAG
        RES     0,(HL)
        CALL    DECPOS
        LD      B,4
        CALL    LOOP
        JP      WAIT

GOJUMP2 LD      IX,JUMP2
        LD      A,3
        LD      (KIND),A
        LD      B,3
        CALL    LOOP
        CALL    ADJ
        LD      B,1
        CALL    LOOP
        CALL    ADJ
        LD      B,2
        CALL    LOOP
        LD      HL,FLAG
        SET     0,(HL)
        LD      C,3
        LD      A,(POS)
        LD      B,A
LLOOP2  CALL    DECB
        DEC     C
        JR      NZ,LLOOP2
        LD      A,B
        LD      (POS),A
        LD      B,203
        CALL    PUTLONG
        LD      B,2
        CALL    MVE
        LD      C,2
        LD      A,(POS)
        LD      B,A
LLOOP3  CALL    DECB
        DEC     C
        JR      NZ,LLOOP3
        LD      A,B
        LD      (POS),A
        LD      B,204
        CALL    PUTLONG
        LD      C,2
        LD      A,(POS)
        LD      B,A
LLOOP4  CALL    DECB
        DEC     C
        JR      NZ,LLOOP4
        LD      A,B
        LD      (POS),A
        LD      B,2
        CALL    MVE
        LD      B,2
        CALL    LOOP
        LD      HL,FLAG
        RES     0,(HL)
        LD      B,2
        CALL    LOOP
        JP      CONT2
GOBLOCK LD      IX,BLOCK
        CALL    MAKEDE
        LD      HL,FLAG
        SET     0,(HL)
        LD      B,2
        CALL    LOOP
        LD      HL,FLAG
        RES     0,(HL)
        JP      WAIT

PRET    LD      HL,TIME
        INC     (HL)
        LD      A,(MCOUNT)
        AND     A
        JR      Z,NOMUS
        DEC     A
        LD      (MCOUNT),A
        AND     A
        JR      NZ,NOMUS
        LD      A,(PAGE)
        PUSH    AF
        LD      A,20
        CALL    SETPAGE
        CALL    49152
        POP     AF
        CALL    SETPAGE
        XOR     A
        LD      (AMUS),A
        LD      HL,0
        LD      (AMUS+1),HL
NOMUS   LD      A,(LIVES)
        CP      1
        JR      NZ,NFLASH1
        LD      A,(TIME)
        BIT     0,A
        JR      Z,PUTE2
        XOR     A
        LD      (LIVES),A
        CALL    PUTKLIV
        LD      A,1
        LD      (LIVES),A
        JR      NFLASH1
PUTE2   CALL    PUTKLIV
NFLASH1 LD      HL,#A000
FLIP1   LD      DE,#4000;#57E0
        LD      A,16
        CALL    SETPAGE
        LD      B,186
PRLP    LD      C,40
        PUSH    DE
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        POP     DE
FLIP2   CALL    INC_DE1
        DJNZ    PRLP
        LD      B,2
        CALL    DELAY
        POP     BC
        POP     DE
        LD      HL,SCR-1
AGA     INC     HL
        LD      A,(HL)
        INC     HL
        AND     A
        JR      Z,CHECK
        DEC     A
        CP      B
        JR      NZ,AGA
        LD      A,(DIR)
        AND     A
        JR      Z,SB
        LD      A,(POS)
        LD      (PPOS),A
        ADD     A,(HL)
        JR      AD
SB      LD      A,(POS)
        SUB     (HL)
AD      LD      (POS),A
CHECK   CALL    TSTBLK
NMIRT
NPRO    PUSH    DE
        CALL    PAUSE
        POP     DE
        LD      A,(POS)
        PUSH    BC
        LD      B,A
        CALL    RETRIEV
        RES     7,A
        LD      (SAV),A
        CP      "a"
        JP      C,NOPEN1
        LD      HL,FLAG
        BIT     0,(HL)
        JP      NZ,NOPEN1
        BIT     1,(IY+118)
        JP      NZ,NOPEN2
        LD      A,(PRESS1)
        LD      B,A
        LD      A,(SAV)
        SUB     "a"
        CP      B
        JR      Z,NOPEN1
        SET     1,(IY+118)
        CALL    REST
        CALL    COUNT
        LD      (FOPEN),BC
        LD      HL,FL
        LD      (ITEM),HL
        CALL    PUTITM
        CALL    SAVE
NOPEN2  LD      A,(SAV)
        SUB     "a"
        LD      (PRESS),A
        LD      C,A
        LD      B,0
        SLA     C
        SLA     C
        PUSH    DE
        LD      HL,GATES
        ADD     HL,BC
        CALL    FILLD
        LD      C,(HL)
        INC     HL
        LD      B,(HL)
        LD      A,B
        CP      #FE
        JR      Z,OPEX
        CALL    MAKEOPEN
        POP     DE
        LD      A,(SAV)
        JP      NKOL
OPEX    LD      A,(EOPEN)
        AND     A
        JR      NZ,NOPX1
        LD      A,1
        LD      (EOPEN),A
NOPX1   POP     DE
        LD      A,(SAV)
        JR      NSPA
NOPEN1  BIT     1,(IY+118)
        JR      Z,NOPEN
        PUSH    DE
        RES     1,(IY+118)
        CALL    REST
        LD      BC,(FOPEN)
        LD      HL,FL
        LD      (ITEM),HL
        SET     0,(IY+71)
        CALL    PUTITM
        RES     0,(IY+71)
        CALL    SAVE
        LD      A,#FF
        LD      (PRESS),A
        POP     DE
NOPEN   LD      A,(SAV)
NSPA
NKOL    LD      HL,FLAG
        BIT     2,(HL)
        JR      NZ,ARET1
        CP      "$"
        JR      Z,NARET
        CP      "@"
        JR      NZ,ARET
NARET   LD      A,(POS)
        LD      B,A
FAR     CALL    INCB
        CALL    RETRIEV
        RES     7,A
        CP      "@"
        JR      Z,FAR
        CP      "$"
        JR      Z,FAR
        CALL    INCB
        LD      A,B
        LD      (POS),A
        LD      A,(POS)
        LD      B,A
        CALL    RETRIEV
        RES     7,A
        CP      " "
        JR      Z,ARET1
        CALL    TSTSCR
GBLOCK  LD      SP,(STACK)
        JP      GOBLOCK
ARET    LD      A,(POS)
        LD      B,A
        CALL    DECB
        CALL    RETRIEV
        RES     7,A
        CP      "$"
        JR      Z,FAR
        CP      "@"
        JR      Z,FAR
ARET1   CALL    TSTSCR
PS2     POP     BC
        RET
SCR     DEFB    6,1,9,2,10,2,13,2,14,2,16,3,17,1,18,2,59,1
        DEFB    70,3,48,2,91,3,93,4,98,3,97,3,39,3
        DEFB    27,2,147,2,151,1,152,255,0

CURLEV  EQU     14
STARTPOS EQU    #0003
STARTLEV EQU    1
STAPOS  EQU     15
STADIR  EQU     0
HEIGHT  EQU     6
LENGHT  EQU     40
WIDTH   DEFB    40
HEIGH   DEFB    6
WDTH    DEFB    5
HGHT    DEFB    2
NLEV    DEFB    "LEVEL 12",0
GATES   DEFW    #0001,#0200
        DEFW    #0002,#0200
        DEFW    #0003,#0200
        DEFW    #FFFF,#FFFF
AGATEIN DEFW    #0003,#A50C,#A68D
AGATE   DEFW    #FFFF
FIRES   DEFW    #AA05,#AA1A,#A804,#A81D,#A804,#A81D,#A60A,#A614,#A801,#A80E
TSTSCR  PUSH    BC              ;--------
        LD      A,(POS)
        CP      200
        JR      NC,OUTOF
        CP      32
        JR      NC,OUTOF1
        POP     BC
        RET
OUTOF1  SUB     32
        LD      (POS),A
        PUSH    DE
        LD      A,(SCREEN)
        INC     A
        LD      (SCREEN),A
        CALL    CLS
        LD      BC,(SCREEN)
        CALL    PUTROOM
        CALL    PLACE
        POP     DE
        CALL    SAVE0
        EX      DE,HL
        LD      DE,32
        SCF
        CCF
        SBC     HL,DE
        EX      DE,HL
        POP     BC
        RET
OUTOF   ADD     A,32
        LD      (POS),A
        PUSH    DE
        LD      A,(SCREEN)
        DEC     A
        LD      (SCREEN),A
        CALL    CLS
        AND     A
        JR      Z,OUTM
        LD      BC,(SCREEN)
        CALL    PUTROOM
        CALL    PLACE
        POP     DE
        CALL    SAVE0
        EX      DE,HL
        LD      DE,32
        ADD     HL,DE
        EX      DE,HL
        POP     BC
        RET
OUTM    LD      A,19
        CALL    SETPAGE
        CALL    CLS1
        LD      HL,#C000
        LD      DE,#A000
        LD      B,176
OUTLOOP PUSH    BC
        PUSH    HL
        LD      BC,32
        LDIR
        POP     HL
        CALL    INC_HL1
        POP     BC
        DJNZ    OUTLOOP
        LD      HL,#C000
        LD      DE,#4000
        LD      BC,6912-64
        LDIR
        LD      A,16
        CALL    SETPAGE
        LD      HL,#C000
        LD      DE,#C001
        LD      (HL),#FF
        LD      BC,#1AFF
        LDIR
        LD      DE,#CD00
        LD      B,64
MASL    PUSH    BC
        LD      HL,MAS
        LD      BC,32
        LDIR
        POP     BC
        DJNZ    MASL
        CALL    PLACE
        POP     DE
        CALL    SAVE0
        LD      DE,#ADDE
        LD      A,#1F
        LD      (POS),A
        POP     BC
        LD      SP,(STACK)
        JP      CONT3
MAS     DEFS    23,#FF
        DEFB    #C0,#01
        DEFS    07,#FF

INJOY1  LD      A,(SCREEN)
        AND     A
        JP      NZ,INJOY
        LD      A,#FF
        PUSH    AF
        LD      A,(POS)
        CP      #16
        JR      C,STANS1
        POP     AF
        RES     4,A
        RET
STANS1  POP     AF
        RET

ENDGAM  DI
        LD      HL,#724B
        LD      (23714),HL
        EI
        LD      HL,49152+6
        CALL    IMUSIC
        LD      HL,#C000+6912
        LD      B,10
ENDLOOP PUSH    BC
        LD      A,19
        CALL    SETPAGE
        LD      DE,#ADCD
        LD      B,42
ENDLP   PUSH    BC
        LD      BC,4
        LDIR
        PUSH    HL
        LD      HL,28
        ADD     HL,DE
        EX      DE,HL
        POP     HL
        POP     BC
        DJNZ    ENDLP
        PUSH    HL
        CALL    PRET1
        POP     HL
        POP     BC
        DJNZ    ENDLOOP
        LD      B,255
WW      PUSH    BC
        LD      B,10
        CALL    PRET1
        HALT
        POP     BC
        DJNZ    WW
        LD      B,40
WW1     PUSH    BC
        LD      B,10
        CALL    PRET1
        HALT
        POP     BC
        DJNZ    WW1
        CALL    CLEAR
        LD      HL,#4000
        LD      DE,#4001
        LD      (HL),L
        LD      BC,#1800
        LDIR
        LD      (HL),7
        LD      BC,767
        LDIR
        CALL    TIMEOFF
        LD      A,20
        CALL    SETPAGE
        CALL    49152
        LD      A,19
        CALL    SETPAGE
        CALL    SCROLLI
        LD      B,47
        CALL    SCROLL
        LD      B,000
        CALL    DELAY
        LD      B,122
        CALL    SCROLL
SELF    JR      SELF
PRET1   CALL    DOALL
        PUSH    BC
        PUSH    DE
        JP      PRET

AFONT   EQU     59282-256

SCROLLI LD      HL,#B000
        LD      DE,#B001
        LD      (HL),L
        LD      BC,#E00
        LDIR
        CALL    LINEINIT
        CALL    ROLL
        RET

SCROLL  PUSH    BC
        LD      B,4
LOOP_   PUSH    BC
        CALL    PUT_
        CALL    PRINT
        CALL    ROLL
        HALT
        HALT
        POP     BC
        DJNZ    LOOP_
        POP     BC
        DJNZ    SCROLL
        RET

ROLL    PUSH    BC
        PUSH    AF
        PUSH    IX
M8065   LD      IX,TABLE-1
M8069   INC     IX
        LD      A,(IX)
        CP      #AA
        JP      NZ,NFRESH
        LD      IX,TABLE
        XOR     A
NFRESH  LD      (M8065+2),IX
        LD      (VAR1_),A
        LD      A,(IX+#11)
        LD      (VAR2_),A
        LD      A,(IX+#22)
        LD      (VAR3),A
        POP     IX
        POP     AF
        POP     BC
        RET
VAR1_   DEFB    0
VAR2_   DEFB    0
VAR3    DEFB    0
LINE    DEFW    #B000

PUT_    LD      DE,(LINE)
        LD      A,(VAR2_)
        LD      B,A
        LD      A,(VAR1_)
        CALL    PUT1_
        LD      B,#08
        LD      A,(VAR3)
        CALL    PUT1_
        LD      B,#08
        ADD     A,#10
        CALL    PUT1_
        LD      B,#08
        ADD     A,#10
        CALL    PUT1_
        LD      B,#08
        ADD     A,#10
        CALL    PUT1_
        LD      B,#08
        ADD     A,#10
        CALL    PUT1_
        LD      B,#08
        ADD     A,#10
        CALL    PUT1_
        LD      B,#08
        ADD     A,#10
        CALL    PUT1_
        LD      B,#08
        ADD     A,#10
        CALL    PUT1_
        LD      B,#08
        ADD     A,#10
        CALL    PUT1_
        LD      B,#08
        ADD     A,#10
        CALL    PUT1_
        LD      B,#08
        ADD     A,#10
        CALL    PUT1_
        EX      AF,AF'
        LD      A,(VAR2_)
        LD      B,A
        LD      A,#08
        SUB     B
        LD      B,A
        EX      AF,AF'
        ADD     A,#10
PUT1_   INC     B
        DEC     B
        RET     Z
        DI
        PUSH    AF
        LD      (STACK1+1),SP
        LD      H,0
        LD      L,A
        LD      A,B
        ADD     HL,HL
        LD      BC,LINETABLE
        ADD     HL,BC
        LD      SP,HL
        EX      DE,HL
        LD      B,A
        POP     DE
PLOOP   LD      C,H
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        POP     DE
        LD      A,H
        CP      #BE
        JR      NZ,NFR
        LD      HL,#B000
NFR     DJNZ    PLOOP
STACK1  LD      SP,0
        EI
        EX      DE,HL
        POP     AF
        RET
TEST    LD      A,#BE
        CP      H
        RET     NZ
        LD      HL,#B000
        RET
PRINT   LD      A,(VAR1_)
        OR      A
        RET     NZ
        LD      HL,(LINE)
        LD      (CURLINE+1),HL
        LD      DE,#20
        ADD     HL,DE
        CALL    TEST
        LD      (LINE),HL
        LD      A,(CURPOS+1)
        INC     A
        AND     #07
        JP      NZ,NEXT
        LD      HL,(ATEXT+1)
        LD      DE,#20
        ADD     HL,DE
        LD      (ATEXT+1),HL
        XOR     A
NEXT    LD      (CURPOS+1),A
        LD      B,#20
ATEXT   LD      HL,TEXT
PTLOOP  PUSH    BC
        PUSH    HL
        CALL    PRI
        POP     HL
        INC     HL
        POP     BC
        DJNZ    PTLOOP
        RET
PRI     LD      A,(HL)
        LD      L,A
        LD      H,0
        ADD     HL,HL
        ADD     HL,HL
        ADD     HL,HL
        LD      DE,AFONT
        ADD     HL,DE
CURPOS  LD      A,#07
        LD      E,A
        LD      D,0
        ADD     HL,DE
CURLINE LD      DE,#B000
        LDI
        LD      (CURLINE+1),DE
        RET
LINEINIT
        LD      DE,#4000
        LD      B,#C0
        LD      HL,LINETABLE
LILOOP  LD      (HL),E
        INC     HL
        LD      (HL),D
        INC     HL
        CALL    INC_DE1
        DJNZ    LILOOP
        LD      DE,#4000
        LD      B,#10
LILOOP1 LD      (HL),E
        INC     HL
        LD      (HL),D
        INC     HL
        CALL    INC_DE1
        DJNZ    LILOOP1
        RET
TABLE   DEFB    #00,#00,#00,#00,#00,#00,#00,#00
        DEFB    #08,#07,#06,#05,#04,#03,#02,#01,#AA
        DEFB    #08,#07,#06,#05,#04,#03,#02,#01
        DEFB    #00,#00,#00,#00,#00,#00,#00,#00,#AA
        DEFB    #10,#0F,#0E,#0D,#0C,#0B,#0A,#09
        DEFB    #08,#07,#06,#05,#04,#03,#02,#01,#AA
CLEAR   LD      B,8
C_LOOP  PUSH    BC
        LD      DE,#5800
C_LOOP1 LD      A,(DE)
        AND     7
        JR      Z,NINC_
        DEC     A
        LD      B,A
        LD      A,(DE)
        AND     #F8
        OR      B
        LD      (DE),A
NINC_   LD      A,(DE)
        AND     #38
        JR      Z,NINC1_
        SUB     8
        LD      B,A
        LD      A,(DE)
        AND     #C7
        OR      B
        LD      (DE),A
NINC1_  INC     HL
        INC     DE
        LD      A,D
        CP      #5B
        JR      NZ,C_LOOP1
        HALT
        HALT
        HALT
        POP     BC
        DJNZ    C_LOOP
        RET
LINETABLE       EQU     #A000
TEXT    DEFB    "                                "
        DEFB    "tiran dvafar powerven, ego armiq"
        DEFB    "   razbita. wesx narod persii   "
        DEFB    " priwetstwuet swo` princessu... "
        DEFB    "  i kone~no-ve `no}u, kotoryj   "
        DEFB    "  spas ee ot sil txmy. s |togo  "
        DEFB    "    dnq on izwesten kak...      "
        DEFB    "                                "
        DEFB    "       PRINCE OF PERSIA.        "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "  pozdrawlq` was s uspe}nym pro-"
        DEFB    "hovdeniem igry. uweren, ~to  ona"
        DEFB    "dostawila  wam  nemalo  priqtnyh"
        DEFB    "minut.                          "
        DEFB    "           uda~i !!!            "
        DEFB    "                                "
        DEFB    "              NICODIM 17.02.1996"
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "            THE END             "
        DEFB    "            '''''''             "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
        DEFB    "                                "
READ    DI
TRACK   LD      A,#3C
        LD      C,CURLEV
        CALL    SEARCH
        CALL    FORMAT
        EI
        RET
ZAGR    LD      IX,#2FC3
        JP      TRDOS
SEARCH  LD      IX,#2F4D
TRDOS   PUSH    IX
        JP      #3D2F
FORMAT  LD      HL,#A000
        LD      BC,#007F
        LD      A,#E0
        LD      IX,#2F57
        PUSH    IX
        LD      IX,#3FE5
        PUSH    IX
        LD      IX,#2FC3
        JP      TRDOS
        INCLUDE "ABLOCK1.asm"
        INCLUDE "ENDPART1.asm"
