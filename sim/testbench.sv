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
  logic [8:0] max_len_zeros;

  logic v1_valid ;
  logic vcs_valid;
  logic l0_valid ;
  logic l1_valid ;

  initial forever #5 clk = ~clk;

  initial begin
    ##2 rst_n = 0;
    ##2 rst_n = 1;
  end

  default clocking main @(posedge clk);
  endclocking

  static_ctrl #(
    .WORD_SIZE(DATA_WIDTH),
    .V1_MIN   (100       ),
    .V1_MAX   (120       ),
    .Vcs_MIN  (50        ),
    .Vcs_MAX  (100       ),
    .L0_MIN   (4         ),
    .L0_MAX   (24        ),
    .L1_MIN   (4         ),
    .L1_MAX   (24        )
  ) dut (
    .clk              (clk              ),
    .rst_n            (rst_n            ),
    .input_data       (input_data       ),
    .ones             (ones             ),
    .change_sign_count(change_sign_count),
    .output_data      (output_data      ),
    .ones_max_len     (ones_max_len     ),
    .zeros_max_len    (zeros_max_len    ),
    .valid_data       (valid_data       ),
    .v1_valid         (v1_valid         ),
    .l0_valid         (l0_valid         ),
    .l1_valid         (l1_valid         ),
    .vcs_valid        (vcs_valid        )
  );

  always_ff @(posedge clk iff rst_n)
    input_data <= $random();

  assign ones_tb       = $countones(output_data);
  assign changes_tb    = changes(output_data);
  assign max_len_ones  = max_len(output_data, 1'b1);
  assign max_len_zeros = max_len(output_data, 1'b0);

  always_ff @(posedge clk iff valid_data)
    begin
      assert(ones_tb == ones) else $display("%tns Expected: %d but %d", $realtime, ones_tb[2], ones);
      assert(changes_tb == change_sign_count) else $display("%tns Expected: %d but %d", $realtime, changes_tb[2], change_sign_count);
      assert(max_len_ones == ones_max_len) else $display("%tns Expected Ones Length: %d but %d", $realtime, max_len_ones, ones_max_len);
      assert(max_len_zeros == zeros_max_len) else $display("%tns Expected Zeros Length: %d but %d", $realtime, max_len_zeros, zeros_max_len);
    end

  always_ff @(posedge clk iff valid_data)
    begin
      if( v1_valid & vcs_valid & l0_valid & l1_valid )
        $display("%tns Found number: %x", $realtime, output_data);
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
