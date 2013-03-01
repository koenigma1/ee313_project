#!/usr/local/bin/perl
#
# Tao Yu & Sabarish Sankaranarayanan
# EE313 TA Winter 2012
# Final project 
#
# Determines the lowest operating voltage an sram array can run off of
# given the spice deck that includes a netlist with the worst case memory cells.
#
# The spice deck must include the ee313 header file, parameterize the clock
# period (tcyc), call the sram cell being tested xctl, with the interior node
# bit being set to 'supply' and bit_b set to 0. 
# Finally, the deck must measure the maximum value reached by node xcbr.bit_b, named
# max_bit_b (.meas TRAN max_bit_b MAX v(xcbr.bit_b)). The spice deck must run on
# its own and be otherwise valid.
#
# Different vdd's are iterated over to obtain the lowest(to an accuracy of 0.0005) vdd
# at which no error is encountered.
#
# If you observe unexpected or mysterious result, please check log file and if necessary
# run generated simulation file manually. Errors like bitline votage stuck at values higher
# than vdd can be cause by ill behavior of the 45nm predictive model. 
# In such case, please uncomment the line below to redefine the starting point of iteration
# $vdd_start = 0.99;
#
# For help or report bugs contact:
# sabarish@stanford.edu or taoy@stanford.edu
#
#---------------------------------------------------------------------------------------------


#Get user input, copious error checking
#--------------------------------------

#get user .sp file, check for validity
print "Enter sram spice deck relative location: ";
chomp($ckt_loc = <task5_write.sp>);

if(!($ckt_loc =~ m/(.*)(.sp)/)){
    print "Not a valid .sp file, exiting.\n";
    exit;
}

#copy over circuit so that it can be tested and deleted in case of failure
$ckt = "sram_test_tmp";
system("cp $ckt_loc $ckt.sp");

#check that .sp file contains desired elements
open(WCFILE, "<$ckt.sp") || die("Couldn't open $ckt_loc\n");
$found1 = 0; $found2 = 0; $found3 = 0; $found4 = 0; $found5 = 0; 
while(<WCFILE>){
    if($_ =~ m/^.include\s*'\/usr\/class\/ee313\/ee313_spice_header.h'/i){
	$found1 = 1;
    }
    elsif($_ =~ m/^.meas\s+TRAN\s+max_bit_b\s+MAX\s+v\(xcbr.bit_b\)/i){
	$found2 = 1;
    }
    elsif($_ =~ m/^.ic\s+v\(xcbr.bit\)\s*=\s*'supply'/i){
	$found3 = 1;
    }
    elsif($_ =~ m/^.ic\s+v\(xcbr.bit_b\)\s*=\s*0/i){
	$found4 = 1;
    }
    elsif($_ =~ m/^.param\s+tcyc\s*=\s*\d+n/i){
	$found5 = 1;
    }
    
}
close(WCFILE);

#doesn't have everything, exit
if(!$found1 || !$found2 || !$found3 || !$found4 || !$found5 ){
    print "\nSpice file doesn't meet the requirements:\n";
    print "1) Must include the ee313 spice header\n";
    print "\.include '/usr/class/ee313/ee313_spice_header.h'\n";
    print "2) Must contain the initial conditions:\n";
    print "       .ic v(xcbr.bit)  = 'supply'\n       .ic v(xcbr.bit_b)= 0\n";
    print "3) Must contain cycle definition: \n       .param tcyc=1n \n";
    print "4) Must contain the line:\n       .meas TRAN max_bit_b MAX v(xcbr.bit_b)\n\n"; 
    system("rm -rf $ckt.sp");
    exit;
}

#check that basic spice file runs
system("hspice -i $ckt.sp -o $ckt.lis");
open(OUTFILE, "<$ckt.lis") || die("Spice run didn't produce a valid output file\n");
while(<OUTFILE>){
    if($_ =~ m/.*error.*/){
	print "Spice file doesn't run, please fix errors and retry.\n";
	system("rm -rf $ckt*");
	exit;
    }
}
close(OUTFILE);

$usr_file = "./run_sram_worst_case_write.log";
open(USRFILE, ">$usr_file") || die("Cannot create log file\n");
close(USRFILE);

#Begin iterating over different Vdd's
#------------------------------------

if (defined($vdd_start)) {
	$vdd = $vdd_start;
} else {
	$vdd = 1.0;
}
$done = 0;
$step_sz = .2;
$down = 1;
$dwrites = 0;
$val_int = 0;

#run simulations until done
while(!$done){

    open(USRFILE, ">>$usr_file") || die("Couldn't open $usr_file");

    print USRFILE "\nRunning worst case simulations at ".$vdd."V\n";
    print "\nRunning worst case simulations at ".$vdd."V\n";

    #Copy spice deck to temp file, replacing supply param, cycle time, 
    #and ee313 header
    
    open(INFILE, "<$ckt.sp") || die("Couldn't open $ckt_loc");
    $gen_sp = "sram_worst_case_write.sp";
    open(TEMPFILE, ">$gen_sp") || die("Could not open file!");
    
    while(<INFILE>){
	if($_ =~ m/^.include '\/usr\/class\/ee313\/ee313_spice_header.h'/){
	    print TEMPFILE ".param supply=1.0\n.option scale=0.022u\n";
	    print TEMPFILE ".option accurate post\n.option dcic=0\n.";
	    print TEMPFILE "global vdd! vdd gnd\n.option parhier=local\n";
	    print TEMPFILE ".option list\n.op\n.protect\n";
	    print TEMPFILE ".lib '/usr/class/ee313/lib/opConditions.lib' SFTT\n";
	    print TEMPFILE ".unprotect\n.param supply=$vdd\n";
	    print TEMPFILE "V_supply vdd gnd dc=Supply\n";
	    print TEMPFILE "V_supply1 vdd! gnd dc=Supply\nvgnd gnd 0 0\n";
	}
	elsif($_ =~ m/(.*.param\s+tcyc\s*=\s*)(\d+n)(.*)/){
	    print TEMPFILE $1."100n".$3."\n";
	}
	elsif(!($_ =~ m/(.*.param\s+supply)/i)) {
	    print TEMPFILE $_;
	}
    }
    
    close(INFILE);
    close(TEMPFILE);

    #run modified spice deck in hspice
    system("hspice -i ".$gen_sp." -o temp_wc.lis");
    open(TEMPFILE, "<temp_wc.lis") || die("Could not open file!");
    #iterate over the output .lis file and check max_bit_b to detect Unsuccessful write
    $dwrites = 0; $val_int = 2;
    while(<TEMPFILE>){
	if($_ =~ m/(.*)(max_bit_b=\s*)([\.\de-]*)(\s*)(.*)/){
		    $val_int = $3;
	}	
	if($val_int < (5/6*$vdd)){
	    $dwrites = 1;
	    last;
	}
    }
    close(TEMPFILE);
    
    #print info for user
    if($dwrites == 1){
	print USRFILE "Unsuccessful write at ".$vdd."V. (max_bit_b = ".$val_int."V)\n";
	print "Unsuccessful write at ".$vdd."V. (max_bit_b = ".$val_int."V)\n";
    } else {
	print USRFILE "Pass write at ".$vdd."V. (max_bit_b = ".$val_int."V)\n";
	print "Pass write at ".$vdd."V. (max_bit_b = ".$val_int."V)\n";
    }

    #change direction of iteration based on observation
    if($dwrites && $down){
	$step_sz = $step_sz / 2;
	$down = 0;
    }
    if(!$down && !$dwrites){
	$down = 1;
	$step_sz = $step_sz / 2;	
    }


    #finish when previous vdd was ok and going dow
    if($step_sz <= 0.0005 && !$dwrites){
	$done = 1;
	print USRFILE "\n--------------------------\n";
	print USRFILE "Finished simulations.\n";
	print USRFILE "'Safe' Vdd to use is ".$vdd."\n\n";
	
	print "\n--------------------------\n";
	print "Finished simulations.\n";
	printf "'Safe' Vdd to use is %1.4fV \n\n",$vdd;
    }

    #determine next vdd to test
    if($down){
	$vdd = $vdd - $step_sz;
    }
    else{
	$vdd = $vdd + $step_sz;
    }
    
    if($vdd <= 0.1 || $vdd >= 1.3){
	#reached here in error, exit
	$done = 1;
	print USRFILE "\nExiting, did not find an acceptable stopping vdd.\n";
	print "Exiting, did not find an acceptable stopping vdd.\n";
        print "Possible reasons:\n";
        print "1) Your cell do not have variation modeled.\n";
	print "2) You did not initialize your cell to the correct value.\n";
        print "3) You did not parameterize transient stop time or other timing critical signals.\n";
    }
    close(USRFILE);
}

print "Log file: ".$usr_file."\n";
print "Simulation file: ".$gen_sp."\n\n";

#clean up temp files
system("rm -rf $ckt*");
system("rm -rf temp_wc*");
