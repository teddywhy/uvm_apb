database -open waves -shm
probe -create testbench -all -tasks -memories -depth all -shm -database waves
probe -create -database waves uvm_pkg::uvm_top -all -depth all
run
exit
