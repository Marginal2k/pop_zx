;==============================================================================
; PRINCE OF PERSIA  (ZX Spectrum 128)
; Disk layer: TR-DOS (Beta Disk) driver
;
; This is the ONLY place that talks to the disk system. Everything else calls
; the two entries below (addresses are fixed in disk.inc):
;
;   DSK_INIT   one-time setup, called by the boot loader
;   DSK_READ   read a block:  HL = destination address
;                             DE = block id (D_xxx from disk.inc)
;                             B  = block length in 256-byte sectors (N_xxx)
;              Registers are not preserved. Interrupts may be enabled on
;              return (callers already expect that from TR-DOS).
;              The 128K page in #C000 selected by the caller stays selected.
;
; The driver is loaded by the boot loader to DISKIO (#5E00) and stays there
; for the whole game. Free room: #5E00..#60FF (the stack grows down from
; #61A7, the kernel starts at #61A8).
;
; Porting to another disk system: rewrite this file (and boot.asm / the image
; builder). With TR-DOS a block id is track*256+sector; another driver may
; treat D_xxx as any 16-bit handle (block number, file index, ...).
;==============================================================================

        ORG     DISKIO

        JP      TRD_READ        ; DSK_READ
        JP      TRD_INIT        ; DSK_INIT

; TR-DOS: #3D13 function 5 = read B sectors from track D, sector E to HL
TRD_READ
        LD      C,5
        JP      #3D13

TRD_INIT
        LD      HL,(#5C3D)      ; ERR_SP: a BASIC/TR-DOS error restarts the
        XOR     A               ; machine instead of dropping into BASIC
        LD      (HL),A          ; (as the original loader did)
        INC     HL
        LD      (HL),A
        LD      HL,#C9F1        ; TR-DOS calls the 48K ROM through #5CC2 (RET);
        LD      (#5CC2),HL      ; POP AF:RET there mutes its error messages
        RET

        ASSERT  DSK_READ == DISKIO && DSK_INIT == DISKIO+3
