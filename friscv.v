module friscv(

    // Entradas
    input           clock,              // Clock do circuito
    input           reset,              // Reseta o circuito
    input           liga_frisc,         // Liga o circuito do Frisc-V 
    input           liga_suco_1,        // Entrada do botão que ativa para o suco 1
    input           liga_suco_2,        // Entrada do botão que ativa para o suco 2
    input           echo,               // Echo do sensor

    // Saídas
    output          ativa_bomba_1,      // Saída para ativar a bomba 1
    output          ativa_bomba_2,      // Saída para ativar a bomba 2
    output          trigger,            // Trigger do sensor


    // Saídas de depuração
    output [6:0]    db_medida_centena,  // Sinal de depuração da centena da medida feita pelo sensor
    output [6:0]    db_medida_dezena,   // Sinal de depuração da dezena da medida feita pelo sensor
    output [6:0]    db_medida_unidade,  // Sinal de depuração da unidade da medida feita pelo sensor
    output [6:0]    db_estado_friscv_uc,// Sinal de depuração da unidade de controle do Frisc-V
    output          db_ativa_bomba_1,   // Sinal de depuração do ativa_bomba_1
    output          db_ativa_bomba_2    // Sinal de depuração do ativa_bomba_2
);

    // Wires auxiliares
    wire s_copo_posicionado, s_liga_frisc_edge, s_liga_suco_1_edge, s_liga_suco_2_edge, s_inicia_medida;
    wire [11:0] s_db_medida;
    wire [3:0] s_db_estado_friscv_uc;

    friscv_fd FD(

        // Entradas
        .clock(clock),                                         // Clock do circuito
        .reset(reset),                                         // Reseta o circuito       
        .echo(echo),                                           // Echo do sensor       
        .inicia_medida(s_inicia_medida),                       // Inicia a medida no sensor 
        // Saídas
        .copo_posicionado(s_copo_posicionado),                 // Saída que indica se o copo está posicionado
        .trigger(trigger),                                     // Trigger do sensor
        .fim_medida(),                                         // Sinal que indica que a medida foi encerrada

        // Saídas de depuração
        .db_medida(s_db_medida)                                // Sinal de depuração da medida
    );

    friscv_uc UC(

        // Entradas
        .clock(clock),                                          // Clock do circuito
        .reset(reset),                                          // Reseta o circuito
        .liga_frisc(liga_frisc),                                // Liga o circuito do Frisc-V 
        .liga_suco_1(liga_suco_1),                              // Entrada do botão que ativa para o suco 1
        .liga_suco_2(liga_suco_2),                              // Entrada do botão que ativa para o suco 2
        .copo_posicionado(s_copo_posicionado),                  // Saída que indica se o copo está posicionado

        // Saídas
        .ativa_bomba_1(ativa_bomba_1),                          // Saída para ativar a bomba 1
        .ativa_bomba_2(ativa_bomba_2),                          // Saída para ativar a bomba 2
        .inicia_medida(s_inicia_medida),                        // Inicia a medida do sensor

        // Saídas de depuração
        .db_estado(s_db_estado_friscv_uc)                       // Sinal de depuração do estado da UC
    );

    // Display hexadecimal do estado da unidade de controle do Frisc-V
    hexa7seg HEX0(
        .hexa(s_db_estado_friscv_uc), 
        .display(db_estado_friscv_uc)
    );

    // Display hexadecimal da medida feita pelo sensor
    hexa7seg HEX3(
        .hexa(s_db_medida[3:0]), 
        .display(db_medida_unidade)
    );

    hexa7seg HEX4(
        .hexa(s_db_medida[7:4]), 
        .display(db_medida_dezena)
    );

    hexa7seg HEX5(
        .hexa(s_db_medida[11:8]), 
        .display(db_medida_centena)
    );

    // Atribuição dos sinais de depuração
    assign db_ativa_bomba_1 = ativa_bomba_1;
    assign db_ativa_bomba_2 = ativa_bomba_2;

endmodule