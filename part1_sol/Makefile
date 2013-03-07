# Makefile for EE313 project part 1

run_task1:
	-hspice -i task1.sp -o task1.lis
	egrep -i 'warn|err' task1.lis
	cat task1.mt0
	rm -rf task1/
	mkdir task1
	mv task1.* task1/
	cp task1/task1.sp .
run_task2:
	-hspice -i task2.sp -o task2.lis
	egrep -i 'warn|err' task2.lis
	cat task2.mt0
	rm -rf task2/
	mkdir task2
	mv task2.* task2/
	cp task2/task2.sp .

run_task3:
	-hspice -i task3.sp -o task3.lis
	egrep -i 'warn|err' task3.lis
	cat task3.mt0
	rm -rf task3/
	mkdir task3
	mv task3.* task3/
	cp task3/task3.sp .

run_task5rd:
	-hspice -i task5rd.sp -o task5rd.lis
	egrep -i 'warn|err' task5rd.lis
	cat task5rd.mt0
	rm -rf task5rd/
	mkdir task5rd
	mv task5rd.* task5rd/
	cp task5rd/task5rd.sp .

run_task5wt:
	-hspice -i task5wt.sp -o task5wt.lis
	egrep -i 'warn|err' task5wt.lis
	cat task5wt.mt0
	rm -rf task5wt/
	mkdir task5wt
	mv task5wt.* task5wt/
	cp task5wt/task5wt.sp .

all: run_task1 run_task2 run_task3 run_task5rd run_task5wt
	echo "DONE"
	grep .TITLE */*.mt* -A4
.PHONY: clean
clean:
	\rm -f *.tr* *.sw* *.ac* *.mt* *.ms* *.ma* *.ic* *.lis *.st* *.log* *.pa*
