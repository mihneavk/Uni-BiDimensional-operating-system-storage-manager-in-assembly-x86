.data
    ; // var globale
    v: .space 1000000
    formatMare: .asciz "%d: ((%d, %d), (%d, %d))\n"
    formatMic: .asciz "((%d, %d), (%d, %d))\n"
    formatCitire: .asciz "%ld"
    n: .space 4
    x: .space 4

.text
.global main


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


numarare:
    ;// 1 param - nr de cautat
    pushl %ebp
    movl %esp,%ebp ; // 8(%ebp) - id-ul pe care in vrem
    movl $-1,%ebx ; // - ebx iterator
    xorl %eax,%eax ; // - eax - tot gasit
    lea v,%edx
    farazero:
        cmp $999999,%ebx
        jge numarare_exit
        addl $1,%ebx
        xorl %ecx,%ecx
        movb (%edx,%ebx,1),%cl
        cmpl %ecx,8(%ebp)
        je gasitNumarare
        jmp farazero

    gasitNumarare:
        addl $8,%eax
        addl $1,%ebx
        xorl %ecx,%ecx
        movb (%edx,%ebx,1),%cl
        cmpl %ecx,8(%ebp)
        jne numarare_exit
        jmp gasitNumarare


    numarare_exit:
        popl %ebp
        ret


stergereMut:
    ; // 1 parametru - nr de sters
    pushl %ebp
    movl %esp,%ebp ; // 8(%ebp) - nr de sters
    lea v,%edx ; // edx - vectorul
    xorl %eax,%eax ; // eax - it init cu 0
    movl $1000000,%ebx ; // ebx-val max - schimba daca se schimba memoria !!
    movl 8(%ebp),%ecx ; // ecx - nr de sters 
    stergere_loopM:
        cmp %eax,%ebx
        jle stergere_finM
        cmpb %cl,(%edx,%eax,1) ; // un if - conditia de a sterge
        jne nu_stergeM
        movb $0,(%edx,%eax,1)
        nu_stergeM:
        addl $1,%eax
        jmp stergere_loopM


    stergere_finM:
        ; // FARA PRINTARE
        popl %ebp
        ret


adaugaMut:
    ; // 2 parametrii - nr de adaugat + lungimea  ex:(5,20) - se folosesc 20/8 = 2,5 - se vor folosi 3 bytes pt reprezentare (5,5,5,0,0,0,...)
    ; // nr de adaugat - 12(%ebp)  || nr de biti 8(%ebp)
    pushl %ebp
    movl %esp,%ebp
    xorl %edx,%edx
    movl 8(%ebp),%eax
    movl $8,%ecx
    divl %ecx ; // impartim (edx,eax) / 8
    cmp $0,%edx
    je ifimpartireperfectaM
    addl $1,%eax
    ifimpartireperfectaM: ; // eax - contine nr de blockuri de care avem nevoie
    lea v , %edx ; // edx -o sa aibe vectorul
    xorl %ecx,%ecx ; // ecx - iterator cu val 0 - pana la 999
    movl $1000,%ebx ; // !!! probabil trebuie schimbat daca schimbam dimensiunile
    subl %eax,%ebx ; // ebx - nr la care trebuie sa ne oprim din cautare

    cautarezeroM:
        cmp %ebx,%ecx
        jg nuexistaM
        cmpb $0,(%edx,%ecx,1)
        je gasitM
        addl $1,%ecx
        jmp cautarezeroM

    gasitM:
        movl %ecx,%esi
        addl %eax,%esi
        subl $1,%esi ; // esi - ultima val pe care trebuie sa o verificam
        loopesiM:
            cmp %esi,%ecx
            je punereM
            cmpb $0,(%edx,%esi,1)
            jne maiincearcaM
            subl $1,%esi
            jmp loopesiM

    punereM:
        addl %ecx,%eax
        subl $1,%eax
        movl 12(%ebp),%ebx


        propriuzisM:
            cmp %eax,%ecx
            jg finalM
            mov %bl,(%edx,%ecx,1)
            addl $1,%ecx
            jmp propriuzisM


        jmp finalM

    maiincearcaM:
        addl %eax,%ecx
        subl $2,%ecx
        jmp cautarezeroM

    nuexistaM:
        addl %eax,%ecx ; // daca nu exista pe linia curenta se trece pe urmatoarea
        subl $1,%ecx
        addl $1000,%ebx
        cmp $1000000,%ecx ; // mai trebuie testat daca asta e comparatia buna !
        jge finalM
        jmp cautarezeroM

    finalM:
        ; // fara printare
        
        popl %ebp
        ret


defrag:
    ; // 0 - parametrii
    ; // gasim toate nr care apar si le dam stergereMut si adaugaMut
    pushl %ebp
    movl %esp,%ebp
    xorl %esi,%esi ; // esi - index icepe la 0 || putem pune de la 0 si nu de la -1 pt ca fiecare fisier e asigurat sa fie pe min 2 blockuri
    subl $8,%esp
    movl $0,-4(%ebp) ; // -4(%ebp) - ultimul nr pus
    movl $0,-8(%ebp) ; // -8(%ebp) - var locala folosita mai tarziu pt memorare
    lea v,%edx ; // edx -vectorul
    loopDefrag:
        cmp $999999,%esi ; // esi = 999999 => esi = 1000000
        jge defrag_fin

        addl $1,%esi
        cmpb $0,(%edx,%esi,1)
        je loopDefrag
        movl -4(%ebp),%ebx
        cmpb %bl,(%edx,%esi,1)
        je loopDefrag

        ; // inseamna ca e un nr nou
        xorl %ebx,%ebx
        movb (%edx,%esi,1),%bl
        movl %ebx,-4(%ebp)

        ; //  STERGERE + ADAUGARE - ne folosim de o numarare
        pushl -4(%ebp)
        call numarare ; // in eax - nr de kB pt a apela comanda adaugaMut
        popl %ebx

        movl %eax,-8(%ebp) ; // -8(%ebp) - ne de kB

        pushl -4(%ebp)
        call stergereMut
        popl %eax

        pushl -4(%ebp)
        pushl -8(%ebp)
        call adaugaMut
        popl %eax
        popl %eax


        ; // !!!!!!!!!
        lea v,%edx
        jmp loopDefrag


    defrag_fin:
        call printareFull
        addl $8,%esp
        popl %ebp
        ret


stergere:
    ; // 1 parametru - nr de sters
    pushl %ebp
    movl %esp,%ebp ; // 8(%ebp) - nr de sters
    lea v,%edx ; // edx - vectorul
    xorl %eax,%eax ; // eax - it init cu 0
    movl $1000000,%ebx ; // ebx-val max - schimba daca se schimba memoria !!
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
        call printareFull
        popl %ebp
        ret

printareFull:
    pushl %ebp
    movl %esp,%ebp
    subl $4,%esp
    movl $0,-4(%ebp) ; // -4(%ebp) - numarul curent pe care trebuie sa nu il luam
    movl $-1,%esi ; // esi - iterator incepe la 0 se temina la 1000000
    lea v , %edx ; // edx - vectorul
    loopPrintFull:
        cmp $999999,%esi ; //cand esi compara pt 999999 - esi este de fapt 1000000
        jge printareFull_final

        addl $1,%esi
        cmpb $0,(%edx,%esi,1)
        je loopPrintFull
        movl -4(%ebp),%ebx
        cmpb %bl,(%edx,%esi,1)
        je loopPrintFull

        ; // daca am gasit un id bun

        xorl %ebx,%ebx
        movb (%edx,%esi,1),%bl ; // ebx - nr de inceput de id
        movl %ebx, -4(%ebp)
        pushl %ebx
        call getF
        popl %ebx
        ; // dupa getf - pierd edx - trebuie reatribuire - esi ramane
        lea v , %edx



        jmp loopPrintFull




    printareFull_final:
        addl $4,%esp
        popl %ebp
        ret


get:
    ; // exact ca getF - dar pe format mic

    ; // 
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
    movl $1000000,%ebx ; // ! schimbat daca se schimba dimensiunile - ebx = len(v)
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
        pushl 8(%ebp)
        call printMic
        popl %eax
        popl %eax
        popl %eax


    get_final:
        addl $4,%esp
        popl %ebp
        ret


printMic:
    ; // 8(%ebp) - id  || 12(%ebp) - x || 16(%ebp) - y || (x,y)
    ; // ca printMare , dar fara id
    pushl %ebp
    movl %esp,%ebp
    xorl %eax,%eax ; // eax = 0 (iteratorul de linii)

    loopPrintMic:
        movl 12(%ebp),%ecx
        cmp $1000,%ecx
        jl PrintMicGata
        subl $1000,12(%ebp)
        subl $1000,16(%ebp)
        addl $1,%eax
        jmp loopPrintMic



    PrintMicGata:
        ; // ((eax,x),(eax,y))
        pushl 16(%ebp)
        pushl %eax
        pushl 12(%ebp)
        pushl %eax
        pushl $formatMic
        call printf
        popl %eax 
        popl %eax 
        popl %eax 
        popl %eax 
        popl %eax 



    printMicFin:
        popl %ebp
        ret


printMare:
    ; // 8(%ebp) - id  || 12(%ebp) - x || 16(%ebp) - y || (x,y)
    pushl %ebp
    movl %esp,%ebp
    xorl %eax,%eax ; // eax = 0 (iteratorul de linii)

    loopPrintMare:
        movl 12(%ebp),%ecx
        cmp $1000,%ecx
        jl PrintMareGata
        subl $1000,12(%ebp)
        subl $1000,16(%ebp)
        addl $1,%eax
        jmp loopPrintMare



    PrintMareGata:
        ; // (id: (eax,x),(eax,y))
        pushl 16(%ebp)
        pushl %eax
        pushl 12(%ebp)
        pushl %eax
        pushl 8(%ebp)
        pushl $formatMare
        call printf
        popl %eax
        popl %eax 
        popl %eax 
        popl %eax 
        popl %eax 
        popl %eax 



    printMareFin:
        popl %ebp
        ret



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
    movl $1000000,%ebx ; // ! schimbat daca se schimba dimensiunile - ebx = len(v)
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
        call printMare
        popl %eax
        popl %eax
        popl %eax


    get_finalF:
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
    divl %ecx ; // impartim (edx,eax) / 8
    cmp $0,%edx
    je ifimpartireperfecta
    addl $1,%eax
    ifimpartireperfecta: ; // eax - contine nr de blockuri de care avem nevoie
    lea v , %edx ; // edx -o sa aibe vectorul
    xorl %ecx,%ecx ; // ecx - iterator cu val 0 - pana la 999
    movl $1000,%ebx ; // !!! probabil trebuie schimbat daca schimbam dimensiunile
    subl %eax,%ebx ; // ebx - nr la care trebuie sa ne oprim din cautare

    cautarezero:
        cmp %ebx,%ecx
        jg nuexista
        cmpb $0,(%edx,%ecx,1)
        je gasit
        addl $1,%ecx
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
        addl %eax,%ecx ; // daca nu exista pe linia curenta se trece pe urmatoarea
        subl $1,%ecx
        addl $1000,%ebx
        cmp $1000000,%ecx ; // mai trebuie testat daca asta e comparatia buna !
        jge final
        jmp cautarezero

    final:
        ; // printare cu getF al elementului 12(%ebp)
        pushl 12(%ebp)
        call getF
        popl %ebx

        ; // /////////////////////
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
