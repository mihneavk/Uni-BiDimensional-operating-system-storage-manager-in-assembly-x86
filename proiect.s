.data
    ; // var globale
    v: .space 1000
    formatAdunare: .asciz "%d: (%d, %d)\n"
    format_get: .asciz "(%d, %d)\n"
    formatCitire: .asciz "%ld"
    n: .space 4
    x: .space 4

.text
.global main


getF:
    ; // !!! EXACT get-ul normal dar face printarea mare
    ; // 
    ; // 1 parametru - id
    ; // ret (0,0) daca nu exista - si ret (prim val,ult val) daca exista
    pushl %ebp ; // 8(%ebp) - nr de cautat
    movl %esp,%ebp
    subl $4,%esp
    movl $0,-4(%ebp) ; //  -4(%ebp) - prima valoare(x)  -  (x,y)    y - eax       || -4(%ebp) - initializat cu 0
    xorl %eax,%eax ; // eax - 0 (iterator)
    movl 8(%ebp),%ecx ; // ecx - nr de cautat
    lea v,%edx ; // edx - vectorul
    movl $1000,%ebx ; // ! schimbat daca se schimba dimensiunile - ebx = len(v)
    loopgetF:
        cmpb %cl,(%edx,%eax,1)
        je get_gasitF
        addl $1,%eax
        cmp %eax,%ebx
        jle nu_exista_getF
        jmp loopgetF


    get_gasitF:
        movl %eax,-4(%ebp)
        addl $1,%eax
        for_loop_gasitF:
            cmpb %cl,(%edx,%eax,1)
            jne get_gataF
            addl $1,%eax
            cmp %eax,%ebx
            jle get_gataF
            jmp for_loop_gasitF
        get_gataF:
            subl $1,%eax
            jmp get_printareF



    nu_exista_getF:
        xorl %eax,%eax

    get_printareF:
        pushl %eax
        pushl -4(%ebp)
        pushl 8(%ebp)
        pushl $formatAdunare
        call printf
        popl %eax
        popl %eax
        popl %eax
        popl %eax


    get_finalF:
        addl $4,%esp
        popl %ebp
        ret

adaugare_mare:
    ; // 1 parametru - nr de citiri
    pushl %ebp
    movl %esp,%ebp ; // 8(%ebp) = n (nr de numere)
    subl $8,%esp
    loop_adaugare:
    movl $0,-4(%ebp) ; // -4(%ebp) - x (nr de pus)
    movl $0,-8(%ebp) ; // -8(%ebp) - y (nr de biti)

    ; // Citire X
    lea -4(%ebp),%ecx
    pushl %ecx
    pushl $formatCitire
    call scanf
    popl %ecx
    popl %ecx

    ; // Citire Y
    lea -8(%ebp),%ecx
    pushl %ecx
    pushl $formatCitire
    call scanf
    popl %ecx
    popl %ecx

    pushl -4(%ebp)
    pushl -8(%ebp)
    call adauga
    popl %ecx
    popl %ecx


    subl $1,8(%ebp)
    cmp $0,8(%ebp)
    jle admare_exit
    jmp loop_adaugare





    admare_exit:
        addl $8,%esp
        popl %ebp
        ret


defrag:
    ; // 0 - var 
    pushl %ebp
    movl %esp,%ebp
    defrag_cont:
    xorl %esi,%esi ; // esi este un ok = 0
    movl $1,%eax ; // eax este un iterator | !! incepe de la 1
    movl $1000,%ebx ; // ebx - max vectorului !! schimbat la dim mai mari
    lea v , %edx ; // edx - vectorul
    defrag_loop:
        cmpb $0,-1(%edx,%eax,1)
        jne nu_schimba
        cmpb $0,(%edx,%eax,1)
        je nu_schimba
        ; // daca trebuie schimbat
        movl $1,%esi ; // ok = 1
        xorl %ecx,%ecx
        movb (%edx,%eax,1),%cl ; // ecx = nr pe poz curenta
        movb %cl,-1(%edx,%eax,1)
        movb $0,(%edx,%eax,1) ; // interschimbare v[i-1] - v[i] 

        nu_schimba:
        addl $1,%eax
        cmp %eax,%ebx
        jle defrag_exit
        jmp defrag_loop
        



    defrag_exit:
        cmp $0,%esi
        jne defrag_cont ; // daca ok = 1 se reface algoritmul
        call printarefull
        popl %ebp
        ret


stergere:
    ; // 1 parametru - nr de sters
    pushl %ebp
    movl %esp,%ebp ; // 8(%ebp) - nr de sters
    lea v,%edx ; // edx - vectorul
    xorl %eax,%eax ; // eax - it init cu 0
    movl $1000,%ebx ; // ebx-val max - schimba daca se schimba memoria !!
    movl 8(%ebp),%ecx ; // ecx - nr de sters 
    stergere_loop:
        cmp %eax,%ebx
        jle stergere_fin
        cmpb %cl,(%edx,%eax,1) ; // un if - conditia de a sterge
        jne nu_sterge
        movb $0,(%edx,%eax,1)
        nu_sterge:
        addl $1,%eax
        jmp stergere_loop


    stergere_fin:
        call printarefull
        popl %ebp
        ret



printarefull:
    pushl %ebp
    movl %esp,%ebp
    xorl %eax,%eax ; // eax - iterator de la 0 la 999
    movl $1000,%ebx ; // ! schimbat daca se schimba dimensiunile - ebx = len(v)
    lea v , %edx ; // edx - vectorul

    print_loop_gasire:
        cmp %eax,%ebx
        jle printarefull_exit
        cmpb $0,(%edx,%eax,1)
        jne printfull_gasit
        addl $1,%eax
        jmp print_loop_gasire

    printfull_gasit:
        xorl %ecx,%ecx
        movb (%edx,%eax,1),%cl ; // ecx - nr gasit in vector

        pushl %ecx
        call getF
        popl %ecx ; // printare 

        addl $1,%eax
        movl $1000,%ebx
        lea v , %edx
        jmp print_loop_gasire ; // ne intoarcem cu eax pus dupa sirul gasit
        

    printarefull_exit:
        popl %ebp
        ret

get:
    ; // 1 parametru - id
    ; // ret (0,0) daca nu exista - si ret (prim val,ult val) daca exista
    pushl %ebp ; // 8(%ebp) - nr de cautat
    movl %esp,%ebp
    subl $4,%esp
    movl $0,-4(%ebp) ; //  -4(%ebp) - prima valoare(x)  -  (x,y)    y - eax       || -4(%ebp) - initializat cu 0
    xorl %eax,%eax ; // eax - 0 (iterator)
    movl 8(%ebp),%ecx ; // ecx - nr de cautat
    lea v,%edx ; // edx - vectorul
    movl $1000,%ebx ; // ! schimbat daca se schimba dimensiunile - ebx = len(v)
    loopget:
        cmpb %cl,(%edx,%eax,1)
        je get_gasit
        addl $1,%eax
        cmp %eax,%ebx
        jle nu_exista_get
        jmp loopget


    get_gasit:
        movl %eax,-4(%ebp)
        addl $1,%eax
        for_loop_gasit:
            cmpb %cl,(%edx,%eax,1)
            jne get_gata
            addl $1,%eax
            cmp %eax,%ebx
            jle get_gata
            jmp for_loop_gasit
        get_gata:
            subl $1,%eax
            jmp get_printare



    nu_exista_get:
        xorl %eax,%eax

    get_printare:
        pushl %eax
        pushl -4(%ebp)
        pushl $format_get
        call printf
        popl %eax
        popl %eax
        popl %eax



    get_final:
        addl $4,%esp
        popl %ebp
        ret


adauga:
    ; // 2 parametrii - nr de adaugat + lungimea  ex:(5,20) - se folosesc 20/8 = 2,5 - se vor folosi 3 bytes pt reprezentare (5,5,5,0,0,0,...)
    ; // nr de adaugat - 12(%ebp)  || nr de biti 8(%ebp)
    pushl %ebp
    movl %esp,%ebp
    xorl %edx,%edx
    movl 8(%ebp),%eax
    movl $8,%ecx
    divl %ecx ; // impartim (edx,eax) / 8   -- edx - restul si in eax - catul
    cmp $0,%edx
    je ifimpartireperfecta
    addl $1,%eax
    ifimpartireperfecta: ; // eax - contine nr de blockuri de care avem nevoie
    lea v , %edx ; // edx -o sa aibe vectorul
    xorl %ecx,%ecx ; // ecx - iterator cu val 0 - pana la 999
    movl $1000,%ebx ; // !!! probabil trebuie schimbat daca schimbam dimensiunile
    subl %eax,%ebx ; // ebx - nr la care trebuie sa ne oprim din cautare

    cautarezero:
        cmpb $0,(%edx,%ecx,1)
        je gasit
        addl $1,%ecx
        cmp %ebx,%ecx
        jg nuexista
        jmp cautarezero

    gasit:
        movl %ecx,%esi
        addl %eax,%esi
        subl $1,%esi ; // esi - ultima val pe care trebuie sa o verificam
        loopesi:
            cmp %esi,%ecx
            je punere
            cmpb $0,(%edx,%esi,1)
            jne maiincearca
            subl $1,%esi
            jmp loopesi

    punere:
        addl %ecx,%eax
        subl $1,%eax
        movl 12(%ebp),%ebx

        pushl %eax ; // printare
        pushl %ecx
        pushl %ebx
        pushl $formatAdunare
        call printf
        popl %ebx
        popl %ebx
        popl %ecx
        popl %eax

        lea v , %edx ; // edx a fost sters de print - l-am repus

        propriuzis:
            cmp %eax,%ecx
            jg final
            mov %bl,(%edx,%ecx,1)
            addl $1,%ecx
            jmp propriuzis


        jmp final

    maiincearca:
        addl %eax,%ecx
        subl $2,%ecx
        jmp cautarezero

    nuexista:
        pushl $0
        pushl $0
        pushl 12(%ebp)
        pushl $formatAdunare
        call printf
        popl %eax
        popl %eax
        popl %eax
        popl %eax

    final:
        popl %ebp
        ret

main:
    ; // fisiere intre 1 si 255 - 254 total (2^8 - 2)
    
    ; // Citire n
    pushl $n
    pushl $formatCitire
    call scanf
    popl %ecx
    popl %ecx

    forLoopMare:
        ; // Verif while n
        movl n,%eax
        cmp $0,%eax
        jle et_exit
        subl $1,n

        ; // citirea lui X
        pushl $x
        pushl $formatCitire
        call scanf
        popl %ecx
        popl %ecx

        movl x,%eax

        cmp $1,%eax
        je MainAdd
        
        cmp $2,%eax
        je MainGet

        cmp $3,%eax
        je MainStergere

        jmp MainDefrag


    MainAdd:
        ; // Citire - nr de numere
        pushl $x
        pushl $formatCitire
        call scanf
        popl %ecx
        popl %ecx

        pushl x
        call adaugare_mare
        popl %ecx
        jmp forLoopMare

    MainGet:
        ; // Citire - nr de gasit
        pushl $x
        pushl $formatCitire
        call scanf
        popl %ecx
        popl %ecx

        pushl x
        call get
        popl %ecx
        jmp forLoopMare

    MainStergere:
        ; // Citire - nr de numere
        pushl $x
        pushl $formatCitire
        call scanf
        popl %ecx
        popl %ecx

        pushl x
        call stergere
        popl %eax
        jmp forLoopMare

    MainDefrag:
        call defrag
        jmp forLoopMare

    et_exit:
    movl $1, %eax
    movl $0, %ebx
    int $0x80