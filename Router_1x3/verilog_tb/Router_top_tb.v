module Router_top_tb();
	 reg clock;
	 reg resetn;
     reg [2:0]read_enb;
	 reg [7:0]data_in;
	 reg pkt_valid;
 
	 wire [7:0]data_out_0,data_out_1,data_out_2;
	 wire valid_out_0,valid_out_1,valid_out_2;
	 wire error;
	 wire busy;

	 event e1,e2;
	
integer i;

Router_top DUT(
	clock,
	resetn,
	read_enb,
	data_in,
	pkt_valid,

	data_out_0,data_out_1,data_out_2,
	valid_out_0,valid_out_1,valid_out_2,
	error,
	busy
	);

	always #10 clock = ~clock;

	task rst();
	begin
	@(negedge clock)
	resetn = 0;
	@(negedge clock)
	resetn = 1;
	end
	endtask

	task init();
	begin
		{clock,read_enb/*,data_in,pkt_valid*/}=0;
	end
	endtask

/////////////////// pkt 14
	task pkt_gen_14;
	reg [7:0]payload_data,parity,header;
	reg [5:0]payload_len;
	reg [1:0]addr;
	
	begin
		@(negedge clock)
		wait(~busy)
		@(negedge clock)
		payload_len = 6'd14;
		addr = 2'b00;
		header = {payload_len,addr};
		parity = 0;
		data_in = header;
		pkt_valid = 1;
		parity = parity ^ header;
		
		@(negedge clock)
		wait(~busy)
		for(i=0;i<payload_len;i=i+1)
		begin
			@(negedge clock)
			wait(~busy)
			payload_data = {$random}%256;
			data_in = payload_data;
			parity= parity^data_in;
			end

			@(negedge clock)
			wait(~busy)
			pkt_valid = 0;
			data_in = parity;
		end
		endtask

///////////////// pkt 16
	task pkt_gen_16;
	reg [7:0]payload_data,parity,header;
	reg [5:0]payload_len;
	reg [1:0]addr;
	
	begin	@(negedge clock)
		wait(~busy)

		@(negedge clock)
		payload_len = 6'd16;
		addr = 2'b01;
		header = {payload_len,addr};
		parity = 0;
		data_in = header;
		pkt_valid = 1;
		parity = parity ^ header;
		
		@(negedge clock)
		wait(~busy)
		for(i=0;i<payload_len;i=i+1)
		begin
			@(negedge clock)
			wait(~busy)
			payload_data = {$random}%256;
			data_in = payload_data;
			parity= parity^data_in;
			end

			@(negedge clock)
			wait(~busy)
			pkt_valid = 0;
			data_in = parity;
		end
		endtask
	
////////////// pkt random
	task pkt_gen;
	reg [7:0]payload_data,parity,header;
	reg [5:0]payload_len;
	reg [1:0]addr;
	
	begin
		->e2;
		@(negedge clock)
		wait(~busy)

		@(negedge clock)
		payload_len = {$random}%63+1;
		addr = 2'b00;
		header = {payload_len,addr};
		parity = 0;
		data_in = header;
		pkt_valid = 1;
		parity = parity ^ header;
		
		@(negedge clock)
		wait(~busy)
		for(i=0;i<payload_len;i=i+1)
		begin
			@(negedge clock)
			wait(~busy)
			payload_data = {$random}%256;
			data_in = payload_data;
			parity = parity^payload_data;

			end

			@(negedge clock)
			wait(~busy)
			pkt_valid = 0;
			data_in = parity;
		end
		endtask

/////////////// pkt 12
	task pkt_gen_12;
	reg [7:0]payload_data,parity,header;
	reg [5:0]payload_len;
	reg [1:0]addr;
	
	begin	@(negedge clock)
		wait(~busy)

		@(negedge clock)
		payload_len = 6'd12;
		addr = 2'b10;
		header = {payload_len,addr};
		parity = 0;
		data_in = header;
		pkt_valid = 1;
		parity = parity ^ header;
		
		@(negedge clock)
		wait(~busy)
		for(i=0;i<payload_len;i=i+1)
		begin
			@(negedge clock)
			wait(~busy)
			payload_data = {$random}%256;
			data_in = payload_data;
			parity= parity^data_in;
			end

			@(negedge clock)
			wait(~busy)
			pkt_valid = 0;
			data_in = parity;
		end
		endtask
	
////////// event rand
	initial 
	begin
	@(e2)
	@(negedge clock)
	read_enb[0] =1;

	repeat(16)
	@(negedge clock)
	wait(~valid_out_0)
	@(negedge clock)
	read_enb[0] =0;
	//#200 $finish;
	end



	

	initial
		begin
		init();
		rst();
	
		pkt_gen;
		repeat(0)
		@(negedge clock)
		read_enb[0] = 1;
		wait(~valid_out_0)
		@(negedge clock)
		read_enb[0] = 0;

		pkt_gen_14;
		repeat(2)
		@(negedge clock)
		read_enb[0] = 1;
		wait(~valid_out_0)
		@(negedge clock)
		read_enb[0] = 0;
		//#500;
		
		pkt_gen_16;
		repeat(2)
		@(negedge clock)
		read_enb[1] = 1;
		wait(~valid_out_1)
		@(negedge clock)
		read_enb[1] = 0;
		//#500;

		pkt_gen_12;
		repeat(2)
		@(negedge clock)
		read_enb[2] = 1;
		wait(~valid_out_2)
		@(negedge clock)
		read_enb[2] = 0;

		rst();
		pkt_gen_14;
		repeat(30)
		@(negedge clock)

		rst();
		pkt_gen_16;
		repeat(30)
		@(negedge clock)

		rst();
		pkt_gen;
		repeat(30)
		@(negedge clock)


	
		rst();
		pkt_gen_16;
		repeat(2)
		@(negedge clock)
		read_enb[1] = 1;
		wait(valid_out_1)
		@(negedge clock)
		read_enb[1] = 0;

		#500 $finish;
		end
endmodule

