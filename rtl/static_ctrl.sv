module static_ctrl #(
  parameter WORD_SIZE = 256              ,
  parameter BIT_RES   = $clog2(WORD_SIZE)
) (
  input                        clk              ,
  input                        rst_n            ,
  input        [          7:0] input_data       ,
  output       [WORD_SIZE-1:0] output_data      ,
  output                       valid_data       ,
  output logic [  BIT_RES-1:0] ones             ,
  output logic [  BIT_RES-1:0] change_sign_count,
  output logic [  BIT_RES-1:0] ones_max_len     ,
  output logic [  BIT_RES-1:0] zeros_max_len
);

  localparam BYTE_CNT   = WORD_SIZE / 8        ;
  localparam DELAY      = $clog2(WORD_SIZE) - 1;
  localparam DATA_DELAY = $clog2(WORD_SIZE) - 2;
  localparam ONES_DELAY = $clog2(WORD_SIZE) - 5;

  logic [DELAY-1:0] valid_dl;

  logic [WORD_SIZE-1:0] data               ;
  logic [WORD_SIZE-1:0] data_dl[DATA_DELAY];

  logic [                 7:0] shift_reg[BYTE_CNT];
  logic [$clog2(BYTE_CNT)-1:0] rx_cnt             ;

  logic [BIT_RES-1:0] ones_delay[ONES_DELAY-1:0];
  logic [BIT_RES-1:0] ones_wire                 ;

  logic [BIT_RES-1:0] change_sign_delay[ONES_DELAY-1:0];
  logic [BIT_RES-1:0] change_sign_wire                 ;

  assign output_data = data_dl[DATA_DELAY-1];
  assign valid_data  = valid_dl[DELAY-1];

  generate
    if( ONES_DELAY == 0 )
      begin
        assign ones              = ones_wire;
        assign change_sign_count = change_sign_wire;
      end
    else
      begin
        always_ff @(posedge clk or negedge rst_n)
          begin
            if( ~rst_n )
              for (int i = 0; i < ONES_DELAY; i++)
                begin
                  ones_delay[i]        <= '0;
                  change_sign_delay[i] <= '0;
                end
            else
              begin
                ones_delay[0]        <= ones_wire;
                change_sign_delay[0] <= change_sign_wire;
                for (int i = 1; i < ONES_DELAY; i++)
                  begin
                    ones_delay[i]        <= ones_delay[i-1];
                    change_sign_delay[i] <= change_sign_delay[i-1];
                  end
              end
          end

          assign ones              = ones_delay[ONES_DELAY-1];
          assign change_sign_count = change_sign_delay[ONES_DELAY-1];
        end
      endgenerate

  always_comb
    for (int i = 0; i < BYTE_CNT; i++)
      data[8*i+:8] = shift_reg[i];

  always_ff @(posedge clk or negedge rst_n)
    begin
      if( ~rst_n )
        for (int i = 0; i < DATA_DELAY; i++)
          data_dl[i] <= '0;
      else
        begin
          data_dl[0] <= data;
          for (int i = 1; i < DATA_DELAY; i++)
            data_dl[i] <= data_dl[i-1];
        end
    end

    always_ff @(posedge clk or negedge rst_n)
      begin
        if( ~rst_n )
          valid_dl <= '0;
        else
          begin
            valid_dl[0] <= 1'b1;
            for (int i = 1; i < DELAY; i++)
              valid_dl[i] <= valid_dl[i-1];
          end
      end

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
    .clk(clk      ),
    .in (data     ),
    .out(ones_wire)
  );

  change_sign #(
    .WORD_SIZE(WORD_SIZE)
  ) change_sign_inst (
    .clk              (clk             ),
    .data_in          (data            ),
    .change_sign_count(change_sign_wire)
  );

  ones_max_length #(
    .WORD_SIZE(WORD_SIZE)
  ) ones_max_length_inst (
    .clk        (clk         ),
    .rst_n      (rst_n       ),
    .in         (data        ),
    .current_max(ones_max_len)
  );

  ones_max_length #(
    .WORD_SIZE(WORD_SIZE)
  ) zeros_max_length_inst (
    .clk        (clk          ),
    .rst_n      (rst_n        ),
    .in         (~data        ),
    .current_max(zeros_max_len)
  );

endmodule : static_ctrl 

module ones_max_length #(
  parameter WORD_SIZE = 256
) (
  input                          clk        ,
  input                          rst_n      ,
  input  [        WORD_SIZE-1:0] in         ,
  output [$clog2(WORD_SIZE)-1:0] current_max
);

  localparam BYTE_CNT = WORD_SIZE / 8;

  genvar i, j, k;

  logic [$clog2(WORD_SIZE):0] layer_len  [$clog2(BYTE_CNT)+1][BYTE_CNT];
  logic [$clog2(WORD_SIZE):0] layer_end  [$clog2(BYTE_CNT)+1][BYTE_CNT];
  logic [$clog2(WORD_SIZE):0] layer_start[$clog2(BYTE_CNT)+1][BYTE_CNT];

  generate
    begin
      for (i = 0; i < BYTE_CNT; i++)
        begin: ones_length_inst
          ones_len_byte ones_inst (
            .clk      (clk              ),
            .rst_n    (rst_n            ),
            .in       (in[8*i +: 8]     ),
            .max_len  (layer_len[0][i]  ),
            .max_end  (layer_end[0][i]  ),
            .max_start(layer_start[0][i])
          );
        end
      for (k = 1; k <= $clog2(BYTE_CNT); k++)
        begin: layers
          for (j = 0; j < (BYTE_CNT >> k); j++)
            begin: layer
              join_lens #(
                .WIDTH_IN(4+k),
                .LAYER   (k  )
              ) join_layer (
                .clk       (clk                    ),
                .rst_n     (rst_n                  ),
                .in_0_start(layer_start[k-1][2*j]  ),
                .in_0_len  (layer_len[k-1][2*j]    ),
                .in_0_end  (layer_end[k-1][2*j]    ),
                .in_1_start(layer_start[k-1][2*j+1]),
                .in_1_len  (layer_len[k-1][2*j+1]  ),
                .in_1_end  (layer_end[k-1][2*j+1]  ),
                .out_start (layer_start[k][j]      ),
                .out_len   (layer_len[k][j]        ),
                .out_end   (layer_end[k][j]        )
              );
            end
        end
    end
  endgenerate

  assign current_max = layer_len[$clog2(BYTE_CNT)][0];

endmodule : ones_max_length

module join_lens #(
  parameter WIDTH_IN = 4, 
  parameter LAYER = 1
) (
  input                       clk       ,
  input                       rst_n     ,
  input        [WIDTH_IN-1:0] in_0_start,
  input        [WIDTH_IN-1:0] in_0_len  ,
  input        [WIDTH_IN-1:0] in_0_end  ,
  input        [WIDTH_IN-1:0] in_1_start,
  input        [WIDTH_IN-1:0] in_1_len  ,
  input        [WIDTH_IN-1:0] in_1_end  ,
  output logic [  WIDTH_IN:0] out_start ,
  output logic [  WIDTH_IN:0] out_len   ,
  output logic [  WIDTH_IN:0] out_end   
);

  always_ff @(posedge clk or negedge rst_n)
    begin
      if( ~rst_n )
        begin
          out_start <= '0;
          out_len   <= '0;
          out_end   <= '0;
        end
      else
        begin
          if( in_0_len == 8*2**(LAYER-1))
            out_start <= in_0_start + in_1_start;
          else
            out_start <= in_0_start;
          if( in_0_end != 0)
            begin
              if( in_0_end + in_1_start > in_0_len && in_0_end + in_1_start > in_1_len )
                out_len = in_0_end + in_1_start;
              else
                begin
                  if( in_0_len > in_1_len )
                    out_len = in_0_len;
                  else
                    out_len = in_1_len;
                end
            end
          else
            out_len = (in_0_len > in_1_len) ? in_0_len : in_1_len;
          if( in_1_len == 8*2**(LAYER-1) )
            out_end <= in_1_end + in_0_end;
          else
            out_end <= in_1_end;
        end
    end

endmodule 

module ones_len_byte (
  input              clk      ,
  input              rst_n    ,
  input        [7:0] in       ,
  output logic [3:0] max_len  ,
  output logic [3:0] max_end  ,
  output logic [3:0] max_start
);

  logic [11:0] rom[256];

  logic [11:0] rom_read;

  initial $readmemh("../scripts/mem_len.hex", rom);

  assign max_end   = rom_read[7:4];
  assign max_len   = rom_read[11:8];
  assign max_start = rom_read[3:0];

  always_ff @( posedge clk or negedge rst_n )
    begin
      if( ~rst_n )
        rom_read <= '0;
      else
        rom_read <= rom[in];
    end

endmodule : ones_len_byte