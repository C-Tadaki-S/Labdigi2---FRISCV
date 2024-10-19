module friscv_fd(
    
);

    interface_hcsr04 INTERFACE_HCSR04(

        // Entradas
        .clock(),
        .reset(),
        .medir(),
        .echo(),

        // Saídas
        .trigger(),
        .medida(),
        .pronto(),

        // Saídas de depuração
        .db_reset(),
        .db_medir(),
        .db_estado()   
    );

endmodule