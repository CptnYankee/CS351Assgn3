/*numarray.s*/
.data
	.balign 4
	arr: .skip 40
	value: .word 0
	fmt: .asciz "%d"
	pmt: .asciz "Please enter a number:"
	pmt_search: .asciz "Which number would you like to find?"
	pmt_found: .asciz "Value found at index %d"
	pmt_not_found: .asciz "Value not found\n"
	
.text

.global main
.global printf
.global scanf

main:
	str lr, [sp,#-4]!
	mov R8, #0
	/*Store start of arr in R7*/
	ldr R7, addrarr
	bl populate
	bl search
	b end
	
populate:
	/*have we done this 10 times yet?*/
	cmp R8, #10
	beq fin
	
	/*prompt user for a value*/
	ldr R0, addrp
	bl printf
	ldr R0, addrf
	sub sp, sp, #4
	mov r1, sp
	/*Pass sp into scanf then pop the scanned
	value into R4*/
	bl scanf
	ldr r4, [sp], #4
	/*store input value into arr[0+R8*4]
	should increment by 1 each time.*/
	str r4, [R7, R8, LSL #2]
	add R8,R8,#1
	b populate
	
/*array is finalized*/	
fin:
	/*reinitialize R8(index) to 0
	and store in stack*/
	mov R8, #0
	str R8, [sp, #-4]!
	b search
	
search:
	/*prompt user for a value*/
	ldr R0, addrs
	bl printf
	
	ldr R0, addrf
	ldr R1, addrv
	/*store address in stack
	experimental format*/
	sub sp, sp, #4
	mov r1,sp
	bl scanf
	ldr R5,[sp],#4
	b step
	 
step:
	/*retrieve index*/
	ldr R8, [sp],#4
	cmp R8,#10
	beq failed
	ldr R7, addrarr
	/*load value at arr[address + index*4]*/
	ldr R4, [R7,R8,LSL #2]
	cmp R4,R5
	beq found
	add R8,R8, #1
	str R8, [sp, #-4]!
	b step
	/*if not found end*/
failed:
	ldr R0, addrpnf
	bl printf
	b end
	
found:
	/*if found, print found at R8*/
	ldr R0, addrpf
	mov R1, R8
	bl printf
	b end
	
end:
	/*hopefully the stack is correctly lined up!*/
	ldr lr, [sp], #4
	bx lr
	
addrv: .word value
addrarr: .word arr
addrp: .word pmt
addrs: .word pmt_search
addrpf: .word pmt_found
addrpnf: .word pmt_not_found
addrf: .word fmt