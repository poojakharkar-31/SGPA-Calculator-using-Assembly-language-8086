
TITLE "SGPA Calculator"

.MODEL small
.STACK 256
.DATA              

    ; Declaring some string and variables in order to use further...
     newline DB 0DH,0AH,"$"
     welcome DB "********** Welcome to the SGPA Calculator ***********$"
     thanks DB 0DH,0AH,0DH,0AH,"Thanks for using our program. See you again... $"
     ask DB 0DH,0AH,0DH,0AH,"Now What you want to do?",
         
          DB 0DH,0AH,"1- Exit ",0DH,0AH," $"
     invalid_ DB 0DH,0AH,"Your input is not valid. Please enter a valid input $"
     subject DB 0DH,0AH,0DH,0AH,"How many subjects do you have in your semester?",0DH,0AH," $"
     grade DB 0DH,0AH,0DH,0AH,"Enter the grade of subject $"
     invalidG DB 0DH,0AH,"The grade you entered is invalid. Please enter a valid grade  $"
     invalid DB 0DH,0AH,"Your input is not valid please enter a valid input from 1 to 5.",0DH,0AH," $"
     creditHour DB 0DH,0AH,"Now enter the credits assigned for that subject",0DH,0AH,"$"
     show DB 0AH,0DH,"Your SGPA is :  $"
     nSub DB ?
     i DB ?

     var DB ?,?    
     total DB 0,0
     tch DB 0
     result DB ?,?
     
.CODE
main PROC
     .startup
   ; Display welcome string
     lea dx,welcome
     call displayString
     
   ; Calculating the SGPA...
     GPA:
        mov i,0
      ; Asking for number of subjects
        lea dx,subject
        call displayString
        TakeS:
        call input
      ; Saving number of subjects in cl for comparasion of loop
        mov cl,al
        sub cl,30h
        cmp cl,0               ; 0 is an invalid value
        JE not_valid
        cmp cl,9               ; value greater than 9 is also invalid
        JG not_valid
        Next:  
          ; Increamenting the loop value
            inc i      
           
          ; Asking for grade
            lea dx,grade
            call displayString
            mov dl,i
            add dl,30h
            call displayChr
            lea dx,newline       ; newline
            call displayString
            call input
           
          ; moving grade into bl and computing its gpa value
            mov bl,al
            call compute
           
          ; Taking number of credits assigned to the subject
            lea dx,creditHour
            call displayString
           
            takeC:
                call input
                sub al,30h
                cmp al,0               ; 0 is an invalid value
                JE notvalid
                cmp al,5               ; value greater than 5 is also invalid
                JG notvalid
               
            add tch,al  ; Adding to total credits assigned
            mov bl,al  
           
          ; Multiply subjects grade with credit hours
            call multiply      
           
          ; add subject gpa to total
            call sum          
           
        cmp cl,i        ; Reapet loop untill i becomes cl
        JNE Next      
       
      ; Divide total SGPA by tch to compute the result
        call ComputeResult
       
      ; Displaying the result
        lea dx,show
        call displayString
        mov dl,result
        add dl,30h
        call displayChr
        mov dl,'.'
        call displayChr
        mov bx,0
        mov dl,result+1
        add dl,30h
        call displayChr
        mov dl,result+2
        add dl,30h
        call displayChr
        JMP askForAgain  
       
      ; For invalid credit assigned value...
        notValid:
             lea dx,invalid
             call displayString
             JMP takeC    
             
      ; For invalid number of Subjects...
        not_Valid:
             lea dx,invalid
             call displayString
             JMP takeS          
       
      ; Asking user if he wants to continue or not          
        askForAgain:
             lea dx,ask
             call displayString
             lea dx,newline       ; newline
             call displayString
           
           ; Getting user choice in al
             Choice:
             call input
             ;cmp al,31h
             ;JE GPA
             cmp al,31h
             JE ExitP
             lea dx,invalid_
             call displayString
             JMP Choice
             
       
        ExitP:
             ; Thanks note
             lea dx,thanks
             call displayString    
        .EXIT
main ENDP
ret

; Function to display character value
displayChr PROC
     mov ah,02h
     int 21h
  ret
displayChr ENDP
 
; Displaying string
displayString PROC
     mov ah,09h
     int 21h
   ret
displayString ENDP

; Taking input in al
input PROC
     mov ah,01h
     int 21h    
   ret
input ENDP
 
; Computing sgpa corresponding to a grade
compute PROC
      up:
      cmp bl,'A'
      JE A
      cmp bl,'B'
      JE B
      cmp bl,'C'
      JE C
      cmp bl,'D'
      JE D
      cmp bl,'F'
      JE F
      call invalidGrade      ; Any input other than above will be invalid
      A:
        call input
        cmp al,'+'           ; A+ grade
        JE AA      
        cmp al,0DH           ; A  grade
        JE AA
        cmp al,'-'           ; A- grade
        JE A_
        call invalidGrade    ; If input is other than A+ or A-
      ; For A and A+ SGPA will be 9.8
        AA:
           mov var,9
           mov var+1,8
           JMP Exit
      ; For A- SGPA will be 9.5
        A_:
           mov var,9
           mov var+1,5
           JMP Exit
      B:
        call input
        cmp al,'+'           ; B+ grade
        JE BPositive
        cmp al,'-'           ; B- grade
        JE BNegative
        cmp al,0DH           ; B grade
        JE BB                
        call invalidGrade    ; If input is other than B+ or B-
       
      ; For B grade SGPA will be 8.0  
        BB:
           mov var,8
           mov var+1,0
           JMP Exit                
           
      ; For B+ grade SGPA will be 8.3            
        BPositive:
           mov var,8
           mov var+1,3
           JMP Exit      
           
      ; For B- grade SGPA will be 7.7
        BNegative:
           mov var,7
           mov var+1,7
           JMP Exit
      C:
        call input
        cmp al,'+'          ; C+ grade
        JE CPositive
        cmp al,'-'          ; C- grade
        JE CNegative    
        cmp al,0DH          ; C  grade
        JE CC
        call invalidGrade   ; If input is other than C+ or C-
       
      ; For C grade SGPA will be 6.0  
        CC:
           mov var,6
           mov var+1,0
           JMP Exit  
      ; For C+ grade SGPA will be 6.3          
        CPositive:
           mov var,6
           mov var+1,3
           JMP Exit
      ; For C- grade SGPA will be 5.7
        CNegative:
           mov var,5
           mov var+1,7
           JMP Exit
      D:
        call input          
        cmp al,'+'           ; D+ grade
        JE DPositive        
        cmp al,'-'           ; D- grade
        JE DNegative        
        cmp al,0DH           ; D  grade
        JE DD
        call invalidGrade    ; If input is other than D+ or D-
         
      ; For D grade SGPA will be 4.0  
        DD:
           mov var,4
           mov var+1,0
           JMP Exit
      ; For D+ grade SGPA will be 4.3          
        DPositive:
           mov var,4
           mov var+1,3
           JMP Exit  
      ; For D- grade SGPA will be 3.7
        DNegative:
           mov var,3
           mov var+1,7
           JMP Exit
           
    ; For F grade SGPA will be 2.0
      F:
        mov var,2
        mov var+1,0
        JMP Exit
       
     invalidGrade:  
      ; Asking for a valid grade...
        lea dx,invalidG
        call displayString
        lea dx,newline       ;newline
        call displayString
        call input
        mov bl,al
        JMP up
     
     Exit:
   ret
compute ENDP

; Multiplying subject's sgpa with credit hours
multiply PROC
      mov ax,0h
      mov al,var+1
      mul bl
      mov var+1,al
      mov ax,0h
      mov al,var
      mul bl
      mov var,al
      mov bl,var+1
     
      mov ax,0h
      mov al,var+1
      mov bl,10
      div bl
      cmp al,0
      JE Exit_
        add var,al
        mov var+1,ah
      Exit_:      
   ret
multiply ENDP

; Adding sgpa of all subjects to total...
sum PROC    
      mov bl,var
      add total,bl
      mov bl,var+1
      add total+1,bl
      mov bl,total
     
      mov ax,0h
      mov al,total+1
      mov bl,10
      div bl
      cmp al,0
      JE Exitt
        add total,al
        mov total+1,ah
      Exitt:
  ret
sum ENDP

; Divide total sgpa with total number of credit hours to compute final gpa...
ComputeResult PROC
     mov ax,0h
     mov al,total
     mov bl,tch
     div bl
     mov result,al
     mov al,ah    
     cmp al,0
     JE Skip
     mov ah,0h
     mov cl,10
     mul cl
     mov bl,tch
     div bl
     mov result+1,al
     mov al,ah    
     cmp al,0
     JE Skip
     mov ah,0h
     mov cl,10
     mul cl
     mov bl,tch
     div bl
     mov result+2,al
     Skip:
     
     
  ret
ComputeResult ENDP

           

