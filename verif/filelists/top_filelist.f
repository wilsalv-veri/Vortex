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
+define+EXT_M_ENABLE

//Reference other filelists
-f $VORTEX/verif/filelists/rtl_filelist.f
-f $VORTEX/verif/filelists/dpi_filelist.f
-f $VORTEX/verif/filelists/tb_filelist.f
-f $VORTEX/verif/filelists/tests_filelist.f
