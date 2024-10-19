/* --------------------------------------------------------------------------
 *  Arquivo   : interface_hcsr04.v
 * --------------------------------------------------------------------------
 *  Descricao : circuito de interface com sensor ultrassonico de distancia
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 * --------------------------------------------------------------------------
 */
 
module interface_hcsr04 (

    // Entradas
    input clock,
    input reset,
    input medir,
    input echo,

    // Saídas
    output trigger,
    output [11:0] medida,
    output pronto,

    // Saídas de depuração
    output db_reset,
    output db_medir,
    output [3:0] db_estado    
);

    // Sinais internos
    wire        s_zera;
    wire        s_gera;
    wire        s_registra;
    wire        s_fim_medida;
	wire		s_zera_timeout, s_conta_timeout, s_fim_timeout;
    wire [11:0] s_medida;

    // Unidade de controle
    interface_hcsr04_uc U1 (
        .clock     (clock       ),
        .reset     (reset       ),
        .medir     (medir       ),
        .echo      (echo        ),
        .fim_medida(s_fim_medida),
        .zera      (s_zera      ),
        .gera      (s_gera      ),
        .registra  (s_registra  ),
        .pronto    (pronto      ),
		.zera_timeout(s_zera_timeout),
		.conta_timeout(s_conta_timeout),
		.fim_timeout(s_fim_timeout),
        .db_estado (db_estado   )
    );

    // Fluxo de dados
    interface_hcsr04_fd U2 (
        .clock     (clock       ),
        .pulso     (echo        ), 
        .zera      (s_zera      ),
        .gera      (s_gera      ),
        .registra  (s_registra  ),
        .fim_medida(s_fim_medida),
        .trigger   (trigger     ),
        .fim       (            ),  // (desconectado)
        .distancia (s_medida    ),
		.zera_timeout(s_zera_timeout),
		.conta_timeout(s_conta_timeout),
		.fim_timeout(s_fim_timeout)
    );

    // Atribuição das saída
    assign medida = s_medida; 

    // Atribuição dos sinais de depuração
    assign db_reset = reset;
    assign db_medir = medir;

endmodule
