module ones_count #(
  parameter WORD_SIZE = 64               , //128
  parameter BYTE_CNT  = WORD_SIZE / 8    , //16
  parameter BIT_RES   = $clog2(WORD_SIZE)
) (
  input                        clk,
  input        [WORD_SIZE-1:0] in ,
  output logic [  BIT_RES-1:0] out
);

  logic [3:0] ones_byte[  BYTE_CNT];
  logic [6:0] word_ones[BYTE_CNT/4]; //4

  genvar k,j;

  generate

    for (k = 0; k < BYTE_CNT; k++)
      begin: ones_count
        rom_ones_count ones_inst (
          .clk    (clk         ),
          .data_in(in[8*k +: 8]),
          .ones   (ones_byte[k])
        );
      end

    for(j = 0; j < BYTE_CNT / 4; j++ )
      begin: sum_inst
        sum_four #(
          .COUNT    (4),
          .DATA_SIZE(4)
        ) sum_four_inst (
          .clk(clk                ),
          .in (ones_byte[4*j +: 4]),
          .out(word_ones[j]       )
        );
      end

    sum_four #(
      .COUNT    (( BYTE_CNT / 4 )),
      .DATA_SIZE(7               )
    ) sum_out_inst (
      .clk(clk                             ),
      .in (word_ones[0 +: ( BYTE_CNT / 4 )]),
      .out(out                             )
    );

    endgenerate

endmodule

module rom_ones_count (
  input              clk    ,
  input        [7:0] data_in,
  output logic [3:0] ones
);

  logic [3:0] ram_count[256];

  initial $readmemh("../scripts/mem.hex", ram_count);

  always_ff @(posedge clk)
    ones <= ram_count[data_in];

endmodule 

module sum_four #(
  parameter COUNT     = 4,
  parameter DATA_SIZE = 4
) (
  input                              clk      ,
  input        [      DATA_SIZE-1:0] in[COUNT],
  output logic [DATA_SIZE+COUNT-2:0] out
);

  logic [DATA_SIZE+COUNT-2:0] summ;

  generate begin
      case( COUNT )
        1: assign summ =   ( in[0]         );
        2: assign summ =   ( in[0] + in[1] );
        3: assign summ =   ( in[0] + in[1] ) + ( in[2]         );
        4: assign summ =   ( in[0] + in[1] ) + ( in[2] + in[3] );
        8: assign summ = ( ( in[0] + in[1] ) + ( in[2] + in[3] ) ) + ( ( in[4] + in[5] ) + ( in[6] + in[7] ) );
      endcase
    end  
  endgenerate

  always_ff @(posedge clk)
    out <= summ;

endmodule