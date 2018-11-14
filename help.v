module help(input clk, input ps2d, input ps2c, output [7:0] segs, output bit);  // ps2d is assigned to keyboard data, ps2c - to keyboard clock

	wire ready;  // high if the code was read
	wire [7:0] code; // contains the code read from keyboard
	
	keyboard k(clk, ps2d, ps2c, code, ready);
	show_letter s(code, ready, segs, bit);
endmodule


module ps2(input clk, input ps2d, input ps2c, input rx_en, output reg done, output[7:0] code);

	parameter
		idle = 0,  // getting reade to read state 
		rx = 1; // reading state

	reg cur_state, next_state, cur_filt; // state controls
	reg [3:0] cur_bit, next_bit; // number of bit read
	reg [7:0] cur_filter; // with next_filter help to detect the falling edge of keyboard clock on which data is transmitted
	reg [10:0] cur_data, next_data; // registers to read data from keyboard
	wire [7:0] next_filter;
	wire neg_edge, next_filt; // neg_edge is asserted on falling edge of ps2c
	
	initial begin
		done = 1'b0;
	end

	assign code = cur_data[8:1];  // code read from keyboard
	assign next_filter = {ps2c, cur_filter[7:1]};
	assign next_filt = (cur_filter == 8'hff) ? 1'b1 : (cur_filter == 8'h00) ? 1'b0 : cur_filt;
	assign neg_edge = cur_filt & (~next_filt);

	always @(posedge clk) begin
		cur_filter <= next_filter;
		cur_filt <= next_filt;
	end

	always @(posedge clk) begin
		cur_state <= next_state;
		cur_bit <= next_bit;
		cur_data <= next_data;
	end

	always @(*) begin
		
		case (cur_state)
			idle: begin  // preparing to read next data
				if (neg_edge && rx_en) begin
					next_bit = 4'b1010;
					next_state = rx;
					done = 1'b0;
				end
			end
			rx: begin
				if (neg_edge) begin  // reading data on falling edge
					next_data = {ps2d, cur_data[10:1]}; // performing shift and reading data
					next_bit = cur_bit - 1;
				end
				if (cur_bit == 1'b0) begin  // finishing reading data and going back to the idle state
					done = 1'b1;
					next_state = idle;
				end
			end
		endcase
	end

endmodule


module keyboard (input clk, input ps2d, input ps2c, output [7:0] code, output code_ready);
	
	parameter  // ps/2 code for break and states
		break = 8'hf0, 
		pressed = 1'b0,
		unpressed = 1'b1;

	reg rx_en;
	initial rx_en = 1'b1;
	wire done; // asserted when the code was read
	wire [7:0] code_out;
	reg cur_state, next_state, ready;

	ps2 p(clk, ps2d, ps2c, rx_en, done, code_out);

	assign code = code_out;
	assign code_ready = ready;

	always @(posedge clk) begin
		cur_state = next_state;
	end

	always @(*) begin
		ready <= 1'b0;
		case(cur_state)
			pressed: begin  //processing moment when the button was pressed
				if(done) begin
					if (code == break) begin
						next_state <= unpressed;
					end
					else begin
						ready <= 1'b1;
					end
				end
			end
			unpressed: begin  //processing moment when the button was released
				if(done) begin
					next_state <= pressed;
				end
			end
		endcase
	end
endmodule


module show_letter(input [7:0] code, input flag, output [7:0] seg, output bit);

	parameter  // ps/2 letter codes
		a = 8'h1c,
		b = 8'h32,
		c = 8'h21,
		d = 8'h23,
		e = 8'h24,
		f = 8'h3b,
		g = 8'h34,
		h = 8'h33,
		i = 8'h43,
		j = 8'h3b,
		k = 8'h42,
		l = 8'h4b,
		m = 8'h3a,
		n = 8'h31,
		o = 8'h44,
		p = 8'h4d,
		q = 8'h15,
		r = 8'h2d,
		s = 8'h1b,
		t = 8'h2c,
		u = 8'h3c,
		v = 8'h2a,
		w = 8'h1d,
		x = 8'h22,
		y = 8'h35,
		z = 8'h1a;
	
	reg [7:0] ascii; // helping register containing representation of a letter on an 8-segment display

	assign seg = ascii;
	assign bit = 0;

	always @(*) begin  // block for converting code into output to 8-segment display
		if (flag) begin
			case(code)
				a: ascii <= 8'b00010001;
				b: ascii <= 8'b11000001;
				c: ascii <= 8'b01100011;
				d: ascii <= 8'b10000101;
				e: ascii <= 8'b01100001;
				f: ascii <= 8'b01110001;
				g: ascii <= 8'b01000011;
				h: ascii <= 8'b10010001;
				i: ascii <= 8'b10011111;
				j: ascii <= 8'b10001111;
				k: ascii <= 8'b11100001;
				l: ascii <= 8'b11100011;
				m: ascii <= 8'b00000000;
				n: ascii <= 8'b11010101;
				o: ascii <= 8'b00000011;
				p: ascii <= 8'b00110001;
				q: ascii <= 8'b00000010;
				r: ascii <= 8'b11110101;
				s: ascii <= 8'b01001001;
				t: ascii <= 8'b11110001;
				u: ascii <= 8'b10000011;
				v: ascii <= 8'b11000111;
				w: ascii <= 8'b10000010;
				x: ascii <= 8'b10010000;
				y: ascii <= 8'b10011001;
				z: ascii <= 8'b00100101;
				default: ascii <= 8'b00101011;
			endcase
		end
		else begin
			ascii <= 8'b11111110;
		end
	end
endmodule