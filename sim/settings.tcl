set vsim_opt "-voptargs=+acc -msgmode both" 
set vlog_opt {-work work -vlog01compat +incdir+../../../hdl/utils +define+MODELSIM} 
set svlog_opt {-work work -sv +incdir+../../../hdl/utils +define+MODELSIM} 
set vcom_opt {} 
set top_module testbench
set wave_files {wave.do} 
  
set modelsim_edition altera 
set altera_library {} 
  
set design_library { 
    { 
        ../rtl 
        { 
            ones_count.sv
            ones_max_length.sv
            change_sign.sv
            static_ctrl.sv
        } 
    } 
    { 
        ../sim 
        { 
            testbench.sv
        } 
    } 
} 
