# Makefile for EE313 project part 1

run_task1:
	-hspice -i task1.sp -o task1/
	egrep -i 'warn|err' task1/task1.lis
	cat task1/task1.mt0
run_task2:
	-hspice -i task2.sp -o task2/
	egrep -i 'warn|err' task2/task2.lis
	cat task2/task2.mt0

run_task3:
	-hspice -i task3.sp -o task3/
	egrep -i 'warn|err' task3/task3.lis
	cat task3/task3.mt0

run_task5rd:
	-hspice -i task5rd.sp -o task5rd/
	egrep -i 'warn|err' task5rd/task5rd.lis
	cat task5rd/task5rd.mt0

run_task5wt:
	-hspice -i task5wt.sp -o task5wt/
	egrep -i 'warn|err' task5wt/task5wt.lis
	cat task5wt/task5wt.mt0

run_sense_timing:
	-hspice -i sense_timing.sp -o sense_timing/
	egrep -i 'warn|err' sense_timing/sense_timing.lis
	cat sense_timing/sense_timing.mt0

run_full:
	-hspice -i full.sp -o full/
	egrep -i 'warn|err' full/full.lis
	cat full/full.mt0

all: run_task1 run_task2 run_task3 run_task5rd run_task5wt
	echo "DONE"
	grep .TITLE */*.mt* -A4
.PHONY: clean
clean:
	\rm -f *.tr* *.sw* *.ac* *.mt* *.ms* *.ma* *.ic* *.lis *.st* *.log* *.pa*
