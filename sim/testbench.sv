`timescale 1ns/1ns

module testbench ();

  localparam DATA_WIDTH = 256;

  logic       clk        = 0;
  logic       rst_n      = 1;
  logic [7:0] input_data    ;

  logic[DATA_WIDTH-1:0] output_data;

  logic [7:0] ones             ;
  logic [7:0] change_sign_count;

  logic [7:0] ones_tb   ;
  logic [7:0] changes_tb;

  logic [8:0] ones_max_len ;
  logic [8:0] max_len_ones ;
  logic [8:0] zeros_max_len;

  logic [DATA_WIDTH-1:0] bus;
  assign bus = {<<8{dut.shift_reg}};

  initial forever #5 clk = ~clk;

  initial begin
    ##2 rst_n = 0;
    ##2 rst_n = 1;
  end

  default clocking main @(posedge clk);
  endclocking

  static_ctrl #(
    .WORD_SIZE(DATA_WIDTH)
  ) dut (
    .clk              (clk              ),
    .rst_n            (rst_n            ),
    .input_data       (input_data       ),
    .ones             (ones             ),
    .change_sign_count(change_sign_count),
    .output_data      (output_data      ),
    .ones_max_len     (ones_max_len     )
  );

  always_ff @(posedge clk iff rst_n)
    input_data <= $random();

  always_comb
    begin
      ones_tb = $countones(output_data);
      assert(ones_tb == ones) else $display("%tns Expected: %d but %d", $realtime, ones_tb[2], ones);
    end

  always_comb
    begin
      changes_tb = changes(output_data);
      assert(changes_tb == change_sign_count) else $display("%tns Expected: %d but %d", $realtime, changes_tb[2], change_sign_count);
    end

  assign max_len_ones  = max_len(output_data, 1'b1);

  always_ff @(posedge clk)
    begin
      assert(max_len_ones == ones_max_len) else $display("%tns Expected len: %d but %d", $realtime, max_len_ones, ones_max_len);
    end

  function logic [7:0] changes(input [DATA_WIDTH-1:0] in);
    begin
      changes = 0;
      for (int i = 0; i < $size(in) - 1; i++) 
        begin
          if (in[i] ^ in[i+1])
            changes++;
        end
      return changes;
    end
  endfunction 

  function logic [8:0] max_len(input [DATA_WIDTH-1:0] in, input logic f);
    automatic int length = 0;
    max_len = 0;
    for (int i = 0; i < $size(in); i++)
      begin
        if( in[i] == f )
          begin
            length++;
            if( length > max_len )
              max_len = length;
          end
        else
          length = 0;
      end
    return max_len;
  endfunction

endmodule : testbench
