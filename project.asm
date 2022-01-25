.MODEL SMALL

print macro var
     mov ah, 9
     lea dx, var
     int 21h
endm

print_num macro var
    mov ax, var
    mov bl, 10
    div bl
    mov bl, al
    mov bh, ah
    add bl, 30h
    add bh, 30h
    mov ah, 2
    mov dl, bl
    int 21h
    mov dl, bh
    int 21h 

endm

.STACK 100H

.DATA
    ;DEFINE YOUR VARIABLES HERE
    
    n db "MICROBOOK$"
    
    ls db "Create account: $"
    undp db "How many characters your name has? $"
    unp db "Enter your name: $"
    ap db "Enter your age: $"
    
    greetings db "Welcome to MicroBook.$"
    instructions db "Instructions:$"
    lpi db "Press 1 to load your profile$"
    uai db "Press 2 to update your age$"
    mki db "Press 3 to make friends$"
    lci db "Press 4 to like celebrities$"
    slci db "Press 5 to see liked celebrities$"
    ei db "Press 6 to exit$"
    
    und dw ?
    un db und dup(?)
    age dw ?
    friendNum dw 0
    
    c1 dw "Adam$"
    c2 dw "Rock$"
    c3 dw "Messi$"
    c4 dw "John$"
    c5 dw "Bob$"
    
    c db 41h, 52h, 4Dh, 4Ah, 42h
    
    
    lc db 3 dup(0)
    
    unpri db "User Name: $"
    apri db "User age: $"
    fpri db "Number of friends: $"
    
    ua db "Updated age: $"
    mf db "Updated friend count: $"
    
    cp dw "Press the first letter of the desired celebrity$"
    op db "Options$"
    clist dw "1.Adam, 2.Rock, 3.Messi, 4.John, 5.Bob$"
    d db "You can not like anymore celebrity$"
    nd db "No celebrity is liked by you yet$"
    
    divider db "===================$"
    bye db "Good Bye!!!$"
    
    temp dw ?
    lcCount dw 0

.CODE
    MAIN PROC
        
        MOV AX, @DATA
        MOV DS, AX
        
        ; YOUR CODE STARTS HERE
        
        print n
        call newl
        
        print ls
        call newl
        
        print undp
        
        mov bx, 0
        mov dx, 10
        mov ax, 0
 
        input1:
            mov ah, 1
            int 21h
            cmp al, 0Dh
            je iund
            sub al, 30h
            mov ah, 0
            mov temp, ax
            mov ax, bx
            mul dx
            mov dx, 10
            add ax, temp
            mov bx, ax
            jmp input1
            
        iund:
            mov und, bx
            mov bx, 0
            mov dx, 10
            
        call newl
        
        print unp
        mov ah, 1 
        mov cx, und
        mov si, 0
        
        Input:
            int 21h
            mov un[si], al
            inc si
            loop Input
            
        call newl
        
        print ap
        
        mov bx, 0
        mov dx, 10
        mov ax, 0
 
        input2:
            mov ah, 1
            int 21h
            cmp al, 0Dh
            je iage
            sub al, 30h
            mov ah, 0
            mov temp, ax
            mov ax, bx
            mul dx
            mov dx, 10
            add ax, temp
            mov bx, ax
            jmp input2
            
        iage:
            mov age, bx
            mov bx, 0
            mov dx, 10
            
        call newl
        
        print greetings
        call newl
        print instructions
        call newl
        print lpi
        call newl
        print uai
        call newl
        print mki
        call newl
        print lci
        call newl
        print slci
        call newl
        print ei
        call newl
        
        start:
            print divider
            call newl
            
            mov ah, 1
            int 21h
            mov bl, al
            
            cmp bl, 31h
            je load
            
            cmp bl, 32h
            je update
            
            cmp bl, 33h
            je make
            
            cmp bl, 34h
            je like
            
            cmp bl, 35h
            je show
            
            call newl
            print bye
            jmp exit
            
            load:
                call load_profile
                jmp start
                
            update:
                call update_age
                jmp start
                
            make:
                call make_friend
                jmp start
                
            like:
                call like_a_celebrity
                jmp start
                
            show:
                call show_liked_celebrity
                jmp start
        
        ; YOUR CODE ENDS HERE
        exit:
        
            MOV AX, 4C00H
            INT 21H
        
    MAIN ENDP
    
    proc newl
        
        mov ah, 2
        mov dl, 0Dh
        int 21h
        mov dl, 0Ah
        int 21h
        ret
        
    endp newl
    
    proc load_profile
        
        call newl
        
        print unpri
        
        mov ah, 2
        mov cx, und
        mov si, 0
        outun:
            mov dl, un[si]
            inc si
            int 21h
            loop outun
        
        call newl
        print apri
        print_num age
        call newl
        print fpri
        print_num friendNum 
        call newl
        
        ret
        
    endp load_proflie
        
    proc update_age
        
        call newl
        
        print ua
        add age, 5
        print_num age
        call newl
        
        ret
        
    endp update_age
    
    proc make_friend
        
        call newl
        
        print mf
        add friendNum, 1
        print_num friendNum
        call newl
        
        ret
        
    endp make_friend
    
    proc like_a_celebrity
        
        call newl
        
        mov bx, 3
        cmp lcCount, bx
        jge done 
         
        print clist
        call newl
        print cp
        call newl
        print op
        call newl
        
        mov ah, 2
        mov cx, 5
        mov si, 0
        showc:
            mov dl, c[si]
            int 21h
            add si, 1
            call newl
            loop showc
        
        mov ah, 1
        int 21h
        
        mov si, lcCount
        mov lc[si], al
        inc lcCount
        jmp r
        
        done:
            print d
        
        r:
            call newl
            ret
        
        
    endp like_a_celebrity
    
    proc show_liked_celebrity
        
        call newl
        
        mov bx, 0
        cmp lcCount, bx
        jne plc
        
        print nd
        jmp re
        
        ;c db 41h, 52h, 4Dh, 4Ah, 42h
        plc:
            mov ah, 9
            mov cx, 3
            mov si, 0
            showlc:
                cmp lc[si], 41h
                je adam
                cmp lc[si], 52h
                je rock
                cmp lc[si], 4Dh
                je messi
                cmp lc[si], 4Ah
                je john
                cmp lc[si], 42h
                je bob
                cmp lc[si], 0h
                je rest
                
                adam:
                    print c1
                    call newl
                    jmp rest
               
                rock:
                    print c2
                    call newl
                    jmp rest
               
                messi:
                    print c3
                    call newl
                    jmp rest
                
                john:
                    print c4
                    call newl
                    jmp rest
                
                bob:
                    print c5
                    call newl
                    jmp rest
                    
                rest:
                    inc si
                    loop showlc
        re: 
            call newl
            ret
        
    endp show_liked_celebrity        

    END MAIN