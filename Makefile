all:nestedfor
numarray:nestedfor.o
	gcc -o nestedfor nestedfor.o
nestedfor.o:nestedfor.s
	as -o nestedfor.o nestedfor.s
clean:
	rm -vf nestedfor *.0

