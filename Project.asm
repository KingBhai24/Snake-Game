[org 0x0100]
jmp start
oldisr: dd 0
oldtimer: dd 0
Finisher: db 0xb4
flagend: dw 0
flag : dw 0
turn: dw 0
score: dw 0
level: db 0
location: times 20 dw 0
head: db 2
body: db 'O'
soundofmovement: dw 2000
soundofeating: dw 1809
soundofdeath: dw 400
delayofdeath: dw 10
delayofeating: dw 3
delayofmovement: dw 1
snakeattribute: db 0x34
flagtimmer: dw 0
flagkbisr: dw 1			
backgroundspaceandattribute: dw 0x3020 ;background color with space
snaketailstartingpoint: db 30, 12  ;snake's tail starting point coloumn then row
snakelength: db 19  ;length of snake max lenght = 125 = 250 characters
jmpfar: dd 0 ;use for jmp far
interfacechar: db 177
interfaceattribute: db 0x14
fruit: db 3,4,5
makemeatflag: dw 0
updatesnakemmeatcount: dw 0		;use in notailupdate
fruitattribute: db 0xbd
normal: dw 0
gameend: dw 3
gamestart: dw 0
row: db 0		;save row of meat
col: db 0		;save coloumn of meat
speed: dw 10
countmove: dw 0
countspeed: dw 0	
tickcount: dw 0
count: dw 0   	; counter for 1 sec

;////////////////////////////////////////////////

;////////////////////////////////////////////////
won:
;call clrscr
push ax
push di
push es
push cx
push 0xb800
pop es
mov cx,12
mov ah,8
mov al,30
push ax
call calculatelocation
pop di
mov ah,[cs:Finisher]
mov al,21
wonloop:
 mov [es:di],ax
 mov [es:di+22],ax
 add di,160
 loop wonloop
 sub di,160
 add di,4
 mov al,'A'
 mov [es:di],ax
 add di,2
 mov al,'B'
 mov [es:di],ax
 add di,2
 mov al,'S'
 mov [es:di],ax
 add di,2
 mov al,'O'
 mov [es:di],ax
 add di,2
 mov al,'L'
 mov [es:di],ax
 add di,2
 mov al,'U'
 mov [es:di],ax
 add di,2
 mov al,'T'
 mov [es:di],ax
 add di,2
 mov al,'E'
 mov [es:di],ax
 add di,2
 pop cx
 pop es
 pop di
 pop ax
 ret
;////////////////////////////////////////////////

;///////////////////////////////////////////////

Finish:
push ax
push cx
push di
push es
push 0xb800
pop es
mov ah,13
mov al,36
push ax
call calculatelocation
pop di
mov ah,[cs:Finisher]
mov al,'G'
mov [es:di],ax
add di,2
mov al,'A'
mov [es:di],ax
add di,2
mov al,'M'
mov [es:di],ax
add di,2
mov al,'E'
mov [es:di],ax
add di,4
mov al,'O'
mov [es:di],ax
add di,2
mov al,'V'
mov [es:di],ax
add di,2
mov al,'E'
mov [es:di],ax
add di,2
mov al,'R'
mov [es:di],ax
add di,2
pop es
pop di
pop cx
pop ax
ret

;////////////////////////////////////////////////

;////////////////////////////////////////////////
printtime:
push ax
push cx
push dx
push di
push es
push 0xb800
pop es
mov di, 130
mov ah, [cs:backgroundspaceandattribute+1]
mov al, 'T'
mov [es:di], ax
add di, 2
mov al, 'i'
mov [es:di], ax
add di, 2
mov al, 'm'
mov [es:di], ax
add di, 2
mov al, 'e'
mov [es:di], ax
add di, 2
mov al, ' '
mov [es:di], ax
add di, 2
mov ax, [cs:tickcount]
mov cl, 60
div cl
mov dh, 0
mov dl, ah
mov cx, 3
sub cx, ax
mov ax, cx
add al, 0x30
mov ah, [cs:backgroundspaceandattribute + 1]
mov [es:di], ax
add di, 2
mov al, ':'
mov [es:di], ax
add di, 2
cmp dl, 49
ja lessthan10
mov ah, 0
mov cx, 59
sub cx, dx
mov dx, cx
mov al, dl
mov cl, 10
div cl
mov dh, ah
mov cx, 59
sub cx, ax
mov cx, ax
add al, 0x30
mov ah, [cs:backgroundspaceandattribute + 1]
mov [es:di], ax
add di, 2
mov al, dh
add al, 0x30
mov [es:di], ax
jmp exitprinttime
lessthan10:
mov al, '0'
mov [es:di], ax
add di, 2
mov al, dl
mov cx, 59
sub cx, ax
mov ax, cx
add al, 0x30
mov ah, [cs:backgroundspaceandattribute + 1]
mov [es:di], ax
exitprinttime:
pop es
pop di
pop dx
pop cx
pop ax
ret
;/////////////////////////////////////

;/////////////////////////////////////
showlife:
push ax
push es
push 0xb800
pop es
mov ah,[cs:backgroundspaceandattribute+1]
mov al,'L'
mov word[es:2],ax
mov al,'i'
mov word[es:4],ax
mov al,'f'
mov word[es:6],ax
mov al,'e'
mov word[es:8],ax
mov al,':'
mov word[es:10],ax
mov al,[cs:gameend]
add al,0x30
mov word[es:12],ax
pop es
pop ax
ret
;///////////////////////////

;//////////////////////////
makebeep:
push bp
mov bp,sp
push ax
push bx
push cx
mov al,182			;ready our system's speaker
out 43h,al
mov ax,[ss:bp+4]	;sound frequency
out 42h,al
mov al,ah
out 42h,al
in al,61h
or al,00000011b
out 61h,al
mov bx,[bp+6]  		;delay of sound
delay1:
mov cx,65535
delay2:
dec cx
jne delay2
dec bx
jne delay1
in al,61h
and al,11111100b
out 61h,al 
pop cx
pop bx
pop ax
pop bp
ret 4
;////////////////////////

;////////////////////////
showscore:
push ax
push di
push es
mov ah,2
mov al,35
push ax
call calculatelocation
pop di
push 0xb800
pop es
mov ah,[cs:backgroundspaceandattribute+1]
mov al,'S'
mov [es:di],ax
add di,2
mov al,'c'
mov [es:di],ax
add di,2
mov al,'o'
mov [es:di],ax
add di,2
mov al,'r'
mov [es:di],ax
add di,2
mov al,'e'
mov [es:di],ax
add di,2
mov al,':'
mov [es:di],ax
add di,2
push word[cs:score]
call printnum
pop es
pop di
pop ax
ret
;/////////////////////////

;/////////////////////////
printnum: 
 push bp
 mov bp, sp
 push es
 push ax
 push bx
 push cx
 push dx
 push di
 mov ax, 0xb800
 mov es, ax ; point es to video base
 mov ax, [bp+4] ; load number in ax
 mov bx, 10 ; use base 10 for division
 mov cx, 0 ; initialize count of digits
nextdigit: mov dx, 0 ; zero upper half of dividend
 div bx ; divide by 10
 add dl, 0x30 ; convert digit into ascii value
 push dx ; save ascii value on stack
 inc cx ; increment count of values
 cmp ax, 0 ; is the quotient zero
 jnz nextdigit ; if no divide it again
 mov dh,2
 mov dl,42
 push dx
 call calculatelocation
 pop di
 nextpos: pop dx ; remove a digit from the stack
 mov dh, [cs:backgroundspaceandattribute+1] ; use normal attribute
 mov [es:di], dx ; print char on screen
 add di, 2 ; move to next screen location
 loop nextpos ; repeat for all digits on stack
 pop di
 pop dx
 pop cx
 pop bx
 pop ax
 pop es
 pop bp
 ret 2 
;/////////////////////////////

;/////////////////////////////
clrscr:
 push es
 push ax
 push cx
 push di
 mov ax, 0xb800
 mov es, ax ; point es to video base
 xor di, di ; point di to top left column
 mov ax, [cs:backgroundspaceandattribute] ; space char in normal attribute
 mov cx, 2000 ; number of screen locations
 cld ; auto increment mode
 rep stosw ; clear the whole screen
 pop di
 pop cx
 pop ax
 pop es
 ret
;////////////////////////////////////

;/////////////////////////
Interface:
 push ax
 push cx
 push di
 push es
 push 0xB800
 pop es
 mov ah, [interfaceattribute]
 mov al, [interfacechar]
 mov cx, 80
 mov di, 480
interfaceloop1:
 mov [es:di], ax
 mov [es:di + 3360], ax
 add di, 2
 loop interfaceloop1
 mov cx, 22
 mov di, 480
interfaceloop2:
 mov [es:di], ax
 mov [es:di + 158], ax
 add di, 160
 loop interfaceloop2
 cmp byte[cs:level],1
 jne nextlevel
 mov word[cs:makemeatflag],0
 mov word[cs:count],0
 mov ch,10
 mov cl,20
 push cx
 call calculatelocation
 pop di
 mov cx,30
 interfaceloop3:
 mov [es:di],ax
 mov [es:di+960],ax
 add di,2
 loop interfaceloop3
 nextlevel:
 cmp byte[cs:level],2
 jne EndLevel
 mov word[cs:makemeatflag],0
 mov word[cs:count],0
 mov ch,12
 mov cl,4
 push cx
 call calculatelocation
 pop di
 mov cx,12
 interface4:
 mov [es:di],ax
 mov [es:di+118],ax
 add di,2
 loop interface4
 mov ch,8
 mov cl,10
 push cx
 call calculatelocation
 pop di
 mov cx,9
 interface5:
 mov [es:di],ax
 mov [es:di+118],ax
 add di,160
 loop interface5
 jne EndLevel
 call won
 EndLevel:
 inc byte[cs:level]
 pop es
 pop di
 pop cx
 pop ax
 ret
 ;//////////////////////////////////////////
 
 ;//////////////////////////////////////////
GetRandomNumber:
 push bp
 mov bp,sp
 push ax
 mov al,00
 out 0x70,al
 jmp D1
 D1: in al,0x71
 mov ah,0
 mov [ss:bp+4],ax
 pop ax
 pop bp
 ret
 makemeat:		 ; make a meat on random place
 push bx
 push ax
 push cx
 push di
 GetANumber:
 push 0
 call GetRandomNumber
 pop ax
 mov cl,20
 div cl
 add ah,4
 mov [cs:row],ah
 xor ax,ax
 push 0
 call GetRandomNumber
 pop ax
 mov cl,78
 div cl
 add ah,1
 mov [cs:col],ah
 push 0xb800
 pop es
 mov al,[cs:row]
 mov cl,80
 mul cl
 mov cl,[cs:col]
 mov ch,0
 add ax,cx
 shl ax,1
 mov di,ax
 mov ax,[cs:backgroundspaceandattribute]
 cmp word[es:di],ax
 jne GetANumber
 push 0
 call GetRandomNumber
 pop ax
 mov cl,3
 div cl
 mov al,ah
 mov ah,0
 mov bx,ax
 mov al,[cs:fruit+bx]
 mov ah,[cs:fruitattribute]
 mov [es:di],ax
 pop di
 pop cx
 pop ax
 pop bx
 ret
;////////////////////////////

;////////////////////////
kbisr: 
 push ax
 cmp word[cs:flagkbisr],1		;whether we have to update the flag or not
 jne exit1 
 in al,0x60
 cmp word [cs:flag], 0
 jne nextcmp
 entercmp:
 cmp al, 0x1C
 jne exit1
 mov word[cs:flag],3
 mov word[cs:gamestart],1
 jmp Exit
 nextcmp:
 cmp al, 0x48   ;up
 jne nextcmp1
 cmp word [cs:flag], 2
 je exit1
 mov word [cs:flag], 1
 mov word[cs:flagkbisr],0
 mov word[cs:flagtimmer],0
 jmp exit1
nextcmp1:
 cmp al, 0x50   ;down
 jne nextcmp2
 cmp word [cs:flag], 1
 je exit1
 mov word [cs:flag], 2
 mov word[cs:flagkbisr],0
  mov word[cs:flagtimmer],0
 exit1:
 jmp exit2
nextcmp2:
 cmp al, 0x4D  ;right
 jne nextcmp3
 cmp word [cs:flag], 4
 je exit2
 mov word[cs:flag],3
 mov word[cs:flagkbisr],0
  mov word[cs:flagtimmer],0
  exit2:
 jmp Exit
nextcmp3:
 cmp al, 0x4B ;left
 jne Exit
 cmp word [cs:flag], 3
 je Exit
 mov word [cs:flag], 4
 mov word[cs:flagkbisr],0
  mov word[cs:flagtimmer],0
Exit:
 pop ax
 jmp far[cs:oldisr]
 ;////////////////////////////
 
 ;///////////////////////////
timer:
 push ax
 push bx
 cmp word [cs:gameend], 0
 je A
 cmp word[cs:flagtimmer],0
 jne A
 cmp word [cs:gamestart],0
 je A
 inc word[cs:count]
 cmp word[cs:count],18
 jne normalflow
 mov word[cs:count],0
 call printtime
 inc word[cs:tickcount]
 call checktimereset
 cmp word [cs:gameend], 0
 je A
 jmp normalflow
 A:
 jmp exittimer
 normalflow:
 mov bx,[cs:speed]
 cmp bx,0
 je noincrement
 inc word[cs:countmove]
 inc word[cs:countspeed]
 cmp [cs:countmove],bx
 jne checkspeed 
 noincrement:
 push word[cs:delayofmovement]
 push word[cs:soundofmovement]
 call makebeep
 call updatesnake
 call checkmeateat
 call noupdatetailcount
 checkspeed:
 cmp word[cs:countspeed],364
 jne exittimer
 cmp word[cs:speed],0
 je exittimer
 sub word[cs:speed],2
 mov word[cs:countmove],0
 mov word[cs:countspeed],0
exittimer:
 mov al,0x20
 out 0x20,al
 pop bx
 pop ax
 iret
 ;//////////////////////////
 ;////////////////////////
 checktimereset:
 cmp word [cs:tickcount], 240
 jne exitchecktimereset
 dec word [cs:gameend]
 push word[cs:delayofdeath]
 push word[cs:soundofdeath]
 call makebeep
 call showlife
 mov word [cs:tickcount], 0
 exitchecktimereset:
 ret
;///////////////////////////
 
;///////////////////////////
calculatelocation: ;takes row and coloumn and return byte number
 push bp
 mov bp, sp
 push ax
 push cx
 mov ah, 0
 mov ch, 0
 mov cl, 80
 mov al, [ss:bp + 5]; row
 mul cl
 mov cl, [ss:bp + 4]
 mov ch, 0
 add ax, cx
 shl ax, 1
 mov [bp + 4], ax
 pop cx
 pop ax
 pop bp
 ret
;////////////////////////////

;////////////////////////////
TurnCase:    ;saves turning position
 push ax
 push bx
 mov bx, 2
l1: 
 add bx, 2
 cmp word [cs:location + bx], 0
 jne l1
 mov ax, [cs:location + 2]
 mov [cs:location + bx], ax
 pop bx
 pop ax
 ret
;//////////////////////

;/////////////////////
updatelocation:  ;whenever tail approches first turn point it updates array
 push ax
 push bx
 mov bx, 4
 mov ax, 1
updatelocationloop:
 cmp ax, 0
 je exitupdatelocation
 mov ax, [cs:location + bx + 2] ;second turn point
 mov [cs:location + bx], ax ;replace first turn point with second
 add bx, 2
 jmp updatelocationloop
exitupdatelocation:
 pop bx
 pop ax
 ret
;/////////////////////////

;////////////////////////
noupdatetailcount:
cmp word [cs:makemeatflag],1
jne noupdatetailexit
cmp word[cs:updatesnakemmeatcount],4
je makezero
inc word[cs:updatesnakemmeatcount]
jmp noupdatetailexit
makezero:
mov word[cs:updatesnakemmeatcount],0
mov word[cs:makemeatflag],0
noupdatetailexit:
ret
;////////////////////////

;////////////////////////
updatetail:
 push dx
restartupdatetail:
 mov dl, [cs:location + 4] ;row of first turn point
 mov dh, [cs:location + 5] ;coloumn of first turn point
 cmp [cs:location], dl  ;compare row of first turnpoint with row of tail
 je leftright
 cmp [cs:location + 1], dh ;compare coloumn of first turn point with coloumn of tail
 je updown
leftright:
 cmp [cs:location  + 1], dh ;compare coloumn of first turnpoint with tail
 ja left
 jb right
 call updatelocation 
 cmp word [cs:location + 4] ,0 ;check first turn point after updating array
 jne restartupdatetail
 jmp exitupdatetail
left:
 sub word [cs:location + 1] ,1
 mov word [cs:normal], 1
 jmp exitupdatetail
right:
 add word [cs:location + 1], 1 
 mov word [cs:normal], 1
 jmp exitupdatetail
updown:
 cmp [cs:location], dl
 ja up
 jb down
 call updatelocation
 cmp word [cs:location + 4] ,0
 jne restartupdatetail
 jmp exitupdatetail
up:
 sub word [cs:location], 1
 mov word [cs:normal], 1
 jmp exitupdatetail
down:
 add word [cs:location], 1
 mov word [cs:normal], 1
exitupdatetail:
 pop dx
 ret
;///////////////////////////
 
;//////////////////////////
removetail:
 push ax
 push di
 mov ah, [cs:location]  ;row of tail
 mov al, [cs:location + 1]  ;coloumn of tail
 push ax
 call calculatelocation
 pop di
 mov ax, [cs:backgroundspaceandattribute] ;space with white background
 mov [es:di], ax
 pop di
 pop ax
 ret
 ;///////////////////////
 
 ;///////////////////////
replaceheadwithbody: ;returns head location
 push bp
 mov bp, sp
 push ax
 push di
 mov ah,[cs:location + 2]  ;row of head
 mov al,[cs:location + 3]  ;coloumn of head
 push ax
 call calculatelocation
 pop di
 mov ah, [cs:snakeattribute]  ;red colour
 mov al, [cs:body]
 mov [es:di], ax
 mov [ss:bp + 4], di
 pop di
 pop ax
 pop bp
 ret
;//////////////////////////

;///////////////////
makesnake:   ;create stationary snake
 call clrscr ; call clrscr subroutine
 push ax
 push cx
 push di
 push es
 push 0xb800
 pop es
 mov cx,20
 mov di,0
 makelocationzero:
 mov word[cs:location+di],0
 add di,2
 loop makelocationzero
 mov ax, [cs:snaketailstartingpoint]  ;row = ah =12;; coloumn = al = 30;; starting point
 push ax ;parameter of calculatelocation
 mov cl, [cs:snakelength]
 mov ch, 0
 mov byte[cs:location], ah ;save location of tail row
 mov byte[cs:location  + 1], al ;save location of tail coloumn
 add al, cl
 mov byte [cs:location + 2], ah  ; saves location of head row
 mov byte [cs:location + 3], al ;saves location of head coloumn
 call calculatelocation
 pop di
 mov al, [cs:body]
 mov ah, [cs:snakeattribute]
snakeloop:
 mov [es:di], ax
 add di, 2
 loop snakeloop
 mov al, [cs:head]
 mov [es:di], ax
 mov word [cs:turn], 3 ;right movement signal
 call Interface 
 call makemeat
 call printtime
 call showscore
 call showlife
 pop es
 pop di
 pop cx
 pop ax
 ret
;/////////////////////////////

;/////////////////////////
checkmeateat:
 push cx
 push es
 push ax
 push bx
 push di
 push 0xb800
 pop es
 mov cl,[cs:row]		; row of meat
 mov ch,[cs:col]		; col of meat
 cmp cl,[cs:location+2]
 je next
 jmp exitcheckmeateat
 next:
 cmp ch,[cs:location+3]
 jne shortjump
 call makemeat
 push word[cs:delayofeating]
 push word[cs:soundofeating]
 call makebeep
 add word[cs:score],5
 call showscore
 mov word [cs:makemeatflag], 1
 add byte[cs:snakelength],4
 cmp byte[cs:snakelength],239
 jne exitcheckmeateat
 cmp byte[cs:level],3
 je eg
 mov byte[cs:snakelength],19
 mov word[cs:tickcount],0
 mov word[cs:speed],10
 mov word[cs:countmove],0
 mov word[cs:countspeed],0
 mov word[cs:flag],0
 mov word[cs:gamestart],0
 add word[cs:score],45
 call makesnake
 shortjump:
 jmp exitcheckmeateat
 eg:
 mov word[cs:flagend],1
 mov word[cs:gameend],0
 exitcheckmeateat:
 pop di
 pop bx
 pop ax
 pop es
 pop cx
 ret
  ;////////////////////////////////////
 
 ;//////////////////////////////////// 
updatesnake:
 mov word[cs:flagkbisr],1
 mov word[cs:countmove],0
 push ax
 push di
 push es 
 push cx
 push 0xb800
 pop es
 mov word [cs:normal], 0
 cmp word [cs:flag], 0
 jne cmpnext
 jmp exitupdatesnake
 
cmpnext:
 cmp word [cs:flag], 1
 jne cmpnext1
 mov word [cs:jmpfar], FirstCase
 jmp jmpfartocase
cmpnext1:
 cmp word [cs:flag], 2
 jne cmpnext2
 mov word [cs:jmpfar], SecondCase
 jmp jmpfartocase 
cmpnext2:
 cmp word [cs:flag], 3
 jne cmpnext3
 mov word [cs:jmpfar], ThirdCase
 jmp jmpfartocase 
cmpnext3:
 cmp word [cs:flag], 4
 mov word [cs:jmpfar], FourthCase
jmpfartocase:
 mov [cs:jmpfar + 2], cs 
 jmp far[cs:jmpfar]
;////////////////////////////
FirstCase: ;up case
 mov ah, [cs:location + 2] ;snake head row
 mov al, [cs:location + 3] ;snake head coloumn
 push ax
 call calculatelocation
 pop di
 sub di, 160
 
 mov al, [cs:interfacechar]
 cmp [es:di], al
 je exitcase
 
 mov al, [cs:body]
 cmp [es:di], al
 je exitcase
 
 mov ax, [cs:flag]
 cmp ax, [cs:turn]
 je Execution1
 call TurnCase
Execution1:
 mov word [cs:turn], 1 ;up signal
 cmp word [cs:makemeatflag], 1 ;does not allow to update tail if true
 je endexecution11
 call removetail
 cmp word [cs:location + 4] ,0
 je endexecution1
 call updatetail
 cmp word [cs:normal], 1
 je endexecution11
endexecution1:
 sub byte[cs:location], 1  ;normal tail decrement
endexecution11:
 push 0
 call replaceheadwithbody
 pop di
 sub byte[cs:location + 2], 1 ;head row
 jmp normal1
 exitcase:
 mov word [cs:flag], -1 ;so it doesnot compare with enter again in kbisr
 dec word [cs:gameend]
 push word[cs:delayofdeath]
 push word[cs:soundofdeath]
 call makebeep
 call showlife
 mov word[cs:flagtimmer],1
 jmp exitupdatesnake
 normal1:
 mov ah, [cs:snakeattribute]
 mov al, [cs:head]
 sub di, 160
 mov [es:di], ax
 jmp exitupdatesnake
;/////////////////////////////
SecondCase: ;down case
 mov ah, [cs:location + 2] ;snake head row
 mov al, [cs:location + 3] ;snake head coloumn
 push ax
 call calculatelocation
 pop di
 add di, 160
 
 mov al, [cs:interfacechar]
 cmp [es:di], al
 je exitcase ;mentioned in first case
 
 mov al, [cs:body]
 cmp [es:di], al
 je exitcase
 
 mov ax, [cs:flag]
 cmp ax, [cs:turn]
 je Execution2
 call TurnCase
Execution2:
 mov word [cs:turn], 2  ;down signal 
 cmp word [cs:makemeatflag], 1
 je endexecution21
 call removetail
 cmp word [cs:location + 4] ,0
 je endexecution2
 call updatetail
 cmp word [cs:normal], 1
 je endexecution21
endexecution2:
 add byte[cs:location], 1
endexecution21:
 push 0
 call replaceheadwithbody
 pop di 
 add byte[cs:location + 2], 1 ;head row
 mov ah, [cs:snakeattribute]
 mov al, [cs:head]
 add di, 160
 mov [es:di], ax
 jmp exitupdatesnake
;////////////////////////////
ThirdCase: ;right case

 mov ah, [cs:location + 2] ;snake head row
 mov al, [cs:location + 3] ;snake head coloumn
 push ax
 call calculatelocation
 pop di
 add di, 2
 
 mov al, [cs:interfacechar]
 cmp [es:di], al
 je exitthirdcase ;mentioned in first case
 
 mov al, [cs:body]
 cmp [es:di], al
 je exitthirdcase
 
 mov ax, [cs:flag]
 cmp ax, [cs:turn]
 je Execution3
 call TurnCase
Execution3:
 mov word [cs:turn], 3 ;right signal
 cmp word [cs:makemeatflag], 1
  je endexecution31
 call removetail
 cmp word [cs:location + 4] ,0 ;check first turn point
 je endexecution3
 call updatetail
 cmp word [cs:normal], 1
 je endexecution31
endexecution3:
 add byte[cs:location + 1], 1
endexecution31:
 push 0
 call replaceheadwithbody
 pop di
 add byte[cs:location + 3], 1 ;head coloumn
 jmp normal3
 exitthirdcase:
 mov word [cs:flag], -1
 dec word [cs:gameend]
 push word[cs:delayofdeath]
 push word[cs:soundofdeath]
 call makebeep
 call showlife
 mov word[cs:flagtimmer],1
 jmp exitupdatesnake
normal3:
 mov ah, [cs:snakeattribute]
 mov al, [cs:head]
 add di, 2
 mov [es:di], ax
 jmp exitupdatesnake 
 ;//////////////////////////
FourthCase: ; left case
 mov ah, [cs:location + 2] ;snake head row
 mov al, [cs:location + 3] ;snake head coloumn
 push ax
 call calculatelocation
 pop di
 sub di, 2
 
 mov al, [cs:interfacechar]
 cmp [es:di], al
 je exitthirdcase ;mentioned in first case
 
 mov al, [cs:body]
 cmp [es:di], al
 je exitthirdcase
 
 mov ax, [cs:flag]
 cmp ax, [cs:turn]
 je Execution4
 call TurnCase
Execution4:
 mov word [cs:turn], 4 ;left signal
 cmp word [cs:makemeatflag], 1
 je endexecution41
 call removetail
 cmp word [cs:location + 4] ,0 ;checks first turn point
 je endexecution4
 call updatetail
 cmp word [cs:normal], 1
 je endexecution41 
endexecution4:
 sub byte[cs:location + 1], 1 
endexecution41:
 push 0
 call replaceheadwithbody
 pop di
 sub byte[cs:location + 3], 1 ;head coloumn
 mov ah, [cs:snakeattribute]
 mov al, [cs:head]
 sub di, 2
 mov [es:di], ax
exitupdatesnake:
 pop cx
 pop es
 pop di
 pop ax
 ret
;/////////////////////////////

;/////////////////////////////
saveandhookkbisrandtimer:
 push ax
 push es
 xor ax, ax
 mov es, ax ; point es to IVT base
 mov ax, [es:8*4]
 mov [oldtimer], ax ; save offset of old timer routine
 mov ax, [es:8*4+2]
 mov [oldtimer+2], ax ; save segment of old timer routine
 mov ax, [es:9*4]
 mov [oldisr], ax ; save offset of old keybord routine
 mov ax, [es:9*4+2]
 mov [oldisr+2], ax ; save segment of old keyboard routine
 cli ; disable interrupts
 mov word [es:8*4], timer; store offset at n*4
 mov [es:8*4+2], cs ; store segment at n*4+2
 mov word [es:9*4], kbisr ; store offset at n*4
 mov [es:9*4+2], cs ; store segment at n*4+2
 sti ;enable interrupts
 pop es
 pop ax
 ret
;/////////////////////

;/////////////////////
showgameended:
 call clrscr
 cmp word[cs:flagend],1
 jne skipwinning 
 call won
 jmp exitshowgameended
 skipwinning:
 call Finish
 exitshowgameended:
 ret
;///////////////

;/////////////// 
start:
call makesnake ;creates stationary snake
call saveandhookkbisrandtimer ;saves and hooks timer and kbisr
checkgameend:
cmp word [cs:gameend], 0
jne checkgameend
call showgameended
mov dx,start
add dx,15
mov cl,4
shl dx,cl
mov ax, 0x3100 ; terminate program
int 0x21