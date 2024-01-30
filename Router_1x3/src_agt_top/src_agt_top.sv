/***************************************************************
////////////////////////////////////////////////////////////////
					   SOURCE AGENT TOP
////////////////////////////////////////////////////////////////
***************************************************************/
		

class src_agt_top extends uvm_env;

	`uvm_component_utils(src_agt_top)

	src_agent src_agnth[];
	env_config e_cfg;
	src_agt_cfg s_cfg[];
	
	function new(string name = "src_agt_top",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		
		if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
			`uvm_fatal("CONFIG","can't get config from src top")
		
		super.build_phase(phase);
		s_cfg = new[e_cfg.no_src_agt];
		src_agnth = new[e_cfg.no_src_agt];


		foreach(src_agnth[i])
		begin
		s_cfg[i] = e_cfg.src_agt_cfgh[i];
		src_agnth[i] = src_agent::type_id::create($sformatf("src_agnth[%0d]",i),this);
		uvm_config_db #(src_agt_cfg)::set(this,$sformatf("src_agnth[%0d]*",i),"src_agt_cfg",s_cfg[i]);
		end
	endfunction
	

endclass


