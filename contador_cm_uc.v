/* --------------------------------------------------------------------------
 *  Arquivo   : contador_cm_uc.v
 * --------------------------------------------------------------------------
 *  Descricao : unidade de controle do componente contador_cm
 *              
 *              incrementa contagem de cm a cada sinal de tick enquanto
 *              o pulso de entrada permanece ativo
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 * --------------------------------------------------------------------------
 */

module contador_cm_uc (
    input wire clock,
    input wire reset,
    input wire pulso,
    input wire tick,
    output reg zera_tick,
    output reg conta_tick,
    output reg zera_bcd,
    output reg conta_bcd,
    output reg pronto
);

    // Tipos e sinais
    reg [2:0] Eatual, Eprox; // 3 bits são suficientes para os estados

    // Parâmetros para os estados
    parameter inicial = 3'b000;
    parameter espera = 3'b001;
    parameter conta = 3'b010;
    parameter final = 3'b011;
    // parameter F = 3'b100;

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
            inicial:
                Eprox = pulso ? espera : inicial;
            espera:
                Eprox = pulso ? (tick ? conta : espera) : final;
            conta:
                Eprox = espera;
            final:
                Eprox = inicial;
            default: 
                Eprox = inicial; 
        endcase
    end

    // Lógica de saída (Moore)
    always @(*) begin
	
        conta_bcd = Eatual == conta ? 1'b1 : 1'b0;
        zera_tick = Eatual == inicial ? 1'b1 : 1'b0;
        conta_tick = Eatual == espera ? 1'b1 : 1'b0;
        zera_bcd = Eatual == inicial ? 1'b1 : 1'b0;
        conta_bcd = Eatual == conta ? 1'b1 : 1'b0;
        pronto = Eatual == final ? 1'b1 : 1'b0;

    end

endmodule