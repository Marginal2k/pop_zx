;==============================================================================
; PRINCE OF PERSIA  (ZX Spectrum 128, TR-DOS)
; Resident kernel, loaded at #61A8 (original BLOCK2)
;
; Converted from the original TASM 3 sources to sjasmplus.
; Copy protection removed, disk positions are symbols from disk.inc.
;==============================================================================
LEVEL1  EQU     39600
BUFA    EQU     #C000+3000
ITEM    EQU     #FB8D
BUF     EQU     #A000+6144
BUF1    EQU     BUF+300
ROOM    EQU     BUF1+300
ROTT    EQU     ROOM+300
STBUF   EQU     ROTT+256+500
ADOOM   EQU     56640
AHEI    EQU     #FA8A

WALL    EQU     57792
STOLB   EQU     WALL+2016
FL2     EQU     STOLB+2016+14
FL      EQU     FL2+448
FL1     EQU     FL+448
FL3     EQU     FL1+448
FL4     EQU     FL3+448
        ORG     25000
        INCLUDE "kernel_exports.inc"
        INCLUDE "disk.inc"

RANDOM  PUSH    BC
        PUSH    DE
        LD      HL,(SEED)
        INC     HL
        LD      D,0
        LD      A,H
        OR      L
        JR      NZ,NOCARRY
        INC     D
NOCARRY PUSH    DE
        PUSH    HL
        SLA     L
        RL      H
        RL      D
        PUSH    DE
        PUSH    HL
        SLA     L
        RL      H
        RL      D
        SLA     L
        RL      H
        RL      D
        PUSH    DE
        PUSH    HL
        SLA     L
        RL      H
        RL      D
        SLA     L
        RL      H
        RL      D
        SLA     L
        RL      H
        RL      D
        POP     BC
        POP     AF
        ADD     HL,BC
        ADC     A,D
        LD      D,A
        POP     BC
        POP     AF
        ADD     HL,BC
        ADC     A,D
        LD      D,A
        POP     BC
        POP     AF
        ADD     HL,BC
        ADC     A,D
        LD      C,A
        LD      B,0
        OR      A
        SBC     HL,BC
        ADC     HL,BC
        OR      A
        SBC     HL,BC
        DEC     HL
        LD      (SEED),HL
        POP     DE
        POP     BC
        RET
SEED    DEFW    0
INC_HL1 INC     H
        LD      A,H
        AND     #07
        RET     NZ
        LD      A,L
        ADD     A,#20
        LD      L,A
        RET     C
        LD      A,H
        SUB     #8
        LD      H,A
        RET

INC_DE1 INC     D
        LD      A,D
        AND     #07
        RET     NZ
        LD      A,E
        ADD     A,#20
        LD      E,A
        RET     C
        LD      A,D
        SUB     #8
        LD      D,A
        RET
DEC_HL1 DEC     H
        LD      A,H
        OR      #F8
        CPL
        AND     A
        RET     NZ
        LD      A,L
        SUB     #20
        LD      L,A
        RET     C
        LD      A,H
        ADD     A,#08
        LD      H,A
        RET
DEC_DE1 DEC     D
        LD      A,D
        OR      #F8
        CPL
        AND     A
        RET     NZ
        LD      A,E
        SUB     #20
        LD      E,A
        RET     C
        LD      A,D
        ADD     A,#08
        LD      D,A
        RET

DECDE   CALL    DEC_DE
        DEC     C
        JR      NZ,DECDE
        RET
INCDE   CALL    INC_DE
        DEC     C
        JR      NZ,INCDE
        RET

INJOY   LD      A,#EF
        PUSH    BC
        CALL    TESTEND
        LD      A,#F7
        IN      A,(#FE)
        CALL    IROT
        AND     C
        LD      C,A
        LD      A,#FB
        IN      A,(#FE)
        RRA
        JR      C,NOQ
        RES     1,C
NOQ     LD      A,#FD
        IN      A,(#FE)
        RRA
        JR      C,NOA
        RES     2,C
NOA     LD      A,#DF
        IN      A,(#FE)
        RRA
        JR      C,NOOP
        RES     3,C
NOOP    LD      A,#DF
        IN      A,(#FE)
        RRA
        RRA
        JR      C,NOO
        RES     4,C
NOO     LD      A,#7F
        IN      A,(#FE)
        RRA
        JR      C,NSP
        RES     0,C
NSP     LD      A,C
        OR      #E0
        POP     BC
        RET
IROT2   LD      C,#FF
        RRCA
        RL      C
        RRCA
        RL      C
        RRCA
        RL      C
        RRCA
        RL      C
        RRCA
        RL      C
        RRCA
        RL      C
        RRCA
        RL      C
        RRCA
        RL      C
        LD      A,C
        RET
IROT    LD      B,#FF
        RRCA
        RL      B
        RRCA
        RL      B
        RRCA
        RL      B
        RRCA
        RL      B
        RRCA
        RL      B
        LD      A,B
        RET
SETPAGE PUSH    BC
        LD      (PAGE),A
        LD      BC,32765
        OUT     (C),A
        POP     BC
        RET
PAGE    DEFB    0
FILLD   LD      E,(HL)
        INC     HL
        LD      D,(HL)
        INC     HL
        RET
FILLB   LD      C,(HL)
        INC     HL
        LD      B,(HL)
        INC     HL
        RET
PUTLIVE PUSH    BC
        PUSH    DE
        LD      B,5
PLV     LD      A,(HL)
        LD      (DE),A
        INC     HL
        CALL    INC_DE
        DJNZ    PLV
        POP     DE
        POP     BC
        RET
POS     DEFB    2
DIR     DEFB    #FF
LEV     DEFB    0
LIVES   DEFB    3
ALLIV   DEFB    3
TIME    DEFB    0
PPOS    DEFB    0
PUTELIV PUSH    DE
        LD      DE,#B63F
        LD      A,(WNDS)
        AND     A
        JR      Z,PELR
        CP      #FF
        JR      Z,PELR
        NOP
        LD      B,A
PEL     LD      HL,ELIVE
        CALL    PUTLIVE
        DEC     DE
        DJNZ    PEL
PELR    LD      HL,EMPT
        CALL    PUTLIVE
        POP     DE
        RET
PUTKLIV PUSH    DE
        LD      DE,#B620
        LD      A,(LIVES)
        LD      B,A
        AND     A
        JR      Z,NOLIVE
PEL1    LD      HL,KLIVE
        CALL    PUTLIVE
        INC     DE
        DJNZ    PEL1
        LD      A,(LIVES)
        LD      B,A
NOLIVE  LD      A,(ALLIV)
        SUB     B
        JR      Z,PKLR
        LD      B,A
PEL2    LD      HL,KEMPT
        CALL    PUTLIVE
        INC     DE
        DJNZ    PEL2
PKLR    POP     DE
        RET
KLIVE   DEFB    #60,#78,#7E,#78,#60
KEMPT   DEFB    #60,#58,#46,#58,#60
ELIVE   DEFB    #06,#1E,#7E,#1E,#06
DIR1    DEFB    0
POS1    DEFB    0
LEV1    DEFB    0
WNDS    DEFB    0
SSPR    PUSH    DE
        LD      C,22
        LD      A,B
        CP      78
        JR      C,NSPG
        SUB     78
        LD      B,A
        LD      C,17
        CP      78
        JR      C,NSPG
        SUB     78
        LD      B,A
        LD      C,19
NSPG    LD      A,C
        CALL    SETPAGE
        LD      HL,49152
NSPG1   LD      DE,210
        INC     B
        DEC     B
        JR      Z,FIRST
SEARCH  ADD     HL,DE
        DJNZ    SEARCH
FIRST   LD      DE,ROOM
        LD      BC,210
        LDIR
        LD      HL,ROOM
        LD      A,16
        CALL    SETPAGE
        POP     DE
        RET
DECPOS  LD      A,(POS)
        LD      B,A
        CALL    DECB
        LD      A,B
        LD      (POS),A
        RET
INCPOS  LD      A,(POS)
        LD      B,A
        CALL    INCB
        LD      A,B
        LD      (POS),A
        RET
INCB1   LD      A,(DIR1)
        JR      TESTB
INCB    LD      A,(DIR)
TESTB   AND     A
        JR      NZ,DECB_
        INC     B
        RET
DECB_   DEC     B
        RET
DECB1   LD      A,(DIR1)
        CPL
        JR      TESTB
DECB    LD      A,(DIR)
        CPL
        JR      TESTB
COUNT   LD      A,(LEV)
        INC     A
        LD      B,A
        LD      A,(POS)
        ADD     A,3
        SRL     A
        SRL     A
        LD      C,A
        RET
TJUMP   CALL    TFORW
        RET     NC
        BIT     1,A
        SCF
        RET     Z
        CCF
        RET

TFORW   PUSH    AF
        LD      A,(DIR)
        CPL
        JR      TST

TBACK   PUSH    AF
        LD      A,(DIR)
TST     AND     A
        JR      NZ,BIT4
        POP     AF
        BIT     3,A
TEST    SCF
        RET     Z
        CCF
        RET
BIT4    POP     AF
        BIT     4,A
        JR      TEST
MOVE    LD      B,(IX)
        INC     IX
        INC     B
        DEC     B
        RET     Z
MVE     LD      A,(DIR)
MVE2    AND     A
        JR      NZ,MOV1
MOV     DEC     DE
        DJNZ    MOV
        RET
MOV1    INC     DE
        DJNZ    MOV1
        RET
MVE1    LD      A,(DIR)
        CPL
        JR      MVE2
MVE11   LD      A,(DIR1)
        CPL
        JR      MVE2
PUTIT   LD      A,(PS)
        AND     31
        CP      15
        JR      NC,NCB1
OK1     LD      A,E
        AND     31
        CP      20
        JR      C,NCB1
FAL1    INC     HL
        INC     DE
        RET
NCB1    LD      A,(PS)
        CP      15
        JR      C,NCB2
        LD      A,E
        AND     31
        AND     A
        JR      NZ,NCB2
        INC     HL
        RET
NCB2    LD      C,(HL)
        PUSH    DE
        LD      A,D
        AND     #1F
        OR      #C0
        LD      D,A
        LD      A,(DE)
        POP     DE
        AND     (HL)
        LD      B,A
        CPL
        SCF
        RRA
        LD      C,A
        RLA
        RLA
        AND     C
        LD      C,A
        LD      A,(DE)
        AND     C
        OR      B
        LD      (DE),A
        INC     HL
        INC     DE
        RET
        DEFS    10,0

PUTIT1  LD      A,(PS)
        CP      15
        JR      C,NCB3 ; NCB
        LD      A,E
        AND     31
        CP      10
        JR      NC,NCB3
FAL2    INC     HL
        DEC     DE
        RET
;NCB    LD      A,(PS)
;       CP      15
;       JR      NC,NCB3
;       LD      A,E
;       AND     31
;       CP      31
;       JR      NZ,NCB3
;       INC     HL
;       RET
NCB3    LD      A,(HL)
        INC     HL
        CALL    IROT1
        LD      A,C
        PUSH    DE
        LD      A,D
        AND     #1F
        OR      #C0
        LD      D,A
        LD      A,(DE)
        POP     DE
        AND     C
        LD      B,A
        CPL
        SCF
        RRA
        LD      C,A
        RLA
        RLA
        AND     C
        LD      C,A
        LD      A,(DE)
        AND     C
        OR      B
        LD      (DE),A
        DEC     DE
        LD      B,0
        RET
PTXT    DEFB    "      Game paused   ",0
PS      DEFB    0
IROT1   LD      C,A
        LD      IX,ROTT
        ADD     IX,BC
        LD      C,(IX)
        RET
SCREEN  DEFW    #0101
MAKEDE  LD      A,(LEV)
        SLA     A
        LD      HL,ALEV
        LD      B,0
        LD      C,A
        ADD     HL,BC
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        LD      A,(POS)
        LD      H,0
        LD      L,A
        DEC     HL
        DEC     HL
        ADD     HL,DE
        EX      DE,HL
        RET
ROTD    LD      A,(DIR)
        CPL
        LD      (DIR),A
        RET
ADJUST  CALL    MAKEDE
        LD      A,E
        AND     #E0
        LD      E,A
        LD      A,(POS)
        LD      H,0
        DEC     A
        DEC     A
        LD      L,A
        ADD     HL,DE
        EX      DE,HL
        RET
INSCR   LD      A,(SCREEN)
        CP      E
        JR      NZ,SFAI
        LD      A,(SCREEN+1)
        CP      D
        JR      NZ,SFAI
        SCF
        CCF
        RET
SFAI    SCF
        RET
ALEV    DEFW    #A200
        DEFW    #A900
        DEFW    #B000
MAKEDE1 LD      A,(LEV1)
        SLA     A
        LD      HL,ALEV
        LD      B,0
        LD      C,A
        ADD     HL,BC
        LD      E,(HL)
        INC     HL
        LD      D,(HL)
        LD      A,(POS1)
        LD      H,0
        LD      L,A
        DEC     HL
        DEC     HL
        ADD     HL,DE
        EX      DE,HL
        RET
KIND    DEFB    0
TROT    LD      A,(DIR)         ;--------
        AND     A
        JR      Z,OBR
        LD      A,(POS)
        LD      C,A
        LD      A,(POS1)
        JR      CMP
OBR     LD      A,(POS1)
        LD      C,A
        LD      A,(POS)
CMP     CP      C
        RET     NC
        LD      A,(DIR)
        CPL
        LD      (DIR),A
        LD      A,(KIND)
        AND     A
        RET     Z
        CALL    INCPOS
        CALL    INCPOS
        RET
DIFFR   LD      A,(POS1)        ;--------
        LD      C,A
        LD      A,(POS)
        SUB     C
        BIT     7,A
        RET     Z
        NEG
        RET
PUT     LD      A,D             ;---------
        CP      #B8
        RET     NC
        PUSH    DE
        PUSH    BC
        CALL    PUTIT
        CALL    PUTIT
        CALL    PUTIT
        CALL    PUTIT
        CALL    PUTIT
        POP     BC
        POP     DE
        CALL    INC_DE
        DJNZ    PUT
        RET
ROTAT   INC     DE              ;-----------
        INC     DE
        INC     DE
        INC     DE
        PUSH    IX
PUT2    LD      A,D
        CP      #B8
        JR      NC,PRET1
        PUSH    DE
        PUSH    BC
        LD      B,0
        CALL    PUTIT1
        CALL    PUTIT1
        CALL    PUTIT1
        CALL    PUTIT1
        CALL    PUTIT1
        POP     BC
        POP     DE
        CALL    INC_DE
        DJNZ    PUT2
PRET1   POP     IX
        RET
ROTSPR  PUSH    IY              ;---------
        PUSH    DE
        PUSH    BC
        DI
        LD      DE,ROOM
        LD      BC,300
        LDIR
        LD      IY,ROOM
        LD      B,42
RSLOOP  PUSH    BC
        LD      B,0
        LD      A,(IY)
        CALL    IROT1
        LD      D,A
        LD      A,(IY+4)
        CALL    IROT1
        LD      (IY),A
        LD      (IY+4),D
        LD      A,(IY+1)
        CALL    IROT1
        LD      D,A
        LD      A,(IY+3)
        CALL    IROT1
        LD      (IY+1),A
        LD      (IY+3),D
        LD      A,(IY+2)
        CALL    IROT
        LD      (IY+2),A
        POP     BC
        DJNZ    RSLOOP
        LD      HL,ROOM
        POP     BC
        POP     DE
        POP     IY
        EI
        RET
FROT    LD      B,0             ;-------
        LD      HL,ROTT+255
FLOOP   LD      A,B
        DEC     A
        CALL    IROT2
        LD      (HL),A
        DEC     HL
        DJNZ    FLOOP
        RET
TOKEN   DEFB    0
DELSWORD                        ;-------
        PUSH    DE
        PUSH    HL
        LD      HL,SWORD+9
        JR      PSW
PUTSWORD
        LD      A,(TOKEN)
        AND     A
        RET     Z
        LD      A,(SCREEN)
        AND     A
        RET     NZ
        LD      A,(SCREEN+1)
        CP      1
        RET     NZ
        PUSH    DE
        PUSH    HL
        LD      HL,SWORD
PSW     LD      DE,#B408+224
PUTSW   LD      B,3
PSLOOP  LD      C,5
        PUSH    DE
        LDI
        LDI
        LDI
        POP     DE
        CALL    INC_DE
        DJNZ    PSLOOP
        POP     HL
        POP     DE
        RET                     ;--------
TSWORD  LD      (PPOS),A
        LD      A,(TOKEN)
        AND     A
        JR      Z,TSF
        LD      A,(SCREEN)
        AND     A
        JR      NZ,TSF
        LD      A,(SCREEN+1)
        CP      1
        JR      NZ,TSF
        LD      A,(LEV)
        CP      2
        JR      NZ,TSF
        LD      A,(POS)
        CP      15
        JR      C,TSOK
TSF     SCF
        CCF
        LD      A,(PPOS)
        RET
TSOK    LD      A,(DIR)
        AND     A
        JR      Z,TSD
        LD      A,8
        JR      TSD1
TSD     LD      A,12
TSD1    LD      (POS),A
        CALL    MAKEDE
        SCF
        LD      A,(PPOS)
        RET
DELSTAR PUSH    HL              ;-------
        PUSH    DE
        LD      HL,STARS+7
        JR      PST1
PUTSTAR PUSH    HL
        PUSH    DE
        LD      HL,STARS
PST1    LD      DE,#B409+128
        LD      B,7
PSTL    LD      C,5
        PUSH    DE
        LDI
        POP     DE
        CALL    INC_DE
        DJNZ    PSTL
        POP     DE
        POP     HL
        RET
STAR    LD      A,(TOKEN)       ;-------
        AND     A
        RET     Z
        LD      A,(SCREEN)
        AND     A
        RET     NZ
        LD      A,(SCREEN+1)
        CP      1
        RET     NZ
STAR1   LD      A,(STARC)
        INC     A
        AND     127
        LD      (STARC),A
        CP      20
        JR      Z,PUTSTAR
        CP      22
        JR      Z,DELSTAR
        RET
STARC   DEFB    0
SWORD   DEFB    0,0,#08,#7F,#FF,#EF,0,0,#08
        DEFB    #55,#55,#55,#AA,#AA,#AA,#55,#55,#55
STARS   DEFB    #81,#66,#3C,#FF,#3C,#66,#81
        DEFB    #55,#AA,0,#FF,0,#AA,#55
TENEMY  PUSH    DE              ;---------
        PUSH    BC
        LD      HL,ENEMY
TELOP   CALL    FILLD
        CALL    FILLB
        LD      A,(HL)
        INC     HL
        CP      #FE
        JR      Z,TER
        CALL    INSCR
        JR      NC,TEOK
        JR      TELOP
TER     RES     0,(IY+55)
        POP     BC
        POP     DE
        RET
TEOK    PUSH    HL
        LD      HL,(AENEMY)
        LD      A,(POS1)
        LD      (HL),A
        INC     HL
        LD      A,(LEV1)
        LD      (HL),A
        INC     HL
        LD      A,(WNDS)
        LD      (HL),A
        POP     HL
        DEC     HL
        LD      A,(HL)
        LD      (WNDS),A
        DEC     HL
        LD      A,(HL)
        LD      (LEV1),A
        DEC     HL
        LD      A,(HL)
        LD      (POS1),A
        LD      (AENEMY),HL
        SET     0,(IY+55)
        CALL    MAKEDE1
        LD      (EADR),DE
        CALL    PUTELIV
        SET     7,(IY+55)
        RES     1,(IY+71)
        RES     1,(IY+55)
        POP     BC
        POP     DE
        RET
EADR    DEFW    0
AENEMY  DEFW    0
ENEMY   DEFS    46,0
CLS     LD      HL,#A000
        LD      DE,#A001
        LD      (HL),L
        LD      BC,6143
        LDIR
        LD      HL,#5800
        LD      DE,#5801
        LD      (HL),7
        LD      BC,767-64
        LDIR
        RET
INTR    DEFW    0
TIMEON  LD      A,#C3
        LD      (23713),A
        LD      HL,TIMER
        LD      (23714),HL
        NOP
        DI
        LD      A,46
        LD      I,A
        IM      2
        EI
        RET
TIMEOFF IM      1
        LD      HL,(INTR)
        LD      (#5DFF),HL
        RET
ABUF    DEFW    BUF
DELAY   HALT
        DJNZ    DELAY
        RET
PFLAG   DEFB    0
PUTT    PUSH    BC
        LD      B,7
        LD      A,(PFLAG)
        AND     A
        JR      Z,ZEROK
        LD      BC,8
        ADD     HL,BC
        LD      B,3
ZEROK   PUSH    DE
PUTL    LD      A,(PFLAG)
        AND     A
        JR      NZ,BORDOK
        LD      A,B
        CP      4
        JR      NC,BORDOK
        LD      A,E
        AND     31
        CP      3
        JR      NC,BORDOK
        INC     HL
        INC     HL
        JR      NXT
BORDOK  PUSH    BC
        LD      A,B
        CP      4
        JR      NC,NOMASK
        CALL    PUTIT2
        JR      AFT
NOMASK  CALL    PUTIT3
AFT     INC     HL
        POP     BC
NXT     DJNZ    PUTL
        POP     DE
        CALL    INC_DE
        POP     BC
        DJNZ    PUTT
        RET
PUTIT2  LD      A,(HL)
        INC     HL
        LD      C,A
        PUSH    DE
        LD      A,D
        AND     #1F
        OR      #C0
        LD      D,A
        LD      A,(DE)
        CPL
        OR      (HL)
        LD      B,A
        POP     DE
        LD      A,D
        CP      #A0
        JR      C,NP1
        LD      A,(DE)
        AND     B
        BIT     0,(IY+118)
        JR      NZ,NPUT1
        OR      C
NPUT1   LD      (DE),A
NP1     INC     DE
        RET
PUTIT3  LD      A,(HL)
        INC     HL
        LD      C,A
        LD      A,D
        CP      #A0
        JR      C,NP2
        LD      A,(DE)
        AND     (HL)
        BIT     0,(IY+118)
        JR      NZ,NPUT2
        OR      C
NPUT2   LD      (DE),A
NP2     INC     DE
        RET
PUTT1   LD      IX,(ABUFA)
HOWM    LD      C,1
        CALL    INCDE
        LD      (IX),E
        INC     IX
        LD      (IX),D
        INC     IX
PUTTA   PUSH    BC
        LD      B,7
        LD      A,(PFLAG)
        AND     A
        JR      Z,ZEROK1
        LD      BC,8
        ADD     HL,BC
        LD      B,3
ZEROK1  PUSH    DE
PUTL1   LD      A,(PFLAG)
        AND     A
        JR      NZ,BORDOK1
        LD      A,B
        CP      4
        JR      NC,BORDOK1
        LD      A,E
        AND     31
        CP      3
        JR      NC,BORDOK1
        INC     HL
        INC     HL
        JR      NXT1
BORDOK1 PUSH    BC
        LD      A,(DE)
        LD      (IX),A
        INC     IX
        LD      A,B
        CP      4
        JR      NC,NOMASK1
        CALL    PUTIT2
        JR      AFT1
NOMASK1 CALL    PUTIT3
AFT1    INC     HL
        POP     BC
NXT1    DJNZ    PUTL1
        POP     DE
        CALL    INC_DE
        POP     BC
        DJNZ    PUTTA
        RET
PUTT2   LD      HL,(ABUFA)
        CALL    FILLD
PUTTB   PUSH    BC
        LD      B,7
        LD      A,(PFLAG)
        AND     A
        JR      Z,ZEROK2
        LD      BC,8
        ADD     HL,BC
        LD      B,3
ZEROK2  PUSH    DE
PUTL2   LD      A,(PFLAG)
        AND     A
        JR      NZ,BORDOK2
        LD      A,B
        CP      4
        JR      NC,BORDOK2
        LD      A,E
        AND     31
        CP      3
        JR      NC,BORDOK2
        INC     HL
        INC     HL
        JR      NXT2
BORDOK2 LD      A,D
        CP      #A0
        JR      C,NP3
        CP      #B8
        JR      NC,NP3
        LD      A,(HL)
        LD      (DE),A
NP3     INC     DE
        INC     HL
NXT2    DJNZ    PUTL2
        POP     DE
        CALL    INC_DE
        POP     BC
        DJNZ    PUTTB
        RET
ABUFA   DEFW    BUFA
PUTITM  PUSH    BC              ;--------
        PUSH    DE
        XOR     A
        LD      (PFLAG),A
        INC     C
        DEC     C
        JR      NZ,NZER1
        INC     C
        LD      A,#FF
        LD      (PFLAG),A
NZER1   LD      A,B
        LD      B,0
        DEC     C
        SLA     C
        SLA     C
        AND     A
        JR      NZ,NOZ1
        LD      HL,#A000+192
        ADD     HL,BC
        EX      DE,HL
        LD      HL,(ITEM)
ZEROS   LD      BC,406
        ADD     HL,BC
        LD      B,2
        NOP
        JR      PT1
NOZ1    CP      1
        JR      NZ,NOO1
        LD      HL,#A420
        ADD     HL,BC
        EX      DE,HL
        LD      HL,(ITEM)
        LD      B,31
PT1     BIT     0,(IY+71)
        JR      Z,PT
        CALL    DEC_DE
        INC     B
PT      CALL    PUTT
        POP     DE
        POP     BC
        RET
NOO1    CP      2
        JR      NZ,NOT1
        LD      HL,#A800+(25*32)
PRED1   ADD     HL,BC
        EX      DE,HL
        LD      HL,(ITEM)
        LD      B,31
        JR      PT1
NOT1    CP      3
        JR      NZ,NOF1
        LD      HL,#B220
        JR      PRED1
NOF1    POP     DE
        POP     BC
        RET
TIMER   PUSH    BC
        PUSH    DE
        PUSH    HL
        PUSH    AF
        LD      HL,VARS
        DEC     (HL)
        JR      NZ,NMIN
        LD      (HL),50
        LD      B,2
INT1    INC     HL
        LD      A,(HL)
        DEC     A
        LD      C,A
        AND     #F
        CP      #F
        JR      Z,DDAA
        LD      A,C
        JR      NDAA
DDAA    LD      A,C
        LD      C,6
        SUB     C
NDAA    CP      #F9
        JR      NZ,INT2
        LD      A,#59
        LD      (HL),A
        DJNZ    INT1
INT2    LD      (HL),A
        LD      A,(23673)
        CP      5
        JR      NZ,NHOLD
        LD      A,4
        LD      (23673),A
NHOLD   LD      A,(MIN)
        AND     A
        JR      Z,OUTS
        LD      A,(SEC)
        AND     A
        JR      NZ,NMIN
        LD      A,(MIN)
        AND     #F
        JR      Z,PMIN
        LD      A,(MIN)
        AND     #F0
        JR      NZ,NMIN
PMIN    CALL    OUTMIN
NMIN    LD      A,(23560)
        CP      "T"
        PUSH    AF
        CALL    Z,OUTMIN
        POP     AF
        CP      "t"
        CALL    Z,OUTMIN
        XOR     A
        LD      (23560),A
        LD      A,(23673)
        CP      1
        CALL    Z,DELS
END     POP     AF
        POP     HL
        POP     DE
        POP     BC
        JP      MUSIC
OUTS    CALL    LOAD
        JR      END
PRINT   PUSH    AF
        SRL     A
        SRL     A
        SRL     A
        SRL     A
        AND     A
        CALL    NZ,PRN
        POP     AF
        AND     #F
        JR      PRN
PRNT    PUSH    BC
        PUSH    DE
        PUSH    HL
        LD      C,A
        LD      B,0
        SLA     C
        RL      B
        SLA     C
        RL      B
        SLA     C
        RL      B
        LD      HL,(23606)
        ADD     HL,BC
        LD      B,8
        JR      PRN1
PRN     PUSH    BC
        PUSH    DE
        PUSH    HL
        ADD     A,A
        ADD     A,A
        ADD     A,A
        ADD     A,#80
        LD      HL,(23606)
        LD      B,1
        LD      C,A
        ADD     HL,BC
        LD      B,8
PRN1    LD      A,(HL)
        LD      C,A
        SRL     C
        OR      C
        LD      (DE),A
        INC     HL
        CALL    INC_DE
        DJNZ    PRN1
        POP     HL
        POP     DE
        POP     BC
        INC     DE
        RET
OUTMIN  LD      DE,#B608
        LD      A,(MIN)
        CALL    PRINT
        LD      HL,MINL
        CALL    MESS
        XOR     A
        LD      (23673),A
        LD      (23672),A
        RET
OUTSEC  LD      DE,#B608
        LD      A,(SEC)
        CALL    PRINT
        LD      HL,SECL
        CALL    MESS
        XOR     A
        RET
MESS    LD      A,(HL)
        AND     A
        RET     Z
        CALL    PRNT
        INC     HL
        JR      MESS
DELS    LD      DE,#B608
        LD      HL,DELL
        CALL    MESS
        LD      A,4
        LD      (23673),A
        RET
MINL    DEFB    " MINUTES LEFT ",0
DELL    DEFB    "                ",0
SECL    DEFB    " SECONDS LEFT ",0
VARS    DEFB    1
SEC     DEFB    #00
MIN     DEFB    #00
EMPT    DEFB    0,0,0,0,0
MAKEAT  LD      A,E
        LD      C,A
        LD      A,D
        RRCA
        RRCA
        RRCA
        AND     3
        LD      B,A
        LD      HL,#5800
        ADD     HL,BC
        RET

PUTAEX  PUSH    HL
        PUSH    DE
        PUSH    IX
        CALL    MAKEATR
        LD      DE,32
        LD      A,#1F
        PUSH    HL
        POP     IX
        LD      B,7
PUTAEXL LD      (IX),A
        INC     IX
        DJNZ    PUTAEXL
        LD      B,8
PAE     LD      (IX-1),A
        LD      (IX-7),A
        ADD     IX,DE
        DJNZ    PAE
        POP     IX
        POP     DE
        POP     HL
        RET
PTORCH  CALL    MAKEATR
        LD      BC,32
        LD      (HL),#42
        ADD     HL,BC
        LD      (HL),#42
        ADD     HL,BC
        LD      (HL),6
        ADD     HL,BC
        LD      (HL),6
        LD      HL,TORCH
        LD      B,17
INCTOR  CALL    INC_DE
        DJNZ    INCTOR
        LD      B,14
        CALL    PFIR
        RET
TF      DEFB    0
PUTFIR  PUSH    HL
        PUSH    BC
        PUSH    DE
        LD      HL,39450        ; FIREGFX: flame frames inside the current program block
        LD      DE,16
        LD      A,(TF)
        AND     A
        JR      Z,NINF
        LD      B,A
ANF     ADD     HL,DE
        DJNZ    ANF
NINF    POP     DE
        LD      B,16
        CALL    PFIR
        POP     BC
        POP     HL
        RET
PFIR    LD      A,(HL)
        INC     HL
        LD      (DE),A
        CALL    INC_DE
        DJNZ    PFIR
        RET
TORCH   DEFB    #5D,#5D,#2A,0,#3E,0,#5D,0,#1C,8,#1C,8,#1C,8
PUTFIRE PUSH    DE
        LD      DE,(AFIRE1)
        CALL    PUTFIR
        LD      A,(TF)
        INC     A
        CP      9
        JR      NZ,NTFB
        XOR     A
NTFB    LD      (TF),A
        LD      DE,(AFIRE2)
        CALL    PUTFIR
        POP     DE
        RET
AFIRE1  DEFW    #A044
AFIRE2  DEFW    #A046
PAUSE   LD      A,#FE
        IN      A,(#FE)
        BIT     0,A
        RET     NZ
        LD      A,#7F
        IN      A,(#FE)
        BIT     1,A
        RET     NZ
        DI
        LD      DE,#B605
        LD      HL,PTXT
        CALL    MESS1
PWAIT   CALL    INJOY
        BIT     0,A
        JR      NZ,PWAIT
        LD      DE,#B606
        LD      HL,DELL
        CALL    MESS1
        EI
        RET
STL     DEFS    18,#FF
STIM    DEFB    0
STPOS   DEFB    0
        DEFS    5,0
STPUT   LD      HL,STL
        LD      A,(TIME)
        LD      (STIM),A
        LD      A,19
        CALL    SETPAGE
STPN    CALL    FILLB
        LD      A,B
        CP      #FF
        JR      NZ,NEXST
        LD      A,16
        CALL    SETPAGE
        RET
NEXST   PUSH    BC
        CALL    COUNT
        LD      A,C
        DEC     A
        POP     BC
        CP      C
STFLAG  JR      C,STPN
        PUSH    HL
        LD      IX,58608
        SLA     C
        SLA     C
        DEC     B
        LD      A,(LEV)
        CP      B
        JR      NZ,NCL
        LD      DE,432
        LD      A,(STIM)
        INC     A
        INC     A
        LD      (STIM),A
        AND     15
        CP      4
        JR      NC,NCL
        INC     A
        CP      2
        JR      NZ,SEARS
        LD      A,C
        LD      (STPOS),A
        LD      A,2
SEARS   ADD     IX,DE
        DEC     A
        JR      NZ,SEARS
NCL     INC     B
        LD      A,B
        LD      B,0
        CP      1
        JR      NZ,NOO3_1
        LD      HL,#A100
        JR      PT2_1
NOO3_1  CP      2
        JR      NZ,NOT_1
        LD      HL,#A800
        JR      PT2_1
NOT_1   LD      HL,#AF00
PT2_1   ADD     HL,BC
        EX      DE,HL
        PUSH    IX
        POP     HL
        LD      BC,216
        ADD     HL,BC
        LD      B,54
P_S     LD      C,4
        PUSH    DE
P_S1    LD      A,(DE)
        AND     (HL)
        OR      (IX)
        LD      (DE),A
        INC     DE
        INC     HL
        INC     IX
        DEC     C
        JR      NZ,P_S1
        POP     DE
        CALL    INC_DE
        DJNZ    P_S
        POP     HL
        JP      STPN
STSAVE  LD      HL,STL
        LD      DE,STBUF
STSA    CALL    FILLB
        LD      A,B
        CP      #FF
        RET     Z
        PUSH    HL
        LD      A,B
        LD      B,0
        SLA     C
        SLA     C
        CP      1
        JR      NZ,NOO3_
        LD      HL,#A100
        ADD     HL,BC
PT2_    LD      B,54
SAST    PUSH    HL
        LD      C,5
        LDI
        LDI
        LDI
        LDI
        POP     HL
        CALL    INC_HL
        DJNZ    SAST
        POP     HL
        JR      STSA
NOO3_   CP      2
        JR      NZ,NOT_
        LD      HL,#A840
PRD_    ADD     HL,BC
        JR      PT2_
NOT_    LD      HL,#AF40
        JR      PRD_
STREST  LD      HL,STL
        LD      DE,STBUF
STSA1   CALL    FILLB
        LD      A,B
        CP      #FF
        RET     Z
        PUSH    HL
        LD      A,B
        LD      B,0
        SLA     C
        SLA     C
        CP      1
        JR      NZ,NOO3_2
        LD      HL,#A100
        ADD     HL,BC
PT2_2   LD      B,54
        EX      DE,HL
SAST1   PUSH    DE
        LD      C,5
        LDI
        LDI
        LDI
        LDI
        POP     DE
        CALL    INC_DE
        DJNZ    SAST1
        EX      DE,HL
        POP     HL
        JR      STSA1
NOO3_2  CP      2
        JR      NZ,NOT_2
        LD      HL,#A840
PRD_2   ADD     HL,BC
        JR      PT2_2
NOT_2   LD      HL,#AF40
        JR      PRD_2
DOMIR   LD      A,(SCREEN)
        CP      #0A
        RET     NZ
        LD      A,(SCREEN+1)
        AND     A
        RET     NZ
        LD      A,(EOPEN)
        CP      46
        RET     NZ
        LD      A,(LEV)
        AND     A
        RET     NZ
        LD      A,19
        CALL    SETPAGE
        DI
        PUSH    IX
        PUSH    IY
        PUSH    DE
        LD      IX,58608+168+2160
        LD      HL,#A10C
        LD      DE,#A110
        LD      B,56
DML     PUSH    BC
        PUSH    HL
        PUSH    DE
        LD      B,3
DML1    PUSH    BC
        LD      IY,ROTT
        LD      B,0
        LD      A,(DE)
        LD      C,A
        ADD     IY,BC
        LD      A,(IY)
        AND     (IX)
        OR      (HL)
        LD      (HL),A
        INC     HL
        INC     IX
        DEC     DE
        POP     BC
        DJNZ    DML1
        POP     DE
        CALL    INC_DE
        POP     HL
        CALL    INC_HL
        POP     BC
        DJNZ    DML
        LD      A,16
        CALL    SETPAGE
        POP     DE
        POP     IY
        POP     IX
        EI
        RET
DOMIR1  LD      A,(SCREEN)
        CP      #0A
        RET     NZ
        LD      A,(SCREEN+1)
        AND     A
        RET     NZ
        LD      A,(EOPEN)
        CP      46
        RET     NZ
        LD      A,(LEV)
        AND     A
        JR      Z,PMOK
        LD      A,(POS)
        CP      7
        RET     NC
PMOK    LD      A,19
        CALL    SETPAGE
        PUSH    DE
        LD      HL,58608+2160
        LD      DE,#A10C
        LD      B,56
DML2    PUSH    DE
        LD      C,5
        LDI
        LDI
        LDI
        POP     DE
        CALL    INC_DE
        DJNZ    DML2
        LD      A,16
        CALL    SETPAGE
        POP     DE
        RET
EOPEN   DEFB    0
PUTGATE LD      A,B             ;---------
        AND     A
        RET     Z
        CP      4
        RET     Z
        PUSH    IX
        PUSH    HL
        PUSH    DE
        PUSH    BC
        PUSH    DE
        LD      HL,ADOOM+720
        LD      DE,ROOM
        LD      BC,72*3
        LDIR
        POP     DE
        INC     D
        LD      HL,ADOOM
GINC    DEC     D
        JR      Z,GOK
        INC     HL
        INC     HL
        INC     HL
        JR      GINC
GOK     LD      DE,ROOM
        LD      B,72*3
XOLOOP  LD      A,(DE)
        OR      (HL)
        LD      (DE),A
        INC     HL
        INC     DE
        DJNZ    XOLOOP
        POP     BC
        PUSH    BC
        LD      A,B
        LD      B,0
        SLA     C
        SLA     C
        CP      1
        JR      NZ,NOO3
        LD      HL,#A000+192
        ADD     HL,BC
        EX      DE,HL
        LD      HL,ROOM+42
        LD      IX,ADOOM+936+39
        LD      B,57
PT2     CALL    PT5
        POP     DE
        POP     BC
        POP     HL
        POP     IX
        RET
NOO3    CP      2
        JR      NZ,NOT_0
        LD      HL,#A600
PRD     ADD     HL,BC
        EX      DE,HL
        LD      HL,ROOM
        LD      IX,ADOOM+936-3
        LD      B,71
        JR      PT2
NOT_0   LD      HL,#AD00
        JR      PRD
PT5     PUSH    IY
PT51    PUSH    DE
        LD      C,3
PT52    LD      A,D
        AND     #1F
        OR      #C0
        DEFB    #FD
        LD      H,A
        DEFB    #FD
        LD      L,E
        LD      A,(IX)
        PUSH    AF
        LD      A,(IY)
        CPL
        OR      (IX)
        LD      (IX),A
        LD      A,(DE)
        AND     (IX)
        LD      (DE),A
        LD      A,(IX)
        CPL
        AND     (HL)
        LD      (HL),A
        LD      A,(DE)
        OR      (HL)
        LD      (DE),A
        POP     AF
        LD      (IX),A
        INC     DE
        INC     HL
        INC     IX
        DEC     C
        JR      NZ,PT52
        POP     DE
        CALL    INC_DE
        DJNZ    PT51
        POP     IY
        RET
SAVE0_  PUSH    BC
        PUSH    DE
        LD      HL,BUF1
        JR      CSAVE0
SAVE0   PUSH    BC
        PUSH    DE
        LD      HL,BUF
CSAVE0  XOR     A
        LD      (HL),A
        INC     HL
        LD      (HL),E
        INC     HL
        LD      (HL),D
        INC     HL
        EX      DE,HL
        LD      B,42
S0LOOP  PUSH    HL
        LD      C,7
        LDI
        LDI
        LDI
        LDI
        LDI
        POP     HL
        CALL    INC_HL
        DJNZ    S0LOOP
        POP     DE
        POP     BC
        RET
SAVE2_  PUSH    BC
        PUSH    DE
        LD      HL,BUF1
        LD      A,(DIR)
        CPL
        JR      CSAVE2
SAVE2   PUSH    BC
        PUSH    DE
        LD      HL,BUF
        LD      A,(DIR)
CSAVE2  AND     A
        JR      Z,NODEC
        DEC     DE
        DEC     DE
NODEC   LD      A,2
        LD      (HL),A
        INC     HL
        LD      (HL),E
        INC     HL
        LD      (HL),D
        INC     HL
        EX      DE,HL
        LD      B,42
S2LOOP  PUSH    HL
        LD      C,7
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        LDI
        POP     HL
        CALL    INC_HL
        DJNZ    S2LOOP
        POP     DE
        POP     BC
        RET
SAVE4   PUSH    BC
        PUSH    DE
        LD      A,(DIR)
        AND     A
        JR      Z,NOINC
        INC     DE
        INC     DE
NOINC   LD      HL,BUF
        LD      A,4
        LD      (HL),A
        INC     HL
        LD      (HL),E
        INC     HL
        LD      (HL),D
        INC     HL
        EX      DE,HL
        LD      B,50
S4LOOP  PUSH    HL
        LD      C,7
        LDI
        LDI
        LDI
        POP     HL
        CALL    INC_HL
        DJNZ    S4LOOP
        POP     DE
        POP     BC
        RET
RETR    PUSH    BC
        LD      A,E
        SLA     A
        SLA     A
        SLA     A
        ADD     A,C
        LD      C,A
        LD      A,D
        PUSH    DE
        LD      D,A
        ADD     A,D
        ADD     A,D
        POP     DE
        ADD     A,B
        LD      B,A
        CALL    RETR1
        POP     BC
        RET
RETR1   PUSH    BC
        PUSH    HL
        PUSH    DE
        INC     B
        DEC     B
        JR      Z,NOSEEK1
        LD      HL,LEVEL1
        LD      DE,(AHEI)
SEEK2   ADD     HL,DE
        DJNZ    SEEK2
NOSEEK1 ADD     HL,BC
        LD      A,(HL)
        POP     DE
        POP     HL
        POP     BC
        RET
PRESS   DEFB    #FF
PRESS1  DEFB    #FF
TBUTTON CALL    COUNT_
        PUSH    DE
        LD      DE,(SCREEN)
        CALL    RETR
        LD      (SAV),A
        POP     DE
        CP      "a"
        JR      C,NOPEN1_
        LD      (SAV),A
        BIT     2,(IY+118)
        JR      NZ,NOPEN2_
        SET     2,(IY+118)
        LD      (FOPEN),BC
        LD      HL,FL
        LD      (ITEM),HL
        CALL    PUTITM
        DEFS    3,0
NOPEN2_ LD      A,(SAV)
        SUB     "a"
        LD      (PRESS1),A
        LD      C,A
        LD      B,0
        SLA     C
        SLA     C
        PUSH    DE
        LD      HL,(AGATES)
        ADD     HL,BC
        CALL    FILLD
        LD      C,(HL)
        INC     HL
        LD      B,(HL)
        LD      A,B
        CP      #FE
        JR      Z,OPEX_
        CALL    MAKEOPEN
        POP     DE
        RET
OPEX_   LD      A,(EOPEN)
        AND     A
        JR      NZ,NOPX1_
        LD      A,1
        LD      (EOPEN),A
NOPX1_  POP     DE
        RET
NOPEN1_ BIT     2,(IY+118)
        RET     Z
        PUSH    DE
        RES     2,(IY+118)
        LD      BC,(FOPEN)
        LD      HL,FL
        LD      (ITEM),HL
        SET     0,(IY+71)
        CALL    PUTITM
        RES     0,(IY+71)
        DEFS    3,0
        LD      A,#FF
        LD      (PRESS1),A
        POP     DE
        RET
COUNT_  LD      A,(POS1)
        LD      B,A
        CALL    DECB1_
        CALL    DECB1_
        LD      A,B
        ADD     A,3
        SRL     A
        SRL     A
        LD      C,A
        LD      A,(LEV1)
        INC     A
        LD      B,A
        RET
DECB1_  LD      A,(DIR1)
        CPL
        AND     A
        JR      NZ,DECBA
        INC     B
        RET
DECBA   DEC     B
        RET
OPEN    DEFS    40,#FF
MAKEOPEN                        ;--------
        LD      HL,OPEN
OSEAR   LD      A,(HL)
        CP      #FF
        JR      Z,OFOUND
        LD      A,(HL)
        INC     HL
        CP      E
        JR      NZ,OSEARN
        LD      A,(HL)
        INC     HL
        CP      D
        JR      NZ,OSEARN+1
        LD      A,(HL)
        INC     HL
        CP      C
        JR      NZ,OSEARN+2
        LD      A,(HL)
        INC     HL
        CP      B
        JR      NZ,OSEARN+3
        LD      A,(HL)
        CP      46
        RET     C
        CP      165
        JR      NC,RECOUN
        LD      A,46
        LD      (HL),A
        RET
RECOUN  RES     0,A
        NEG
        RRCA
        LD      (HL),A
        RET
OSEARN  INC     HL
        INC     HL
        INC     HL
        INC     HL
        JR      OSEAR
OFOUND  LD      (HL),E
        INC     HL
        LD      (HL),D
        INC     HL
        LD      (HL),C
        INC     HL
        LD      (HL),B
        INC     HL
        LD      (HL),0
        RET
SAV     DEFB    0
FOPEN   DEFW    0
SAVE_   LD      DE,(BUF1+1)
        LD      A,(BUF1)
        AND     A
        JP      Z,SAVE0_
        JP      SAVE2_
SAVE    LD      DE,(BUF+1)
        LD      A,(BUF)
        AND     A
        JP      Z,SAVE0
        CP      2
        JP      Z,SAVE2
        CP      4
        JP      Z,SAVE4
AGATES  DEFW    0
LOAD    CALL    OUTSEC
        LD      A,(SEC)
        AND     A
        RET     NZ
ENDGAM  IM      1
        LD      SP,#61A8
        LD      HL,#5800
        LD      DE,#5801
        LD      (HL),L
        LD      BC,767
        LDIR
        LD      HL,32000
        PUSH    HL
        LD      HL,26000
        LD      DE,D_INTRO
        LD      BC,N_INTRO*256+5
        JP      DSK_READ
TESTEND IN      A,(#FE)
        LD      C,A
        PUSH    AF
        LD      A,#7F
        IN      A,(#FE)
        RRCA
        RRCA
        JR      C,TFALED
        LD      A,#FB
        IN      A,(#FE)
        BIT     2,A
        JR      Z,ENDGAM
TFALED  POP     AF
        RET
; HL - address of filename   DE - address of loading
        JR      NZ,FAILED
        DJNZ    SEARFIL
SEARFIL POP     IX
        POP     HL
        EX      DE,HL
        LD      E,(IX+14)
        LD      D,(IX+15)
        LD      B,(IX+13)
        POP     AF
        CALL    SETPAGE
        LD      C,5
        CALL    DSK_READ
EL      POP     IX
        POP     HL
        POP     DE
        POP     BC
        POP     AF
        RET
ENDLOAD POP     AF
        CALL    SETPAGE
        JR      EL
FAILED  POP     IX
        POP     HL
NEXFIL  JR      NEXFIL
        DEFS    2,0
RETRIEV PUSH    BC      ;--------
        PUSH    HL
        PUSH    DE
        PUSH    BC
        LD      A,16
        CALL    SETPAGE
        LD      BC,(SCREEN)
        SLA     C
        SLA     C
        SLA     C
        LD      A,B
        ADD     A,B
        ADD     A,B
        LD      B,A
        INC     B
        LD      A,(LEV)
        ADD     A,B
        LD      B,A
        LD      HL,LEVEL1
        LD      DE,(AHEI)
SEEK    ADD     HL,DE
        DJNZ    SEEK
        ADD     HL,BC
        POP     BC
        LD      C,B
        LD      B,0
        INC     C
        INC     C
        INC     C
        SRL     C
        SRL     C
        ADD     HL,BC
        LD      A,(HL)
        POP     DE
        POP     HL
        POP     BC
        RET
PUTMAP1 PUSH    DE
        LD      DE,(SCREEN)
        CALL    PUTMAP2
        POP     DE
        RET
PUTMAP2 PUSH    BC              ;----------
        PUSH    AF
        LD      A,E
        SLA     A
        SLA     A
        SLA     A
        ADD     A,C
        LD      C,A
        LD      A,D
        ADD     A,D
        ADD     A,D
        ADD     A,B
        LD      B,A
        POP     AF
        CALL    PUTMAP
        POP     BC
        RET
PUTMAP  PUSH    BC              ;---------
        PUSH    HL
        PUSH    DE
        INC     B
        DEC     B
        JR      Z,NOSEEK
        LD      HL,LEVEL1
        LD      DE,(AHEI)
SEEK1   ADD     HL,DE
        DJNZ    SEEK1
NOSEEK  ADD     HL,BC
        LD      (HL),A
        POP     DE
        POP     HL
        POP     BC
        RET
HOW     PUSH    BC              ;--------
        LD      A,(POS)
        LD      B,A
        CALL    DECB
        LD      C,0
HLOOP   CALL    RETRIEV
        RES     7,A
        CP      " "
        JR      Z,COUNTEN
        CP      ":"
        JR      Z,COUNTEN
        CP      "@"
        JR      Z,INF
        CP      "$"
        JR      Z,INF
        INC     C
        CALL    DECB
        JR      HLOOP
INF     LD      C,#FF
COUNTEN LD      A,C
        POP     BC
        CP      5
        RET     C
        PUSH    BC
        LD      HL,STL
        LD      A,#FF
        LD      (MIND),A
COUNA   CALL    FILLB
        LD      A,B
        CP      #FF
        JR      Z,COUNR
        LD      A,(LEV)
        INC     A
        CP      B
        JR      NZ,COUNA
        SLA     C
        SLA     C
        CALL    COUND
        LD      B,A
        LD      A,(MIND)
        CP      B
        JR      C,COUNA
        LD      A,B
        LD      (MIND),A
        JR      COUNA
COUNR   POP     BC
        LD      A,(MIND)
        AND     A
        RET     NZ
        LD      A,#FF
        RET
MIND    DEFB    0
COUND   LD      A,(DIR)
        LD      B,0
        AND     A
        JR      Z,OBRD
        LD      A,(POS)
CDL     INC     A
        INC     B
        CP      C
        JR      NZ,CDL
CDR     LD      A,B
        RET
OBRD    LD      A,(POS)
        INC     C
        DEC     A
CDL1    DEC     A
        INC     B
        CP      C
        JR      Z,CDR
        JR      CDL1
PUTDRINKG
        PUSH    DE
        LD      HL,DRINKG
        JR      PDA
PUTDRINK
        PUSH    DE              ;-------
        LD      HL,DRINKS
PDA     CALL    FILLD
        CALL    FILLB
        LD      A,E
        CP      #FF
        JR      Z,PDR
        CALL    INSCR
        JR      C,PDA
        LD      (ADRINK+2),HL
        PUSH    HL
        LD      A,B
        LD      B,0
        DEC     C
        SLA     C
        SLA     C
        AND     A
        CP      1
        JR      NZ,NOO11
        LD      HL,#A5E2
        ADD     HL,BC
        EX      DE,HL
PT11    LD      HL,(ADRINK)
        LD      B,12
PDL     LD      A,(HL)
        LD      (DE),A
        CALL    INC_DE
        INC     HL
        DJNZ    PDL
        POP     HL
        JR      PDR
NOO11   CP      2
        JR      NZ,NOT11
        LD      HL,#ACE2
PRED11  ADD     HL,BC
        EX      DE,HL
        LD      HL,(ITEM)
        LD      B,31
        JR      PT11
NOT11   LD      HL,#B3E2
        JR      PRED11
PDR     POP     DE
        RET
TDRINKG PUSH    AF
        PUSH    DE
        LD      HL,DRINKG-2
        JR      TDL
TDRINK  PUSH    AF              ;-------
        PUSH    DE
        LD      HL,DRINKS-2
TDL     INC     HL
        INC     HL
        CALL    FILLD
        LD      A,D
        CP      #FF
        JR      Z,TDF
        CALL    INSCR
        JR      C,TDL
        CALL    COUNT
        LD      A,(HL)
        CP      C
        JR      NZ,TDF
        INC     HL
        LD      A,(HL)
        CP      B
        JR      NZ,TDF
        LD      A,(POS)
        DEC     A
        AND     #FC
        LD      D,A
        LD      A,(DIR)
        AND     A
        JR      NZ,DPOK
        INC     D
        INC     D
        INC     D
        INC     D
DPOK    LD      A,D
        LD      (POS),A
        POP     DE
        CALL    MAKEDE
        POP     AF
        SCF
        RET
TDF     POP     DE
        POP     AF
        SCF
        CCF
        RET
ADRINK  DEFW    DRINK,0
DRINK   DEFB    #00,#00,#00,#BD,#19,#98,#3C,#7E,#2A,#7E,#3C,#80
        DEFB    #00,#00,#00,#FF,#55,#AA,#55,#AA,#55,#AA,#55,#AA
DRNK    DEFB    #3C,#18,#3C,#7E,#6A,#56,#7E,#BC,#3D,#BC,#19,#82
DRINKS  DEFS    26,0
DRINKG  DEFS    14,0
INC_DE  PUSH    HL
        LD      HL,32
        ADD     HL,DE
        EX      DE,HL
        POP     HL
        RET
INC_HL  PUSH    DE
        LD      DE,32
        ADD     HL,DE
        POP     DE
        RET
DEC_DE  PUSH    HL
        EX      DE,HL
        LD      DE,32
        SCF
        CCF
        SBC     HL,DE
        EX      DE,HL
        POP     HL
        RET
DEC_HL  PUSH    DE
        LD      DE,32
        SCF
        CCF
        SBC     HL,DE
        POP     DE
        RET
MAKEATR LD      A,D
        AND     31
        LD      L,E
        SLA     L
        SLA     L
        SLA     L
        SRL     A
        RR      L
        SRL     A
        RR      L
        SRL     A
        RR      L
        OR      #58
        LD      H,A
        RET
MESS1   CALL    MESS
        LD      HL,#B600
        LD      DE,#50C0
        LD      B,8
ML      PUSH    DE
        PUSH    BC
        LD      BC,32
        LDIR
        POP     BC
        POP     DE
        INC     D
        DJNZ    ML
        RET
MUSIC   PUSH    AF
        PUSH    BC
        PUSH    DE
        PUSH    HL
        PUSH    IX
        PUSH    IY
        LD      A,(PAGE)
        PUSH    AF
        LD      A,20
        CALL    SETPAGE
AMUS    DEFS    3,0
        POP     AF
        CALL    SETPAGE
        POP     IY
        POP     IX
        POP     HL
        POP     DE
        POP     BC
        POP     AF
        JP      56

; The tile blocks (res/tiles*.bin) contain drawing code without source that
; calls the kernel at fixed addresses, and every program is ORGed right
; after the kernel - so the kernel layout must not move.
        ASSERT  RANDOM == #61A8 && INC_DE == #71F4 && DEC_DE == #7203
        ASSERT  $ <= 29300
