module static_ctrl #(
  parameter WORD_SIZE = 256              ,
  parameter BIT_RES   = $clog2(WORD_SIZE)
) (
  input                      clk              ,
  input                      rst_n            ,
  input        [        7:0] input_data       ,
  output logic [BIT_RES-1:0] ones             ,
  output logic [BIT_RES-1:0] change_sign_count
);

  localparam BYTE_CNT = WORD_SIZE / 8;

  logic [       WORD_SIZE-1:0] data               ;
  logic [                 7:0] shift_reg[BYTE_CNT];
  logic [$clog2(BYTE_CNT)-1:0] rx_cnt             ;

  always_comb
    for (int i = 0; i < BYTE_CNT; i++)
      data[8*i+:8] = shift_reg[i];

  always_ff @(posedge clk or negedge rst_n)
    begin
      if( ~rst_n )
        begin
          for( int i = 0; i < BYTE_CNT; i++)
            shift_reg[i] <= '0;
          rx_cnt <= '0;
        end
      else
        begin
          shift_reg[rx_cnt] <= input_data;
          rx_cnt            <= rx_cnt + 1'b1;
        end
    end

  ones_count #(
    .WORD_SIZE(WORD_SIZE)
  ) ones_count_inst (
    .clk(clk ),
    .in (data),
    .out(ones)
  );

  change_sign #(
    .WORD_SIZE(WORD_SIZE)
  ) change_sign_inst (
    .clk              (clk              ),
    .data_in          (data             ),
    .change_sign_count(change_sign_count)
  );

endmodule : static_ctrl

module change_sign #(
  parameter WORD_SIZE = 64
) (
  input                          clk              ,
  input  [        WORD_SIZE-1:0] data_in          ,
  output [$clog2(WORD_SIZE)-1:0] change_sign_count
);

  (* keep *)logic [WORD_SIZE-1:0] change_sign;

  genvar i;

  generate
    begin
      for (i = 0; i < WORD_SIZE - 1; i++)
        begin: sign_detect
          assign change_sign[i] = data_in[i] ^ data_in[i+1];
        end
      assign change_sign[WORD_SIZE-1] = 1'b0;
    end
  endgenerate

  ones_count #(
    .WORD_SIZE(WORD_SIZE)
  ) ones_count_inst (
    .clk(clk              ),
    .in (change_sign      ),
    .out(change_sign_count)
  );

endmodule