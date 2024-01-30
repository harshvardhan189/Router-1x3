/***************************************************************
////////////////////////////////////////////////////////////////
						ROUTER SOURCE INTERFACE
////////////////////////////////////////////////////////////////
***************************************************************/

interface Router_src_if(input bit clock);
	
	logic resetn;
	logic [7:0] data_in;
	logic pkt_valid;
	logic busy;
	logic error;
	

	// Source Driver Clocking

	clocking src_drv_cb@(posedge clock);
	default input #1 output #1;
		output resetn;
		output pkt_valid;
		output data_in;
		input busy;
		input error;
	endclocking


	// Source Monitor Clocking
	
	clocking src_mon_cb@(posedge clock);
	default input #1 output #1;
		input busy;
		input error;
		input data_in;
		input pkt_valid;
		input resetn;
	endclocking

	
	modport SRC_DRV_MP(clocking src_drv_cb);
	modport SRC_MON_MP(clocking src_mon_cb);

endinterface
















