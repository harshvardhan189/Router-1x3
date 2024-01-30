module Router_fifo_tb();
	 reg clock,resetn;
	 reg  we;
	 reg re;
	 reg  lfd_state;
	 reg soft_reset;
     reg  [7:0]data_in;
	
	 wire full,empty;
	 wire [7:0]data_out;

	 integer k;

	 Router_fifo DUT(clock,resetn,we,re,lfd_state,soft_reset,data_in,full,empty,data_out);


	 always #10 clock = ~clock;

	 task init();
	 begin
	 	{we,re,clock,data_in}=0;
	 end
	 endtask


	 task rst();
	 begin
		 @(negedge clock)
		 resetn=0;
		 @(negedge clock)
		 resetn=1;
	 end
	 endtask

	 task s_reset();
	 begin
	
		 @(negedge clock)
	 	 soft_reset=1;
		 @(negedge clock)
		 soft_reset=0;
	 end
	 endtask

	task write;
	reg [7:0]payload,parity,header;
	reg [5:0]payload_len;
	reg [1:0]addr;

	begin
		@(negedge clock)
		payload_len = 6'd14;
		addr = 2'b01;
		header = {payload_len,addr};
		data_in = header;
		lfd_state = 1'b1;
		we=1;
			for(k=0;k<payload_len;k=k+1)
				begin
				@(negedge clock)
				lfd_state=0;
				payload = {$random}%256;
				data_in =payload;
				end
	@(negedge clock)
	//lfd_state =0;
	parity = {$random}%256;
	data_in = parity;
	end
	endtask

	task read(input i,input j);
	begin
		@(negedge clock)
		we=i;
		re=j;
	end
	endtask

	
	initial 
	begin

	init();
	rst();
	s_reset();
	write();
	repeat(16)
	read(0,1);
	read(0,0);

	#500 $finish;

	end
endmodule

