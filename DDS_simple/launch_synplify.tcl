#-- Lattice Semiconductor Corporation Ltd.
#-- Synplify OEM project file C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/DDS/DDS_simple/launch_synplify.tcl
#-- Written on Fri Feb 11 19:00:49 2022

project -close
set filename "C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/DDS/DDS_simple/DDS_simple_syn.prj"
project -new "$filename"
set create_new 1

#device options
set_option -technology SBTICE40UP
set_option -part iCE40UP5K
set_option -package SG48
set_option -speed_grade High-Performance_1.2V

if {$create_new == 1} {
	#-- add synthesis options
	#compilation/mapping options
	set_option -symbolic_fsm_compiler true
	set_option -resource_sharing true

	#use verilog 2001 standard option
	set_option -vlog_std v2001
	set_option -disable_io_insertion false

	#map options
	set_option -frequency auto
	set_option -maxfan 1000
	set_option -auto_constrain_io 0
	set_option -retiming false; set_option -pipe true
	set_option -force_gsr false
	set_option -compiler_compatible 0
	
	set_option -default_enum_encoding default

	#timing analysis options
	
	

	#automatic place and route (vendor) options
	set_option -write_apr_constraint 1

	#synplifyPro options
	set_option -fix_gated_and_generated_clocks 0
	set_option -update_models_cp 0
	set_option -resolve_multiple_driver 0
	
	#-- set any command lines input by customer
	
	set_option -dup false
}
	#-- add_file options
add_file -verilog {G:/lattice/radiant/ip/pmi/pmi.v}
add_file -vhdl -lib pmi {G:/lattice/radiant/ip/pmi/pmi.vhd}
set_option -include_path "C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/DDS"
add_file -verilog "C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/DDS/DDS_simple/source/acculator.v"
add_file -verilog "C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/DDS/DDS_simple/source/bcd_8421.v"
add_file -verilog "C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/DDS/DDS_simple/source/key_filter.v"
add_file -verilog "C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/DDS/DDS_simple/source/OLED12864.v"
add_file -verilog "C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/DDS/DDS_simple/source/pwm_adc.v"
add_file -verilog "C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/DDS/DDS_simple/source/raw_DDS.v"
add_file -verilog "C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/DDS/DDS_simple/source/state_fsm.v"
add_file -verilog "C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/DDS/DDS_simple/source/top.v"
add_file -verilog "C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/DDS/DDS_simple/source/user_rom8x2k.v"
add_file -verilog "C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/DDS/DDS_simple/source/wave_sel.v"
add_file -verilog "C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/DDS/pll_sys/rtl/pll_sys.v"
#-- top module name
set_option -top_module {top}
project -result_format "vm"
project -result_file {C:/Users/11091/Desktop/FPGA_Active_By_yinghe/my_prj/simple_DDS/DDS/DDS_simple/DDS_simple_DDS_simple.vm}
project -save "$filename"
