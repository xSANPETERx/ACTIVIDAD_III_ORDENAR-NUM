; Programa que genera 20 números aleatorios y ordena de forma ascendente o descendente
; Realizado por Roberto Yael San Pedro Rivera

;------------------
; Programa principal
;------------------

    .org 0000h
    ld sp,27ffh
inicio:
    ld a,89h
    out (cw),a
    ld hl,txtin
    call mstrtxt
    ld b,20
    ld hl,27ffh
    call num_rnd
    ld hl,27ffh
    ld b,20
    call mostrar_num
    ld hl,ord_txt1
    call mstrtxt
    ld hl,ord_txt2
    call mstrtxt
    ld hl,ord_txt3
    call mstrtxt
    in a,(teclado)
    cp 'A'
    jp z,orden_ascen
    cp 'D'
    jp z,orden_descen
    call mostrar_num_ord
    call pregunta
    halt

;---------
; Subrutinas
;---------

mstrtxt:
    ld a,(hl)
    cp '$'
    jp z,fin_mstxt
    out (lcd),a
    inc hl
    jp mstrtxt
fin_mstxt:
    ret

num_rnd:
    ld a, r
    ld c, a
    add a, a
    add a, c
    add a, a
    add a, a
    add a, c
    add a, 82
    srl a
    srl a
    srl a
    srl a
    add a, 30h      ; Suma 30h para convertir a ASCII
    cp 3Ah          ; Si supera 39h, ajustar
    jp nc, ajustar
    inc hl
    ld (hl), a
    dec b
    jp nz, num_rnd
    ret

ajustar:
    sub 6h    ; Resta para ajustar al rango (30h-39h)
    inc hl
    ld (hl),a
    dec b
    jp nz, num_rnd
    ret

mostrar_num:
    ld a,(hl)
    call conv_decimal
    inc hl
    djnz mostrar_num
    ret

conv_decimal:
    ld b,10
    ld d,0
decenas:
    cp b
    jp mostrar_unidades
    sub b
    inc d
    jp decenas

mostrar_decenas:
    ld a,d
    add a,'0'
    out (lcd),a

mostrar_unidades:
    ld a,(hl)
    and 0fh
    ld b,10
    ld d,0
unidades:
    cp b
    jp fin_conv
    sub b
    inc d
    jp unidades
fin_conv:
    ld a,d
    add a,'0'
    out (lcd),a
    ret

orden_ascen:
    ld hl,27ffh
    ld b,20
    call ordenar
    call mostrar_as
    ret

orden_descen:
    ld hl,27ffh
    ld b,20
    call ordenar
    call mostrar_des
    ret

mostrar_num_ord:
    ld hl,27ffh
    ld b,20
loop_mstr_ord:
    ld a,(hl)
    call conv_decimal
    inc hl
    djnz loop_mstr_ord
    ret

pregunta:
    ld hl,preg_txt1
    call mstrtxt
    ld hl,preg_txt2
    call mstrtxt
    in a,(teclado)
    cp 'R'
    jp z,inicio
    cp 'S'
    jp z,fin_programa

fin_programa:
    ld hl,txt_salida
    call mstrtxt
    halt

ordenar:
    ld hl,27ffh
    ld e,20
ascendente_loop:
    ld a,(hl)
    inc hl
    ld b,(hl)
    dec e
    jp z,reinicio
    cp b
    jp nc,intercambio
    jp ascendente_loop

intercambio:
    ld (hl),a
    dec hl
    ld (hl),b
    inc hl
    jp ascendente_loop

reinicio:
    dec d
    jp z, end3
    jp ordenar

end3:
    ret

mostrar_as:
    ld hl,27ffh
    ld b,20
loop_as:
    ld a,(hl)
    out (lcd),a
    inc hl
    djnz loop_as
    ret

mostrar_des:
    ld hl,27ffh
    ld b,20
    ld e,19
final_des:
    inc hl
    dec e
    jp nz,final_des
loop_des:
    ld a,(hl)
    out (lcd),a
    dec hl
    djnz loop_des
    ret

;-------
; Datos
;-------

    .org 2000h
txtin .db "GENERANDO NUM:$"
ord_txt1 .db "ORDENAR$"
ord_txt2 .db "ASCENDENTE O$"
ord_txt3 .db " DESCENDENTE?$"
preg_txt1 .db "REPETIR(R) O$"
preg_txt2 .db " SALIR(S)?$"
txt_salida .db "FIN PROGRAMA$"
lcd    .equ 01h
teclado .equ 02h
cw     .equ 03h

    .end

