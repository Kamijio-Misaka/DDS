if {[catch {

# define run engine funtion
source [file join {G:/lattice/radiant} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/DDS"
# synthesize IPs
# synthesize VMs
# synthesize top design
file delete -force -- DDS_simple_DDS_simple.vm DDS_simple_DDS_simple.ldc
run_engine synpwrap -prj "DDS_simple_DDS_simple_synplify.tcl" -log "DDS_simple_DDS_simple.srf"
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o DDS_simple_DDS_simple.udb DDS_simple_DDS_simple.vm] "C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/DDS/DDS_simple/DDS_simple_DDS_simple.ldc"

} out]} {
   runtime_log $out
   exit 1
}
