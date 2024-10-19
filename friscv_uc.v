module friscv_uc(

    // Entradas
    input           clock,              // Clock do circuito
    input           reset,              // Reseta o circuito
    input           liga_frisc,         // Liga o circuito do Frisc-V 
    input           liga_suco_1,        // Entrada do botão que ativa para o suco 1
    input           liga_suco_2,        // Entrada do botão que ativa para o suco 2
    input           copo_posicionado,   // Saída que indica se o copo está posicionado
    input           fim_medida,         // Sinal que indica que a medida foi encerrada
    input           fim_bomba,          // Sinal que indica que o tempo de ativacao da bomba foi finalizado

    // Saídas
    output reg      ativa_bomba_1,      // Saída para ativar a bomba 1
    output reg      ativa_bomba_2,      // Saída para ativar a bomba 2
    output reg      conta_bomba,        // Ativa o contador de segundos para a bomba
    output reg      zera_bomba,         // Zera o contador de segundos para a bomba 

    // Saídas de depuração
    output [3:0]    db_estado           // Sinal de depuração do estado da UC
);

    // Tipos e sinais
    reg [3:0] Eatual, Eprox; // 3 bits são suficientes para os estados

    // Parâmetros para os estados
    parameter inicial = 3'b000;

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
            inicial: Eprox = liga_frisc ? ;


            default: 
                Eprox = inicial; 
        endcase
    end

    // Lógica de saída (Moore)
    always @(*) begin
	
    ativa_bomba_1 = Eatual == ? ;      
    ativa_bomba_2 = Eatual == ? ;      
    conta_bomba = Eatual == ? ;        
    zera_bomba = Eatual == ? ;               

        case(Eatual)
            : db_estado = 4'b0000;
            : db_estado = 4'b0001;
            : db_estado = 4'b0010;
            : db_estado = 4'b0011;
            : db_estado = 4'b0100;
            : db_estado = 4'b0101;
            : db_estado = 4'b0110;
            : db_estado = 4'b0111;
            : db_estado = 4'b1000;
            : db_estado = 4'b1001;
            default                   : db_estado = 4'b1110;
        endcase

    end

endmodule