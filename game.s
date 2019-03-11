/*game.s*/
.data
	value: .word 0
	pmt: .asciz "Guess a number!"
	pmt_high: .asciz "Too high.\n"
	pmt_low: .asciz "Too low.\n"
	pmt_win: .asciz "You guessed correctly after %d tries!"
	fmt: .asciz "%d"
	count: .word 0

.text
.global main
.global printf
.global scanf
.global rand
.global srand
.global time

main:
	str lr, [sp,#-4]!
	
	mov R0, #0
	/*get sys time*/
	bl time
	/*R0 contains systime, can pass to srand and rand*/
	bl srand
	bl rand
	
	/*attempt at modulos function*/
	mov R5, #10
	/*random value divided by 10*/
	udiv R2,R0,R5
	/*r2 = val/10*/
	/*mul R1,R2,R5
	mls multiples then subtracts!*/
	
	mls R0, R5, R2, R0
	add R0, R0, #1
	/*store our random value in stack*/
	str R0, [sp,#-4]!
	
	/*check target
	mov R1,R0
	ldr R0, addrf
	bl printf
	*/
	
	ldr R0, addrp
	bl printf
	ldr R0, addrf
	ldr R1, addrv
	bl scanf
	b guess
	
guess:
 /*increment guesses*/
	ldr R4,addrc
	ldr R5, [R4]
	add R5,R5,#1
	str R5, [R4]
	
	ldr R1, [sp], #4
	cmp R0,R1
	beq win
	blt low
	bgt high
	
low:
	str R1, [sp,#-4]!
	ldr R0, addrpl
	bl printf
/* allow the user to input a new guess*/	
	ldr R0,addrf
	ldr R1,addrv
	bl scanf
	b guess
	
high:
	str R1, [sp,#-4]!
	ldr R0, addrph
	bl printf
/* allow the user to input a new guess*/	
	ldr R0,addrf
	ldr R1,addrv
	bl scanf
	b guess
	
win:
	/*Print number of tries*/
	ldr R0, addrpw
	ldr R1, addrc
	ldr R1, [R1]
	bl printf
	
	ldr lr, [sp], #4
	bx lr
	
addrp: .word pmt
addrf: .word fmt	
addrph: .word pmt_high
addrpl: .word pmt_low
addrpw: .word pmt_win
addrv: .word value
addrc: .word count