/***************************************************************
////////////////////////////////////////////////////////////////
						VIRTUAL SEQUENCER
////////////////////////////////////////////////////////////////
***************************************************************/

class router_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

	`uvm_component_utils(router_virtual_sequencer)

	src_sequencer src_seqrh[];
	dst_sequencer dst_seqrh[];

	env_config e_cfg;

	function new (string name = "router_virtual_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
			`uvm_fatal("CONFIG","can't get config")
		super.build_phase(phase);
	src_seqrh = new[e_cfg.no_src_agt];
	dst_seqrh = new[e_cfg.no_dst_agt];

	endfunction
endclass


