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

PUTMAN  PUSH    DE              ;---------
        PUSH    BC
        LD      A,B
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
MFLAG   DEFB    0
AMOVE   DEFW    0
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
        LD      HL,60050+15
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
        LD      (TOKEN),A
        LD      (MCOUNT),A
        LD      A,#FF
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
DOALL                           ;--------
        CALL    PUTFIRE
        CALL    DOOPEN
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
        CALL    FIRINIT
        CALL    PUTKLIV
        LD      HL,GATES
PLLOP   LD      A,(HL)
        CP      #FF
        JP      NZ,PLLOP1
FLIP3   NOP
        NOP
        NOP
NEXIT
NEXIT1  CALL    PUTIN
        POP     BC
        POP     DE
        POP     HL
        RET
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
NAD     CALL    MAKEDE
        LD      SP,(STACK)
        JP      GOBLOCK
TBCONT1 CALL    INCPOS
        JR      TBCONT
VAR     DEFB    0
VAP     DEFB    0
FBYTE   DEFB    0
TSTFAL  LD      DE,(SCREEN)     ;-----
        LD      C,8
SFLP    CALL    RETR
        CP      ":"
        JR      NZ,NKA
        LD      A,30
        LD      (FBYTE),A
        XOR     A
        LD      (FBYTE),A
NKA     DEC     C
        JR      NZ,SFLP
        RET                     ;--------
TTOP
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
VAR1    LD      BC,406
        ADD     HL,BC
        LD      B,2
        NOP
VAR2    LD      B,31
        LD      C,28
        CALL    DECDE
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
CLS1    LD      HL,#5800
        LD      DE,#5801
        LD      (HL),L
        LD      BC,767
        LDIR
        RET
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
UP      DEFB    55,0,56,1,57,0,58,0,59,0,60,0,61,0,62,0,63,0,76,0,1,0
