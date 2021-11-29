onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/dut/WORD_SIZE
add wave -noupdate /testbench/dut/BYTE_CNT
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/rst_n
add wave -noupdate /testbench/dut/input_data
add wave -noupdate /testbench/dut/shift_reg
add wave -noupdate -radix hexadecimal -childformat {{{/testbench/dut/data[31]} -radix hexadecimal} {{/testbench/dut/data[30]} -radix hexadecimal} {{/testbench/dut/data[29]} -radix hexadecimal} {{/testbench/dut/data[28]} -radix hexadecimal} {{/testbench/dut/data[27]} -radix hexadecimal} {{/testbench/dut/data[26]} -radix hexadecimal} {{/testbench/dut/data[25]} -radix hexadecimal} {{/testbench/dut/data[24]} -radix hexadecimal} {{/testbench/dut/data[23]} -radix hexadecimal} {{/testbench/dut/data[22]} -radix hexadecimal} {{/testbench/dut/data[21]} -radix hexadecimal} {{/testbench/dut/data[20]} -radix hexadecimal} {{/testbench/dut/data[19]} -radix hexadecimal} {{/testbench/dut/data[18]} -radix hexadecimal} {{/testbench/dut/data[17]} -radix hexadecimal} {{/testbench/dut/data[16]} -radix hexadecimal} {{/testbench/dut/data[15]} -radix hexadecimal} {{/testbench/dut/data[14]} -radix hexadecimal} {{/testbench/dut/data[13]} -radix hexadecimal} {{/testbench/dut/data[12]} -radix hexadecimal} {{/testbench/dut/data[11]} -radix hexadecimal} {{/testbench/dut/data[10]} -radix hexadecimal} {{/testbench/dut/data[9]} -radix hexadecimal} {{/testbench/dut/data[8]} -radix hexadecimal} {{/testbench/dut/data[7]} -radix hexadecimal} {{/testbench/dut/data[6]} -radix hexadecimal} {{/testbench/dut/data[5]} -radix hexadecimal} {{/testbench/dut/data[4]} -radix hexadecimal} {{/testbench/dut/data[3]} -radix hexadecimal} {{/testbench/dut/data[2]} -radix hexadecimal} {{/testbench/dut/data[1]} -radix hexadecimal} {{/testbench/dut/data[0]} -radix hexadecimal}} -subitemconfig {{/testbench/dut/data[31]} {-height 15 -radix hexadecimal} {/testbench/dut/data[30]} {-height 15 -radix hexadecimal} {/testbench/dut/data[29]} {-height 15 -radix hexadecimal} {/testbench/dut/data[28]} {-height 15 -radix hexadecimal} {/testbench/dut/data[27]} {-height 15 -radix hexadecimal} {/testbench/dut/data[26]} {-height 15 -radix hexadecimal} {/testbench/dut/data[25]} {-height 15 -radix hexadecimal} {/testbench/dut/data[24]} {-height 15 -radix hexadecimal} {/testbench/dut/data[23]} {-height 15 -radix hexadecimal} {/testbench/dut/data[22]} {-height 15 -radix hexadecimal} {/testbench/dut/data[21]} {-height 15 -radix hexadecimal} {/testbench/dut/data[20]} {-height 15 -radix hexadecimal} {/testbench/dut/data[19]} {-height 15 -radix hexadecimal} {/testbench/dut/data[18]} {-height 15 -radix hexadecimal} {/testbench/dut/data[17]} {-height 15 -radix hexadecimal} {/testbench/dut/data[16]} {-height 15 -radix hexadecimal} {/testbench/dut/data[15]} {-height 15 -radix hexadecimal} {/testbench/dut/data[14]} {-height 15 -radix hexadecimal} {/testbench/dut/data[13]} {-height 15 -radix hexadecimal} {/testbench/dut/data[12]} {-height 15 -radix hexadecimal} {/testbench/dut/data[11]} {-height 15 -radix hexadecimal} {/testbench/dut/data[10]} {-height 15 -radix hexadecimal} {/testbench/dut/data[9]} {-height 15 -radix hexadecimal} {/testbench/dut/data[8]} {-height 15 -radix hexadecimal} {/testbench/dut/data[7]} {-height 15 -radix hexadecimal} {/testbench/dut/data[6]} {-height 15 -radix hexadecimal} {/testbench/dut/data[5]} {-height 15 -radix hexadecimal} {/testbench/dut/data[4]} {-height 15 -radix hexadecimal} {/testbench/dut/data[3]} {-height 15 -radix hexadecimal} {/testbench/dut/data[2]} {-height 15 -radix hexadecimal} {/testbench/dut/data[1]} {-height 15 -radix hexadecimal} {/testbench/dut/data[0]} {-height 15 -radix hexadecimal}} /testbench/dut/data
add wave -noupdate -radix unsigned /testbench/dut/rx_cnt
add wave -noupdate /testbench/output_data
add wave -noupdate -divider {Ones Counter}
add wave -noupdate -radix unsigned /testbench/dut/ones
add wave -noupdate /testbench/ones_tb
add wave -noupdate -divider {Change of sign}
add wave -noupdate /testbench/change_sign_count
add wave -noupdate /testbench/changes_tb
add wave -noupdate -divider {Ones Max Length}
add wave -noupdate /testbench/max_len_ones
add wave -noupdate /testbench/dut/ones_max_len
add wave -noupdate -divider tmp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors
quietly wave cursor active 0
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
WaveRestoreZoom {0 ns} {1890 ns}
