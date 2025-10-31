
#Example of Adding Defines
#+define+UVM_NO_DPI
#+define+MY_PARAM=4

// Set the include path for UVM macros and other files
+incdir+$UVM_HOME/src

// Add the UVM package file. It is crucial to compile this before any
// files that depend on it.
$UVM_HOME/src/uvm_pkg.sv

# RTL
apb_design_example.sv

#TB
apb_tb_example.sv