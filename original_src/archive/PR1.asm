        ORG     #A000+6144
BUF     DEFS    300
BUF1    DEFS    300
ROOM    DEFS    300
ROTT    DEFS    256

        ORG     29300

        DI
        LD      HL,STAX
        LD      BC,11600
        LD      A,27
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
        LD      HL,#C000
        LD      DE,PRINCE2
        LD      BC,#2105
        CALL    #3D13
        LD      HL,57458
        LD      DE,#0500
        LD      BC,#0505
        CALL    #3D13
        LD      HL,58608
        LD      DE,#1306
        LD      BC,#0A05
        CALL    #3D13
        LD      HL,61200
        LD      DE,#0B07
        LD      BC,#1105
        CALL    #3D13
        LD      A,20
        CALL    SETPAGE
        LD      HL,#C000
        LD      DE,#1400
        LD      BC,#2C05
        CALL    #3D13
        CALL    PROT
        CALL    TIMEON
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
        LD      HL,#B4A9
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
        LD      A,2
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
        LD      A,(FFLAG)
        AND     A
        JR      NZ,NOREADY
        LD      A,(TOKEN)
        AND     A
        JR      NZ,NOREADY
        BIT     0,(IY+55)
        JR      Z,NOREADY
        LD      A,(WNDS)
        AND     A
        JP      Z,NOREADY
        LD      A,(LEV1)
        LD      C,A
        LD      A,(LEV)
        CP      C
        JR      NZ,NOREADY
        CALL    TCLEAR
        JR      C,NOREADY
        BIT     1,(IY+71)
        JP      Z,GOREADY
NOREADY CALL    INJOY
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
        CALL    INJOY
        CALL    TJUMP
        JP      C,GOJUMP
        DJNZ    M1
        LD      B,4
CONT    CALL    LOOP
CONT2   CALL    INJOY
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
        LD      IX,RUN+16
        LD      B,4
        CALL    LOOP
CONT1   CALL    INJOY
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
        LD      (HEI),A
        CALL    TDOWN
        JP      C,GODOWN1
GODOWN2 LD      B,1
        LD      IX,DOWN
        CALL    LOOP
        LD      A,(HEI)
        AND     A
        JR      Z,NOBEAT
        LD      A,(LIVES)
        DEC     A
        LD      (LIVES),A
        AND     A
        JP      Z,GODIE
        LD      A,7
        OUT     (#FE),A
        HALT
        XOR     A
        OUT     (#FE),A
        LD      A,(HEI)
        CP      2
        JP      NC,GODIE
        CALL    PUTKLIV
NOBEAT  LD      B,1
        LD      A,1
        LD      (KIND),A
        CALL    LOOP
        LD      A,(HEI)
        AND     A
        JR      Z,DWAIT
        XOR     A
        LD      (HEI),A
        LD      C,50
BLOOP   LD      B,53
        PUSH    BC
        CALL    PUTMAN
        POP     BC
        DEC     C
        JR      NZ,BLOOP
DWAIT   LD      B,53
        CALL    PUTMAN
        CALL    INJOY
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
        CALL    INJOY
        CALL    TFORW
        JR      C,TAG
        JR      DWAIT
GOUP    LD      IX,UP
        LD      B,11
        CALL    LOOP
        JP      WAIT

FIRE    CALL    TDRINK
        JP      C,GODRINK
        CALL    TDRINKG
        JP      C,GODRINK1
        CALL    TFORW
        JR      C,GOCARE
        CALL    TSWORD
        JP      C,GOSWORD
        CALL    INJOY
        BIT     0,A
        JP      NZ,WAIT
        LD      B,0
        CALL    PUTMAN
        CALL    INJOY
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
        CALL    INJOY
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
        PUSH    DE
        CALL    TEXIT
        POP     DE
        JP      NC,GOEXIT
        LD      B,4
        CALL    LOOP
        CALL    INJOY
        CALL    TFORW
        JP      C,GOJUMP
        CALL    TTOP
        JP      C,TOTOP
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
        CALL    MAKEFALL+3
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
HEI     DEFB    0
GOFALL  LD      IX,FALLC
        XOR     A
        LD      (HEI),A
        LD      B,1
        CALL    MVE
        LD      HL,FLAG
        SET     0,(HL)
        LD      A,(LEV)
        INC     A
        LD      (LEV),A
        LD      C,3
        CALL    FALL1
        LD      C,6
        CALL    FALL1
        LD      C,10
        CALL    FALL1
        LD      A,(KIND)
        CP      1
        JR      Z,NPR
        AND     A
        JR      Z,NPR
        CP      6
        JR      Z,NPR
        CP      4
        JR      Z,NPR
        CALL    DECPOS
        LD      B,1
        CALL    MVE
NPR     LD      C,14
        CALL    FALL1
        CALL    SCRUD
        CALL    TSTZ
        JP      NC,NEXFAL
NOFALL  LD      HL,FLAG
        RES     0,(HL)
        CALL    INCPOS
        JP      VIS3
NEXFAL  LD      C,19
        CALL    FALL1
        CALL    DECPOS
FAG     CALL    TSTZ
        JR      C,NOFALL
        LD      A,16
        CALL    SETPAGE
        CALL    MAKEDE
        LD      A,(POS)
        LD      B,A
        CALL    RETRIEV
        RES     7,A
        CP      " "
        JR      Z,FALLN
ENDFAL  LD      HL,FLAG
        RES     0,(HL)
        LD      A,(LEV)
        INC     A
        LD      B,A
        PUSH    DE
        CALL    TSTFAL
        POP     DE
        JP      GODOWN2
FALLN   LD      A,(LEV)
        INC     A
        LD      (LEV),A
        LD      A,(HEI)
        INC     A
        LD      (HEI),A
        LD      IX,FALLC+8
        LD      C,15
        CALL    FALL1
        LD      C,25
        CALL    FALL1
        CALL    SCRUD
        JR      FAG
FALL1   CALL    INCDE
        LD      B,1
        CALL    LOOP
        RET
GOBLOCK LD      IX,BLOCK
        CALL    MAKEDE
        LD      HL,FLAG
        SET     0,(HL)
        LD      B,2
        CALL    LOOP
        LD      HL,FLAG
        RES     0,(HL)
        JP      WAIT

TOTOP   LD      HL,FLAG
        SET     0,(HL)
        SET     2,(HL)
        LD      B,7
        CALL    LOOP
        LD      C,8
        CALL    DECDE
        LD      B,0
        CALL    PUTHIGH
        LD      B,1
        LD      C,8
        CALL    DECDE
        CALL    PUTHIGH
        LD      B,4
        CALL    PUTHIGH
        LD      A,(LEV)
        DEC     A
        LD      (LEV),A
        CALL    DECPOS
        LD      HL,FLAG
        RES     0,(HL)
        LD      B,5
        PUSH    DE
        CALL    PUTHIGH
        POP     DE
        LD      A,(POS)
        LD      B,A
        CALL    RETRIEV
        RES     7,A
        CP      "a"
        JR      C,VIS2
        LD      C,1
        CALL    INCDE
        CALL    INCPOS
VIS1    LD      B,5
        PUSH    DE
        LD      HL,FLAG
        SET     3,(HL)
        CALL    PUTHIGH
        LD      HL,FLAG
        RES     3,(HL)
        POP     DE
        LD      A,7
        LD      (KIND),A
VIS2    CALL    INJOY
        BIT     1,A
        JR      Z,TOUP
        PUSH    AF
        CALL    INCPOS
        POP     AF
        BIT     0,A
        JR      Z,VIS1
        CALL    DECPOS
        LD      HL,FLAG
        RES     2,(HL)
        JP      FALN1
TOUP    LD      IX,TOP
        LD      A,7
        LD      (KIND),A
        LD      B,1
        CALL    LOOP
        LD      C,3
        CALL    DECDE
        LD      B,1
        CALL    LOOP
        LD      C,6
        CALL    DECDE
        LD      B,1
        CALL    LOOP
        LD      C,6
        CALL    DECDE
        LD      B,1
        CALL    LOOP
        LD      C,2
        CALL    DECDE
        LD      B,5
        CALL    LOOP
        CALL    SCRUD
        CALL    MAKEDE
        LD      B,8
        CALL    LOOP
        LD      HL,FLAG
        RES     0,(HL)
        RES     2,(HL)
        JP      WAIT

GODOWN1 LD      IX,DOWN1
        LD      HL,FLAG
        SET     2,(HL)
        LD      B,2
        CALL    LOOP
        LD      B,1
        CALL    MVE1
        LD      C,24
        CALL    INCDE
        LD      B,5
        CALL    LOOP
        LD      B,1
        CALL    MVE1
        LD      C,8
        CALL    INCDE
        LD      B,1
        CALL    LOOP
        LD      C,10
        CALL    INCDE
        LD      B,1
        CALL    LOOP
        CALL    INCPOS
        CALL    MAKEDE
        LD      B,1
        CALL    MVE1
        LD      C,40
        CALL    INCDE
        LD      A,(LEV)
        INC     A
        LD      (LEV),A
        CALL    SCRUD
VIS3    CALL    MAKEDE
        LD      C,14
        CALL    DECDE
        LD      B,1
        CALL    MVE1
VIS     LD      B,5
        LD      A,(LEV)
        DEC     A
        LD      (LEV),A
        LD      HL,FLAG
        SET     3,(HL)
        CALL    PUTHIGH
        LD      HL,FLAG
        RES     3,(HL)
        LD      A,(LEV)
        INC     A
        LD      (LEV),A
        CALL    INJOY
        BIT     0,A
        JR      NZ,FALN
        PUSH    AF
        CALL    INCPOS
        POP     AF
        BIT     1,A
        JR      NZ,VIS
        CALL    DECPOS
        LD      IX,TOP+8
        LD      A,(LEV)
        DEC     A
        LD      (LEV),A
        CALL    SCRUD
        CALL    MAKEDE
        LD      C,40
        CALL    INCDE
        LD      B,2
        CALL    MVE1
        JP      TOUP
FALN1   LD      A,(LEV)
        INC     A
        LD      (LEV),A
        CALL    SCRUD
FALN    LD      C,5
        CALL    INCDE
        LD      HL,FLAG
        RES     0,(HL)
        RES     2,(HL)
        LD      B,1
        CALL    MVE
        LD      B,3
        CALL    PUTHIGH
        CALL    MAKEDE
        LD      B,1
        CALL    MVE1
        LD      IX,JUMP1+22
        LD      B,4
        CALL    LOOP
        JP      WAIT
GODRINK1
        LD      A,(ALLIV)
        INC     A
        LD      (ALLIV),A
        LD      (LIVES),A
        SET     4,(IY+55)
GODRINK LD      B,3
        LD      IX,DRIN
        CALL    LOOP
        LD      HL,DRINK+12
        LD      (ADRINK),HL
        CALL    REST
        CALL    PUTDRINK
        CALL    PUTDRINKG
        CALL    SAVE
        LD      B,22
        CALL    LOOP
        PUSH    DE
        LD      HL,(ADRINK+2)
        LD      D,H
        LD      E,L
        DEC     DE
        DEC     DE
        DEC     DE
        DEC     DE
KDLP    LD      A,(HL)
        CP      #FF
        JR      Z,ENDKD
        LD      BC,4
        LDIR
        JR      KDLP
ENDKD   LD      BC,4
        LDIR
        POP     DE
        LD      A,(ALLIV)
        LD      B,A
        LD      A,(LIVES)
        CP      B
        JP      Z,P_W
        INC     A
        LD      (LIVES),A
        SET     4,(IY+55)
P_W     CALL    PUTKLIV
        BIT     4,(IY+55)
        JP      Z,WAIT
        LD      HL,50678+6
        LD      A,50
        CALL    IMUSIC
        RES     4,(IY+55)
        JP      WAIT
GOSWORD LD      B,4
        LD      IX,TAKES
        XOR     A
        LD      (TOKEN),A
        CALL    LOOP
        CALL    REST
        CALL    DELSWORD
        CALL    SAVE
        LD      B,1
        CALL    LOOP
        LD      HL,50678+6
        LD      A,50
        CALL    IMUSIC
        CALL    FLSH
        LD      B,8
        CALL    LOOP
        LD      B,2
        CALL    MVE1
        LD      B,5
        CALL    LOOP
        JP      WAIT

GOREADY LD      IX,READY
        LD      A,4
        LD      (KIND),A
        LD      B,4
        CALL    LOOP
BATTLE  LD      A,(WNDS)
        AND     A
        JR      Z,ENDB
        LD      A,(LEV)
        LD      B,A
        LD      A,(LEV1)
        CP      B
        JR      NZ,ENDB
        BIT     0,(IY+55)
        JR      Z,ENDB
        LD      B,148
        CALL    PUTMAN
        CALL    INJOY
        CP      #FF
        JR      Z,BATTLE
        BIT     0,A
        JP      Z,GOKICK
        BIT     2,A
        JR      Z,ENDB
        BIT     1,A
        JR      Z,GOPAR
        CALL    TFORW
        JR      C,GSTEPF
        CALL    TBACK
        JR      C,GSTEPB
        JR      BATTLE
GOPAR   LD      IX,PAR
        LD      HL,(AMOVE)
        LD      A,(HL)
        CP      166
        JP      Z,RPAR
        CP      167
        JP      Z,RPAR
        CP      250
        JP      Z,RPAR1
        LD      B,2
        CALL    LOOP
        JR      BATTLE
ENDB    LD      IX,TAKES+12
        LD      B,5
        LD      A,8
        LD      (KIND),A
        CALL    LOOP
        XOR     A
        LD      (KIND),A
        CALL    MAKEDE
        INC     IX
        INC     IX
        INC     IX
        INC     IX
        LD      B,4
        CALL    LOOP
        CALL    DECPOS
        SET     1,(IY+71)
        JP      WAIT
GSTEPF  LD      IX,STEPF
        LD      B,2
        CALL    LOOP
        JP      BATTLE
GSTEPB  LD      IX,STEPB
        LD      B,1
        CALL    LOOP
        LD      B,1
        CALL    MVE1
        LD      B,1
        CALL    LOOP
        JP      BATTLE
GOKICK  LD      IX,KICK
        SET     5,(IY+55)
        LD      B,2
        CALL    LOOP
        LD      B,2
        CALL    MVE
        LD      C,4
        CALL    INCDE
        RES     5,(IY+55)
        SET     6,(IY+55)
        LD      B,205
        CALL    PUTLONG
        BIT     4,(IY+55)
        JR      NZ,NOWOUN
        CALL    DIFFR
        CP      7
        JR      NC,NOWOUN
        SET     2,(IY+55)
NOWOUN  RES     4,(IY+55)
        LD      B,1
        CALL    MVE
        LD      B,206
        CALL    PUTLONG
        LD      B,207
        CALL    PUTLONG
        RES     6,(IY+55)
        LD      B,3
        CALL    MVE1
        LD      C,4
        CALL    DECDE
        LD      B,2
        CALL    LOOP
        JP      BATTLE
RPAR    LD      B,1
        CALL    LOOP
RPAR1   SET     3,(IY+55)
        LD      IX,PAR+2
        LD      B,1
        CALL    LOOP
        LD      B,1
        CALL    MVE1
        LD      B,152
        CALL    PUTMAN
        JP      BATTLE
GOEXIT  LD      A,B
        INC     A
        LD      (POS),A
        XOR     A
        LD      (DIR),A
        CALL    MAKEDE
        LD      C,5
        CALL    DECDE
        LD      IX,EXIT
        LD      B,6
        CALL    LOOP
        LD      B,1
        CALL    MVE1
        LD      B,1
        CALL    LOOP
        LD      C,15
        CALL    DECDE
        LD      B,5
        CALL    LOOP
        LD      DE,0
        LD      B,50
        IM      1
WEXIT   PUSH    BC
        LD      B,1
        CALL    PUTMAN
        POP     BC
        DJNZ    WEXIT
REXIT   LD      A,CURLEV
        IM      1
        INC     A
        LD      C,0
        RRCA
        RL      C
        RRCA
        RL      C
        RRCA
        RL      C
        RRCA
        RL      C
        LD      A,#41
        ADD     A,C
        LD      HL,PWORD
        LD      (HL),A
        INC     HL
        LD      A,(MIN)
        AND     #F
        PUSH    AF
        ADD     A,#41
        LD      (HL),A
        INC     HL
        POP     AF
        ADD     A,C
        LD      C,A
        LD      A,(SEC)
        RRCA
        RRCA
        RRCA
        RRCA
        AND     #F
        PUSH    AF
        ADD     A,#41
        LD      (HL),A
        INC     HL
        POP     AF
        ADD     A,C
        LD      C,A
        LD      A,(SEC)
        AND     #F
        PUSH    AF
        ADD     A,#41
        LD      (HL),A
        INC     HL
        POP     AF
        ADD     A,C
        LD      C,A
        LD      A,(MIN)
        RRCA
        RRCA
        RRCA
        RRCA
        AND     #F
        PUSH    AF
        ADD     A,#41
        LD      (HL),A
        INC     HL
        POP     AF
        ADD     A,C
        LD      C,A
        LD      A,(ALLIV)
        LD      B,0
        RRCA
        RL      B
        RRCA
        RL      B
        RRCA
        RL      B
        RRCA
        RL      B
        LD      A,#41
        ADD     A,B
        LD      (HL),A
        INC     HL
        LD      A,B
        ADD     A,C
        AND     #0F
        ADD     A,#41
        LD      (HL),A
        CALL    CLS
        CALL    CLS1
        LD      HL,39000
        LD      DE,#290D
        LD      BC,#1E05
        CALL    #3D13
        CALL    39000
        LD      HL,#4000
        LD      DE,LOADING
        LD      BC,#1B05
        CALL    #3D13
        LD      HL,PWORD
        LD      DE,#B60C
        CALL    MESS1
        LD      B,150
        CALL    DELAY
        LD      HL,29300
        PUSH    HL
        LD      DE,#4B05
        LD      BC,#2E05
        JP      #3D13
PWORD   DEFB    "       ",0
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
NFLASH1 LD      A,#30
        LD      (STFLAG),A
        PUSH    IX
        CALL    STPUT
        POP     IX
        LD      A,#38
        LD      (STFLAG),A
        LD      HL,#A000
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
        LD      B,DEL
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
        CALL    TSTWOUN
NMIRT   LD      A,(LIVES)
        AND     A
        JR      Z,NPRO
        LD      A,(STPOS)
        CP      #FF
        JR      Z,NPRO
        INC     A
        LD      B,A
        LD      A,(KIND)
        AND     A
        JR      NZ,NOK0
        CALL    TST0
        JR      NPRO
NOK0    CP      6
        JR      NZ,NOK6
        CALL    TST0
        JR      NPRO
NOK6    CP      5
        JR      NC,NOK13
        CALL    TST0
        CALL    TST1
        CALL    TST2
        CALL    TST3
        JR      NPRO
NOK13
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
        LD      HL,FLAG
        BIT     0,(HL)
        JP      NZ,NKOL
        CP      ":"
        JR      NZ,NFF
        CALL    MAKEFALL
        LD      A,":"
        JP      NKOL
NFF     CP      " "
        JR      NZ,NSPA
        LD      A,(KIND)
        CP      1
        JR      NZ,DOF
ADF     LD      A,(POS)
        LD      B,A
        CALL    INCB
        CALL    RETRIEV
        RES     7,A
        CP      " "
        JR      NZ,DOF
        LD      A,B
        LD      (POS),A
        JR      ADF
DOF     CALL    MAKEDE
        LD      SP,(STACK)
        JP      GOFALL
NSPA    CP      "!"
        JR      NZ,NKOL
        LD      A,(KIND)
        AND     A
        JR      Z,NKOL
        CP      6
        JR      Z,NKOL
        CALL    MAKEDE
        XOR     A
        LD      (LIVES),A
        CALL    PUTKLIV
        LD      SP,(STACK)
        JP      GODEAD1
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
        POP     BC
        RET
SCR     DEFB    6,1,9,2,10,2,13,2,14,2,16,3,17,1,18,2,59,1
        DEFB    70,3,48,2,91,3,93,4,98,3,97,3,39,3
        DEFB    27,2,147,2,151,1,152,255,0

MENEMY  BIT     0,(IY+55)
        RET     Z
        PUSH    BC
        PUSH    DE
        PUSH    HL
        LD      A,(WNDS)
        CP      1
        JR      NZ,NFLASH
        LD      A,(TIME)
        BIT     0,A
        JR      Z,PUTE1
        XOR     A
        LD      (WNDS),A
        CALL    PUTELIV
        LD      A,1
        LD      (WNDS),A
        JR      NFLASH
PUTE1   CALL    PUTELIV
NFLASH  LD      A,(WNDS)
        AND     A
        JR      Z,NROT
        LD      A,(POS1)
        LD      C,A
        LD      A,(POS)
        SUB     C
        BIT     7,A
        LD      A,#FF
        JR      NZ,D1OK
        XOR     A
D1OK    LD      (DIR1),A
NROT    LD      A,(KIND)
        CP      4
        CALL    Z,TROT
        LD      DE,(EADR)
        BIT     7,(IY+71)
        JR      Z,NEFALL1
        CALL    EFALL1
        JP      MERET-3
NEFALL1 BIT     2,(IY+55)
        JP      NZ,EWOUN
        BIT     3,(IY+55)
        JP      NZ,EBLKED
        BIT     1,(IY+55)
        JP      Z,THINK
        LD      HL,(AMOVE)
DO      LD      B,(HL)
        INC     B
        DEC     B
        JR      NZ,NDO
        RES     1,(IY+55)
        JP      THINK
NDO     INC     HL
        PUSH    HL
        LD      A,B
        CP      7
        JR      NZ,NRD
        LD      A,#FF
        LD      (DIR1),A
        LD      A,B
NRD     CP      119
        JR      NZ,NDR
        PUSH    AF
        PUSH    BC
        PUSH    DE
        LD      HL,DRINK+12
        LD      (ADRINK),HL
        CALL    PUTDRINKG
        LD      HL,(ADRINK+2)
        LD      D,H
        LD      E,L
        DEC     DE
        DEC     DE
        DEC     DE
        DEC     DE
KDLP1   LD      A,(HL)
        CP      #FF
        JR      Z,ENDKD1
        LD      BC,4
        LDIR
        JR      KDLP1
ENDKD1  LD      BC,4
        LDIR
        POP     DE
        POP     BC
        POP     AF
NDR     CP      250
        JR      C,NLNG
        SUB     242
        PUSH    DE
        LD      B,A
        PUSH    BC
        LD      C,4
        CALL    INCDE
        LD      B,3
        CALL    MVE11
        POP     BC
        CALL    PUTELNG
        POP     DE
        JR      AFPT
NLNG    DEC     B
        CALL    ENTST
        CALL    PUTEN
AFPT    POP     HL
        LD      A,(HL)
        INC     HL
        LD      (AMOVE),HL
        BIT     7,A
        JR      Z,INP
        NEG
        LD      HL,DECB1
        LD      (MELP+1),HL
        JR      DEP
INP     LD      HL,INCB1
        LD      (MELP+1),HL
DEP     LD      C,A
        INC     C
        DEC     C
        JP      Z,MERET
        LD      A,(POS1)
        LD      B,A
MELP    CALL    INCB1
        DEC     C
        JR      NZ,MELP
        LD      A,B
        LD      (POS1),A
        CALL    MAKEDE1
        JP      MERET
THINK
AMIR6   LD      A,(WNDS)
        AND     A
        JR      NZ,NDEAD
NDS     LD      A,#FF
        LD      (DPF),A
        LD      B,181
        JP      MRT
DPF     DEFB    0
NDEAD   LD      A,(LEV)
        LD      C,A
        LD      A,(LEV1)
        CP      C
        JP      NZ,NOR
        CALL    TCLEAR
        JR      NC,EOMOVE
        JP      NOR
EOMOVE  LD      A,(KIND)
        CP      5
        JP      Z,NOR
        CP      7
        JP      Z,NOMOVE
        CP      4
        JR      Z,THINK1
        CALL    DIFFR
        CP      7
        JP      C,EKICK
        LD      A,(KIND)
        AND     A
        JR      Z,TOMAN
NOMOVE  LD      B,160
        JR      MRT
THINK1  CALL    DIFFR
        CP      7
        JR      C,THINK2
        CP      9
        JR      NC,TOMAN
        LD      A,(POS1)
        CP      2
        JR      C,TOMAN
        CP      31
        JR      NC,TOMAN
        CALL    RANDOM
        LD      A,H
        CP      PTOMAN
        JR      C,NOMOVE
TOMAN   SET     1,(IY+55)
        LD      HL,TMAN
        JP      DO
NOR     LD      B,159
MRT     CALL    ENTST
        CALL    PUTEN
MERET   LD      (EADR),DE
        POP     HL
        POP     DE
        POP     BC
        RET
THINK2  BIT     6,(IY+55)
        JR      Z,CTHINK
        CALL    RANDOM
        LD      A,H
        CP      PBLK
        JR      C,EBLK
        JR      NOMOVE
CTHINK  CALL    RANDOM
        LD      A,H
        CP      PKICK
        JR      C,NOMOVE
EKICK   SET     1,(IY+55)
        LD      HL,TKICK
        JP      DO
EBLK    SET     1,(IY+55)
        SET     4,(IY+55)
        LD      HL,TBLK
        JP      DO
EWOUN   SET     1,(IY+55)
        RES     2,(IY+55)
        LD      HL,59135+6
        LD      A,10
        CALL    IMUSIC
        LD      A,(WNDS)
        CP      #FF
        JR      Z,NDECE
        DEC     A
        LD      (WNDS),A
        CALL    PUTELIV
        LD      A,(WNDS)
        AND     A
        JR      Z,EDEAD
NDECE   LD      HL,TWOUN
        JP      DO
EBLKED  SET     1,(IY+55)
        RES     3,(IY+55)
        LD      HL,TBLKED
        JP      DO
EDEAD   SET     1,(IY+55)
        LD      HL,52274+6
        LD      A,50
        CALL    IMUSIC
        LD      HL,TDEAD
        JP      DO
ERISE   SET     1,(IY+55)
        CALL    MAKEDE1
        LD      HL,TRISE
        JP      DO
EFIGHT  LD      A,3
        LD      (POS1),A
        XOR     A
        LD      (LEV1),A
        LD      A,3
        LD      (WNDS),A
        CALL    PUTELIV
        CALL    MAKEDE1
        SET     1,(IY+55)
        LD      HL,TFIGHT
        JP      DO
EFRIEND SET     1,(IY+55)
        LD      HL,TFRIEND
        LD      A,#FF
        LD      (FFLAG),A
        JP      DO
EFALL   POP     DE
        POP     BC
FALLO   SET     7,(IY+71)
        LD      A,#FF
        LD      (NUMFAL),A
EFALL1  LD      A,(NUMFAL)
        INC     A
        LD      (NUMFAL),A
        AND     A
        JP      Z,STEP0
        CP      1
        JP      Z,STEP1
        CP      2
        JP      Z,STEP2
        CP      3
        JR      Z,STEP3
STEP4   LD      A,(LEV1)
        INC     A
        CP      3
        JP      Z,OUTFAL
        LD      (LEV1),A
        CALL    MAKEDE1
        LD      A,(POS1)
        LD      B,A
        CALL    DECB
        CALL    DECB
        LD      A,B
        ADD     A,3
        SRL     A
        SRL     A
        LD      C,A
        LD      A,(LEV1)
        INC     A
        LD      B,A
        PUSH    DE
        LD      DE,(SCREEN)
        CALL    RETR
        POP     DE
        CP      " "
        JP      Z,EPFAL
        RES     7,(IY+71)
        RES     1,(IY+55)
        POP     HL
        LD      A,(NUMFAL)
        CP      5
        JP      C,NOR
        XOR     A
        LD      (WNDS),A
        JP      NDS
STEP3   LD      C,15
        JR      INCFAL
STEP2   LD      C,10
        JR      INCFAL
STEP1   LD      C,5
        JP      INCFAL
STEP0   LD      A,(POS1)
        LD      B,A
        CALL    DECB
        LD      A,B
        LD      (POS1),A
        CALL    MAKEDE1
        LD      C,5
INCFAL  CALL    INCDE
EPFAL   LD      B,172
        RET
NUMFAL  DEFB    0
OUTFAL  LD      DE,(SCREEN)
        INC     D
        LD      A,(POS1)
        LD      B,A
        CALL    DECB
        CALL    DECB
        LD      A,B
        ADD     A,3
        SRL     A
        SRL     A
        LD      C,A
        LD      B,1
TFAGA   CALL    RETR
        CP      " "
        JR      NZ,FALEND
        INC     B
        LD      A,B
        CP      4
        JR      NZ,TFAGA
        LD      B,1
        INC     D
        JR      TFAGA
FALEND  RES     0,(IY+55)
        RES     7,(IY+71)
        LD      HL,(AENEMY)
        DEC     HL
        DEC     HL
        LD      (HL),E
        INC     HL
        LD      (HL),D
        INC     HL
        INC     HL
        DEC     B
        LD      A,B
        LD      (HL),A
        LD      (LEV1),A
        INC     HL
        XOR     A
        LD      (HL),A
NCOR    LD      B,#FF
        RET
; IY+55 - bit0:there is an enemy; bit1:enemy moves
;         bit2:enemy wounded bit3:kid blocks bit7:enemy falls
;         bit4:enemy blocks bit5:kid kicks bit6:kid wounds
ACLSE   DEFW    CLSE
CLSE    DEFB    30,15,1,0
PROT    CALL    READ
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
        RET
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
        INCLUDE "PART1.asm"
        INCLUDE "LEVEL1.asm"
        ORG     29300
