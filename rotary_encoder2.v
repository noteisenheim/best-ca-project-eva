module rotary_encoder2 (input dt, input sw, input clk, output [7:0] segs, output [2:0] bits);  // dt and sw - inputs of rotary encoder

	reg[9:0] rot;  // counter of rotations made
	reg [3:0] num3; // register helping to output the number onto 8-segment display
	reg[7:0] r;  // rot mod 20
	
	reg bit2, bit3; // registers which determine whether output containd 2 digits or 3 digits
	
	initial begin
		bit2 <= 0;
		bit3 <= 0;
		rot <= 0;
	end
	
	display3num d3(bit3, clk, num3, segs, bits);
	
	always @(posedge sw) begin  // geting numbers of rotations
		if (!dt) begin
			rot = rot + 1; //incrementing on clockwise rotation
		end
		else begin
			rot = rot - 1; //decrementing on counterclockwise rotation
		end
	end
	
	always @(posedge clk) begin  // converting number of rotations into the angle of rotation
		r = rot % 20;
		case (r)
			0: begin
				bit2 = 1;
				bit3 = 0;
				num3 = 4'b0000;
			end
			1: begin
				bit2 = 1;
				bit3 = 0;
				num3 = 4'b0001;
			end
			2: begin
				bit2 = 1;
				bit3 = 0;
				num3 = 4'b0010;
			end
			3: begin
				bit2 = 1;
				bit3 = 0;
				num3 = 4'b0011;
			end
			4: begin
				bit2 = 1;
				bit3 = 0;
				num3 = 4'b0100;
			end
			5: begin
				bit2 = 1;
				bit3 = 0;
				num3 = 4'b0101;
			end
			6: begin
				bit2 = 0;
				bit3 = 1;
				num3 = 4'b0000;
			end
			7: begin
				bit2 = 0;
				bit3 = 1;
				num3 = 4'b0001;
			end
			8: begin
				bit2 = 0;
				bit3 = 1;
				num3 = 4'b0010;
			end
			9: begin
				bit2 = 0;
				bit3 = 1;
				num3 = 4'b0011;
			end
			10: begin
				bit2 = 0;
				bit3 = 1;
				num3 = 4'b0100;
			end
			11: begin
				bit2 = 0;
				bit3 = 1;
				num3 = 4'b0101;
			end
			12: begin
				bit2 = 0;
				bit3 = 1;
				num3 = 4'b0110;
			end
			13: begin
				bit2 = 0;
				bit3 = 1;
				num3 = 4'b0111;
			end
			14: begin
				bit2 = 0;
				bit3 = 1;
				num3 = 4'b1000;
			end
			15: begin
				bit2 = 0;
				bit3 = 1;
				num3 = 4'b1001;
			end
			16: begin
				bit2 = 0;
				bit3 = 1;
				num3 = 4'b1010;
			end
			17: begin
				bit2 = 0;
				bit3 = 1;
				num3 = 4'b1011;
			end
			18: begin
				bit2 = 0;
				bit3 = 1;
				num3 = 4'b1100;
			end
			19: begin
				bit2 = 0;
				bit3 = 1;
				num3 = 4'b1101;
			end
		endcase
	end 
	
endmodule




module display3num(input flag, input CLK, input [3:0] num, output [7:0] segs, output [2:0] bits);  // module for outputing the angle of rotation

	reg [2:0] b = 3'b111; // helping register for output
	reg [7:0] num1, num2, num3; //helping reisters to contain how numbers are displayed
	reg [7:0] s = 8'b11111111; //helping register for output

	reg [1:0] state;
	reg [32:0] ctr;

	assign segs = s;
	assign bits = b;

	always begin
		if (flag) begin  // flag determines whether output is 3-digit or 2-digit (3-digit if asserted)
			case(num) // for numbers with 3 digits
				4'b0000: begin
					num1 = 8'b10011111;
					num2 = 8'b00000011;
					num3 = 8'b00000001;
				end	
				4'b0001: begin
					num1 = 8'b10011111;
					num2 = 8'b00100101;
					num3 = 8'b01000001;
				end
				4'b0010: begin
					num1 = 8'b10011111;
					num2 = 8'b10011001;
					num3 = 8'b10011001;
				end
				4'b0011: begin
					num1 = 8'b10011111;
					num2 = 8'b01000001;
					num3 = 8'b00100101;
				end
				4'b0100: begin
					num1 = 8'b10011111;
					num2 = 8'b00000001;
					num3 = 8'b00000011;
				end
				4'b0101: begin
					num1 = 8'b10011111;
					num2 = 8'b00001001;
					num3 = 8'b00000001;
				end
				4'b0110: begin
					num1 = 8'b00100101;
					num2 = 8'b10011111;
					num3 = 8'b01000001;
				end
				4'b0111: begin
					num1 = 8'b00100101;
					num2 = 8'b00001101;
					num3 = 8'b10011001;
				end
				4'b1000: begin
					num1 = 8'b00100101;
					num2 = 8'b01001001;
					num3 = 8'b00100101;
				end
				4'b1001: begin
					num1 = 8'b00100101;
					num2 = 8'b00011111;
					num3 = 8'b00000011;
				end
				4'b1010: begin
					num1 = 8'b00100101;
					num2 = 8'b00000001;
					num3 = 8'b00000001;
				end
				4'b1011: begin
					num1 = 8'b00001101;
					num2 = 8'b00000011;
					num3 = 8'b00001101;
				end
				4'b1100: begin
					num1 = 8'b00001101;
					num2 = 8'b00100101;
					num3 = 8'b10011001;
				end
				4'b1101: begin
					num1 = 8'b00001101;
					num2 = 8'b10011001;
					num3 = 8'b00100101;
				end
			endcase
		end
		else begin
			case(num[2:0]) // for numbers with 2 digits
				3'b000: begin
					num1 = 8'b00000011;
					num2 = num1;
				end
				3'b001: begin
					num1 = 8'b00000001;
					num2 = 8'b10011111;
				end
				3'b010: begin
					num1 = 8'b01000001;
					num2 = 8'b00001101;
				end
				3'b011: begin
					num1 = 8'b10011001;
					num2 = 8'b01001001;
				end
				3'b100: begin
					num1 = 8'b00100101;
					num2 = 8'b00011111;
				end
				3'b101: begin
					num1 = 8'b00000011;
					num2 = 8'b00001001;
				end
			endcase
		end
	end

	always @ (posedge CLK) begin

		ctr <= ctr + 1;
		state <= ctr[16:15];
		
		if (flag) begin  // output for numbers with 3 digits
			if (state == 2'b00) begin
					s = num3;
					b = 3'b110;
				end
			else if (state == 2'b01) begin
					s = num2;
					b = 3'b101;
				end
			else if (state == 2'b10) begin
					s = num1;
					b = 3'b011;
				end
		end
		else begin // output for numbers with 2 digits
			if (state[0] == 1'b0) begin
					s = num1;
					b = 3'b110;
				end
			else if (state[0] == 1'b1) begin
					s = num2;
					b = 3'b101;
				end
		end
	end

endmodule