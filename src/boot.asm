;==============================================================================
; PRINCE OF PERSIA  (ZX Spectrum 128, TR-DOS)
; Boot loader. Replaces the original protected loader (PROT): no decryption,
; no raw-track check. Loaded by the BASIC boot together with the disk driver.
;==============================================================================

        INCLUDE "disk.inc"
        INCLUDE "disk_io.asm"   ; resident driver at DISKIO, boot code follows it

BOOT    DI
        XOR     A
        OUT     (#FE),A
        LD      HL,#4000        ; clear the screen
        LD      DE,#4001
        LD      BC,#1AFF
        LD      (HL),L
        LDIR
        LD      A,7
        LD      (#5C8D),A       ; ATTR P / ATTR T
        LD      (#5C8E),A
        LD      SP,#61A7
        CALL    DSK_INIT
        LD      HL,#4000        ; loading screen
        LD      DE,D_LOADING
        LD      BC,(N_LOADING-1)*256+5
        CALL    DSK_READ
        LD      HL,32000        ; intro: loaded to 26000, entry 32000
        PUSH    HL
        LD      HL,26000
        LD      DE,D_INTRO
        LD      BC,N_INTRO*256+5
        JP      DSK_READ

        ASSERT  $ <= #6100      ; keep clear of the stack
