onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/dut/WORD_SIZE
add wave -noupdate /testbench/dut/BYTE_CNT
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/rst_n
add wave -noupdate /testbench/dut/input_data
add wave -noupdate /testbench/dut/shift_reg
add wave -noupdate -radix unsigned /testbench/dut/rx_cnt
add wave -noupdate -divider {Ones Counter}
add wave -noupdate -radix unsigned /testbench/dut/ones
add wave -noupdate -radix unsigned {/testbench/ones_tb[2]}
add wave -noupdate -divider {Change of sign}
add wave -noupdate /testbench/change_sign_count
add wave -noupdate {/testbench/changes_tb[2]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {45 ns} 0} {{Cursor 2} {116 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ns} {242 ns}
