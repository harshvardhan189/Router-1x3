

/***************************************************************
////////////////////////////////////////////////////////////////
					 	DESTINATION AGENT 
////////////////////////////////////////////////////////////////
***************************************************************/

class dst_agent extends uvm_agent;
	
	`uvm_component_utils(dst_agent)

	dst_drv drvh;
	dst_mon monh;
	dst_sequencer seqrh;

	dst_agt_cfg d_cfg;

	function new(string name = "dst_agent",uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		
		
		if(!uvm_config_db #(dst_agt_cfg)::get(this,"","dst_agt_cfg",d_cfg))
			`uvm_fatal("CONFIG","can't get config")
	
		super.build_phase(phase);
		monh = dst_mon::type_id::create("monh",this);


		if(d_cfg.is_active == UVM_ACTIVE)
		begin
			drvh = dst_drv::type_id::create("drvh",this);
			seqrh = dst_sequencer::type_id::create("seqrh",this);
		end

	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(d_cfg.is_active == UVM_ACTIVE)
			drvh.seq_item_port.connect(seqrh.seq_item_export);
	endfunction

endclass



