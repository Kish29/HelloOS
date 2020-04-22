org 0x7c00

BaseOfLoader equ 0x1000
OffsetOfLoader equ 0x00

SectorNumOfRootDirStart equ 19
SectorNumOfFAT1Start equ 1
SectorBanlance equ 17

    jmp short BootStartInitialize     ; 指令执行从BootStartInitialize开始
    nop
    BS_OEMName	db	'jarsboot'
    BPB_BytesPerSec	dw	512
    BPB_SecPerClus	db	1   ;数据区的没簇占多少扇区
    BPB_RsvdSecCnt	dw	1
    BPB_NumFATs	db	2
    BPB_RootEntCnt	dw	224  ; 根目录总的文件数目
    ; 因为根目录占用14个扇区，每个扇区512个字节，而且目录项每个占用32Bytes
    ; 那么一个扇区就有512/32=16个文件，14个扇区就有224个文件
    BPB_TotSec16	dw	2880
    BPB_Media	db	0xf0  ; 可移动磁盘的类型F0，不可移动F8
    BPB_FATSz16	dw	9   ; 每个fat表占用的扇区数
    BPB_SecPerTrk	dw	18  ; 每个磁道的扇区数
    BPB_NumHeads	dw	2
    BPB_HiddSec	dd	0
    BPB_TotSec32	dd	0
    BS_DrvNum	db	0
    BS_Reserved1	db	0
    BS_BootSig	db	0x29
    BS_VolID	dd	0
    BS_VolLab	db	'boot loader'
    BS_FileSysType	db	'FAT12   '

; initialize
    mov ax, cs
    mov es, ax
    mov ds, ax
    mov ss, ax
    mov sp, 0x7c00


; clear sreen
    mov ax, 0600h
    mov bx, 0200h
    mov cx, 0
    mov dx, 184fh
    int 10h
; set cursor
    mov ax, 0200h
    mov bx, 0h
    mov dx, 0h
    int 10h
; display message
    mov 
 
 
 
 
 
 
; messages 
StartBootMessage: db 'Start booting...'
StartBootMessageLength equ $ - StartBootMessage