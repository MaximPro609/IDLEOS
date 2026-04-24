.code16
.global _start

_start:
    mov $0x03, %ax
    int $0x10

    mov $msg_wel, %si
    mov $0x0E, %ah
    mov $0x0E, %bl
pr_w:
    lodsb
    or %al, %al
    jz s_dly
    int $0x10
    jmp pr_w

s_dly:
    mov $0x2F, %cx
o_l: push %cx; mov $0xFFFF, %cx
i_l: loop i_l; pop %cx; loop o_l
    call nl
    jmp do_ins

main_l:
    mov $msg_p, %si
    call pr_s
    mov $cmd_b, %di

get_i:
    mov $0x00, %ah
    int $0x16
    mov $0x0E, %ah
    int $0x10
    cmp $13, %al
    je chk_c
    stosb
    jmp get_i

chk_c:
    movb $0, (%di)
    call nl
    mov $cmd_b, %si
    mov $c_ver, %di
    call scmp
    jc do_v
    mov $cmd_b, %si
    mov $c_ins, %di
    call scmp
    jc do_ins
    mov $msg_err, %si
    call pr_s
    jmp main_l

do_v:
    mov $msg_v, %si
    call pr_s
    jmp main_l

do_ins:
    mov $msg_sel, %si
    call pr_s
    mov $0x00, %ah
    int $0x16
    sub $0x30, %al
    add $0x80, %al
    mov %al, %dl
    call nl
    mov $20, %cx
d_b:
    mov $0x0E, %ah
    mov $0xDB, %al
    mov $0x0A, %bl
    int $0x10
    call s_dly_s
    loop d_b
    
    mov $0x03, %ah
    mov $0x01, %al
    mov $0x00, %ch
    mov $0x00, %dh
    mov $0x01, %cl
    xor %bx, %bx
    mov %bx, %es
    mov $0x7C00, %bx
    int $0x13
    jc ins_e
    call nl
    mov $msg_ok, %si
    call pr_s
    jmp main_l

ins_e:
    mov $msg_e_w, %si
    call pr_s
    jmp main_l

s_dly_s:
    push %cx; mov $0x1FFF, %cx
sd_l: loop sd_l; pop %cx; ret

scmp:
    n_c:
    mov (%si), %al; mov (%di), %bl
    cmp %al, %bl; jne n_e
    cmp $0, %al; je eq
    inc %si; inc %di; jmp n_c
    n_e: clc; ret
    eq: stc; ret

pr_s:
    lodsb; or %al, %al; jz s_dn
    mov $0x0E, %ah; int $0x10; jmp pr_s
s_dn: ret

nl:
    mov $0x0E, %ah; mov $10, %al; int $0x10
    mov $13, %al; int $0x10; ret

# --- ДАННЫЕ (УРЕЗАНО ДЛЯ ЭКОНОМИИ МЕСТА) ---
msg_wel:  .ascii "Welcome To IDLEOS\r\n\0"
msg_p:    .ascii "> \0"
msg_err:  .ascii "Err!\r\n\0"
msg_v:    .ascii "v0.1 Max\r\n\0"
msg_sel:  .ascii "Disk (0/1): \0"
msg_ok:   .ascii "DONE!\r\n\0"
msg_e_w:  .ascii "Write Err!\r\n\0"

c_ver: .ascii "ver\0"
c_ins: .ascii "install\0"

.section .bss
cmd_b: .skip 32

.section .text
.org 510
.word 0xaa55