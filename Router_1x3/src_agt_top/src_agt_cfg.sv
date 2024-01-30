

/***************************************************************
////////////////////////////////////////////////////////////////
					 SOURCE	AGENT CONFIGURATION
////////////////////////////////////////////////////////////////
***************************************************************/

class src_agt_cfg extends uvm_object;

	`uvm_object_utils(src_agt_cfg)

	virtual Router_src_if svif;

	uvm_active_passive_enum is_active = UVM_ACTIVE;

	static int mon_rcvd_xtn_cnt = 0;
	static int drv_sent_xtn_cnt = 0;

	function new(string name = "src_agt_cfg");
		super.new(name);
	endfunction
	

endclass



