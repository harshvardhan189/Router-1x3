module Router_fsm_tb();

		reg clock,resetn;
		reg pkt_valid;
		reg [1:0]data_in;
		reg fifo_full;
		reg fifo_empty_0,fifo_empty_1,fifo_empty_2;
		reg soft_reset_0,soft_reset_1,soft_reset_2;
		reg parity_done;
		reg low_pkt_valid;

		wire write_enb_reg;
		wire detect_add;
		wire ld_state;
		wire laf_state;
		wire lfd_state;
		wire full_state;
		wire rst_int_reg;
		wire busy;

		 localparam [2:0] DECODE_ADDRESS     = 3'b000;
		 localparam LOAD_FIRST_DATA    = 3'b001;
		 localparam LOAD_DATA          = 3'b010; 
	     localparam LOAD_PARITY        = 3'b011; 
		 localparam CHECK_PARITY_ERROR = 3'b100;
		 localparam  FIFO_FULL_STATE    = 3'b101;
		 localparam LOAD_AFTER_FULL    = 3'b110;
		 localparam WAIT_TILL_EMPTY    = 3'b111;

		 reg [18*8:0] string_reg;


	Router_fsm DUT(clock,resetn,                          
                   pkt_valid,
                   data_in,
                   fifo_full,
                   fifo_empty_0,fifo_empty_1,fifo_empty_2,
                   soft_reset_0,soft_reset_1,soft_reset_2,
 				   parity_done,
				   low_pkt_valid, 
				   write_enb_reg,
				   detect_add,
                   ld_state,                      
				   laf_state,
  	               lfd_state,
                   full_state,
                   rst_int_reg,
				   busy);

		always@(DUT.state)
		begin
			case(DUT.state)
			DECODE_ADDRESS       : string_reg = "DECODE_ADDRESS";
			LOAD_FIRST_DATA      : string_reg = "LOAD_FIRST_DATA";
			LOAD_DATA            : string_reg = "LOAD_DATA";
			LOAD_PARITY          : string_reg = "LOAD_PARITY";
			CHECK_PARITY_ERROR   : string_reg = "CHECK_PARITY_ERROR";
			FIFO_FULL_STATE      : string_reg = "FIFO_FULL_STATE";
			LOAD_AFTER_FULL      : string_reg = "LOAD_AFTER_FULL";
			WAIT_TILL_EMPTY      : string_reg = "WAIT_TILL_EMPTY";
			endcase
		end

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
		{clock,pkt_valid,data_in,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,
		soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_pkt_valid,resetn}=1;
		end
		endtask
		

		task t1();
		begin
		@(negedge clock)
		pkt_valid = 1;
		data_in = 2'b00;
		fifo_empty_0 = 1;
		@(negedge clock)
		@(negedge clock)
		fifo_full = 0;
		pkt_valid = 0;
		@(negedge clock)
		@(negedge clock)
		fifo_full = 0;
		end
		endtask



		task t2();
		begin
		@(negedge clock)
		pkt_valid = 1;
		data_in = 2'b01;
		fifo_empty_1 = 1;
		@(negedge clock)
		@(negedge clock)
		fifo_full = 1;
		@(negedge clock)
		fifo_full = 0;
		@(negedge clock)
		parity_done = 0;
		low_pkt_valid = 1;
		@(negedge clock)
		@(negedge clock)
		fifo_full = 0;
		end
		endtask


		task t3();
		begin
		@(negedge clock)
		pkt_valid = 1;
		data_in = 2'b10;
		fifo_empty_2 = 1;
		@(negedge clock)
		@(negedge clock)
		fifo_full = 1;
		@(negedge clock)
		fifo_full = 0;
		@(negedge clock)
		parity_done = 0;
		low_pkt_valid = 0;
		@(negedge clock)
		fifo_full = 0;
		pkt_valid = 0;
		@(negedge clock)
		@(negedge clock)
		fifo_full = 0;
		end
		endtask


		task t4();
		begin
		@(negedge clock)
		pkt_valid = 1;
		data_in = 2'b01;
		fifo_empty_1 = 1;
		@(negedge clock)
		@(negedge clock)
		fifo_full = 0;
		pkt_valid = 0;
		@(negedge clock)
		@(negedge clock)
		fifo_full = 1;
		@(negedge clock)
		fifo_full = 0;
		@(negedge clock)
		parity_done = 1;
		end
		endtask



		initial
		begin
		init();
		rst();
		t1();
		t2();
		t3();
		t4();
		#500 $finish;
		end

		




			



endmodule
