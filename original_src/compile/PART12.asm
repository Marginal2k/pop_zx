; ---- LEVEL --------
AHEI    EQU     #FA89
AHEI1   EQU     #FAF8
PUTMASK EQU     #FC92
ADOOM   EQU     56640
LEVEL1  EQU     39600
WALL    EQU     57792
STOLB   EQU     WALL+2016
FL2     EQU     STOLB+2016+14
FL      EQU     FL2+448
FL1     EQU     FL+448
FL3     EQU     FL1+448
FL4     EQU     FL3+448
ITEM    EQU     #FB8D
PUTITEM EQU     #FB8F
PUTITEM1 EQU    #FC01
DEL     EQU     1
PUTROOM EQU     #FA64

FALLING EQU     65000
BUFA    EQU     #C000+3000

EXIT    DEFB    183,0,184,0,185,0,186,0,187,0,188,0,189,0,190,0
        DEFB    191,0,192,0,193,0,194,0
KICK    DEFB    156,0,157,0,158,0,153,0
STEPB   DEFB    152,0,153,0
STEPF   DEFB    150,1,151,0
PAR     DEFB    154,0,155,0

TST0    PUSH    BC
        LD      A,(POS)
        CP      B
        JP      Z,STDIE
        POP     BC
        RET
TST1    PUSH    BC
        CALL    INCB
        JR      TST0+1
TST2    PUSH    BC
        CALL    INCB
        JR      TST1+1
TST3    PUSH    BC
        CALL    INCB
        JR      TST2+1
STDIE   LD      SP,(STACK)
        LD      A,(STPOS)
        LD      (POS),A
        CALL    MAKEDE
        INC     DE
        JP      GODIE
MAKEMAN SET     0,(IY+55)
        SET     1,(IY+55)
        SET     7,(IY+55)
        PUSH    BC
        PUSH    DE
        PUSH    HL
        LD      HL,55244+6
        LD      A,20
        CALL    IMUSIC
        LD      A,(DIR)
        LD      (DIR1),A
        XOR     A
        LD      (WNDS),A
        LD      (LEV1),A
        LD      A,14
        LD      (POS1),A
        CALL    MAKEDE1
        LD      (EADR),DE
        LD      HL,TRUN
        LD      (AMOVE),HL
        POP     HL
        POP     DE
        POP     BC
        RET
MFLAG   DEFB    0
AMOVE   DEFW    0
MMAN    SET     0,(IY+55)
        SET     1,(IY+55)
        SET     7,(IY+55)
        PUSH    DE
        XOR     A
        LD      (DIR1),A
        XOR     A
        LD      (LEV1),A
        LD      (WNDS),A
        LD      A,#FF
        LD      (POS1),A
        CALL    MAKEDE1
        LD      (EADR),DE
        LD      HL,TDRNK
        LD      (AMOVE),HL
        LD      A,#FF
        LD      (MFLAG),A
        POP     DE
        RET
PUTELNG PUSH    DE
        PUSH    BC
        PUSH    BC
        CALL    TBUTTON
        POP     BC
        LD      A,(POS1)
        LD      (PS),A
        CALL    SAVE2_
        CALL    SLONG
        LD      A,(DIR1)
        AND     A
        JR      Z,ROT1_
        CALL    PUT1
PELRET  POP     BC
        POP     DE
        RET
ROT1_   CALL    RTD1
        JR      PELRET

PUTLONG PUSH    DE
        PUSH    BC
        LD      A,B
        SUB     200
        LD      B,A
        CALL    REST
        CALL    DOALL
        CALL    SAVE2
        LD      A,(POS)
        LD      (PS),A
        CALL    SLONG
        LD      A,(DIR)
        AND     A
        JR      NZ,ROTATED1
        CALL    PUT1
        JP      PRET
ROTATED1
        CALL    RTD1
        JP      PRET
RTD1    INC     DE
        INC     DE
        INC     DE
        INC     DE
        PUSH    IX
PUT3    PUSH    DE
        PUSH    BC
        LD      B,0
        CALL    PUTIT1
        CALL    PUTIT1
        CALL    PUTIT1
        CALL    PUTIT1
        CALL    PUTIT1
        CALL    PUTIT1
        CALL    PUTIT1
        POP     BC
        POP     DE
        CALL    INC_DE
        LD      A,D
        CP      #B8
        JR      NC,PRET12
        DJNZ    PUT3
PRET12  POP     IX
        RET
PUTHIGH PUSH    DE
        PUSH    BC
        CALL    REST
        CALL    DOALL
        CALL    SAVE4
        LD      A,(POS)
        LD      (PS),A
        PUSH    DE
        LD      A,19
        CALL    SETPAGE
        LD      HL,57458+15
        LD      DE,165
        INC     B
        DEC     B
        JR      Z,FIRST2
SEARCH2 ADD     HL,DE
        DJNZ    SEARCH2
FIRST2  LD      DE,ROOM
        LD      BC,165
        LDIR
        LD      A,16
        CALL    SETPAGE
        LD      HL,ROOM
        POP     DE
        LD      B,50
        LD      A,(DIR)
        AND     A
        JR      NZ,ROTATED3
PUT4    PUSH    DE
        PUSH    BC
        CALL    PUTIT
        CALL    PUTIT
        CALL    PUTIT
        POP     BC
        POP     DE
        CALL    INC_DE
        LD      A,D
        CP      #B8
        JP      NC,PRET
        DJNZ    PUT4
        JP      PRET
ROTATED3
        INC     DE
        INC     DE
        INC     DE
        INC     DE
        PUSH    IX
PUT5    PUSH    DE
        PUSH    BC
        LD      B,0
        CALL    PUTIT1
        CALL    PUTIT1
        CALL    PUTIT1
        POP     BC
        POP     DE
        CALL    INC_DE
        LD      A,D
        CP      #B8
        JP      NC,PRET11
        DJNZ    PUT5
PRET11  POP     IX
        JP      PRET

REST_   BIT     7,(IY+55)
        JR      Z,REST1_
        RES     7,(IY+55)
        RET
REST1_  LD      A,(WNDS)
        AND     A
        JR      NZ,REST2_
        LD      A,(DPF)
        AND     A
        RET     NZ
REST2_  PUSH    BC
        PUSH    DE
        PUSH    HL
        LD      HL,BUF1
        JR      CREST
REST    BIT     2,(IY+71)
        JR      Z,REST1
        RES     2,(IY+71)
        RET
REST1   PUSH    BC
        PUSH    DE
        PUSH    HL
        LD      HL,BUF
CREST   LD      A,(HL)
        INC     HL
        CALL    FILLD
        AND     A
        JR      Z,REST0
        CP      2
        JR      Z,REST2
        CP      4
        JR      Z,REST4
REST0   LD      B,42
R0LOOP  LD      C,5
        PUSH    DE
        LD      A,D
        CP      #A0
        JR      NC,R0OK
        LD      DE,0
R0OK    LDI
        LDI
        LDI
        LDI
        LDI
        POP     DE
        CALL    INC_DE
        LD      A,D
        CP      #B8
        JP      NC,RRET
        DJNZ    R0LOOP
RRET    POP     HL
        POP     DE
        POP     BC
        RET
REST2   LD      B,42
R2LOOP  LD      C,7
        PUSH    DE
        LD      A,D
        CP      #A0
        JR      NC,R1OK
        LD      DE,0
R1OK    LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        POP     DE
        CALL    INC_DE
        LD      A,D
        CP      #B8
        JP      NC,RRET
        DJNZ    R2LOOP
        JR      RRET
REST4   LD      B,50
R4LOOP  LD      C,5
        PUSH    DE
        LD      A,D
        CP      #A0
        JR      NC,R4OK
        LD      DE,0
R4OK    LDI
        LDI
        LDI
        POP     DE
        CALL    INC_DE
        DJNZ    R4LOOP
        JR      RRET
PUT1    PUSH    DE              ;----
        PUSH    BC
        CALL    PUTIT
        CALL    PUTIT
        CALL    PUTIT
        CALL    PUTIT
        CALL    PUTIT
        CALL    PUTIT
        CALL    PUTIT
        POP     BC
        POP     DE
        CALL    INC_DE
        LD      A,D
        CP      #B8
        RET     NC
        DJNZ    PUT1
        RET
SLONG   PUSH    DE              ;-----
        LD      HL,61200
        LD      DE,266
        INC     B
        DEC     B
        JR      Z,FIRST1
SEARCH1 ADD     HL,DE
        DJNZ    SEARCH1
FIRST1  LD      A,19
        CALL    SETPAGE
        LD      DE,ROOM
        LD      BC,266
        LDIR
        LD      B,38
        LD      HL,ROOM
        LD      A,16
        CALL    SETPAGE
        POP     DE
        LD      B,38
        RET
STINIT  LD      HL,STEELS       ;------
        PUSH    IX
        LD      IX,STL
STIA    CALL    FILLD
        CALL    FILLB
        LD      A,D
        CP      #FF
        JR      Z,STIR
        CALL    INSCR
        JR      C,STIA
        LD      (IX),C
        INC     IX
        LD      (IX),B
        INC     IX
        JR      STIA
STIR    LD      (IX),#FF
        LD      (IX+1),#FF
        CALL    STSAVE
        POP     IX
        RET
TCLEAR  PUSH    BC              ;---
        LD      A,(POS)
        LD      C,A
        LD      A,(POS1)
        LD      B,A
        CP      C
        JR      C,DOK
        LD      C,A
        LD      A,(POS)
        LD      B,A
DOK     PUSH    BC
        CALL    RETRIEV
        POP     BC
        BIT     7,A
        JR      NZ,TCF
        CP      " "
        JR      Z,TCF
        CP      ":"
        JR      Z,TCF
        CP      "!"
        JR      Z,TCF
        CP      "@"
        JR      Z,TCF
        CP      "#"
        JR      Z,TCF
        CP      "+"
        JR      Z,TCF
        INC     B
        LD      A,B
        CP      C
        JR      NZ,DOK
        POP     BC
        SCF
        CCF
        RET
TCF     POP     BC
        SCF
        RET

TSTWOUN PUSH    BC              ;-----------
        PUSH    DE
        PUSH    HL
        LD      A,CURLEV
        CP      12
        JR      NZ,NLTEST
        LD      A,(MFLAG)
        CP      #FF
        JR      NZ,NLTEST
        XOR     A
        LD      (MFLAG),A
        JR      WOUNOK
NLTEST  BIT     1,(IY+55)
        JR      Z,TWE
        LD      HL,(AMOVE)
        LD      A,(HL)
        CP      251
        JR      NZ,TWE
        CALL    DIFFR
        CP      7
        JR      C,WOUNOK
TWE     POP     HL
        POP     DE
        POP     BC
        RET
WOUNOK  LD      SP,(STACK)
        LD      HL,59135+6
        LD      A,10
        CALL    IMUSIC
        LD      A,(KIND)
        CP      4
        JR      NZ,GODEAD
        LD      A,(LIVES)
        CP      1
        JR      Z,GODEAD
        DEC     A
        LD      (LIVES),A
        CALL    PUTKLIV
        CALL    MAKEDE
        CALL    INCPOS
        LD      IX,WOUND
        LD      B,3
        CALL    LOOP
        LD      B,2
        CALL    MVE1
        CALL    INCPOS
        CALL    INCPOS
        LD      B,2
        CALL    LOOP
        RES     6,(IY+55)
        RES     5,(IY+55)
        JP      BATTLE
GODIE   LD      IX,DEAD+10
        LD      A,5
        LD      (KIND),A
        JR      GD
GODEAD  CALL    MAKEDE
        LD      IX,DEAD         ;---------
        LD      B,5
        LD      A,5
        LD      (KIND),A
        CALL    LOOP
GD      XOR     A
        LD      (LIVES),A
        LD      (HEI),A
        CALL    PUTKLIV
        LD      A,(LEV)
        CALL    DELMASK
        LD      C,4
        CALL    INCDE
        LD      B,2
        CALL    LOOP
        LD      HL,49152+6
        LD      A,100
        CALL    IMUSIC
WT      LD      B,131
        CALL    PUTMAN
        CALL    INJOY
        CP      #FF
        JR      Z,WT
        LD      SP,(STACK)
        JP      START
GODEAD1 XOR     A
        LD      (KIND),A
        LD      HL,49152+6
        LD      A,100
        CALL    IMUSIC
WT1     LD      B,130
        CALL    PUTMAN
        CALL    INJOY
        CP      #FF
        JR      Z,WT1
        LD      SP,(STACK)
        JP      START
DELMASK PUSH    DE
        LD      DE,(SCREEN)
        INC     A
        LD      B,A
        LD      C,7
DELM    PUSH    BC
        INC     C
        CALL    RETR
        CP      "."
        JR      Z,DM
        CP      "_"
        JR      NZ,NDM
DM      LD      HL,55296+448+448+224
        CALL    PUTMASK
NDM     POP     BC
        DEC     C
        JR      NZ,DELM
        POP     DE
        RET
IMUSIC  DI
        PUSH    DE
        LD      (MCOUNT),A
        LD      A,#CD
        LD      (AMUS),A
        LD      (AMUS+1),HL
        LD      A,(PAGE)
        PUSH    AF
        LD      A,20
        CALL    SETPAGE
        LD      DE,6
        OR      A
        SBC     HL,DE
        LD      (AINIT+1),HL
AINIT   CALL    49152
        POP     AF
        CALL    SETPAGE
        POP     DE
        EI
        RET
WOUND   DEFB    174,0,101,0,159,0,158,0,153,0
DEAD    DEFB    174,0,140,0,141,0,142,0,143,0,144,0,132,0
FIRINIT PUSH    DE
        LD      DE,4
        LD      HL,0
        LD      A,(WDTH)
        LD      B,A
MAKEA   ADD     HL,DE
        DJNZ    MAKEA
        EX      DE,HL
        LD      HL,FIRES
        LD      BC,(SCREEN)
        INC     B
        DEC     B
        JR      Z,NCH
CH      ADD     HL,DE
        DJNZ    CH
NCH     SLA     C
        SLA     C
        ADD     HL,BC
        CALL    FILLD
        LD      (AFIRE1),DE
        CALL    FILLD
        LD      (AFIRE2),DE
        CALL    PTORCH
        LD      DE,(AFIRE1)
        CALL    PTORCH
        POP     DE
        RET

INIT    LD      A,(BEGLIV1)
        LD      (ALLIV),A
        LD      (LIVES),A
        LD      A,16
        CALL    SETPAGE
        LD      HL,FALLING
        LD      DE,FALLING+1
        LD      (HL),#FF
        LD      BC,535
        LDIR
        LD      A,20
        CALL    SETPAGE
        CALL    49152
        XOR     A
        LD      (AMUS),A
        LD      HL,0
        LD      (AMUS+1),HL
        LD      A,23
        CALL    SETPAGE
        LD      HL,#C000
        LD      DE,LEVEL1
        LD      BC,LENGHT*HEIGHT+LENGHT+20
        RES     0,(IY+71)
ILP     LD      A,(HL)
        BIT     0,(IY+71)
        JR      Z,NR
        RES     0,(IY+71)
        SET     7,A
NR      CP      "#"
        JR      NZ,NORE
        SET     0,(IY+71)
NORE    LD      (DE),A
        INC     HL
        INC     DE
        DEC     BC
        LD      A,B
        OR      C
        JR      NZ,ILP
        LD      A,16
        CALL    SETPAGE
        LD      HL,EENEMY
        LD      DE,ENEMY
COPL    LD      A,(HL)
        CP      #FE
        JR      Z,COPE
        LDI
        JR      COPL
COPE    LDI
        LD      HL,LDRINKS
        LD      DE,DRINKS
        LD      BC,26
        LDIR
        LD      HL,LDRINKG
        LD      DE,DRINKG
        LD      BC,14
        LDIR
        RES     0,(IY+71)
        LD      A,STARTLEV
        LD      (LEV),A
        LD      A,STADIR
        LD      (DIR),A
        LD      A,STAPOS
        LD      (POS),A
        XOR     A
        LD      (CFLAG),A
        LD      (FFLAG),A
        LD      (MFLAG),A
        LD      (KIND),A
        LD      (EOPEN),A
        LD      (AENEMY),A
        LD      (AENEMY+1),A
        LD      (TOKEN),A
        LD      (MCOUNT),A
TOKOK   LD      A,#FF
        LD      (OPEN),A
        LD      BC,STARTPOS
        LD      (SCREEN),BC
        CALL    PUTROOM
        CALL    PLACE
        SET     2,(IY+71)
        LD      A,#FF
        LD      HL,OPEN
        LD      B,40
FFAL    LD      (HL),A
        INC     HL
        DJNZ    FFAL
        RET
DOALL   CALL    PUTEDOR         ;--------
        BIT     0,(IY+55)
        CALL    NZ,REST_
        CALL    TSLIM
        CALL    DOFALL
        CALL    PUTFIRE
        CALL    MENEMY
        CALL    DOOPEN
        PUSH    BC
        CALL    STAR2
        PUSH    IX
        PUSH    DE
        LD      A,#FF
        LD      (STPOS),A
        CALL    STREST
        CALL    STPUT
        POP     DE
        POP     IX
        POP     BC
        RET
TSLIM   LD      A,(SCREEN+1)
        AND     A
        RET     NZ
        LD      A,(SCREEN)
        AND     A
        JP      Z,BUILD
        LD      A,(FFLAG)
        CP      #FF
        RET     NZ
        BIT     0,(IY+55)
        RET     Z
        CALL    DIFFR
        CP      2
        RET     NC
        PUSH    HL
        RES     0,(IY+55)
        LD      A,#FE
        LD      (ENEMY+4),A
        LD      A,10
        LD      (FFLAG),A
        LD      A,14
        LD      (MFLAG),A
        LD      HL,52274+6
        LD      A,50
        CALL    IMUSIC
        CALL    FLSH
        POP     HL
        RET
FLSH    LD      B,20
COLOR   LD      A,0
        CPL
        AND     7
        LD      (COLOR+1),A
        OUT     (#FE),A
        LD      HL,#5800
FLLOP   LD      A,(HL)
        CPL
        AND     #3F
        LD      (HL),A
        INC     HL
        LD      A,H
        CP      #5B
        JR      NZ,FLLOP
        HALT
        HALT
        HALT
        DJNZ    COLOR
        RET
BUILD   LD      A,(FFLAG)
        CP      10
        RET     NZ
        PUSH    BC
        PUSH    DE
        LD      DE,0
        LD      B,1
        LD      A,(MFLAG)
        DEC     A
        CP      #FF
        JR      Z,ENDBUILD
        LD      C,A
        SRL     C
        LD      (MFLAG),A
        LD      A,"_"
        CALL    PUTMAP2
        PUSH    HL
        LD      HL,FL
        LD      (ITEM),HL
        CALL    PUTITEM1
        POP     HL
        POP     DE
        POP     BC
        RET
ENDBUILD LD     A,11
        LD      (FFLAG),A
        POP     DE
        POP     BC
        RET
STAR2   LD      A,(SCREEN)      ;JJ
        CP      1
        RET     NZ
        LD      A,(SCREEN+1)
        AND     A
        RET     NZ
        LD      A,(LEV)
        CP      2
        RET     NZ
        JP      STAR1
TEXIT   LD      HL,AGATE        ;---------
        CALL    FILLD
        CALL    INSCR
        RET     C
        LD      A,(EOPEN)
        CP      36
        RET     C
        INC     HL
        INC     HL
        INC     HL
        INC     HL
        CALL    FILLB
        LD      A,(HL)
        LD      D,A
        LD      A,(LEV)
        CP      D
        JR      NZ,TEXF
        LD      A,(POS)
        CP      B
        RET     C
        CP      C
        JR      NC,TEXF
        SCF
        CCF
        RET
TEXF    SCF
        RET
PUTIN   LD      HL,AGATEIN
        CALL    FILLD
        CALL    INSCR
        RET     C
        LD      A,19
        CALL    SETPAGE
        CALL    FILLD
        CALL    PUTAEX
        LD      HL,64200
        LD      B,66
PEXLOPX PUSH    BC
        PUSH    DE
        LD      BC,8
        LDIR
        POP     DE
        CALL    INC_DE
        POP     BC
        DJNZ    PEXLOPX
        RET
PUTEXIT LD      HL,AGATE        ;--------
        CALL    FILLD
        CALL    INSCR
        RET     C
        LD      A,19
        CALL    SETPAGE
        CALL    FILLD
        CALL    PUTAEX
        LD      HL,64200
        LD      B,66
PEXLOP  PUSH    BC
        PUSH    DE
        LD      BC,8
        LDIR
        POP     DE
        CALL    INC_DE
        POP     BC
        DJNZ    PEXLOP
        LD      A,(EOPEN)
        CP      46
        RET     NZ
        DEC     A
        LD      (EOPEN),A
        JR      PUTEDOR
EDR     LD      A,16
        CALL    SETPAGE
        POP     BC
        POP     HL
        POP     DE
        RET
PUTEDOR PUSH    DE              ;--------
        PUSH    HL
        PUSH    BC
        LD      A,(EOPEN)
        AND     A
        JR      Z,EDR
        INC     A
        CP      47
        JR      Z,EDR
        LD      (EOPEN),A
        LD      HL,AGATE
        CALL    FILLD
        CALL    INSCR
        JR      C,EDR
        LD      A,19
        CALL    SETPAGE
        INC     HL
        INC     HL
        CALL    FILLD
        LD      HL,64200+528
        LD      A,(EOPEN)
        DEC     A
        LD      B,A
        LD      C,A
        PUSH    DE
        LD      DE,5
EXADD   ADD     HL,DE
        DJNZ    EXADD
        LD      A,55
        SUB     C
        LD      B,A
        POP     DE
        DEC     B
        JR      Z,NOPX
PEXLOP1 PUSH    BC
        PUSH    DE
        LD      BC,5
        LDIR
        POP     DE
        CALL    INC_DE
        POP     BC
        DJNZ    PEXLOP1
NOPX    LD      HL,64200+528+285
        LD      A,(EOPEN)
        DEC     A
        LD      B,A
        LD      A,47
        SUB     B
        LD      B,A
        PUSH    DE
        LD      DE,5
EXADD1  ADD     HL,DE
        DJNZ    EXADD1
        POP     DE
        LD      A,(EOPEN)
        DEC     A
        LD      B,A
PEXLOP2 PUSH    BC
        PUSH    DE
        LD      BC,5
        LDIR
        POP     DE
        CALL    INC_DE
        POP     BC
        DJNZ    PEXLOP2
        JP      EDR
DOOPEN  LD      HL,OPEN         ;---------
NEXGATE LD      A,(HL)
        CP      #FF
        RET     Z
        PUSH    DE
        PUSH    BC
        CALL    FILLD
        CALL    FILLB
        LD      A,(HL)
        CP      100
        JR      NZ,NSTND
        BIT     7,B
        JR      NZ,NOCLOSE
NSTND   INC     A
NOCLOSE RES     7,B
        LD      (HL),A
        CP      255
        CALL    Z,KILL
        CP      205
        JR      NZ,NMO1
        INC     C
        CALL    RETR
        SET     7,A
        CALL    PUTMAP2
        DEC     C
        LD      A,"#"
        CALL    PUTMAP2
        PUSH    BC
        PUSH    DE
        PUSH    AF
        CALL    COUNT
        CALL    RETR
        CP      "#"
        JR      NZ,NVAR
        LD      A,#FD
        LD      (VAR),A
        JR      AVAR
NVAR    BIT     7,A
        JR      Z,AVAR
        LD      A,#FF
        LD      (VAP),A
AVAR    POP     AF
        POP     DE
        POP     BC
NMO1    CP      25
        JR      NZ,NMO
        INC     C
        CALL    RETR
        RES     7,A
        CALL    PUTMAP2
        DEC     C
        LD      A,"'"
        CALL    PUTMAP2
NMO     CP      46
        JR      C,COPEN
        CP      165
        JR      C,NEXG
COPEN   CALL    INSCR
        JR      C,NEXG
        LD      A,(HL)
        CP      165
        JR      C,COPEN1
        BIT     0,A
        JR      NZ,NEXG
        NEG
        RRCA
COPEN1  LD      D,A
        CALL    PUTGATE
NEXG    POP     BC
        POP     DE
        INC     HL
        JP      NEXGATE
KILL    PUSH    AF
        LD      D,H
        LD      E,L
        INC     HL
        DEC     DE
        DEC     DE
        DEC     DE
        DEC     DE
NEXKILL LD      A,(HL)
        CP      #FF
        JR      Z,ENDKILL
        LD      BC,5
        LDIR
        JR      NEXKILL
ENDKILL LD      BC,5
        LDIR
        POP     AF
        RET
PLACE   PUSH    HL              ;----------
        PUSH    DE
        PUSH    BC
        XOR     A
        LD      (DPF),A
        CALL    FIRINIT
        CALL    STINIT
        CALL    PUTKLIV
        CALL    PUTSW1
        LD      HL,DRINK
        LD      (ADRINK),HL
        CALL    PUTDRINK
        LD      HL,DRNK
        LD      (ADRINK),HL
        CALL    PUTDRINKG
        LD      HL,GATES
PLLOP   LD      A,(HL)
        CP      #FF
        JP      NZ,PLLOP1
FLIP3   NOP
        NOP
        NOP
NEXIT   LD      A,CURLEV
        CP      12
        JR      NZ,NEXIT1
        LD      A,(SCREEN)
        CP      #FF
        JR      NZ,NEXIT1
        LD      SP,(STACK)
        JP      REXIT
NEXIT1  CALL    PUTIN
        CALL    PUTEXIT
NCARE1  POP     BC
        POP     DE
        POP     HL
        RET
PUTSW1  LD      A,(SCREEN)
        CP      1
        RET     NZ
        LD      A,(SCREEN+1)
        AND     A
        RET     NZ
        LD      A,(LEV)
        CP      2
        RET     NZ
        PUSH    DE
        PUSH    HL
        LD      HL,SWORD
        LD      DE,#A6E6
        JP      PUTSW
PLLOP1  CALL    FILLD           ;-----
        CALL    FILLB
        CALL    INSCR
        JP      C,PLLOP
        CALL    RETR
        LD      D,0
        CP      "#"
        JR      Z,PPLACE
        LD      D,45
PPLACE  CALL    PUTGATE
        JP      PLLOP
TSTBLK  PUSH    DE              ;-----------
        LD      HL,FLAG
        BIT     3,(HL)
        JR      NZ,TBEXIT
        LD      A,(DIR)
        AND     A
        JR      NZ,TSTBLK1
        LD      A,(VAR)
        AND     A
        JR      NZ,TBEXIT
        LD      DE,(SCREEN)
        CALL    COUNT
        CALL    RETR
        CP      "#"
        JR      Z,TBCONT2
        LD      C,0
        BIT     7,A
        JR      Z,NO4
        LD      C,#FF
NO4     LD      A,C
        LD      (VAP),A
        JR      TBEXIT
TBCONT2 CALL    COUNT
        CALL    RETR
        CP      "#"
        JR      NZ,TBBLK
        CALL    INCPOS
        JR      TBCONT2
TSTBLK1 LD      DE,(SCREEN)
        LD      A,(VAP)
        AND     A
        JR      NZ,TBEXIT
        CALL    COUNT
        CALL    RETR
        BIT     7,A
        JR      NZ,TBCONT
        LD      C,0
        CP      "#"
        JR      NZ,NO3
        LD      C,#FF
NO3     LD      A,C
        LD      (VAR),A
TBEXIT  LD      DE,(SCREEN)
        CALL    COUNT
        CALL    RETR
        CP      "#"
        JR      Z,NCLV
        BIT     7,A
        JR      NZ,NCLV
        XOR     A
        LD      (VAR),A
        LD      (VAP),A
NCLV    POP     DE
        RET
TBCONT  CALL    COUNT
        CALL    RETR
        BIT     7,A
        JR      NZ,TBCONT1
TBBLK   CALL    COUNT
        CALL    RETR
        RES     7,A
        CP      " "
        JR      NZ,NAD
        LD      A,(POS)
        LD      B,A
        CALL    INCB
        CALL    INCB
        LD      A,B
        LD      (POS),A
        CALL    MAKEDE
        LD      SP,(STACK)
        JP      GOFALL
NAD     CALL    MAKEDE
        LD      SP,(STACK)
        JP      GOBLOCK
TBCONT1 CALL    INCPOS
        JR      TBCONT
VAR     DEFB    0
VAP     DEFB    0
PUTEN   PUSH    DE              ;--------
        PUSH    BC
        PUSH    BC
        CALL    TBUTTON
        POP     BC
        LD      A,(POS1)
        LD      (PS),A
        CALL    SAVE0_
        CALL    SSPR
        LD      B,42
        LD      A,(DIR1)
        AND     A
        JR      Z,ROTATED_
        CALL    PUT
PERET   POP     BC
        POP     DE
        RET
ROTATED_
        CALL    ROTAT
        JR      PERET
CURSPR  DEFB    0
CURDE   DEFW    0
PUTMAN  PUSH    DE              ;---------
        PUSH    BC
        LD      A,B
        LD      (CURSPR),A
        LD      (CURDE),DE
        CALL    REST
        CALL    DOALL
        CALL    SAVE0
        LD      A,(POS)
        LD      (PS),A
        CALL    SSPR
        LD      B,42
        LD      A,(DIR)
        AND     A
        JR      NZ,ROTATED
        CALL    PUT
        JP      PRET
ROTATED CALL    ROTAT
        JP      PRET
MAKEFALL                        ;---------
        CALL    COUNT
        PUSH    BC
        PUSH    DE
        PUSH    HL
        LD      HL,FALLING
FSEAR   LD      A,(HL)
        CP      #FF
        JR      Z,FFOUND
        CP      C
        JR      Z,RMF
        INC     HL
        INC     HL
        INC     HL
        INC     HL
        INC     HL
        INC     HL
        INC     HL
        JR      FSEAR
FFOUND  LD      (HL),C
        INC     HL
        LD      (HL),B
        INC     HL
        LD      A,(FBYTE)
        LD      (HL),A
        INC     HL
        PUSH    DE
        LD      DE,(SCREEN)
        LD      (HL),E
        INC     HL
        LD      (HL),D
        INC     HL
        LD      A,"U"
        CALL    PUTMAP2
        LD      DE,0
        LD      A,(FBYTE)
        AND     A
        CALL    Z,FFREE
        LD      (HL),E
        INC     HL
        LD      (HL),D
        POP     DE
RMF     POP     HL
        POP     DE
        POP     BC
        RET
FBYTE   DEFB    0
TSTFAL  LD      DE,(SCREEN)     ;-----
        LD      C,8
SFLP    CALL    RETR
        CP      ":"
        JR      NZ,NKA
        LD      A,30
        LD      (FBYTE),A
        CALL    MAKEFALL+3
        XOR     A
        LD      (FBYTE),A
NKA     DEC     C
        JR      NZ,SFLP
        RET                     ;--------
TTOP    LD      A,CURLEV
        CP      4
        JR      NZ,TTOP1
        LD      A,(SCREEN)
        CP      #0A
        JR      NZ,TTOP1
        LD      A,(SCREEN+1)
        AND     A
        JR      NZ,TTOP1
        LD      A,(EOPEN)
        CP      46
        JR      Z,TFAL1
TTOP1   LD      A,(LEV)         ;--------
        DEC     A
        CP      #FF
        JR      NZ,NWOR
        LD      A,(SCREEN+1)
        AND     A
        JR      Z,TFAL1
        LD      A,#FF
NWOR    LD      (LEV),A
        LD      HL,FLAG
        RES     1,(HL)
        LD      A,(POS)
        LD      B,A
        CALL    DECB
        CALL    DECB
        CALL    DECB
        LD      C,6
TLP     CALL    RETRIEV
        RES     7,A
        CP      " "
        JR      Z,TEST1
        PUSH    AF
        CALL    INCB
        POP     AF
        DEC     C
        JR      Z,TFAL
        CP      "@"
        JR      Z,TLP
        CP      "$"
        JR      Z,TLP
        LD      HL,FLAG
        SET     1,(HL)
        INC     C
        DEC     C
        JR      NZ,TLP
TFAL    LD      A,(LEV)
        INC     A
        LD      (LEV),A
TFAL1   SCF
        CCF
        RET
TEST1   LD      HL,FLAG
        BIT     1,(HL)
        JR      Z,TFAL
        LD      A,(LEV)
        INC     A
        LD      (LEV),A
        LD      A,(POS)
        LD      B,A
        LD      A,C
        CP      5
        JR      NZ,N4
        CALL    DECB
        JR      TOKE
N4      CP      4
        JR      Z,TOKE
        PUSH    AF
        CALL    INCB
        POP     AF
        CP      3
        JR      Z,TOKE
        PUSH    AF
        CALL    INCB
        POP     AF
        CP      2
        JR      Z,TOKE
        CALL    INCB
TOKE    LD      A,B
        LD      (POS),A
        CALL    ADJUST
        SCF
        RET
TSTSCR  PUSH    BC              ;--------
        LD      A,(POS)
        CP      200
        JR      NC,OUTOF
        CP      32
        JR      NC,OUTOF1
        POP     BC
        RET
OUTOF   ADD     A,32
        LD      (POS),A
        PUSH    DE
        LD      A,(SCREEN)
        DEC     A
        LD      (SCREEN),A
        CALL    CLS
        LD      BC,(SCREEN)
        CALL    PUTROOM
        CALL    TENEMY
        CALL    PLACE
        POP     DE
        CALL    SAVE0
        EX      DE,HL
        LD      DE,32
        ADD     HL,DE
        EX      DE,HL
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
        CALL    TENEMY
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
SCRUD   LD      A,(LEV)         ;--------
        CP      3
        JR      Z,SCRDOWN
        CP      #FF
        JR      Z,SCRUP
        RET
SCRUP   LD      A,2
        LD      (LEV),A
        PUSH    DE
        CALL    CLS
        LD      A,(SCREEN+1)
        DEC     A
        LD      (SCREEN+1),A
        LD      BC,(SCREEN)
        CALL    PUTROOM
        CALL    TENEMY
        CALL    PLACE
        POP     DE
        CALL    SAVE0
        RET
SCRDOWN XOR     A
        LD      (LEV),A
        PUSH    DE
        CALL    CLS
        LD      A,(SCREEN+1)
        INC     A
        LD      (SCREEN+1),A
        LD      BC,(SCREEN)
        CALL    PUTROOM
        CALL    TENEMY
        CALL    PLACE
        POP     DE
        CALL    SAVE0
        RET
TDOWN   LD      A,(POS)         ;--------
        LD      B,A
        CALL    INCB
        CALL    RETRIEV
        BIT     7,A
        SCF
        CCF
        RET     NZ
        CP      " "
        SCF
        RET     Z
        CCF
        RET
ADJ     LD      A,(POS)         ;--------
        LD      B,A
        CALL    DECB
        CALL    RETRIEV
        RES     7,A
        CP      " "
        RET     Z
        CP      "!"
        RET     Z
        LD      A,B
        LD      (POS),A
        LD      B,1
        CALL    MVE
        RET
TSTZ    LD      A,(LEV)         ;--------
        DEC     A
        LD      (LEV),A
        CALL    INJOY
        BIT     0,A
        JR      NZ,ETST
        LD      A,(POS)
        LD      B,A
        LD      C,3
TZLOOP  CALL    DECB
        CALL    RETRIEV
        RES     7,A
        CP      "@"
        JR      Z,ETST
        CP      "$"
        JR      Z,ETST
        CP      " "
        JR      NZ,TZOK
        DEC     C
        JR      NZ,TZLOOP
        JR      ETST
TZOK    CALL    INCB
        LD      A,B
        LD      (POS),A
        CALL    MAKEDE
        LD      C,42
        CALL    INCDE
        LD      B,1
        CALL    MVE1
        LD      HL,FLAG
        SET     2,(HL)
        SET     3,(HL)
        LD      B,5
        CALL    PUTHIGH
        LD      A,(LEV)
        INC     A
        LD      (LEV),A
        SCF
        RET
ETST    LD      A,(LEV)         ;---------
        INC     A
        LD      (LEV),A
        SCF
        CCF
        RET
DOFALL  LD      HL,FALLING      ;---------
NEXF    LD      A,(HL)
        CP      #FF
        JR      NZ,DFAL
        IM      2
        RET
DFAL    PUSH    BC
        PUSH    DE
        PUSH    IX
        CALL    FILLB
        LD      A,(HL)
        INC     A
        CP      29
        JR      NZ,NUMOK
        LD      A,28
NUMOK   LD      (HL),A
        LD      (SAV),A
        INC     HL
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        CP      30
        JR      NC,FCON
        CP      16
        JR      Z,RFALL
        JP      NC,SFALL
FCON    INC     HL
        INC     HL
        INC     HL
        CALL    INSCR
        JR      C,NEXF2
        PUSH    HL
        LD      A,(SAV)
        LD      HL,FL
        CP      38
        JR      Z,THIS
        LD      HL,FL3
        BIT     1,A
        JR      Z,THIS
        LD      HL,FL4
THIS    LD      (ITEM),HL
        CALL    PUTITM
        POP     HL
NEXF2   LD      A,(SAV)
        CP      38
        JP      Z,ENDFAL1
NEXF1   POP     IX
        POP     DE
        POP     BC
        JR      NEXF
RFALL   LD      A," "
        IM      1
        INC     HL
        INC     HL
        INC     HL
        CALL    PUTMAP2
        CALL    INSCR
        JR      C,NEXF1
        PUSH    HL
        LD      A,16
        CALL    SETPAGE
        LD      HL,#5B00
        CALL    PUTMASK
        LD      HL,FL4
        LD      (ITEM),HL
        SET     0,(IY+118)
        CALL    PUTITM
        RES     0,(IY+118)
        DEC     C
        INC     B
        CALL    RETR
        CP      "@"
        JR      NZ,NRW
PW_     LD      HL,WALL
        LD      (ITEM),HL
        CALL    PUTITEM
        JR      NRW1
NRW     CP      "I"
        JR      NZ,NRW1
        LD      HL,STOLB
        LD      (ITEM),HL
        CALL    PUTITEM
        DEC     B
        LD      A,B
        CP      #FF
        JR      Z,NRW1
        CALL    RETR
        CP      "I"
        JR      Z,NRW
        CP      "@"
        JR      Z,PW_
        CP      "_"
        JR      NZ,NRW1
        LD      HL,FL
        LD      (ITEM),HL
        CALL    PUTITEM1
NRW1    POP     HL
        SCF
        CCF
        LD      BC,7
        SBC     HL,BC
        JR      NEXF1
SFALL   DEC     HL
        DEC     HL
        DEC     HL
        LD      A,B
        CP      3
        JR      NZ,NADJU
        LD      B,0
        CALL    INSCR
        JR      C,RREST
        SET     5,(IY)
RREST   INC     D
NADJU   LD      (HL),B
        INC     HL
        INC     HL
        INC     HL
        LD      (HL),D
        PUSH    DE
        INC     HL
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        LD      (ABUFA),DE
        POP     DE
        BIT     3,(IY)
        JR      NZ,NTHR
        LD      A,(SAV)
        CP      28
        JR      Z,THR
        CP      27
        JR      Z,THR
        CP      24
        JR      NZ,NTHR
THR     INC     B
        CALL    RETR
        CP      "$"
        JR      Z,NEFALL
        CP      " "
        JP      NZ,ENDFALL
NEFALL  DEC     HL
        DEC     HL
        SET     3,(IY)
        JR      SFALL
NTHR    INC     HL
        RES     3,(IY)
        BIT     5,(IY)
        JR      Z,NRF
        PUSH    HL
        LD      B,31
        LD      A,23
        CALL    SETPAGE
        CALL    PUTT2
        LD      A,16
        CALL    SETPAGE
        RES     5,(IY)
        POP     HL
        JP      NEXF1
NRF     CALL    INSCR
        JP      C,NEXF1
        PUSH    HL
        LD      HL,TABL
        PUSH    BC
        LD      A,(SAV)
        SUB     17
        LD      B,0
        LD      C,A
        ADD     HL,BC
        LD      A,(HL)
        LD      (HOWM+1),A
        POP     BC
        PUSH    DE
        PUSH    BC
        LD      HL,FL4
        LD      DE,48260
        LD      BC,420
        LDIR
        POP     BC
        POP     DE
        LD      A,23
        CALL    SETPAGE
        LD      HL,48260
        LD      (ITEM),HL
        PUSH    BC
        LD      B,31
        CALL    PUTT2
        POP     BC
        PUSH    BC
        LD      HL,PUTT1
        LD      (PT+1),HL
        LD      HL,VAR2
        LD      DE,ZEROS
        LD      BC,7
        LDIR
        POP     BC
        CALL    PUTITM
        LD      HL,VAR1
        LD      DE,ZEROS
        LD      BC,7
        LDIR
        LD      HL,PUTT
        LD      (PT+1),HL
        POP     HL
        LD      A,16
        CALL    SETPAGE
        JP      NEXF1
ENDFALL CP      "a"
        JR      C,NOPENF
        PUSH    BC
        PUSH    DE
        PUSH    HL
        SUB     "a"
        LD      C,A
        LD      B,0
        SLA     C
        SLA     C
        LD      HL,(AGATES)
        ADD     HL,BC
        CALL    FILLD
        CALL    FILLB
        SET     7,B
        CALL    MAKEOPEN
        POP     HL
        POP     DE
        POP     BC
NOPENF  LD      A,"."
        CALL    PUTMAP2
        CALL    INSCR
        JR      C,NPO
        PUSH    HL
        PUSH    BC
        LD      HL,FL1
        LD      (ITEM),HL
        LD      B,31
        LD      A,23
        CALL    SETPAGE
        CALL    PUTT2
        LD      A,16
        CALL    SETPAGE
        POP     BC
        CALL    PUTITM
        POP     HL
NPO     DEC     HL
        DEC     HL
        LD      D,H
        LD      E,L
        INC     HL
        LD      C,(HL)
        INC     HL
        LD      B,(HL)
        LD      A,23
        CALL    SETPAGE
        XOR     A
        INC     BC
        LD      (BC),A
        LD      A,16
        CALL    SETPAGE
        INC     HL
        DEC     DE
        DEC     DE
        DEC     DE
        DEC     DE
        PUSH    DE
CHECK1  LD      A,(HL)
        CP      #FF
        JR      Z,ENDP
        LD      BC,7
        LDIR
        JR      CHECK1
ENDP    LD      BC,7
        LDIR
        POP     HL
        JP      NEXF1
ENDFAL1 LD      A,":"
        CALL    PUTMAP2
        DEC     HL
        JR      NPO
FFREE   PUSH    BC
        PUSH    HL
        LD      HL,BUFA+1
        LD      BC,7*32+2
        LD      A,23
        CALL    SETPAGE
FSEA    LD      A,(HL)
        AND     A
        JR      Z,FFOUN
        ADD     HL,BC
        JR      FSEA
FFOUN   LD      (HL),#FF
        DEC     HL
        EX      DE,HL
        LD      A,16
        CALL    SETPAGE
        POP     HL
        POP     BC
        RET
VAR1    LD      BC,406
        ADD     HL,BC
        LD      B,2
        NOP
VAR2    LD      B,31
        LD      C,28
        CALL    DECDE
TABL    DEFB    1,4,9,14,22,33,43,01,20,40,1,1,1,1
FREST   DEFB    0
LOOP    PUSH    BC              ;+-------
        CALL    LP
        POP     BC
        DJNZ    LOOP
        RET

LP      LD      B,(IX)          ;--------
        INC     IX
        DEC     B
        CALL    PUTMAN
        CALL    MOVE
        RET
FLIPATR PUSH    DE
        LD      DE,#5800
        LD      HL,#5B00-32
        LD      B,12
FLLOOP  PUSH    BC
        PUSH    HL
        LD      B,32
FLLOOP1 LD      C,(HL)
        LD      A,(DE)
        LD      (HL),A
        LD      A,C
        LD      (DE),A
        INC     HL
        INC     DE
        DJNZ    FLLOOP1
        POP     HL
        SCF
        CCF
        LD      BC,32
        SBC     HL,BC
        POP     BC
        DJNZ    FLLOOP
        POP     DE
        RET
ENTST   PUSH    BC
        CALL    COUNT_
        PUSH    DE
        LD      DE,(SCREEN)
        CALL    RETR
        RES     7,A
        CP      "!"
        JR      NZ,NSH
        POP     DE
        POP     BC
        XOR     A
        LD      (WNDS),A
        LD      B,172
        RET
NSH     CP      " "
        JP      Z,EFALL
        CP      ":"
        CALL    Z,MAKEFALL+3
        POP     DE
        POP     BC
        RET
CLS1    LD      HL,#5800
        LD      DE,#5801
        LD      (HL),L
        LD      BC,767
        LDIR
        RET
TAKES   DEFB    52,0,53,0,54,0,54,0,133,0
        DEFB    134,0,135,0,136,0,137,0,138,0
        DEFB    139,0,139,0,139,0,20,1,21,0,22,0,23,0,1,0
DRIN    DEFB    52,0,53,0,54,0,119,0,120,0,121,0,122,0,123,0,124,0
        DEFB    125,0,126,0,127,0,128,0,129,0,130,0,130,0,130,0
        DEFB    130,0,130,0,130,0,130,0,130,0,129,0,126,0,1,0
DOWN1   DEFB    117,0,114,0,113,0,112,0,111,0,110,0,109,0,107,0
        DEFB    105,0
TOP     DEFB    105,0,106,0,107,1,108,0,109,0,110,1,111,0,112,0
        DEFB    113,5,114,0,115,0,116,0,117,0,118,0,63,0,76,0,1,0
BLOCK   DEFB    21,0,22,0
FALLC   DEFB    100,0,101,0,102,0,103,0,104,0,104,0,104,0
JUMP2   DEFB    91,1,92,2,93,0,94,1,95,2,96,5
        DEFB    97,1,98,2,99,1,8,1
JUMP1   DEFB    77,0,78,0,79,0,80,0,81,0,82,0,83,0,84,0,85,0
        DEFB    86,0,87,0,88,0,89,0,90,1,1,0
CARE    DEFB    64,0,65,0,66,1,67,0,68,0,69,0,70,0,71,0,72,0,73,0
        DEFB    74,0,75,2,1,0
CARE2   DEFB    64,0,65,0,66,0,67,0,73,0,74,0,75,2,1,0
CARE3   DEFB    64,0,65,0,66,0,73,0,74,0,75,1,1,0
CARE4   DEFB    64,0,65,0,66,1,67,0,68,0,69,0,47,0,61,0,62,0,63,0,1,0
RUN     DEFB    1,0,2,0,3,0,4,0,5,0,6,2,7,0,8,1,9,1,10,0,11,2,12,1,13,1,14,1,15,1,8,1
STOP    DEFB    16,0,17,2,18,1,19,0,20,1,21,0,22,0,23,0,1,0
ROT     DEFB    23,0,24,0,25,0,26,1
BACK    DEFB    16,0,17,2,18,1,19,2,27,0,28,0,29,0,30,0,31,0,32,0
        DEFB    33,0,34,0,35,0,14,1,15,1,8,1
JUMP    DEFB    36,0,37,0,38,0,39,0,40,0,41,1,42,1,43,1
        DEFB    45,0,46,0,47,0,48,0,49,0,50,0,51,2,1,0
DOWN    DEFB    52,0,53,0,54,0
TFIGHT  DEFB    104,0,53,0,54,0
UP      DEFB    55,0,56,1,57,0,58,0,59,0,60,0,61,0,62,0,63,0,76,0,1,0
READY   DEFB    145,0,146,0,147,1,148,2,0

TRISE   DEFB    177,0,178,0,179,0,180,0,0
TDEAD   DEFB    177,0,178,0,179,0,180,0,181,0,182,0,0
TBLK    DEFB    161,0,175,0,176,0-1,170,0,0
TMAN    DEFB    162,0,163,1,164,1,0
TKICK   DEFB    165,0,166,0,167,0,250,0,251,0,168,0,169,0,170,0,0
TWOUN   DEFB    171,0,172,0,173,0-2,169,0,170,0,0
TBLKED  DEFB    252,0,168,0,169,0,170,0,0
TRUN    DEFB    97,1,98,2,99,1,8,1
        DEFB    9,1,10,0,11,2,12,1,13,1,14,1,15,1,8,1
        DEFB    9,1,10,0,11,2,12,1,13,1,14,1,15,1,0
TDRNK   DEFB    1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0
        DEFB    1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0
        DEFB    1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0
        DEFB    8,0,8,1,9,1,10,0,11,2,12,1,13,1,14,1,15,1,8,1
        DEFB    16,0,17,2,18,1,19,0,20,1,21,0,22,0,23,0,1,0
        DEFB    52,0,53,0,54,0,119,0,120,0,121,0,122,0,123,0,124,0
        DEFB    125,0,126,0,127,0,128,0,129,0,130,0,130,0,130,0
        DEFB    130,0,130,0,130,0,130,0,130,0,129,0,126,0,1,0
        DEFB    23,0,24,0,25,0,26,0
        DEFB    7,0,8,1,9,1,10,0,11,2,12,1,13,1,14,1,15,1,8,1
        DEFB    9,1,10,0,11,2,12,1,13,1,0
TFRIEND DEFB    135,0,136,0,137,0,138,0
        DEFB    139,255,20,1,21,0,22,0,23,0,1,0,0
TCARE   DEFB    64,0,65,0,66,1,67,0,68,0,69,0,70,0,71,0,72,0,73,0
        DEFB    74,0,75,2,1,0,0
