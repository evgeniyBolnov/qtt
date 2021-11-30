module static_ctrl #(
  parameter WORD_SIZE = 32              , //! Размер анализируемого слова
  parameter BIT_RES   = $clog2(WORD_SIZE), //! Количество бит для счетчиков
  parameter V1_MIN    = 100              , //! Ограничение для V1
  parameter V1_MAX    = 156              , //! Ограничение для V1
  parameter Vcs_MIN   = 100              , //! Ограничение для Vзп
  parameter Vcs_MAX   = 156              , //! Ограничение для Vзп
  parameter L0_MIN    = 4                , //! Ограничение для L0
  parameter L0_MAX    = 24               , //! Ограничение для L0
  parameter L1_MIN    = 4                , //! Ограничение для L1
  parameter L1_MAX    = 24                 //! Ограничение для L1
) (
  input                        clk              , //! Тактовая частота
  input                        rst_n            , //! Асинхронный сброс, активный 0
  input        [          7:0] input_data       , //! Входной байт
  output       [WORD_SIZE-1:0] output_data      , //! Выходное слово
  output                       valid_data       , //! Валидность выходных данных
  output logic [  BIT_RES-1:0] ones             , //! Количество единиц в слове
  output logic [  BIT_RES-1:0] change_sign_count, //! Количество знакоперемен
  output logic [  BIT_RES-1:0] ones_max_len     , //! Максимальная длина подряд идущих единиц
  output logic [  BIT_RES-1:0] zeros_max_len    , //! Максимальная длина подряд идущих нулей
  output                       v1_valid         , //! Соответствие условиям
  output                       l0_valid         , //! Соответствие условиям
  output                       l1_valid         , //! Соответствие условиям
  output                       vcs_valid          //! Соответствие условиям
);

  localparam BYTE_CNT   = WORD_SIZE / 8        ; //! Количество байт
  localparam DELAY      = $clog2(WORD_SIZE) - 1; //! Задержка для сигнала valid_data
  localparam DATA_DELAY = $clog2(WORD_SIZE) - 2; //! Задержка для данных
  localparam ONES_DELAY = $clog2(WORD_SIZE) - 5; //! Задержка для компенсации расчета кол-ва единиц и знакоперемен

  logic [DELAY-1:0] valid_dl; //! Регистры задержки для valid_data

  logic [WORD_SIZE-1:0] data               ; //! Регистр для слова
  logic [WORD_SIZE-1:0] data_dl[DATA_DELAY]; //! Регистры задержки для слова

  logic [                 7:0] shift_reg[BYTE_CNT];
  logic [$clog2(BYTE_CNT)-1:0] rx_cnt             ;

  logic [BIT_RES-1:0] ones_delay[ONES_DELAY-1:0];
  logic [BIT_RES-1:0] ones_wire                 ;

  logic [BIT_RES-1:0] change_sign_delay[ONES_DELAY-1:0];
  logic [BIT_RES-1:0] change_sign_wire                 ;

  assign output_data = data_dl[DATA_DELAY-1];
  assign valid_data  = valid_dl[DELAY-1];

  assign l0_valid    = ( zeros_max_len     > L0_MIN  ) && ( zeros_max_len     <= L0_MAX  );
  assign l1_valid    = ( ones_max_len      > L1_MIN  ) && ( ones_max_len      <= L1_MAX  );

  generate
    if( ONES_DELAY == 0 )
      begin
        assign ones              = ones_wire;
        assign change_sign_count = change_sign_wire;

        assign v1_valid          = ( ones_wire > V1_MIN  ) && ( ones_wire <  V1_MAX  ) ? 1'b1 : 1'b0;
        assign vcs_valid         = ( change_sign_wire > Vcs_MIN ) && ( change_sign_wire <  Vcs_MAX ) ? 1'b1 : 1'b0;
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

          assign v1_valid          = ( ones_delay[ONES_DELAY-1] > V1_MIN  ) && ( ones_delay[ONES_DELAY-1] <  V1_MAX  ) ? 1'b1 : 1'b0;
          assign vcs_valid         = ( change_sign_delay[ONES_DELAY-1] > Vcs_MIN ) && ( change_sign_delay[ONES_DELAY-1] <  Vcs_MAX ) ? 1'b1 : 1'b0;
        end
      endgenerate

  always_ff @(posedge clk or negedge rst_n)
    begin: data_delay
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
    begin : fill_reg
      if( ~rst_n )
        begin
          data     <= '0;
          rx_cnt   <= '0;
          valid_dl <= '0;
        end
      else
        begin
          data[8*rx_cnt+:8] <= input_data;
          rx_cnt            <= rx_cnt + 1'b1;
          valid_dl[0]       <= 1'b1;
          for (int i = 1; i < DELAY; i++)
            valid_dl[i] <= valid_dl[i-1];
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
