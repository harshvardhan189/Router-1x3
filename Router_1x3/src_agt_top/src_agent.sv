/***************************************************************
////////////////////////////////////////////////////////////////
					 	SOURCE AGENT 
////////////////////////////////////////////////////////////////
***************************************************************/

class src_agent extends uvm_agent;
	
	`uvm_component_utils(src_agent)

	src_drv drvh;
	src_mon monh;
	src_sequencer seqrh;

	src_agt_cfg s_cfg;

	function new(string name = "src_agent",uvm_component parent = null );
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		
		if(!uvm_config_db #(src_agt_cfg)::get(this,"","src_agt_cfg",s_cfg))
			`uvm_fatal("CONFIG","can't get config")
		
		super.build_phase(phase);
		monh = src_mon::type_id::create("monh",this);
		
		if(s_cfg.is_active == UVM_ACTIVE)
		begin
			drvh = src_drv::type_id::create("drvh",this);
			seqrh = src_sequencer::type_id::create("seqrh",this);
		end

	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(s_cfg.is_active == UVM_ACTIVE)
			drvh.seq_item_port.connect(seqrh.seq_item_export);
	endfunction

endclass


