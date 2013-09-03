format pe gui 4.0
entry start
include  'win32ax.inc'

section 'code' data readable writeable executable

proc	 strcmp,szOne,szTwo
	 xor		 eax,eax
	 mov		 esi,[szOne]
	 mov		 edx,[szTwo] 
	 xor		 ecx,ecx 
     @@: lodsb 
	 test		 al,al
	 jz		 @F
	 cmp		 byte [edx+ecx],0
	 jz		 strcmpEnd
	 cmp		 al,byte [edx+ecx]
	 setne	 al
	 jne		 strcmpEnd
	 inc	 ecx
	 jmp		 @B 
  @@: cmp	      byte [edx+ecx],0 
	 setne	 al
  strcmpEnd: 
	 xor		 eax,1
	 ret
endp

start:

nop
mov eax, [fs:0x30]
mov eax, [eax+0Ch]
mov eax, [eax+14h]
mov eax, [eax]
mov eax, [eax]
mov ebx, [eax+10h]
mov eax, [ebx+3Ch]
mov eax, [eax+ebx+78h] ;exportDir
mov [exportDir], eax
add eax, ebx
mov esi, [eax+20h] ;namePtr
mov [namePtr], esi
mov edi, [eax+24h] ;ordPtr
mov [ordPtr], edi
mov eax, [esi+ebx]
add esi, ebx
add eax, ebx
push GetProcAddress
push eax
add edi, ebx
_check:
stdcall strcmp
test eax,eax
jne _found
mov eax, [namePtr]
add eax, 4
mov [namePtr],eax  ;save
mov ecx,[ordPtr]
add ecx,2
mov [ordPtr], ecx  ;save
mov esi, [namePtr]
add esi,ebx
add eax,ebx
mov eax,[eax]
add eax,ebx
push GetProcAddress
push eax
jmp _check
_found:
mov eax, [exportDir]
add eax, ebx
mov ecx, ebx
add ecx, [eax+1Ch]
mov edx, [ordPtr]
add edx, ebx
movzx eax, word ptr edx
mov ecx, [ecx+eax*4]
add ecx, ebx
mov [GetProcAddr], ecx
push LoadLibrary
push ebx
stdcall ecx
mov [LoadLib], eax
push User32
call eax
mov [hUser32], eax
invoke GetProcAddr,[hUser32],MessageBoxA
mov [MsgBox], eax
invoke MsgBox, 0,User32,User32,0
ret


hUser32 dd ?
GetProcAddr dd ?
LoadLib     dd ?
MsgBox	    dd ?
MessageBoxA db 'MessageBoxA',0
User32 db 'user32.dll',0
GetProcAddress db 'GetProcAddress',0
LoadLibrary db 'LoadLibraryA',0
namePtr dd 0
ordPtr dd 0
exportDir dd 0