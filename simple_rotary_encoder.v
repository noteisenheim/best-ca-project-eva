module simple_rotary_encoder (input dt, input sw);  // sw is pinned to the sensor A output, dt - to the sensor B output

	reg [7:0] rot = 0;  // counter of rotations
	
	always @(posedge sw) begin  // the always block will activate on the positive edge of sw
		if (!dt) begin
			rot <= rot + 1;  // counter is incremented on clockwise rotation (if sensor B is low on positive edge of sensor A)
		end
		else begin
			rot <= rot - 1;  // otherwise, counter is decreased
		end
	end
endmodule