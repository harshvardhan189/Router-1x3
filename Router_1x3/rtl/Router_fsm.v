module Router_fsm(
			
		input clock,resetn,
		input pkt_valid,
		input [1:0]data_in,
		input fifo_full,
		input fifo_empty_0,fifo_empty_1,fifo_empty_2,
		input soft_reset_0,soft_reset_1,soft_reset_2,
		input parity_done,
		input low_pkt_valid,

		output write_enb_reg,
		output detect_add,
		output ld_state,
		output laf_state,
		output lfd_state,
		output full_state,
		output rst_int_reg,
		output busy
			
			);
		 localparam DECODE_ADDRESS           = 3'b000;
		 localparam LOAD_FIRST_DATA    		 = 3'b001;
		 localparam LOAD_DATA          		 = 3'b010; 
	     localparam LOAD_PARITY        		 = 3'b011; 
		 localparam CHECK_PARITY_ERROR 		 = 3'b100;
		 localparam FIFO_FULL_STATE   		 = 3'b101;
		 localparam LOAD_AFTER_FULL    		 = 3'b110;
		 localparam WAIT_TILL_EMPTY    		 = 3'b111;

	reg [2:0]state,next_state;
	reg [1:0]addr;


	always@(posedge clock)
	begin
		addr <= data_in;

		if(!resetn)
		state <= DECODE_ADDRESS;

		else if(soft_reset_0 || soft_reset_1 || soft_reset_2)
		state <= DECODE_ADDRESS;
		
		else 
		state <= next_state;
	end

	always@(*)
	begin
		next_state = DECODE_ADDRESS;
		case(state)
			DECODE_ADDRESS: 

							 if((pkt_valid & (data_in[1:0]==0) & fifo_empty_0) ||
								(pkt_valid & (data_in[1:0]==1) & fifo_empty_1) ||
								(pkt_valid & (data_in[1:0]==2) & fifo_empty_2))
												
									next_state = LOAD_FIRST_DATA;
											 
							 else if((pkt_valid & (data_in[1:0]==0)& (!fifo_empty_0))||
							 		(pkt_valid & (data_in[1:0]==1)& (!fifo_empty_1))||
									(pkt_valid & (data_in[1:0]==2)& (!fifo_empty_2)))
													
									next_state = WAIT_TILL_EMPTY;
		 					 else 
								next_state = DECODE_ADDRESS;
							 
			LOAD_FIRST_DATA :

								next_state = LOAD_DATA;

			LOAD_DATA	:

							if(!fifo_full && !pkt_valid)
							  	next_state = LOAD_PARITY;

							else if(fifo_full)
								next_state = FIFO_FULL_STATE;

							else
				      			next_state = LOAD_DATA;

			LOAD_PARITY  :

								next_state = CHECK_PARITY_ERROR;

			CHECK_PARITY_ERROR :

							if(fifo_full)
								next_state = FIFO_FULL_STATE;
			
							else if(!fifo_full)
								next_state = DECODE_ADDRESS;
			

			FIFO_FULL_STATE  :

							if(!fifo_full)
								next_state = LOAD_AFTER_FULL;
												
							else
								next_state = FIFO_FULL_STATE;
				
			LOAD_AFTER_FULL  :

							if(!parity_done && !low_pkt_valid)
								next_state = LOAD_DATA;
											   
							else if(!parity_done && low_pkt_valid)
								next_state = LOAD_PARITY;

							else if(parity_done)
								next_state = DECODE_ADDRESS;


			WAIT_TILL_EMPTY  : 
						    if((fifo_empty_0 && (addr == 0)) ||
						    	(fifo_empty_1 && (addr == 1)) ||
						    	(fifo_empty_2 && (addr == 2)) )

						    	next_state = LOAD_FIRST_DATA;
						    
						    else 
						    	next_state = WAIT_TILL_EMPTY;
							  
		endcase
	end

	assign write_enb_reg = ((state == LOAD_AFTER_FULL)||(state == LOAD_PARITY)||(state == LOAD_DATA));
	assign detect_add = (state == DECODE_ADDRESS);
	assign ld_state = (state == LOAD_DATA);
	assign laf_state = (state == LOAD_AFTER_FULL);
	assign lfd_state = (state == LOAD_FIRST_DATA);
	assign full_state = (state == FIFO_FULL_STATE);
	assign rst_int_reg = (state == CHECK_PARITY_ERROR);
	assign busy = ((state == DECODE_ADDRESS)||(state == LOAD_DATA)) ? 1'b0 : 1'b1;


endmodule
		
