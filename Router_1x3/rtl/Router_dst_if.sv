/***************************************************************
////////////////////////////////////////////////////////////////
						ROUTER DESTINATION INTERFACE
////////////////////////////////////////////////////////////////
***************************************************************/

interface Router_dst_if(input bit clock);
	
	logic read_enb;
	logic vld_out;
	logic [7:0] data_out;
	
	
	// Destation Driver Clocking
	
	clocking dst_drv_cb@(posedge clock);
	default input #1 output #1;
		output read_enb;
		input vld_out;
	endclocking

	
	// Destation Monitor Clocking

	clocking dst_mon_cb@(posedge clock);
	default input #1 output #1;
		input data_out;
		input read_enb;
	endclocking

	
	// Modports

	modport DST_DRV(clocking dst_drv_cb);
	modport DST_MON(clocking dst_mon_cb);


endinterface


