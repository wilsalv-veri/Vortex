-f $VORTEX/hw/verif/filelists/sim_params_filelist.f

// Set the include path for UVM macros and other files
+incdir+$UVM_HOME/src

// Add the UVM package file. It is crucial to compile this before any
// files that depend on it
$UVM_HOME/src/uvm_pkg.sv

+define+NOPAE
+define+GBAR_ENABLE
+define+LMEM_ENABLED
+define+SV_DPI
+define+SIMULATION
+define+

//Reference other filelists
-f $VORTEX/hw/verif/filelists/rtl_filelist.f
-f $VORTEX/hw/verif/filelists/dpi_filelist.f
-f $VORTEX/hw/verif/filelists/tb_filelist.f
