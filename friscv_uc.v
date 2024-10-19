module friscv_uc(

    // Entradas
    input               clock,              // Clock do circuito
    input               reset,              // Reseta o circuito
    input               liga_frisc,         // Liga o circuito do Frisc-V 
    input               liga_suco_1,        // Entrada do botão que ativa para o suco 1
    input               liga_suco_2,        // Entrada do botão que ativa para o suco 2
    input               copo_posicionado,   // Saída que indica se o copo está posicionado

    // Saídas
    output reg          ativa_bomba_1,      // Saída para ativar a bomba 1
    output reg          ativa_bomba_2,      // Saída para ativar a bomba 2
    output reg          inicia_medida,      // Inicia a medida do sensor

    // Saídas de depuração
    output reg [3:0]    db_estado           // Sinal de depuração do estado da UC
);

    // Tipos e sinais
    reg [3:0] Eatual, Eprox; // 3 bits são suficientes para os estados

    // Parâmetros para os estados
    parameter inicial = 4'b000;
    parameter espera_ativar = 4'b0001;
    parameter liga_bomba_1 = 4'b0010;
    parameter liga_bomba_2 = 4'b0011;
    parameter final = 4'b0100;


    // Memória de estado
    always @(posedge clock, posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox; 
    end

    // Lógica de próximo estado
    always @(*) begin
        case (Eatual)

            inicial: Eprox = liga_frisc ? espera_ativar : inicial;
            espera_ativar:  Eprox = (liga_suco_1 && copo_posicionado) ? liga_bomba_1 : (liga_suco_2 && copo_posicionado) ? liga_bomba_2 : espera_ativar;
            liga_bomba_1:  Eprox = (liga_suco_1 && copo_posicionado) ? liga_bomba_1 : final;
            liga_bomba_2:  Eprox = (liga_suco_2 && copo_posicionado) ? liga_bomba_2 : final;
            final:  Eprox = inicial;
            default: Eprox = inicial; 

        endcase
    end

    // Lógica de saída (Moore)
    always @(*) begin
	
    inicia_medida = Eatual != inicial ? 1'b1 : 1'b0; 
    ativa_bomba_1 = Eatual == liga_bomba_1 ? 1'b1 : 1'b0;      
    ativa_bomba_2 = Eatual == liga_bomba_2 ? 1'b1 : 1'b0;      

        case(Eatual)
     
            inicial                 : db_estado = 4'b0000;
            espera_ativar           : db_estado = 4'b0001;
            liga_bomba_1            : db_estado = 4'b0010;
            liga_bomba_2            : db_estado = 4'b0011;
            final                   : db_estado = 4'b0100;
            default                 : db_estado = 4'b1110;

        endcase

    end

endmodule