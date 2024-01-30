
/***************************************************************
////////////////////////////////////////////////////////////////
					 DESTINATION AGENT CONFIGURATION
////////////////////////////////////////////////////////////////
***************************************************************/

class dst_agt_cfg extends uvm_object;

	`uvm_object_utils(dst_agt_cfg)

	virtual Router_dst_if dvif;

	uvm_active_passive_enum is_active = UVM_ACTIVE;

	static int mon_rcvd_xtn_cnt = 0;
	static int drv_sent_xtn_cnt = 0;

	function new(string name = "dst_agt_cfg");
		super.new(name);
	endfunction
	

endclass


