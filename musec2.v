module musec2(input clk, input rb, output buzzer, output [7:0] segs, output [3:0] bits); // rb - RockButton
	
	// 2 constants that determine the current state
	parameter init = 0;
	parameter play = 1;

	reg state; // current state
	reg [32:0] beat_cnt; // determines neither for how long 1 note will play or the lenght of the pause 
	reg [16:0] tone_cnt; 
	reg [16:0] tone_value; // determines the current notes frequency
	reg buzz;
	reg [16:0] cur; // determines the note we r going to play
	reg silence, short, stop; // silence - if 1 then then pause; short - if 1 then beat_cnt is relatively small; stop - stops the music after the 2nd repetition
	reg [7:0] s; // segs but as a register
	reg [3:0] b; // bits but as a register
	reg [32:0] ctr; // counter for Oleg
	reg [1:0] st; // state for Oleg
	
	assign buzzer = buzz;
	assign segs = s;
	assign bits = b;
	
	always @(posedge clk) begin // OLEG
		ctr = ctr + 1;
		st = ctr[24:23];  // state assignment
		if (st == 2'b00) begin // output for O
			s = 8'b00000011;
			b = 4'b0111;
		end
		else if (st == 2'b01) begin // output for L
			s = 8'b11100011;
			b = 4'b1011;
		end
		else if (st == 2'b10) begin  // output for E
			s = 8'b01100001;
			b = 4'b1101;
		end
		else if (st == 2'b11) begin // output for G
			s = 8'b01000011;
			b = 4'b1110;
		end
		
	end

	always @(posedge clk or posedge rb) begin // MUSIC
	if(rb) begin // In Cyclone 4 if the button is pressed it's value is 0
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
					if (!stop) begin // determines if the song is playing for the 1st time or the 2nd
						cur = 0; 
						stop = 1; 
					end
				end
				if(cur == 32) begin // the final chord 
					tone_value = 8450;  
				end
				if(cur > 32) begin // silence, until cur overflows
					silence = 1;
				end
			end
							
			play : begin
				if (silence) begin //holds the pause for 10000000 clock cycles
					beat_cnt = beat_cnt + 1;
					if(beat_cnt == 10000000) begin 
						state = init; 
						cur = cur + 1; 
					end
					buzz = 1;
				end
				else if (short) begin // plays the note for 10000000 clock cycles
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
				else begin // plays the note for 40000000 seconds
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