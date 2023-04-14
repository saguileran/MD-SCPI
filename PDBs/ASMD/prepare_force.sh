#!/bin/bash

avg=`echo "0.0" | bc`;

for stage in `seq 1 10`;
do
	more asmd_1.work.dat.${stage} | awk '{print $1}' > tmp
	for i in `seq 1 50`; 
	do
		more asmd_${i}.work.dat.${stage} | awk '{print $3 }' > tmp.${i}; # + " '$avg' " }' > tmp.${i} ;
	done

	paste tmp tmp.1 tmp.2 tmp.3 tmp.4 tmp.5 tmp.6 tmp.7 tmp.8 tmp.9 tmp.10 tmp.11 tmp.12 tmp.13 tmp.14 tmp.15 tmp.16 tmp.17 tmp.18 tmp.19 tmp.20 tmp.21 tmp.22 tmp.23 tmp.24 tmp.25 tmp.26 tmp.27 tmp.28 tmp.29 tmp.30 > force_${stage}.datA;
	paste tmp.31 tmp.32 tmp.33 tmp.34 tmp.35 tmp.36 tmp.37 tmp.38 tmp.39 tmp.40 tmp.41 tmp.42 tmp.43 tmp.44 tmp.45 tmp.46 tmp.47 tmp.48 tmp.49 tmp.50 > force_${stage}.datB;
	paste force_${stage}.datA force_${stage}.datB > force_${stage}.dat;
	
	avg=`echo "scale=4; 0.0" | bc`;
	for i in `seq 1 50`;
        do
#		echo "Old average = $avg"
		last=`tail -1 tmp.$i | awk '{print $1}'`;
		avg=`echo "scale=4; $avg + $last" | bc` ;
#		echo "New average = $avg"
	done
	avg=`echo "scale=4; $avg / 50." | bc`;
	rm tmp* 
done
rm force_*A force_*B
