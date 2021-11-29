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