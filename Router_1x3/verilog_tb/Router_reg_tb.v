module Router_reg_tb();

	reg clock;
	reg resetn;
	reg pkt_valid;
	reg [7:0] data_in;
	reg fifo_full;
	reg detect_add;
	reg ld_state;
	reg laf_state;
	reg full_state;
	reg lfd_state;
	reg rst_int_reg;

	wire err;
	wire parity_done;
	wire low_pkt_valid;
	wire [7:0]d_out;
	
	integer i;

 Router_reg DUT(clock,
		   		resetn,
		   		pkt_valid,
		   		data_in,
		   		fifo_full,
		   		detect_add,
		   		ld_state,
		   		laf_state,
		   		full_state,
		   		lfd_state,
		   		rst_int_reg,

		   		err,
		   		parity_done,
		   		low_pkt_valid,
		   		d_out);

	always #10 clock = ~clock;

	task rst();
	begin
		@(negedge clock)
		resetn = 1'b0;
		@(negedge clock)
		resetn = 1'b1;
	end
	endtask

	task init();
	begin
		{clock,pkt_valid,data_in,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg} = 0;
	end
	endtask

	task packet_generation;
		reg [7:0] payload_data,parity,header;
		reg [5:0] payload_len;
		reg [1:0] addr;
		begin
			@(negedge clock)
			payload_len = 6'd14;
			addr =2'b10;
			pkt_valid = 1;
			detect_add = 1;
			header = {payload_len,addr};
			parity = 8'h00^header;
			data_in = header;
			@(negedge clock)
			detect_add =0 ;
			lfd_state =1;
			full_state = 0;
			fifo_full = 0;
			laf_state = 0;
			for(i=0;i<payload_len;i=i+1)
				begin
					@(negedge clock)
					lfd_state = 0;
					ld_state =1;
					payload_data = {$random}%256;
					data_in = payload_data;
					parity  = parity ^ data_in;
				end
			@(negedge clock)
			pkt_valid =0 ;
			data_in = parity;
			@(negedge clock)
			ld_state=0;
		end
	endtask

	initial
	begin
		init();
		rst();
		packet_generation;
		#500 $finish;


	end
endmodule

