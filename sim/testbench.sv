`timescale 1ns/1ns

module testbench ();

  localparam DATA_WIDTH = 32;

  logic       clk        = 0;
  logic       rst_n      = 1;
  logic [7:0] input_data    ;

  logic [7:0] ones             ;
  logic [7:0] change_sign_count;

  logic [7:0] ones_tb[3];
  logic [7:0] changes_tb[3];

  logic [31:0] bus;
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
    .change_sign_count(change_sign_count)
  );

  always_ff @(posedge clk iff rst_n)
    input_data <= $random();

  always_ff @(posedge clk iff rst_n)
    begin
      ones_tb[0]  <= $countones(bus);
      ones_tb[1]  <= ones_tb[0];
      ones_tb[2]  <= ones_tb[1];
      assert(ones_tb[2] == ones) else $display("%tns Expected: %d but %d", $realtime, ones_tb[2], ones);
    end

  always_ff @(posedge clk iff rst_n)
    begin
      changes_tb[0] <= changes(bus);
      changes_tb[1]  <= changes_tb[0];
      changes_tb[2]  <= changes_tb[1];
      assert(changes_tb[2] == change_sign_count) else $display("%tns Expected: %d but %d", $realtime, changes_tb[2], change_sign_count);
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

endmodule : testbench
