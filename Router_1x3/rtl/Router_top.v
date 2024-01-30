module Router_top(
	input clock,
	input resetn,
	input [2:0]read_enb,
	input [7:0]data_in,
	input pkt_valid,

	output  [7:0]data_out_0,data_out_1,data_out_2,
	output  valid_out_0,valid_out_1,valid_out_2,
	output error,
	output  busy
	);

wire [7:0]data_out[2:0];
wire [7:0]d_out;
wire [2:0]we,full,empty;
wire lfd_state;
wire [2:0] soft_reset;

assign data_out_0 =data_out[0];
assign data_out_1 =data_out[1];
assign data_out_2 =data_out[2];

Router_fsm DUT_FSM(
			
		 .clock(clock),
		 .resetn(resetn),
		 .pkt_valid(pkt_valid),
		 .data_in(data_in),
		 .fifo_full(fifo_full),
		 .fifo_empty_0(empty[0]),
		 .fifo_empty_1(empty[1]),
		 .fifo_empty_2(empty[2]),
		 .soft_reset_0(soft_reset[0]),
		 .soft_reset_1(soft_reset[1]),
		 .soft_reset_2(soft_reset[2]),
		 .parity_done (parity_done),
		 .low_pkt_valid(low_pkt_valid),

		 .write_enb_reg(write_enb_reg),
		 .detect_add(detect_add),
		 .ld_state(ld_state),
		 .laf_state(laf_state),
		 .lfd_state(lfd_state),
		 .full_state(full_state),
		 .rst_int_reg(rst_int_reg),
		 .busy(busy));

Router_sync DUT_SYNC(
		
		 .clock(clock),
		 .resetn(resetn),
		 .data_in(data_in[1:0]),
		 .detect_add(detect_add),
		 .full_0(full[0]),
		 .full_1(full[1]),
		 .full_2(full[2]),
		 .empty_0(empty[0]),
		 .empty_1(empty[1]),
		 .empty_2(empty[2]),
		 .write_enb_reg(write_enb_reg),
		 .read_enb_0(read_enb[0]),
		 .read_enb_1(read_enb[1]),
		 .read_enb_2(read_enb[2]),
		
		 .fifo_full(fifo_full),
		 .write_enb(we),
		 .vld_out_0(valid_out_0),
		 .vld_out_1(valid_out_1),
		 .vld_out_2(valid_out_2),
		 .soft_reset_0(soft_reset[0]),
		 .soft_reset_1(soft_reset[1]),
		 .soft_reset_2(soft_reset[2]));

Router_reg DUT_REG(
		 .clock(clock),
		 .resetn(resetn),
		 .pkt_valid(pkt_valid),
		 .data_in(data_in),
		 .fifo_full(fifo_full),
		 .detect_add(detect_add),
		 .ld_state(ld_state),
		 .laf_state(laf_state),
		 .full_state(full_state),
		 .lfd_state(lfd_state),
		 .rst_int_reg(rst_int_reg),

		 .err(error),
		 .parity_done(parity_done),
		 .low_pkt_valid(low_pkt_valid),
		 .d_out(d_out));

	genvar i;
	
	generate for(i=0;i<3;i=i+1)
	begin: fifo

	Router_fifo DUT_FIFO(

		 .clock(clock),
		 .resetn(resetn),
		 .we(we[i]),
		 .re(read_enb[i]),
		 .lfd_state(lfd_state),
		 .soft_reset(soft_reset[i]),
    	 .data_in(d_out),
		 
		 .full(full[i]),
		 .empty(empty[i]),
		 .data_out(data_out[i]));
	end
	endgenerate


endmodule




