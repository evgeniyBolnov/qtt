`timescale 1ns/1ns

module testbench ();

  logic       clk        = 0;
  logic       rst_n      = 1;
  logic [7:0] input_data    ;

  logic [7:0] ones;

  logic [7:0] ones_tb[2];

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
    .WORD_SIZE(32)
  ) dut (
    .clk       (clk       ),
    .rst_n     (rst_n     ),
    .input_data(input_data),
    .ones      (ones      )
  );

  always_ff @(posedge clk iff rst_n)
    input_data <= $random();

  always_ff @(posedge clk iff rst_n)
    begin
      ones_tb[0]  <= $countones(bus);
      ones_tb[1]  <= ones_tb[0];
      assert(ones_tb[1] == ones) else $display("%tns Expected: %d but %d", $realtime, ones_tb[1], ones);
    end

endmodule : testbench