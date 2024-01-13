#!/bin/bash -f

TOP_LEVEL=testbench

timescale=1ns/1ps

FILE_CMD=__xrun_cmd.f
FILE_TCL=__xrun.tcl
FILE_LOG=__xrun.log
FILE_HISTORY=__xrun.history

echo timescale     = ${timescale}

###########################################################################################################################
current_dirname=`pwd`
echo current_dirname=$current_dirname
###########################################################################################################################

###########################################################################################################################
# UVM
###########################################################################################################################

UVMHOME=CDNS-1.2

echo UVMHOME=$UVMHOME

#############################################################
#   Report Verosity
#   UVM_DEBUG    500 
#   UVM_FULL     400 
#   UVM_HIGH     300
#   UVM_MEDIUM   200
#   UVM_LOW      100
#   UVM_NONE       0
#
# +UVM_VERBOSITY=UVM_DEBUG
# +UVM_VERBOSITY=UVM_FULL
# +UVM_VERBOSITY=UVM_HIGH      
# +UVM_VERBOSITY=UVM_MEDIUM  
# +UVM_VERBOSITY=UVM_LOW     
# +UVM_VERBOSITY=UVM_NONE    
UVM_VERBOSITY=UVM_FULL

echo UVM_VERBOSITY=$UVM_VERBOSITY 


#############################################################

UVM_TESTNAME=uvm_apb_master_test

echo UVM_TESTNAME=${UVM_TESTNAME} 

###########################################################################################################################

OS=`uname`
machinetype=`uname -m`
date_time=`date "+%Y%m%d_%H%M%S"`

echo OS            = $OS
echo machinetype   = $machinetype
echo date_time     = $date_time

###########################################################################################################################

  echo database -open waves -shm                                                                             > ${FILE_TCL}
  echo probe -create ${TOP_LEVEL} -all -tasks -memories -depth all -shm -database waves                     >> ${FILE_TCL}

# echo probe -create -database waves testbench.dut -assertions -transaction -depth all                      >> ${FILE_TCL}


# Probe the entire UVM Testbench Hierarchy
  echo probe -create -database waves uvm_pkg::uvm_top -all -depth all                                       >> ${FILE_TCL}
  echo run                                                                                                  >> ${FILE_TCL}
  echo exit                                                                                                 >> ${FILE_TCL}

# echo uvm_set \"*\" \"recording_detail\" UVM_FULL                                                          >> ${FILE_TCL}
# echo if \{\!\$simvision_attached\} \{                                                                     >> ${FILE_TCL}
# echo run\;                                                                                                >> ${FILE_TCL}
# echo exit\;                                                                                               >> ${FILE_TCL}
# echo \}\;                                                                                                 >> ${FILE_TCL}


# echo run                                                                                                   > ${FILE_TCL}
# echo exit                                                                                                 >> ${FILE_TCL}

###########################################################################################################################

generate_file_cmd()
{ 
  echo generate ${FILE_CMD}

  if [[ ($2 != "") ]]; then
    echo args=$2
    FILELIST_TEST_VECTOR=$2
  fi

  echo  FILELIST_TEST_VECTOR=${FILELIST_TEST_VECTOR}

  if [[ ($3 != "") ]]; then
    echo args=$3
    LOOP=$3
  fi

  echo  LOOP=${LOOP}

  ########################################################################################################################

  echo +access+rwc                                                                                           > ${FILE_CMD}
  echo +64bit                                                                                               >> ${FILE_CMD}
  echo -v93                                                                                                 >> ${FILE_CMD}
  echo +SV                                                                                                  >> ${FILE_CMD}
  echo -relax                                                                                               >> ${FILE_CMD}
  echo -namemap_mixgen                                                                                      >> ${FILE_CMD}
  echo +libext+.sv+.v+.vhd+                                                                                 >> ${FILE_CMD}
  
  echo +xmtimescale+${timescale}                                                                            >> ${FILE_CMD}
  
  #echo +sem2009                                                                                            >> ${FILE_CMD}
  #echo +notimingchecks                                                                                     >> ${FILE_CMD}
  #echo +nowarn+NOCMIC                                                                                      >> ${FILE_CMD}
  #echo +licqueue                                                                                           >> ${FILE_CMD}
  
  echo +xmlicq                                                                                              >> ${FILE_CMD}

  echo -logfile ${FILE_LOG}                                                                                 >> ${FILE_CMD}

  echo -history_file ${FILE_HISTORY}                                                                        >> ${FILE_CMD}

  ########################################################################################################################

  echo -uvmhome ${UVMHOME}                                                                                  >> ${FILE_CMD}
  echo +UVM_VERBOSITY=${UVM_VERBOSITY}                                                                      >> ${FILE_CMD}
  echo +UVM_TESTNAME=${UVM_TESTNAME}                                                                        >> ${FILE_CMD}

  ########################################################################################################################
  # Built-In Trace
  #   +UVM_PHASE_TRACE       - Enable phase execution tracing (Useful with run-time subphases)
  #   +UVM_OBJECTION_TRACE   - Enable tracing of objection raising/dropping
  #   +UVM_CONFIG_DB_TRACE   - Enable tracing of config database access
  #   +UVM_RESOURCE_DB_TRACE - Enable tracing of resource database access

# echo +UVM_PHASE_TRACE                                                                                     >> ${FILE_CMD}
# echo +UVM_OBJECTION_TRACE                                                                                 >> ${FILE_CMD}
# echo +UVM_CONFIG_DB_TRACE                                                                                 >> ${FILE_CMD}
# echo +UVM_RESOURCE_DB_TRACE                                                                               >> ${FILE_CMD}

  ########################################################################################################################
  
# echo -top ${TOP_LEVEL}                                                                                    >> ${FILE_CMD}
  
  echo -F filelist/top.f                                                                                    >> ${FILE_CMD}
 
# echo -gui                                                                                                 >> ${FILE_CMD}
  echo -input ${FILE_TCL}                                                                                   >> ${FILE_CMD}
  
  ########################################################################################################################
  # User Define PlusArgs  $value$plusargs $test$plusargs
  
}

###########################################################################################################################

main()
{
  generate_file_cmd $1 $2 $3 $4 $5 $6 $7 $8 $9

  execute $1 $2 $3 $4 $5 $6 $7 $8 $9

}



execute()
{
#  if [[ ($2 != "") ]]; then
#    echo args=$2
#    FILELIST_TEST_VECTOR=$2
#  fi
#
#  echo  FILELIST_TEST_VECTOR=${FILELIST_TEST_VECTOR}
#  echo +FILELIST_TEST_VECTOR=${FILELIST_TEST_VECTOR}                                                      >> ${FILE_CMD}

  case $1 in
       "clean" )
         echo Clean...
         clean $1 $2 $3 $4 $5 $6 $7 $8 $9
         
         exit 0
       ;;

       "rerun" )
         echo rerun
         clean $1 $2 $3 $4 $5 $6 $7 $8 $9
         sim $1 $2 $3 $4 $5 $6 $7 $8 $9
       ;;

       "gen" )
         echo gen
         generate_file_cmd $1 $2 $3 $4 $5 $6 $7 $8 $9
       ;;

       "all" )
         echo all
         sim $1 $2 $3 $4 $5 $6 $7 $8 $9
       ;;

       "h" )
         help
       ;;

       "-h" )
         help
       ;;

       "-help" )
         help
       ;;

       "help" )
         help
       ;;

       * )
         help
       ;;
  esac
}

help()
{
  echo ------------------------------------------------------------------------------------------------
  echo Help:
  echo ------------------------------------------------------------------------------------------------
  echo Usage:
  echo "     "\.\/`basename $0` all    - start the simulation
  echo "     "\.\/`basename $0` clean  - remove all the output files and directories.
  echo ------------------------------------------------------------------------------------------------
  echo Example:
  echo "     "\.\/`basename $0` help
  echo "     "\.\/`basename $0` clean
  echo "     "\.\/`basename $0` all
  echo "     "\.\/`basename $0` clean \; \.\/`basename $0` all
  echo ------------------------------------------------------------------------------------------------
}

sim()
{
#  xrun -f ${FILE_CMD} -input ${FILE_TCL}
   xrun -f ${FILE_CMD}
}

clean()
{
# rm -rf xrun.log
# rm -rf xrun.history

  rm -rf xrun.key
  rm -rf xcelium.d
  rm -rf waves.shm
  rm -rf .simvision

  rm -rf ${FILE_CMD}
  rm -rf ${FILE_TCL}
  rm -rf ${FILE_LOG}
  rm -rf ${FILE_HISTORY}

  echo rm -rf xrun.key
  echo rm -rf xcelium.d
  echo rm -rf waves.shm
  echo rm -rf .simvision

  echo rm -rf ${FILE_CMD}
  echo rm -rf ${FILE_TCL}
  echo rm -rf ${FILE_LOG}
  echo rm -rf ${FILE_HISTORY}


#   if [[ ($2 != "") ]]; then
#     echo #!/bin/bash -f   > __clean.sh
# 
#     echo rm -f $2.axi_s
#     echo rm -f $2.axi_s        >> __clean.sh
#     rm -f $2.axi_s
# 
#     echo rm -f $2.error
#     echo rm -f $2.error        >> __clean.sh
#     rm -f $2.error
# 
#     echo rm -f $2.report
#     echo rm -f $2.report       >> __clean.sh
#     rm -f $2.report
# 
#     DIR_FILELIST=`dirname $2`
#     DIR_FILELIST=`realpath ${DIR_FILELIST}`
#     echo DIR_FILELIST=${DIR_FILELIST}
# 
#     echo rm -rf ${DIR_FILELIST}/result/* 
#     echo rm -rf ${DIR_FILELIST}/result/*      >> __clean.sh
# #   rm -rf ${DIR_FILELIST}/result/*
# 
#     echo rm -rf ${DIR_FILELIST}/waveform/*
#     echo rm -rf ${DIR_FILELIST}/waveform/*    >> __clean.sh
# #   rm -rf ${DIR_FILELIST}/waveform/*
#     
#     chmod u+x __clean.sh
#     
#     ./__clean.sh
#     
#     rm -f __clean.sh
#     
# #    cd ${DIR_FILELIST}/result/
# #    echo change to `pwd`
# #    rm -rf *
# #    
# #    cd ${DIR_FILELIST}/waveform/
# #    echo change to `pwd`
# #    rm -rf *
# #    
# #    cd $current_dirname
#   fi

}


main $1 $2 $3 $4 $5

