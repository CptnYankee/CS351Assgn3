/*nestedfor.s*/
.data
/*******************************************************
* a is the outer loop counter								*
* c is the inner loop counter, and will be printed		*
* goal is the use-defined number of times we cycle		*
********************************************************/
	a: .word 0
	c: .word 0
	goal: .word 0
	pmt: .asciz "Please enter a number:"
	fmt: .asciz "%d"
	newl: .asciz "\n"
	
.text

.global main
.global printf
.global scanf

main:
	str lr, [sp,#-4]!
	
	ldr R0, addrp
	bl printf
	
	ldr R0, addrf
	ldr R1, addrg
	bl scanf
	/*initialize a and c to 1*/
	ldr R4, addra
	mov R5, #1
	str R5, [R4]
	
	ldr R4, addrc
	mov R5, #1
	str R5, [R4]
	b loopin
/*outer loop*/
loopout:
	/*newline in between inner loops*/
	ldr R0, addrnl
	bl printf
	/*put goal into R2*/
	ldr R1, addrg
	ldr R2, [r1]
	/*put a into R3 */
	ldr R1, addra
	ldr R3, [R1]
	/*Have we reached our goal?*/
	cmp R2,R3
	/*If yes, then we can end*/
	beq end
	/*increment a by 1*/
	add R3, R3, #1
	str R3, [R1]
	
	/*reset c to 1 for next loop*/
	ldr R4, addrc
	mov R5, #1
	str R5, [R4]
	b loopin

/*inner loop*/	
loopin:
	ldr R1, addra
	ldr R2, [R1]
	ldr R3, addrc
	ldr R4, [R3]
	
	/*is c > a yet?*/
	cmp R4,R2
	/*if yes, go back to outer loop*/
	bgt loopout
	
	/*print c for this loop*/
	ldr R0, addrf
	ldr R1, addrc
	ldr R1, [R1]
	bl printf
	
	/*increment c*/
	ldr R1, addrc
	ldr R1, [R1]
	add R1, R1, #1
	ldr R2, addrc
	str R1, [R2]
	/*to the inner loop*/
	b loopin
	
end:
	ldr lr, [sp],#4
	bx lr
	
addra: .word a
addrc: .word c
addrg: .word goal	
addrp: .word pmt
addrf: .word fmt
addrnl: .word newl
