org 10000h
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ax, 0h
    mov ss, ax
    mov sp, 7c00h
; ====== 显示字符串
    mov ax, 1301h
    mov bx, 000bh
    mov dx, 021fh
    mov cx, StartLoaderMessageLength
    mov bp, StartLoaderMessage
    int 10h
    
    jmp $
StartLoaderMessage: db 'Start Loader......'
StartLoaderMessageLength equ $ - StartLoaderMessage
