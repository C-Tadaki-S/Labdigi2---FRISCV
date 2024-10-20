`timescale 1ns/1ns

module friscv_tb;

    // Declaração de sinais
        // Entradas
    reg           clock;             // Clock do circuito
    reg           reset;             // Reseta o circuito
    reg           liga_frisc;        // Liga o circuito do Frisc-V 
    reg           liga_suco_1;       // Entrada do botão que ativa para o suco 1
    reg           liga_suco_2;       // Entrada do botão que ativa para o suco 2
    reg           echo;              // Echo do sensor

    // Saídas
    wire          ativa_bomba_1;     // Saída para ativar a bomba 1
    wire          ativa_bomba_2;     // Saída para ativar a bomba 2
    wire          trigger;           // Trigger do sensor


    // Saídas de depuração
    wire [6:0]    db_medida_centena; // Sinal de depuração da centena da medida feita pelo sensor
    wire [6:0]    db_medida_dezena;  // Sinal de depuração da dezena da medida feita pelo sensor
    wire [6:0]    db_medida_unidade; // Sinal de depuração da unidade da medida feita pelo sensor
    wire [6:0]    db_estado_friscv_uc; // Sinal de depuração da unidade de controle do Frisc-V
    wire          db_ativa_bomba_1;  // Sinal de depuração do ativa_bomba_1
    wire          db_ativa_bomba_2;   // Sinal de depuração do ativa_bomba_2
    // Componente a ser testado (Device Under Test -- DUT)
    friscv dut (
      .clock(clock),             // Clock do circuito
      .reset(reset),             // Reseta o circuito
      .liga_frisc(liga_frisc),        // Liga o circuito do Frisc-V 
      .liga_suco_1(liga_suco_1),       // Entrada do botão que ativa para o suco 1
      .liga_suco_2(liga_suco_2),       // Entrada do botão que ativa para o suco 2
      .echo(echo),              // Echo do sensor

        // Saídas
      .ativa_bomba_1(ativa_bomba_1),     // Saída para ativar a bomba 1
      .ativa_bomba_2(ativa_bomba_2),     // Saída para ativar a bomba 2
      .trigger(trigger),           // Trigger do sensor
      .db_medida_centena(db_medida_centena), // Sinal de depuração da centena da medida feita pelo sensor
      .db_medida_dezena(db_medida_dezena),  // Sinal de depuração da dezena da medida feita pelo sensor
      .db_medida_unidade(db_medida_unidade), // Sinal de depuração da unidade da medida feita pelo sensor
      .db_estado_friscv_uc(db_estado_friscv_uc), // Sinal de depuração da unidade de controle do Frisc-V
      .db_ativa_bomba_1(db_ativa_bomba_1),  // Sinal de depuração do ativa_bomba_1
      .db_ativa_bomba_2(db_ativa_bomba_2)   // Sinal de depuração do ativa_bomba_2
    );

    // Configurações do clock
    parameter clockPeriod = 20; // clock de 50MHz
    // Gerador de clock
    always #(clockPeriod/2) clock = ~clock;

    // Array de casos de teste (estrutura equivalente em Verilog)
    reg [31:0] casos_teste [0:5]; // Usando 32 bits para acomodar o tempo
    integer caso;

    // Largura do pulso
    reg [31:0] larguraPulso; // Usando 32 bits para acomodar tempos maiores

    // Geração dos sinais de entrada (estímulos)
    initial begin
        $display("Inicio das simulacoes");

        // Inicialização do array de casos de teste
        casos_teste[0] = 32'd200;   // 588us (10cm)
        casos_teste[1] = 32'd300;   // 609us (10,36cm) truncar para 10cm
        casos_teste[2] = 32'd400;   // 882us (15cm)
        casos_teste[3] = 32'd926;   // 926us (15,74cm) arredondar para 16cm
        casos_teste[4] = 32'd1471;   // 1470us (25cm)
        casos_teste[5] = 32'd1501;   // 1501us (25,51cm) arredondar para 26cm

        // Valores iniciais
        reset = 0;
        liga_frisc = 0;
        liga_suco_1 = 0;
        liga_suco_2 = 0;
        echo = 0;
        clock = 0;

        // Reset
        caso = 1; 
        #(2*clockPeriod);
        reset = 1;
        #(2_000); // 2 us
        liga_frisc = 1;
        liga_suco_1 = 1;
        liga_suco_2 = 0;
        reset = 0;
        @(negedge clock);

        // Espera de 100us
        #(100_000); // 100 us

        // // Loop pelos casos de teste
        for (caso = 1; caso < 7; caso = caso + 1) begin
            // 1) Determina a largura do pulso echo
            $display("Caso de teste %0d: %0dus", caso, casos_teste[caso-1]);
            larguraPulso = casos_teste[caso-1]*1000; // 1us=1000

            // 2) Envia pulso medir
            @(negedge clock);
            // 3) Espera por 400us (tempo entre trigger e echo)
            #(400_000); // 400 us

            // 4) Gera pulso de echo
            echo = 1;
            #(larguraPulso);
            echo = 0;

            // 5) Espera final da medida
            $display("Fim do caso %0d", caso);

            // 6) Espera entre casos de teste
            #(100_000); // 100 us
        end

        // Fim da simulação
        $display("Fim das simulacoes");
        caso = 99; 
        $stop;
    end

endmodule