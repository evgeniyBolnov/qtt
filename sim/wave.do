onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/rst_n
add wave -noupdate /testbench/dut/input_data
add wave -noupdate -radix unsigned /testbench/dut/rx_cnt
add wave -noupdate /testbench/output_data
add wave -noupdate /testbench/valid_data
add wave -noupdate /testbench/l0_valid
add wave -noupdate /testbench/l1_valid
add wave -noupdate /testbench/v1_valid
add wave -noupdate /testbench/vcs_valid
add wave -noupdate -divider {Ones Counter}
add wave -noupdate -radix unsigned /testbench/dut/ones
add wave -noupdate -radix unsigned /testbench/ones_tb
add wave -noupdate -divider {Change of sign}
add wave -noupdate -radix unsigned /testbench/change_sign_count
add wave -noupdate -radix unsigned /testbench/changes_tb
add wave -noupdate -divider {Ones Max Length}
add wave -noupdate -radix unsigned /testbench/dut/ones_max_len
add wave -noupdate -radix unsigned /testbench/max_len_ones
add wave -noupdate -divider {Zeros Max Length}
add wave -noupdate -radix unsigned -childformat {{{/testbench/dut/zeros_max_len[7]} -radix unsigned} {{/testbench/dut/zeros_max_len[6]} -radix unsigned} {{/testbench/dut/zeros_max_len[5]} -radix unsigned} {{/testbench/dut/zeros_max_len[4]} -radix unsigned} {{/testbench/dut/zeros_max_len[3]} -radix unsigned} {{/testbench/dut/zeros_max_len[2]} -radix unsigned} {{/testbench/dut/zeros_max_len[1]} -radix unsigned} {{/testbench/dut/zeros_max_len[0]} -radix unsigned}} -subitemconfig {{/testbench/dut/zeros_max_len[7]} {-height 15 -radix unsigned} {/testbench/dut/zeros_max_len[6]} {-height 15 -radix unsigned} {/testbench/dut/zeros_max_len[5]} {-height 15 -radix unsigned} {/testbench/dut/zeros_max_len[4]} {-height 15 -radix unsigned} {/testbench/dut/zeros_max_len[3]} {-height 15 -radix unsigned} {/testbench/dut/zeros_max_len[2]} {-height 15 -radix unsigned} {/testbench/dut/zeros_max_len[1]} {-height 15 -radix unsigned} {/testbench/dut/zeros_max_len[0]} {-height 15 -radix unsigned}} /testbench/dut/zeros_max_len
add wave -noupdate -radix unsigned -childformat {{{/testbench/max_len_zeros[8]} -radix unsigned} {{/testbench/max_len_zeros[7]} -radix unsigned} {{/testbench/max_len_zeros[6]} -radix unsigned} {{/testbench/max_len_zeros[5]} -radix unsigned} {{/testbench/max_len_zeros[4]} -radix unsigned} {{/testbench/max_len_zeros[3]} -radix unsigned} {{/testbench/max_len_zeros[2]} -radix unsigned} {{/testbench/max_len_zeros[1]} -radix unsigned} {{/testbench/max_len_zeros[0]} -radix unsigned}} -subitemconfig {{/testbench/max_len_zeros[8]} {-height 15 -radix unsigned} {/testbench/max_len_zeros[7]} {-height 15 -radix unsigned} {/testbench/max_len_zeros[6]} {-height 15 -radix unsigned} {/testbench/max_len_zeros[5]} {-height 15 -radix unsigned} {/testbench/max_len_zeros[4]} {-height 15 -radix unsigned} {/testbench/max_len_zeros[3]} {-height 15 -radix unsigned} {/testbench/max_len_zeros[2]} {-height 15 -radix unsigned} {/testbench/max_len_zeros[1]} {-height 15 -radix unsigned} {/testbench/max_len_zeros[0]} {-height 15 -radix unsigned}} /testbench/max_len_zeros
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {415190 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 183
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
WaveRestoreZoom {0 ns} {1183103 ns}
