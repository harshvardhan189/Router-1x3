module Router_sync(
		
		input clock,resetn,
		input [1:0] data_in,
		input detect_add,
		input full_0,full_1,full_2,
		input empty_0,empty_1,empty_2,
		input write_enb_reg,
		input read_enb_0,read_enb_1,read_enb_2,
		
		output reg fifo_full,
		output reg [2:0]write_enb,
		output  vld_out_0,vld_out_1,vld_out_2,
		output reg soft_reset_0,soft_reset_1,soft_reset_2

		);


		reg [1:0]temp;
		reg [4:0]count_0,count_1,count_2;


	assign vld_out_0 = ~empty_0;
	assign vld_out_1 = ~empty_1;
	assign vld_out_2 = ~empty_2;


	always@(posedge clock)
	begin
		if(!resetn)
			temp <=0;
		else if(detect_add)
			temp <= data_in;
	end

	always@(*/*write_enb_reg,temp*/)
	begin
	write_enb = 0;
	if(write_enb_reg)
		begin
		case(temp)

			2'b00 : write_enb = 3'b001;
			2'b01 : write_enb = 3'b010;
			2'b10 : write_enb = 3'b100;
			default : write_enb = 3'b0;
		endcase
		end
	end

	
	always@(*/*temp*/)
	begin
	fifo_full =0;
		case(temp)
		2'b00 : fifo_full = full_0;
		2'b01 : fifo_full = full_1;
		2'b10 : fifo_full = full_2;
		default : fifo_full = 1'b0;
		endcase

	end
/////////////// soft_reset_0 \\\\\\\\\\\\\\\\\
	always@(posedge clock)
	begin
		if(!resetn)
			{soft_reset_0,count_0} <= 0;
		else if(vld_out_0)
			begin
			count_0 <= count_0+1;
			soft_reset_0<=0;
				if(read_enb_0)
					begin
					count_0 <= 0;
					soft_reset_0 <= 0;
					end
				else if (count_0 == 29)
					begin
					count_0 <= 0;
					soft_reset_0 <= 1;
					end
			end
		else 
		begin
		count_0 <= 1'b0;
		soft_reset_0 <= 1'b0;
		end
	end
/////////////////// soft_reset_1 \\\\\\\\\\\\\\\\

		always@(posedge clock)
	begin
		if(!resetn)
			{soft_reset_1,count_1} <= 0;
		else if(vld_out_1)
			begin
			count_1 <= count_1 + 1;
			soft_reset_1 <=0;
				if(read_enb_1)
					begin
					count_1 <= 0;
					soft_reset_1 <= 0;
					end
				else if (count_1 == 29)
					begin
					count_1 <= 0;
					soft_reset_1 <= 1;
					end
			end
		else 
		begin
		count_1 <= 1'b0;
		soft_reset_1 <= 1'b0;
		end
	end

//////////////// soft_reset_2 \\\\\\\\\\\\\\\\\\
	
	always@(posedge clock)
	begin
		if(!resetn)
			{soft_reset_2,count_2} <= 0;
		else if(vld_out_2)
			begin
			count_2 <= count_2+1;
			soft_reset_2 <=0;
				if(read_enb_2)
					begin
					count_2 <= 0;
					soft_reset_2 <= 0;
					end
				else if (count_2 == 29)
					begin
					count_2 <= 0;
					soft_reset_2 <= 1;
					end
			end
		else 
		begin
		count_2 <= 1'b0;
		soft_reset_2 <= 1'b0;
		end
	end



endmodule
