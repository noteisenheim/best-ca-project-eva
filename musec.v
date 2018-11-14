module musec(input clk, input rb, output buzzer, output [7:0] segs, output [3:0] bits);
	parameter init = 0;
	parameter play = 1;

	reg state;
	reg [32:0] beat_cnt;
	reg [16:0] tone_cnt;
	reg [16:0] tone_value;
	reg buzz;
	reg [16:0] cur;
	reg silence, short, stop;
	reg [7:0] s;
	reg [3:0] b;
	reg [32:0] ctr;
	reg [1:0] st;
	
	assign buzzer = buzz;
	assign segs = s;
	assign bits = b;
	
	always @(posedge clk) begin
		ctr = ctr + 1;
		st = ctr[24:23];
		if (st == 2'b00) begin
			s = 8'b00000011;
			b = 4'b0111;
		end
		else if (st == 2'b01) begin
			s = 8'b11100011;
			b = 4'b1011;
		end
		else if (st == 2'b10) begin
			s = 8'b01100001;
			b = 4'b1101;
		end
		else if (st == 2'b11) begin
			s = 8'b01000011;
			b = 4'b1110;
		end
		
	end

	always @(posedge clk or posedge rb) begin
	if(rb) begin
		state = init;
		buzz=1;
		cur = 0;
		stop = 0;
		end
	else
		case(state)
			init : begin
				silence = 0;
				short = 0;
				beat_cnt = 0;
				tone_cnt = 0;
				buzz = 0;
				state = play;
				
				if(cur == 0) begin 
					tone_value = 8450;  
				end
				if(cur == 1) begin 
					tone_value = 7595; 
					short = 1;  
				end
				if(cur == 2) begin 
					silence = 1;  
				end
				if(cur == 3) begin 
					tone_value = 7595; 
					short = 1; 
				end
				if(cur == 4) begin 
					tone_value = 8450; 
				end
				if(cur == 5) begin 
					tone_value = 7595; 
					short = 1;  
				end
				if(cur == 6) begin 
					silence = 1;  
				end
				if(cur == 7) begin 
					tone_value = 7595; 
					short = 1; 
				end
				if(cur == 8) begin 
					tone_value = 8450;  
				end
				if(cur == 9) begin 
					tone_value = 7160; 
					short = 1;  
				end
				if(cur == 10) begin 
					silence = 1;  
				end
				if(cur == 11) begin 
					tone_value = 7160; 
					short = 1; 
				end
				if(cur == 12) begin 
					tone_value = 8450;  
				end
				if(cur == 13) begin 
					tone_value = 7160; 
					short = 1;  
				end
				if(cur == 14) begin 
					silence = 1;  
				end
				if(cur == 15) begin 
					tone_value = 7160; 
					short = 1; 
				end
				if(cur == 16) begin 
					tone_value = 8450;  
				end
				if(cur == 17) begin 
					tone_value = 6375; 
					short = 1;  
				end
				if(cur == 18) begin 
					silence = 1;  
				end
				if(cur == 19) begin 
					tone_value = 6375; 
					short = 1; 
				end
				if(cur == 20) begin 
					tone_value = 8450;  
				end
				if(cur == 21) begin 
					tone_value = 6375; 
					short = 1;  
				end
				if(cur == 22) begin 
					silence = 1;  
				end
				if(cur == 23) begin 
					tone_value = 6375; 
					short = 1; 
				end
				if(cur == 24) begin 
					tone_value = 5680; 
					short = 1;  
				end
				if(cur == 25) begin 
					silence = 1;  
				end
				if(cur == 26) begin 
					tone_value = 6375; 
					short = 1;  
				end
				if(cur == 27) begin 
					silence = 1;  
				end
				if(cur == 28) begin 
					tone_value = 7160; 
					short = 1;  
				end
				if(cur == 29) begin 
					silence = 1;  
				end
				if(cur == 30) begin 
					tone_value = 7595; 
					short = 1;  
				end
				if(cur == 31) begin 
					silence = 1; 
					if (!stop) begin 
						cur = 0; 
						stop = 1; 
					end
				end
				if(cur == 32) begin 
					tone_value = 8450;  
				end
				if(cur > 32) begin
					silence = 1;
				end
			end
							
			play : begin
				if (silence) begin
					beat_cnt = beat_cnt + 1;
					if(beat_cnt == 10000000) begin 
						state = init; 
						cur = cur + 1; 
					end
					buzz = 1;
				end
				else if (short) begin
					beat_cnt = beat_cnt + 1;
					if(beat_cnt == 10000000) begin 
						state = init; 
						cur = cur + 1; 
					end
					tone_cnt = tone_cnt + 1;
					if(tone_cnt == tone_value) begin
						buzz = ~buzz;
						tone_cnt = 0;
					end
				end
				else begin
					beat_cnt = beat_cnt + 1;
					if (beat_cnt == 40000000) begin 
						state = init; 
						cur = cur + 1; 
					end
					tone_cnt = tone_cnt + 1;
					if (tone_cnt == tone_value) begin
						buzz = ~buzz;
						tone_cnt = 0;
					end
				end	
			end
			
			default : state = init;
		endcase
							
	end


endmodule