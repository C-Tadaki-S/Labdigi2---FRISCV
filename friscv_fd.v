module friscv_fd(

    // Entradas
    input           clock,                  // Clock do circuito
    input           reset,                  // Reseta o circuito       
    input           echo,                   // Echo do sensor 
    input           inicia_medida,          // Inicia a medida no sensor      

    // Saídas
    output          copo_posicionado,       // Saída que indica se o copo está posicionado
    output          trigger,                // Trigger do sensor
    output          fim_medida,             // Sinal que indica que a medida foi encerrada 

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
    assign copo_posicionado = (s_medida <= 12'b0000_0000_0101 && s_medida != 12'b0000_0000_0000) ? 1'b1 : 1'b0;     

    // Atribuição dos sinais de depuração
    assign db_medida = s_medida;

endmodule