module Router_sync_tb();

		reg clock,resetn;
		reg [1:0] data_in;
		reg detect_add;
		reg full_0,full_1,full_2;
		reg empty_0,empty_1,empty_2;
		reg write_enb_reg;
		reg read_enb_0,read_enb_1,read_enb_2;
		
		wire fifo_full;
		wire [2:0]write_enb;
		wire  vld_out_0,vld_out_1,vld_out_2;
		wire soft_reset_0,soft_reset_1,soft_reset_2;

	Router_sync DUT(clock,resetn,data_in,detect_add,full_0,full_1,full_2, empty_0,empty_1,empty_2, write_enb_reg,read_enb_0,read_enb_1,read_enb_2,fifo_full,write_enb,vld_out_0,vld_out_1,vld_out_2,soft_reset_0,soft_reset_1,soft_reset_2);

	always #10 clock = ~clock;

	task rst();
	begin
		@(negedge clock)
		resetn=0;
		@(negedge clock)
		resetn=1;
	end
	endtask

	task init();
	begin
		{data_in,detect_add,clock,write_enb_reg,full_0,full_1,full_2,read_enb_0,read_enb_1,read_enb_2} = 0;
		empty_0 = 1;
		empty_1 = 1;
		empty_2 = 1;
	end
	endtask




	task ip_data(input [1:0]d_in,input d,wer);
	begin
		@(negedge clock)
		detect_add = d;
		data_in = d_in;
		write_enb_reg = wer;
	end
	endtask

	task emp(input ep0,ep1,ep2);
	begin
		@(negedge clock)
		empty_0=ep0;
		empty_1=ep1;
		empty_2=ep2;
	end
	endtask

	task full(input f0,f1,f2);
	begin
		@(negedge clock)
		full_0 = f0;
		full_1 = f1;
		full_2 = f2;
	end
	endtask


	task read(input rd0,rd1,rd2);
	begin
		@(negedge clock)
		read_enb_0 = rd0;
		read_enb_1 = rd1;
		read_enb_2 = rd2;
	end
	endtask

	initial
	begin
		init();
		rst();
		ip_data(2'b01,1,1);
		emp(1,0,1);
		full(0,1,0);
		read(1,0,1);
		#1000;

		read(0,1,0);

		#500 $finish;
	end
endmodule


















