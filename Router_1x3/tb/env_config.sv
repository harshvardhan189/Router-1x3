/***************************************************************
////////////////////////////////////////////////////////////////
					 	ENV CONFIGURATION
////////////////////////////////////////////////////////////////
***************************************************************/




class env_config extends uvm_object;

	`uvm_object_utils(env_config)

	bit has_src_agt_top=1  ;
	bit has_dst_agt_top=1 ;
	bit has_sb = 1 ;
	bit has_virtual_sequencer = 1 ;

	static	int no_src_agt = 1;
	static	int no_dst_agt = 3;
	
	src_agt_cfg src_agt_cfgh[];
	dst_agt_cfg dst_agt_cfgh[];

	function new(string name = "env_config");
		super.new(name);
	endfunction
	
endclass


