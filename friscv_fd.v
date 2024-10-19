module friscv_fd(

    // Entradas
    input           clock,                  // Clock do circuito
    input           reset,                  // Reseta o circuito       
    input           echo,                   // Echo do sensor 
    input           liga_frisc,             // Liga o circuito do Frisc-V 
    input           liga_suco_1,            // Entrada do botão que ativa para o suco 1
    input           liga_suco_2,            // Entrada do botão que ativa para o suco 2     
    input           inicia_medida,          // Inicia a medida no sensor      

    // Saídas
    output          copo_posicionado,       // Saída que indica se o copo está posicionado
    output          trigger,                // Trigger do sensor
    output          fim_medida,             // Sinal que indica que a medida foi encerrada
    output          liga_frisc_edge,        // Saída do edge detector para ligar o circuito do Frisc-V 
    output          liga_suco_1_edge,       // Saída do edge detector para entrada do botão que ativa para o suco 1
    output          liga_suco_2_edge,       // Saída do edge detector para entrada do botão que ativa para o suco 2    

    // Saídas de depuração
    output [11:0]   db_medida               // Sinal de depuração da medida
);

    wire [11:0] s_medida;

    interface_hcsr04 INTERFACE_HCSR04(

        // Entradas
        .clock(clock),
        .reset(reset),
        .medir(inicia_medida),
        .echo(echo),

        // Saídas
        .trigger(trigger),
        .medida(s_medida),
        .pronto(fim_medida),

        // Saídas de depuração
        .db_reset(),
        .db_medir(),
        .db_estado()   
    );

    // Compara para verificar se há um objeto numa distância de menor ou igual a 10 cm
    assign copo_posicionado = s_medida <= 12'b0000_0000_0101 ? 1'b1 : 1'b0;

    edge_detector EDGE_LIGA_SUCO_1(
        .clock(clock),
        .reset(reset),
        .sinal(liga_suco_1),
        .pulso(liga_suco_1_edge)
    );    

    edge_detector EDGE_LIGA_SUCO_2(
        .clock(clock),
        .reset(reset),
        .sinal(liga_suco_2),
        .pulso(liga_suco_2_edge)
    );  

    edge_detector EDGE_LIGA_FRISCV(
        .clock(clock),
        .reset(reset),
        .sinal(liga_frisc),
        .pulso(liga_frisc_edge)
    );       

endmodule