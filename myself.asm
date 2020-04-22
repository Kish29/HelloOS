org 0x7c00 ;注意，org伪指令告诉编译器，这段代码的起始地址是0x7c00，
;如果不设置话，编译期默认这段程序的起始地址是0 
;获取你自己定义的数据地址（比如字符串数据）就是获取的相对于这个程序开始的地址
;比如一个message相对于这个程序的偏移地址是0x25
;当你 mov ax, message的时候，不加org指令的情况下，编译期会把这个指令翻译成
;==== mov ax, 0x25 ===========
;而当你加上org 0x7c00的时候，编译器就翻译成了
;==== mov ax, 0x7c25 =========
;而我们的这个boot程序要放到内存0x7c00处执行，
;注意：！！！这里的0x7c00是rip寄存器的值，不是cs的值，在bochs运行的时候加上断点会看到
;cs的值其实是0，意思就是这个程序是在0x0000:0x7c00处执行的，所以这个org 0x7c00必须加上
;所以如果不设置话，如果你调用bios 10h的13h中断，es:bp = 0:0x25是找不到字符串的




BaseOfStack equ 0x7c00
BaseOfLoader equ 0x1000
OffsetOfLoader equ 0x00

SectorsOfRootDir equ 14 ; 已知根目录总的文件数是224，那么224 × 32=7168就是根目录占用的总字节大小
; 224 x 32 / 512 =  14 就是根目录占用的扇区数量
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
    BPB_RootEntCnt	dw	224  ; 根目录总的文件数目，这个用来确定根目录区占用的扇区数量
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
    mov sp, BaseOfStack 


; clear sreen
    mov ax, 0600h ; 06h号中断屏幕上卷
    mov bx, 0200h ; bh=上卷后屏幕中的属性
    mov cx, 0 ; 左上角行列坐标
    mov dx, 184fh ; 右下角行列坐标
    int 10h
; set cursor
    mov ax, 0200h ; 02h中断设置光标位置
    mov bx, 0h ; bh=显示页码
    mov dx, 0h ; dx=行列号
    int 10h
; display message
    mov ax, ds 
	mov es, ax 
	mov bx, 000ch
	mov bp, StartBootMessage  ; 13h中断显示字符串 es:bp是字符串地址
    mov cx, StartBootMessageLength 
	mov dx, 0020h ; 显示字符串的位置
	mov ax, 1301h ; al=01显示后光标移到字符串后面
	int 10h
; initial floppy
	xor ax, ax 
	xor dx, dx 
	int 13h

; 这里开始每次读取1个根目录扇区的数据到缓冲区0：0x8000中，一共读取14次
Read_Sector_In_Root_Dir_For_Searching_Loader:
	cmp byte [ReadSectorsOfRootDirNum], 0
	je Loader_Have_Not_Found
	dec byte [ReadSectorsOfRootDirNum]
	; 由于我们要调用int
; ====== 要用到的变量
ReadCurrentSectorInRootDir: db SectorNumOfRootDirStart 
ReadSectorsOfRootDirNum: db SectorsOfRootDir 
 
; messages 
StartBootMessage: db 'Start booting...'
StartBootMessageLength equ $ - StartBootMessage

	times 510 - ($ -$$) db 0
	db 0x55
	db 0xaa ; 后面的字数据是主引导签名(MBR)
