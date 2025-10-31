// Set the include path for UVM macros and other files
+incdir+$UVM_HOME/src
// Add the UVM package file. It is crucial to compile this before any
// files that depend on it
//-f $VORTEX/hw/verif/filelists/sim_params_filelist.f
//$VORTEX/hw/verif/sim_params/sim_params.sv
$UVM_HOME/src/uvm_pkg.sv
+define+NOPAE
+define+GBAR_ENABLE
+define+LMEM_ENABLED
+define+WIL_DEBUG
+define+SV_DPI

//Reference other filelists
-f $VORTEX/hw/verif/filelists/rtl_filelist.f
-f $VORTEX/hw/verif/filelists/dpi_filelist.f
-f $VORTEX/hw/verif/filelists/tb_filelist.f
