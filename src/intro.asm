;==============================================================================
; PRINCE OF PERSIA  (ZX Spectrum 128, TR-DOS)
; Intro (titles + Pro Tracker music). No source survived for this block: it is
; the binary from the master disk (res/intro.bin, already decrypted) with the
; disk access re-assembled here so that it goes through the disk layer.
;
;   26000  Pro Tracker player + module
;   32000  entry
;==============================================================================

        INCLUDE "disk.inc"
        INCLUDE "kernel_api.inc"

        ORG     26000
        INCBIN  "intro.bin"

; the master disk had an XOR decryptor here (32000..32020)
        ORG     32000
        JP      32021
        DEFS    32021-$,0

; end of the intro -> attract-mode demo
        ORG     #7E1E
        CALL    INTRO_LOADS
        LD      HL,29300
        PUSH    HL
        LD      DE,D_DEMO
        LD      BC,N_DEMO*256+5
        JP      DSK_READ
        ASSERT  $ == #7E2E

; key pressed -> main menu
        ORG     #7E36
        CALL    INTRO_LOADS
        LD      HL,29300
        PUSH    HL
        LD      DE,D_MENU
        LD      BC,N_MENU*256+5
        JP      DSK_READ
        ASSERT  $ == #7E46

; loading screen, kernel, dungeon tiles
INTRO_LOADS
        CALL    #7F28
        LD      HL,#4000
        LD      DE,D_LOADING
        LD      BC,(N_LOADING-1)*256+5
        CALL    DSK_READ
        LD      HL,RANDOM       ; = kernel start (#61A8)
        LD      DE,D_KERNEL
        LD      BC,N_KERNEL*256+5
        CALL    DSK_READ
        LD      HL,#D800
        LD      DE,D_TILES
        LD      BC,N_TILES*256+5
        CALL    DSK_READ
        RET
        ASSERT  $ == #7E6E
