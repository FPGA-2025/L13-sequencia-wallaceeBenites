module Sequencia (
    input wire clk,
    input wire rst_n, // Reset síncrono, ativo baixo

    input wire setar_palavra,
    input wire [7:0] palavra,

    input wire start,
    input wire bit_in,

    output reg encontrado // Saída que indica se a sequência foi encontrada
);

    // Registrador para armazenar a palavra a ser buscada
    reg [7:0] palavra_interna;
    // Registrador de deslocamento para os últimos 8 bits recebidos
    reg [7:0] shift_reg;
    // Flag para indicar se a busca está ativa
    reg searching;

    // Lógica síncrona principal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin // Reset ativo baixo
            palavra_interna <= 8'b0;
            shift_reg <= 8'b0;
            encontrado <= 1'b0;
            searching <= 1'b0;
        end else begin
            // Armazena a nova palavra quando setar_palavra está ativo
            if (setar_palavra) begin
                palavra_interna <= palavra;
            end

            // Inicia a busca quando start está ativo
            if (start) begin
                searching <= 1'b1;
            end

            // Lógica de busca e deslocamento (só executa se searching=1 e ainda não encontrou)
            if (searching && !encontrado) begin
                // Desloca o registrador e insere o novo bit_in
                // O novo bit entra na posição menos significativa (bit 0)
                shift_reg <= {shift_reg[6:0], bit_in};

                // Compara o registrador de deslocamento com a palavra interna
                // A comparação é feita APÓS o deslocamento, então comparamos com o valor que ACABOU de ser formado
                if ({shift_reg[6:0], bit_in} == palavra_interna) begin
                    encontrado <= 1'b1; // Encontrou! Ativa a saída e trava
                end
            end
            
            // Se já encontrou, mantém encontrado em 1 (trava)
            // Se não estava buscando, mantém encontrado em 0 (ou o valor do reset)
        end
    end

endmodule

