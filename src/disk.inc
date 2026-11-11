; Disk layer interface + disk map.
;
; All disk access of the game goes through the resident driver (disk_io.asm):
;   DSK_INIT            - called once by the boot loader
;   DSK_READ            - HL = destination address
;                         DE = block id (D_xxx)
;                         B  = length in 256-byte sectors (N_xxx), C is ignored
; To port the game to another disk system replace disk_io.asm, the boot
; loader and (if block ids mean something else there) the D_xxx values.
;
; TR-DOS: D_xxx = track*256+sector (logical track = cylinder*2+side),
;         N_xxx = number of sectors reserved for the block.
; build.py reads this file to place the blocks, so move/resize them here.

DISKIO      EQU #5E00       ; driver address (free RAM below the stack/kernel)
DSK_READ    EQU DISKIO
DSK_INIT    EQU DISKIO+3

D_PRINCE    EQU #0100 ; prince sprites, set 1          -> page 6 (#C000)
D_HIGH      EQU #0500 ; small sprites/digits           -> 57458
D_PRINCE1   EQU #0505 ; prince sprites, set 2          -> page 1 (#C000)
D_PRINCE2   EQU #0905 ; enemy sprites (guard)          -> page 3 (#C000)
D_FIRE      EQU #0B06 ; torch flame (not loaded by the game)
D_LONGGATE  EQU #0B07 ; gates/doors graphics, set 1    -> 61200 (page 3)
D_LONGGATA  EQU #0C08 ; gates/doors graphics, set 2
D_PRINCE2A  EQU #0D09 ; enemy sprites, set A
D_LOADING   EQU #0F0A ; loading screen                 -> #4000
D_PRINCE2C  EQU #1105 ; enemy sprites, set C (level 13)
D_STEELMIR  EQU #1306 ; blades + mirror graphics       -> 58608 (page 3)
D_MUSIC     EQU #1400 ; in-game music + player         -> page 4 (#C000)
D_TILES     EQU #160C ; dungeon tiles + drawing code   -> #D800 (page 0)
D_TILESA    EQU #1902 ; palace tiles + drawing code    -> #D800 (page 0)
D_ENDFILE   EQU #1B08 ; ending sprites                 -> page 3 (#C000)
D_FONT1     EQU #1D0A ; ending font                    -> 59282
D_OMUSIC    EQU #1D0D ; ending music                   -> page 4 (#C000)
D_ENDING    EQU #1E06 ; ending program                 -> 29300
D_LEVEL13   EQU #200F ; level 13 program               -> 29300
D_PRINCE2B  EQU #230D ; enemy sprites, set B (level 12)
D_LONGGATB  EQU #250E ; gates/doors graphics, set 3
D_LEVEL12   EQU #260F
D_CUT1      EQU #290D ; cutscene (after levels 1,5,11) -> 39000
D_LEVEL11   EQU #2B0B
D_LEVEL10   EQU #2E09
D_LEVEL9    EQU #3107
D_CUT4      EQU #3405 ; cutscene (after level 8)       -> 39000
D_CUT3      EQU #3604 ; cutscene (after level 7)       -> 39000
D_LEVEL8    EQU #3803
D_LEVEL7    EQU #3B01
D_LEVEL6    EQU #3D0F
D_LEVEL5    EQU #400D
D_LEVEL4    EQU #430B
D_CUT2      EQU #4609 ; cutscene (after level 3)       -> 39000
D_LEVEL3    EQU #4807
D_LEVEL2    EQU #4B05
D_LEVEL1    EQU #4E03 ; level 1 program                -> 29300
D_MENU      EQU #5101 ; main menu / password entry     -> 29300
D_KERNEL    EQU #530F ; resident kernel                -> #61A8
D_INTRO     EQU #5500 ; intro (music, titles)          -> 26000, entry 32000
D_DEMO      EQU #5E09 ; attract-mode demo level        -> 29300

N_PRINCE    EQU 64
N_HIGH      EQU 5
N_PRINCE1   EQU 64
N_PRINCE2   EQU 33
N_FIRE      EQU 1
N_LONGGATE  EQU 17
N_LONGGATA  EQU 17
N_PRINCE2A  EQU 33
N_LOADING   EQU 27
N_PRINCE2C  EQU 33
N_STEELMIR  EQU 10
N_MUSIC     EQU 44
N_TILES     EQU 38
N_TILESA    EQU 38
N_ENDFILE   EQU 34
N_FONT1     EQU 3
N_OMUSIC    EQU 9
N_ENDING    EQU 41
N_LEVEL13   EQU 46
N_PRINCE2B  EQU 33
N_LONGGATB  EQU 17
N_LEVEL12   EQU 46
N_CUT1      EQU 30
N_LEVEL11   EQU 46
N_LEVEL10   EQU 46
N_LEVEL9    EQU 46
N_CUT4      EQU 31
N_CUT3      EQU 31
N_LEVEL8    EQU 46
N_LEVEL7    EQU 46
N_LEVEL6    EQU 46
N_LEVEL5    EQU 46
N_LEVEL4    EQU 46
N_CUT2      EQU 30
N_LEVEL3    EQU 46
N_LEVEL2    EQU 46
N_LEVEL1    EQU 46
N_MENU      EQU 46
N_KERNEL    EQU 17
N_INTRO     EQU 153
N_DEMO      EQU 46

N_LEVELPRG  EQU 46      ; every level program is loaded with this many sectors
