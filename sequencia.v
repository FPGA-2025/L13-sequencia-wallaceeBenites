module Sequencia (
    input wire clk,
    input wire rst_n, 

    input wire setar_palavra,
    input wire [7:0] palavra,

    input wire start,
    input wire bit_in,

    output reg encontrado 
);


    reg [7:0] palavra_interna;

    reg [7:0] shift_reg;

    reg searching;


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin 
            palavra_interna <= 8'b0;
            shift_reg <= 8'b0;
            encontrado <= 1'b0;
            searching <= 1'b0;
        end else begin
    
            if (setar_palavra) begin
                palavra_interna <= palavra;
            end

            if (start) begin
                searching <= 1'b1;
            end

 
            if (searching && !encontrado) begin
 
                shift_reg <= {shift_reg[6:0], bit_in};


                if ({shift_reg[6:0], bit_in} == palavra_interna) begin
                    encontrado <= 1'b1; 
                end
            end
            
  
        end
    end

endmodule

