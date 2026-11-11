        ORG     #61A8

        LD      A,#2C
        LD      C,0
        LD      IX,#2F4D
        CALL    TRDOS
        DI
        XOR     A
        OUT     (#FE),A
        LD      HL,#4000
        LD      DE,#4001
        LD      BC,#1AFF
        LD      (HL),L
        LDIR
        LD      HL,(#5C3D)
        LD      (HL),A
        INC     HL
        LD      (HL),A
        LD      HL,#C9F1
        LD      (#5CC2),HL
        LD      A,7
        LD      (#5C8D),A
        LD      (#5C8E),A
        LD      SP,#4040
        LD      HL,65535
        LD      BC,65535-STAX
        LD      A,#B2
        LD      R,A
XLOOP   LD      A,R
        XOR     (HL)
        XOR     B
        XOR     C
        XOR     H
        XOR     L
        LD      (HL),A
        DEC     HL
        DEC     BC
        LD      A,B
        OR      C
        JR      NZ,XLOOP
STAX    CALL    READ
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
        CP      0
        JR      NZ,PSEAR
        LD      A,(HL)
        INC     HL
        CP      #AA
        JR      NZ,PSEAR
        LD      SP,#61A7
        LD      HL,#4000
        LD      DE,#0F0A
        LD      BC,#1A05
        CALL    #3D13
        LD      HL,32000
        PUSH    HL
        LD      HL,26000
        LD      DE,#5500
        LD      BC,#9905
        JP      #3D13
READ    DI
TRACK
        CALL    FORMAT
        EI
        RET
ZAGR    LD      IX,#2FC3
        JP      TRDOS
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
ENDPRO
