/***************************************************************
////////////////////////////////////////////////////////////////
							TEST
////////////////////////////////////////////////////////////////
***************************************************************/

class router_test extends uvm_test;

	`uvm_component_utils(router_test)
	
	router_env envh;
	env_config e_cfg;

	src_agt_cfg s_cfg[];
	dst_agt_cfg d_cfg[];

	int no_src_agt =1 ;
	int no_dst_agt =3;
	bit has_src_agt_top =1;
	bit has_dst_agt_top =1;


	bit[1:0]addr;

	function new (string name = "router_test",uvm_component parent);
		super.new(name,parent);
	endfunction

		
	function void config_router();
		if(has_src_agt_top)
		begin
			s_cfg = new[no_src_agt];

			foreach(s_cfg[i])
			begin
				s_cfg[i] = src_agt_cfg::type_id::create($sformatf("s_cfg[%0d]",i));

				if(!uvm_config_db #(virtual Router_src_if)::get(this,"",$sformatf("svif_%0d",i),s_cfg[i].svif))
				`uvm_fatal("CONFIG","can't get config")

				s_cfg[i].is_active = UVM_ACTIVE;

				e_cfg.src_agt_cfgh[i] = s_cfg[i];
			end
		end


		if(has_dst_agt_top)
		begin
			d_cfg = new[no_dst_agt];

			foreach(d_cfg[i])
			begin
				d_cfg[i] = dst_agt_cfg::type_id::create($sformatf("d_cfg[%0d]",i));
				
				if(!uvm_config_db #(virtual Router_dst_if)::get(this,"",$sformatf("dvif_%0d",i),d_cfg[i].dvif))
				`uvm_fatal("CONFIG","can't get config")

				d_cfg[i].is_active = UVM_ACTIVE;

				e_cfg.dst_agt_cfgh[i] = d_cfg[i];
			end
		end

		e_cfg.no_src_agt = no_src_agt;
		e_cfg.no_dst_agt = no_dst_agt;
		e_cfg.has_dst_agt_top = has_dst_agt_top;
		e_cfg.has_src_agt_top = has_src_agt_top;
		
	endfunction


	function void build_phase(uvm_phase phase);
		
		
		e_cfg = env_config::type_id::create("e_cfg");
		if(has_src_agt_top)
			e_cfg.src_agt_cfgh = new [no_src_agt];
		
		if(has_dst_agt_top)
			e_cfg.dst_agt_cfgh = new [no_dst_agt];

		config_router;

		uvm_config_db #(env_config)::set(this,"*","env_config",e_cfg);
		super.build_phase(phase);
		envh = router_env::type_id::create("envh",this);
	
//		set_type_override_by_type (src_xtn::get_type(), src_err_xtn::get_type(), bit replace = 1);

	endfunction
		function void end_of_elaboration_phase(uvm_phase phase);
			uvm_top.print_topology;
		endfunction
endclass



/////////////////////////////////////////////
/*          SMALL PKT TEST                 */
/////////////////////////////////////////////

class src_small_pkt_test extends router_test;

	`uvm_component_utils(src_small_pkt_test)

	src_small_pkt_vseq small_vseqh;
	
	
	function new(string name = "src_small_pkt_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
	//repeat(3)
	begin
		phase.raise_objection(this);
		addr = {$random}%3;
		small_vseqh = src_small_pkt_vseq::type_id::create("small_vseqh"); 
		uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
		small_vseqh.start(envh.v_seqrh);
		phase.drop_objection(this);
	end
	endtask



endclass
	
/////////////////////////////////////////////
/*          MEDIUM PKT TEST                */
/////////////////////////////////////////////


class src_med_pkt_test extends router_test;

	`uvm_component_utils(src_med_pkt_test)

	src_med_pkt_vseq med_vseqh;

	function new(string name = "src_med_pkt_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
	repeat(3)
	begin
		phase.raise_objection(this);
		addr = {$random}%3;
		med_vseqh = src_med_pkt_vseq::type_id::create("med_vseqh"); 
		uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
		med_vseqh.start(envh.v_seqrh);
		phase.drop_objection(this);
	end
	endtask



endclass


/////////////////////////////////////////////
/*              BIG PKT TEST               */
/////////////////////////////////////////////


class src_big_pkt_test extends router_test;

	`uvm_component_utils(src_big_pkt_test)

	src_big_pkt_vseq big_vseqh;

	function new(string name = "src_big_pkt_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
	repeat(3)
	begin
		phase.raise_objection(this);
		addr = {$random}%3;
		big_vseqh = src_big_pkt_vseq::type_id::create("big_vseqh"); 
		uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
		big_vseqh.start(envh.v_seqrh);
		phase.drop_objection(this);
	end
	endtask

endclass


/////////////////////////////////////////////
/*           RAND PKT TEST                 */
/////////////////////////////////////////////



class src_rand_pkt_test extends router_test;

	`uvm_component_utils(src_rand_pkt_test)

	src_rand_pkt_vseq rand_vseqh;

	function new(string name = "src_rand_pkt_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
	repeat(3)
	begin
		phase.raise_objection(this);
		addr = {$random}%3;
		rand_vseqh = src_rand_pkt_vseq::type_id::create("rand_vseqh"); 
		uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
		rand_vseqh.start(envh.v_seqrh);
		phase.drop_objection(this);
	end
	endtask



endclass



/////////////////////////////////////////////
/*              BAD PKT TEST               */
/////////////////////////////////////////////
/*
class bad_pkt_test extends router_test;
	
	`uvm_component_utils(bad_pkt_test)

	function new(string name = "bad_pkt_test", uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
	repeat(3)
	begin
		phase.raise_objection(this);
		addr = {$random}%3;
		rand_vseqh = src_rand_pkt_vseq::type_id::create("rand_vseqh"); 
		uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
		rand_vseqh.start(envh.v_seqrh);
		phase.drop_objection(this);
	end
	endtask
endclass




*/










