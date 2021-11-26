module static_ctrl #(
  parameter WORD_SIZE = 256                   ,
  parameter BIT_RES   = $clog2(WORD_SIZE * 8)
) (
  input                      clk       ,
  input                      rst_n     ,
  input        [        7:0] input_data,
  output logic [BIT_RES-1:0] ones,
  output logic [BIT_RES-1:0] zeros
);

  localparam BYTE_CNT = WORD_SIZE / 8;

  logic [                 7:0] shift_reg[BYTE_CNT];
  logic [$clog2(BYTE_CNT)-1:0] rx_cnt             ;

  logic [3+BYTE_CNT:0] ones_l             ;
  logic [         3:0] ones_byte[BYTE_CNT];

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

  always_ff @(posedge clk or negedge rst_n)
    begin
      if( ~rst_n )
        for( int i = 0; i < BYTE_CNT; i++)
          ones_byte[i] <= '0;
      else
        for( int i = 0; i < BYTE_CNT; i++)
          ones_byte[i] <= bit_count(shift_reg[i]);
    end

  //assign ones_l = (ones_byte[0] + ones_byte[1]) + (ones_byte[2] + ones_byte[3]);

  always_ff @(posedge clk) begin
    for(int i = 0; i < BYTE_CNT; i++)
      ones_l <= ones_l + ones_byte[i];
  end

  always_ff @(posedge clk or negedge rst_n)
    begin
      if( ~rst_n)
        begin
          zeros <= '0;
          ones  <= '0;
        end
      else
        begin
          zeros <= WORD_SIZE - ones_l;
          ones  <= ones_l;
        end
    end


  function logic [3:0] bit_count (logic [7:0]in);
    logic [1:0] lr0[4];
    logic [2:0] lr1[2];
    lr0[0] = in[0] + in[1];
    lr0[1] = in[2] + in[3];
    lr0[2] = in[4] + in[5];
    lr0[3] = in[6] + in[7];
    lr1[0] = lr0[0] + lr0[1];
    lr1[1] = lr0[2] + lr0[3];
    return lr1[0] + lr1[1];
  endfunction : bit_count

endmodule : static_ctrl