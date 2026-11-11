        ORG     #A000+6144
BUF     DEFS    300
BUF1    DEFS    300
ROOM    DEFS    300
ROTT    DEFS    256

        ORG     29300

        DI
        LD      HL,STAX
        LD      BC,11600
        LD      A,#BC
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
STAX    LD      A,22
        CALL    SETPAGE
        LD      HL,#C000
        LD      DE,#0100
        LD      BC,#4005
        CALL    #3D13
        LD      A,17
        CALL    SETPAGE
        LD      DE,#0505
        LD      HL,#C000
        LD      BC,#4005
        CALL    #3D13
        LD      A,3
        LD      (ALLIV),A
        LD      (LIVES),A
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
        LD      A,(LIVES)
        LD      (BEGLIV),A
        LD      A,(ALLIV)
        LD      (BEGLIV1),A
        LD      HL,GATES
        LD      (AGATES),HL
START   LD      HL,33000-256
        LD      (23606),HL
        LD      HL,#5B00
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
        XOR     A
        LD      (23673),A
        LD      (23672),A
        CALL    PLACE
        LD      HL,MES1
        LD      DE,#A903
        CALL    MESS
        LD      HL,MES2
        LD      DE,#AA03
        CALL    MESS
        LD      HL,MES3
        LD      DE,#A913
        CALL    MESS
        LD      HL,MES4
        LD      DE,#AA13
        CALL    MESS
        CALL    MAKEDE
        XOR     A
        LD      (FLAG),A
WAIT    LD      B,0
        CALL    PUTMAN
        LD      A,(SCREEN)
        AND     A
        JP      Z,INPASS
        XOR     A
        LD      (KIND),A
        CALL    INJOY
        CP      #FF
        JR      Z,WAIT
        LD      HL,FLAG
        RES     2,(HL)
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

INPASS  LD      HL,#C000-256
        LD      (23606),HL
        LD      HL,33000
        LD      DE,#C000
        LD      BC,768
        LDIR
        CALL    BOLD
        LD      A,2
        CALL    #1601
        LD      DE,PASS
        XOR     A
        CALL    3082
        LD      HL,15360+256
        LD      DE,#C000
        LD      BC,768
        LDIR
        CALL    BOLD
        SET     3,(IY+48)
        LD      HL,WORD
        LD      B,0
NEW     LD      A,#8F
        PUSH    HL
        PUSH    BC
        RST     16
        LD      A,8
        RST     16
        POP     BC
        POP     HL
        EI
        RES     5,(IY+1)
WAITK   BIT     5,(IY+1)
        JR      Z,WAITK
        LD      A,(IY-50)
        CP      13
        JR      Z,ENTER
        CP      #C
        JR      Z,BACKS
        CP      #30
        JR      C,WAITK
        CP      #7B
        JR      NC,WAITK
        LD      C,A
        LD      A,B
        CP      7
        JR      Z,WAITK
        LD      A,C
        LD      (HL),A
        INC     B
        INC     HL
        PUSH    HL
        PUSH    BC
        RST     16
        POP     BC
        POP     HL
        JR      NEW
BACKS   LD      A,B
        AND     A
        JR      Z,WAITK
        DEC     B
        DEC     HL
        PUSH    BC
        PUSH    HL
        LD      A,#20
        RST     16
        LD      A,8
        RST     16
        LD      A,8
        RST     16
        POP     HL
        POP     BC
        JR      NEW
ENTER   LD      A,B
        CP      7
        JR      NZ,WAITK
        LD      HL,WORD
        LD      C,0
        LD      B,6
SUBW    LD      A,(HL)
        SUB     #41
        LD      (HL),A
        ADD     A,C
        AND     #F
        LD      C,A
        INC     HL
        DJNZ    SUBW
        LD      A,(HL)
        SUB     #41
        CP      C
        JP      NZ,GODEAD
        LD      HL,WORD
        LD      A,(HL)
        LD      C,0
        RRCA
        RL      C
        RRCA
        RL      C
        RRCA
        RL      C
        RRCA
        RL      C
        LD      A,C
        LD      (CLEVEL),A
        INC     HL
        LD      A,(HL)
        LD      (MIN),A
        INC     HL
        LD      A,(HL)
        RRCA
        RRCA
        RRCA
        RRCA
        LD      (SEC),A
        INC     HL
        LD      A,(HL)
        LD      C,A
        LD      A,(SEC)
        OR      C
        LD      (SEC),A
        INC     HL
        LD      A,(HL)
        RRCA
        RRCA
        RRCA
        RRCA
        LD      C,A
        LD      A,(MIN)
        OR      C
        LD      (MIN),A
        INC     HL
        LD      A,(HL)
        LD      B,0
        RRCA
        RL      B
        RRCA
        RL      B
        RRCA
        RL      B
        RRCA
        RL      B
        LD      A,B
        LD      (ALLIV),A
        LD      A,(CLEVEL)
        CP      13
        JP      NC,GODEAD
        CP      2
        JP      C,GODEAD
        LD      A,(ALLIV)
        CP      3
        JP      C,GODEAD
        CP      13
        JP      NC,GODEAD
        LD      A,(MIN)
        CP      #60
        JP      NC,GODEAD
        LD      HL,#5800
        LD      DE,#5801
        LD      (HL),L
        LD      BC,767
        LDIR
        LD      HL,15360
        LD      (23606),HL
        CALL    LOADING
        LD      A,20
        CALL    SETPAGE
        LD      HL,#C000
        LD      DE,#1400
        LD      BC,#2C05
        CALL    #3D13
        LD      A,(CLEVEL)
        CP      2
        JR      Z,GO2
        CP      3
        JR      Z,GO3
        CP      4
        JR      Z,GO4
        CP      5
        JR      Z,GO5
        CP      6
        JP      Z,GO6
        CP      7
        JP      Z,GO7
        CP      8
        JP      Z,GO8
        CP      9
        JP      Z,GO9
        CP      10
        JP      Z,GO10
        CP      11
        JP      Z,GO11
        CP      12
        JP      Z,GO12
GO2     CALL    AFTER151
        CALL    LOADING
        CALL    PR2
        LD      HL,29300
        PUSH    HL
        LD      DE,#4B05
        LD      BC,#2E05
        JP      #3D13
GO3     CALL    PR2A
        LD      HL,29300
        PUSH    HL
        LD      DE,#4807
        LD      BC,#2E05
        JP      #3D13
GO4     CALL    AFTER3
        CALL    LOADING
        CALL    PR2
        CALL    LEVA
        LD      HL,29300
        PUSH    HL
        LD      DE,#430B
        LD      BC,#2E05
        JP      #3D13
GO5     CALL    PR2
        CALL    LEVA
        LD      HL,29300
        PUSH    HL
        LD      DE,#400D
        LD      BC,#2E05
        JP      #3D13
GO6     CALL    AFTER151
        CALL    LOADING
        CALL    PR2
        CALL    LEVA
        LD      HL,29300
        PUSH    HL
        LD      DE,#3D0F
        LD      BC,#2E05
        JP      #3D13
GO7     CALL    PR2
        LD      HL,29300
        PUSH    HL
        LD      DE,#3604
        LD      BC,#2E05
        JP      #3D13
GO8     CALL    AFTER7
        CALL    LOADING
        CALL    PR2
        LD      HL,29300
        PUSH    HL
        LD      DE,#3405
        LD      BC,#2E05
        JP      #3D13
GO9     CALL    PR2
        LD      HL,29300
        PUSH    HL
        LD      DE,#3107
        LD      BC,#2E05
        JP      #3D13
GO10    CALL    PR2
        CALL    LEVA
        LD      HL,29300
        PUSH    HL
        LD      DE,#2E09
        LD      BC,#2E05
        JP      #3D13
GO11    CALL    PR2
        CALL    LEVA
        LD      HL,29300
        PUSH    HL
        LD      DE,#2B0B
        LD      BC,#2E05
        JP      #3D13
GO12    CALL    AFTER151
        CALL    LOADING
        CALL    PR2B
        CALL    LEVA
        LD      HL,29300
        PUSH    HL
        LD      DE,#260F
        LD      BC,#2E05
        JP      #3D13
STACK   DEFW    0
PASS    DEFB    #80,22,9,7,"Wwedite parolx",22,11,#8A
WORD    DEFS    7,#20
CLEVEL  DEFB    0
AFTER151
        LD      DE,#290D
AFTER   LD      BC,#1E05
        LD      HL,39000
        CALL    #3D13
        LD      A,16
        CALL    SETPAGE
        JP      39000
AFTER3  LD      DE,#4609
        JR      AFTER
AFTER7  LD      DE,#3604
        LD      BC,#1F05
        JR      AFTER+3
LOADING LD      HL,#4000
        LD      DE,#0F0A
        LD      BC,#1A05
        CALL    #3D13
        RET
PR2     LD      A,19
        CALL    SETPAGE
        LD      HL,#C000
        LD      DE,#0905
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
        RET
PR2A    LD      A,19
        CALL    SETPAGE
        LD      HL,#C000
        LD      DE,#0D09
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
        LD      DE,#0C08
        LD      BC,#1105
        CALL    #3D13
        RET
PR2B    LD      A,19
        CALL    SETPAGE
        LD      HL,#C000
        LD      DE,#230D
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
        LD      DE,#250E
        LD      BC,#1105
        CALL    #3D13
        RET
LEVA    LD      A,16
        CALL    SETPAGE
        LD      HL,55296
        LD      DE,#1902
        LD      BC,#2605
        CALL    #3D13
        RET

GOONE   LD      SP,(STACK)
        LD      HL,15360
        LD      (23606),HL
        LD      HL,#5800
        LD      DE,#5801
        LD      BC,767
        LD      (HL),L
        LDIR
        LD      HL,#4000
        LD      DE,#0F0A
        LD      BC,#1A05
        CALL    #3D13
        LD      HL,29300
        PUSH    HL
        LD      DE,#4E03
        LD      BC,#2E05
        JP      #3D13
;KIND 0-Stand,1-Run,2-Jump1,3-Jump2
;4-Battle 5-Dead,6-Care,7-ToUp
FLAG    DEFB    0
BEGLIV  DEFB    0
BEGLIV1 DEFB    0
FFLAG   DEFB    0
BOLD    LD      HL,#C000
BLOOP   LD      A,(HL)
        LD      D,A
        RRCA
        OR      D
        LD      (HL),A
        INC     HL
        LD      A,H
        CP      #C3
        JR      NZ,BLOOP
        RET
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
        DJNZ    M1
        LD      B,4
CONT    CALL    LOOP
CONT2   CALL    INJOY
        CALL    TBACK
        JR      C,GOBACK
        LD      B,A
        LD      A,(SCREEN)
        AND     A
        JR      NZ,NINP
        LD      B,#FF
NINP    LD      A,B
        CP      #FF
        JR      NZ,NSTAND
STAND   LD      IX,STOP
        LD      B,9
        XOR     A
        LD      (KIND),A
        CALL    LOOP
        JP      WAIT
NSTAND  BIT     1,A
        LD      IX,RUN+16
        LD      B,4
        CALL    LOOP
CONT1   CALL    INJOY
        CALL    TBACK
        JR      C,GOBACK
        LD      B,A
        LD      A,(SCREEN)
        AND     A
        JR      NZ,NINP1
        LD      B,#FF
NINP1   LD      A,B
        CP      #FF
        JR      Z,STAND
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

HEI     DEFB    0
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
        JP      WAIT

TST0    LD      A,(POS)
        CP      B
        JP      Z,STDIE
        RET
TST1    PUSH    BC
        CALL    INCB
        LD      A,(POS)
        CP      B
        JP      Z,STDIE
        POP     BC
        RET
TST2    PUSH    BC
        CALL    INCB
        CALL    INCB
        LD      A,(POS)
        CP      B
        JP      Z,STDIE
        POP     BC
        RET
TST3    PUSH    BC
        CALL    INCB
        CALL    INCB
        CALL    INCB
        LD      A,(POS)
        CP      B
        JP      Z,STDIE
        POP     BC
        RET
STDIE   LD      SP,(STACK)
        LD      A,(STPOS)
        LD      (POS),A
        CALL    MAKEDE
        INC     DE
        JP      GODIE
PRET    HALT
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
CHECK   PUSH    DE
        CALL    PAUSE
        POP     DE
        LD      A,(POS)
        PUSH    BC
        LD      B,A
        CALL    RETRIEV
        RES     7,A
        LD      (SAV),A
        LD      A,(SAV)
ARET1   CALL    TSTSCR
        POP     BC
        RET
SCR     DEFB    6,1,9,2,10,2,13,2,14,2,16,3,17,1,18,2,59,1
        DEFB    70,3,48,2,91,3,93,4,98,3,97,3,39,3
        DEFB    27,2,147,2,151,1,152,255,0

MES1    DEFB    "Wwesti parolx",0
MES2    DEFB    "      <",0
MES3    DEFB    "Nowaq igra",0
MES4    DEFB    "    >",0
;----- LEVEL --------
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

PUTLONG PUSH    DE
        PUSH    BC
        LD      A,B
        SUB     200
        LD      B,A
        CALL    REST
        CALL    PUTFIRE
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
        CALL    PUTFIRE
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
DPF     DEFB    0
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

GODEAD  CALL    MAKEDE
        LD      IX,DEAD+2       ;---------
        LD      A,5
        LD      (KIND),A
        LD      B,5
        CALL    LOOP
GODIE   LD      IX,DEAD+10
        XOR     A
        LD      (LIVES),A
        LD      (HEI),A
        CALL    PUTKLIV
        LD      A,(LEV)
        CALL    DELMASK
        LD      C,4
        CALL    INCDE
        LD      B,2
        CALL    LOOP
WT      LD      B,131
        CALL    PUTMAN
        CALL    INJOY
        CP      #FF
        JR      Z,WT
        JP      START
GODEAD1 XOR     A
        LD      (KIND),A
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

INIT    LD      A,(BEGLIV)      ;---------
        LD      (LIVES),A
        LD      A,(BEGLIV1)
        LD      (ALLIV),A
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
        LD      HL,LDRINKS
        LD      DE,DRINKS
        LD      BC,26
        LDIR
        RES     0,(IY+71)
        LD      A,STARTLEV
        LD      (LEV),A
        LD      A,STADIR
        LD      (DIR),A
        LD      A,STAPOS
        LD      (POS),A
        XOR     A
        LD      (FFLAG),A
        LD      (KIND),A
        LD      (EOPEN),A
        LD      (AENEMY),A
        LD      (AENEMY+1),A
        LD      (TOKEN),A
        LD      A,CURLEV
        CP      1
        JR      NZ,TOKOK
        LD      A,#FF
        LD      (TOKEN),A
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
PLACE   PUSH    HL              ;----------
        PUSH    DE
        PUSH    BC
        XOR     A
        LD      (DPF),A
        CALL    FIRINIT
        CALL    PUTKLIV
        LD      HL,DRINK
        LD      (ADRINK),HL
        CALL    PUTDRINK
FLIP3   NOP
        NOP
        NOP
        POP     BC
        POP     DE
        POP     HL
        RET
VAR     DEFB    0
VAP     DEFB    0
CURSPR  DEFB    0
CURDE   DEFW    0
PUTMAN  PUSH    DE              ;---------
        PUSH    BC
        LD      A,B
        LD      (CURSPR),A
        LD      (CURDE),DE
        CALL    REST
        CALL    PUTFIRE
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
FBYTE   DEFB    0
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
        CP      2
        JP      Z,GOONE
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
DRIN    DEFB    52,0,53,0,54,0,119,0,120,0,121,0,122,0,123,0,124,0
        DEFB    125,0,126,0,127,0,128,0,129,0,130,0,130,0,130,0
        DEFB    130,0,130,0,130,0,130,0,130,0,129,0,126,0,1,0
FALLC   DEFB    100,0,101,0,102,0,103,0,104,0,104,0,104,0
RUN     DEFB    1,0,2,0,3,0,4,0,5,0,6,2,7,0,8,1,9,1,10,0,11,2,12,1,13,1,14,1,15,1,8,1
STOP    DEFB    16,0,17,2,18,1,19,0,20,1,21,0,22,0,23,0,1,0
ROT     DEFB    23,0,24,0,25,0,26,1
BACK    DEFB    16,0,17,2,18,1,19,2,27,0,28,0,29,0,30,0,31,0,32,0
        DEFB    33,0,34,0,35,0,14,1,15,1,8,1
UP      DEFB    55,0,56,1,57,0,58,0,59,0,60,0,61,0,62,0,63,0,76,0,1,0
READY   DEFB    145,0,146,0,147,1,148,2,0


; ---- BLOCK1 -------
RANDOM  EQU     #61A8
INC_HL1 EQU     #6201
INC_DE1 EQU     #6210
DEC_HL1 EQU     #621F
DEC_DE1 EQU     #6230
DECDE   EQU     #6241
INCDE   EQU     #6248
INJOY   EQU     #624F
IROT2   EQU     #6291
IROT    EQU     #62AD
SETPAGE EQU     #62C0
PAGE    EQU     #62CB
FILLB   EQU     #62D1
FILLD   EQU     #62CC
PUTLIVE EQU     #62D6
PPOS    EQU     #62EB
TIME    EQU     #62EA
ALLIV   EQU     #62E9
LIVES   EQU     #62E8
LEV     EQU     #62E7
DIR     EQU     #62E6
POS     EQU     #62E5
LEV1    EQU     #6348
POS1    EQU     #6347
DIR1    EQU     #6346
PUTKLIV EQU     #630D
WNDS    EQU     #6349
PUTELIV EQU     #62EC
SSPR    EQU     #634A
DECPOS  EQU     #6383
INCPOS  EQU     #638F
INCB    EQU     #63A0
DECB    EQU     #63B0
INCB1   EQU     #639B
DECB1   EQU     #63AA
COUNT   EQU     #63B6
TJUMP   EQU     #63C6
TFORW   EQU     #63D0
TBACK   EQU     #63D7
MOVE    EQU     #63EA
MVE     EQU     #63F2
MVE2    EQU     #63F5
MOV     EQU     #63F8
MOV1    EQU     #63FC
MVE1    EQU     #6400
MVE11   EQU     #6406
PUTIT   EQU     #640C
PUTIT1  EQU     #6453
PS      EQU     #649A
IROT1   EQU     #649B
SCREEN  EQU     #64A6
MAKEDE  EQU     #64A8
ROTD    EQU     #64C2
ADJUST  EQU     #64CA
INSCR   EQU     #64DC
ALEV    EQU     #64ED
MAKEDE1 EQU     #64F3
KIND    EQU     #650D
TROT    EQU     #650E
DIFFR   EQU     #6539
PUT     EQU     #6547
ROTAT   EQU     #6564
FROT    EQU     #65DD
DELSWORD EQU    #65ED
PUTSWORD EQU    #65F4
TOKEN   EQU     #65EC
TSWORD  EQU     #6620
DELSTAR EQU     #6661
PUTSTAR EQU     #6668
STAR    EQU     #6680
EADR    EQU     #6724
TENEMY  EQU     #66C3
AENEMY  EQU     #6726
ENEMY   EQU     #6728
CLS     EQU     #6756
TIMEON  EQU     #6772
TIMEOFF EQU     #6787
ABUF    EQU     #6790
DELAY   EQU     #6792
PFLAG   EQU     #6796
PUTT    EQU     #6797
PUTIT2  EQU     #67D7
PUTIT3  EQU     #67F7
PUTT1   EQU     #680B
HOWM    EQU     #680F
PUTT2   EQU     #6864
ABUFA   EQU     #68A7
PUTITM  EQU     #68A9
PT      EQU     #68ED
TIMER   EQU     #690F
MESS    EQU     #69FE
MIN     EQU     #6A47
SEC     EQU     #6A46
DELS    EQU     #6A07
DELL    EQU     #6A25
ZEROS   EQU     #68CC
MAKEATR EQU     #7219
PUTAEX  EQU     #6A5B
PTORCH  EQU     #6A84
PUTFIR  EQU     #6AA6
PUTFIRE EQU     #6AD9
AFIRE1  EQU     #6AF6
AFIRE2  EQU     #6AF8
PAUSE   EQU     #6AFA
STL     EQU     #6B2E
STPUT   EQU     #6B3D
STSAVE  EQU     #6BD2
STREST  EQU     #6C14
STFLAG  EQU     #6B61
STPOS   EQU     #6B37
DOMIR   EQU     #6C58
DOMIR1  EQU     #6CBB
EOPEN   EQU     #6CFC
PUTGATE EQU     #6CFD
SAVE0_  EQU     #6DA8
SAVE0   EQU     #6DAF
SAVE2_  EQU     #6DD4
SAVE2   EQU     #6DDF
SAVE4   EQU     #6E11
RETR    EQU     #6E3B
RETR1   EQU     #6E52
PRESS   EQU     #6E69
PRESS1  EQU     #6E6A
TBUTTON EQU     #6E6B
DECB1_  EQU     #6F0D
COUNT_  EQU     #6EF5
OPEN    EQU     #6F18
MAKEOPEN EQU    #6F40
SAV     EQU     #6F80
FOPEN   EQU     #6F81
SAVE_   EQU     #6F83
SAVE    EQU     #6F91
AGATES  EQU     #6FA6
LOAD    EQU     #6FA8
RETRIEV EQU     #7015
PUTMAP  EQU     #706E
PUTMAP1 EQU     #704E
PUTMAP2 EQU     #7058
HOW     EQU     #7085
PUTDRINKG EQU   #7105
PUTDRINK EQU    #710B
TDRINKG EQU     #715C
TDRINK  EQU     #7163
DRINKS  EQU     #71CC
DRINKG  EQU     #71E6
ADRINK  EQU     #71A4
DRNK    EQU     #71C0
DRINK   EQU     #71A8
INC_DE  EQU     #71F4
INC_HL  EQU     #71FC
PUTSW   EQU     #660C
STAR1   EQU     #6690
PST1    EQU     #666D
SWORD   EQU     #66A3
DEC_DE  EQU     #7203
DEC_HL  EQU     #720F
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
        INCLUDE "STALEV.asm"
        ORG     29300
