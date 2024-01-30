
/***************************************************************
////////////////////////////////////////////////////////////////
					   DESTINATION AGENT TOP
////////////////////////////////////////////////////////////////
***************************************************************/

class dst_agt_top extends uvm_env;

	`uvm_component_utils(dst_agt_top)

	dst_agent dst_agnth[];
	dst_agt_cfg d_cfg[];
	env_config e_cfg;

	function new (string name = "dst_agt_top",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
	
		if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
			`uvm_fatal("CONFIG","can't get config from dst top")
		
		super.build_phase(phase);
		d_cfg = new[e_cfg.no_dst_agt];
		dst_agnth = new[e_cfg.no_dst_agt];
		
		foreach(dst_agnth[i])
		begin
		d_cfg[i] = e_cfg.dst_agt_cfgh[i];
		dst_agnth[i] = dst_agent::type_id::create($sformatf("dst_agnth[%0d]",i),this);
		uvm_config_db #(dst_agt_cfg)::set(this,$sformatf("dst_agnth[%0d]*",i),"dst_agt_cfg",d_cfg[i]);
		end

	endfunction
	

endclass

