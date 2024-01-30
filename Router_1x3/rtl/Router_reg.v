module Router_reg(
	input clock,
	input resetn,
	input pkt_valid,
	input [7:0] data_in,
	input fifo_full,
	input detect_add,
	input ld_state,
	input laf_state,
	input full_state,
	input lfd_state,
	input rst_int_reg,

	output reg err,
	output reg parity_done,
	output reg low_pkt_valid,
	output reg [7:0]d_out

);

reg [7:0] header_byte;
reg [7:0] fifo_full_state_byte;
reg [7:0] internal_parity;
reg [7:0] packet_parity;


///////// fifo full state logic ///////////////////

	always@(posedge clock)
	begin
		if(!resetn)
		{d_out} <= 0;

		else if(detect_add && pkt_valid && data_in[1:0] != 3)
			d_out <= d_out; 
		
		else if(lfd_state)
			d_out <= header_byte;

		else if(ld_state && ~fifo_full)
			d_out <= data_in;

		else if(ld_state && fifo_full)
			d_out <= d_out;

		else if(laf_state)
			d_out <= fifo_full_state_byte;
		else 
			d_out <= d_out;
	end

	
//////////// header logic //////////////

	always@(posedge clock)
	begin
		if(!resetn)
			header_byte <= 0;
		else if(detect_add && pkt_valid && data_in [1:0] != 3 )
			header_byte <= data_in;
		else 
			header_byte <= header_byte;
	end


/////////// internal parity logic ////////

	always@(posedge clock)
	begin
		if(!resetn)
			internal_parity <= 0;
		else if(detect_add)
			internal_parity <= 0;
		else if(lfd_state && pkt_valid)
			internal_parity <= (internal_parity) ^ (header_byte);
		else if(pkt_valid && ld_state && ~full_state)
			internal_parity <= internal_parity ^ data_in;
		else 
			internal_parity <= internal_parity;
	end



///////////// parity packet /////////////////

	always@(posedge clock)
	begin
		if(!resetn)
			packet_parity <= 0;
		else if(detect_add)
			packet_parity <=0;
		else if(ld_state && ~pkt_valid)
			packet_parity <= data_in;
		else 
			packet_parity <= packet_parity;

	end

//////////  error logic ///////////////

	always@(posedge clock)
	begin
		if(!resetn)
			err <= 0;
		else if(parity_done)
		begin
		 	if(internal_parity == packet_parity)
				err <= 0;
			else
				err <= 1;
		end

		else err<=0;
	end

	always@(posedge clock)
	begin
		if(!resetn)
			parity_done =0;
		else if((ld_state && (!fifo_full && !pkt_valid))  ||
				(laf_state && low_pkt_valid && !parity_done))
				parity_done <=1;

		else if(detect_add)
				parity_done <=0;
	end


	always@(posedge clock)
	begin
		if(!resetn)
			low_pkt_valid <= 0;
	else if(ld_state && !pkt_valid)
			low_pkt_valid <=1;
	else if(rst_int_reg)
			low_pkt_valid <=0;

	end


	always@(posedge clock)
	begin
		if(!resetn)
			fifo_full_state_byte <= 0;

		else if(ld_state && fifo_full)
			fifo_full_state_byte <= data_in;
			
	end



endmodule
