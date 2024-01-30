/***************************************************************
////////////////////////////////////////////////////////////////
					   	  ENVIORNMENT
////////////////////////////////////////////////////////////////
***************************************************************/

class router_env extends uvm_env;

	`uvm_component_utils(router_env)
	
	src_agt_top sagt_top;
	dst_agt_top dagt_top;

	scoreboard sb;

	router_virtual_sequencer v_seqrh;

	env_config e_cfg;

	function new (string name = "router_env",uvm_component parent);
		super.new(name,parent);
	endfunction

	
	function void build_phase(uvm_phase phase);
		
		if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
			`uvm_fatal("CONFIG","can't get config");
		
		super.build_phase(phase);
		// Source agent 

		if(e_cfg.has_src_agt_top)
			sagt_top = src_agt_top::type_id::create("sagt_top",this);
			
		// Destination agent

		if(e_cfg.has_dst_agt_top)
				dagt_top = dst_agt_top::type_id::create("dagt_top",this);
		// Sequencer
//src_small_pkt_test 
		if(e_cfg.has_virtual_sequencer)
			v_seqrh = router_virtual_sequencer::type_id::create("v_seqrh",this);


		if(e_cfg.has_sb)
			sb = scoreboard::type_id::create("sb",this);

	endfunction

	function void connect_phase(uvm_phase phase);

	super.connect_phase(phase);
		
		if(e_cfg.has_virtual_sequencer)
		begin
		if(e_cfg.has_src_agt_top)
			foreach(e_cfg.src_agt_cfgh[i])
			v_seqrh.src_seqrh[i] = sagt_top.src_agnth[i].seqrh;
		
		if(e_cfg.has_dst_agt_top)
			foreach(e_cfg.dst_agt_cfgh[i])
			v_seqrh.dst_seqrh[i] = dagt_top.dst_agnth[i].seqrh;
		end

		if(e_cfg.has_sb)
		begin
			foreach(e_cfg.src_agt_cfgh[i])
			sagt_top.src_agnth[i].monh.mport.connect(sb.fifo_src[i].analysis_export);
			foreach(e_cfg.dst_agt_cfgh[i])
			dagt_top.dst_agnth[i].monh.mport.connect(sb.fifo_dst[i].analysis_export);
		end	
			

	endfunction
endclass




