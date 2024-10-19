module friscv(

    // Entradas
    input           clock,              // Clock do circuito
    input           reset,              // Reseta o circuito
    input           liga_frisc,         // Liga o circuito do Frisc-V 
    input           liga_suco_1,        // Entrada do botão que ativa para o suco 1
    input           liga_suco_2,        // Entrada do botão que ativa para o suco 2

    // Saídas
    output          ativa_bomba_1,      // Saída para ativar a bomba 1
    output          ativa_bomba_2,      // Saída para ativar a bomba 2


    // Saídas de depuração
);



endmodule