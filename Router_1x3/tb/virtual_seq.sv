/***************************************************************
////////////////////////////////////////////////////////////////
					   SOURCE VIRTUAL SEQUENCES
////////////////////////////////////////////////////////////////
***************************************************************/

class router_vseq extends uvm_sequence #(uvm_sequence_item);
	
	`uvm_object_utils(router_vseq);

	router_virtual_sequencer vseqrh;
	
	dst_sequencer dst_seqrh[];
	src_sequencer src_seqrh[];

	src_small_pkt_xtn  small_xtns;
	src_med_pkt_xtn    med_xtns;
	src_big_pkt_xtn    big_xtns;
	src_rand_pkt_xtn   rand_xtns;

	dst_pkt_xtn dst_xtns;

	env_config e_cfg;

	bit [1:0]addr;

	function new(string name = "router_vseq");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",e_cfg))
		`uvm_fatal(get_type_name(),"can't get config from virtual sequence")

		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
		`uvm_fatal(get_type_name(),"can't get from dst virtual sequence")
				assert($cast(vseqrh,m_sequencer))
		
		else
			`uvm_error("BODY","Error in $cast of virtual sequence")

		dst_seqrh = new[e_cfg.no_dst_agt];
		src_seqrh = new[e_cfg.no_src_agt];

	
		foreach(src_seqrh[i])
				src_seqrh[i] = vseqrh.src_seqrh[i];
		
		foreach(dst_seqrh[i])
				dst_seqrh[i] = vseqrh.dst_seqrh[i];
	endtask

endclass



/////////////////////////////////////////
/*      SMALL PKT VIRTUAL SEQUENCE     */
/////////////////////////////////////////


class src_small_pkt_vseq extends router_vseq;

	`uvm_object_utils(src_small_pkt_vseq)

	function new(string name = "src_small_pkt_vseq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
	
	small_xtns = src_small_pkt_xtn::type_id::create("small_xtns");
	dst_xtns  = dst_pkt_xtn::type_id::create("dst_xtns");

	fork
			if(e_cfg.has_src_agt_top)
			begin
				for(int i=0 ; i<e_cfg.no_src_agt; i++)
					small_xtns.start(src_seqrh[i]);
			end

			begin
			if(addr == 0)
				dst_xtns.start(dst_seqrh[0]);
			
			if(addr == 1)
				dst_xtns.start(dst_seqrh[1]);

			if(addr == 2)
				dst_xtns.start(dst_seqrh[2]);
			end
			
	join

	endtask
endclass


/////////////////////////////////////////
/*     MEDIUM PKT VIRTUAL SEQUENCE     */
/////////////////////////////////////////


class src_med_pkt_vseq extends router_vseq;

	`uvm_object_utils(src_med_pkt_vseq)

	function new(string name = "src_med_pkt_vseq");
		super.new(name);
	endfunction

	task body();
		super.body();

		med_xtns = src_med_pkt_xtn::type_id::create("med_xtns");
	dst_xtns  = dst_pkt_xtn::type_id::create("dst_xtns");
		
	fork
		if(e_cfg.has_src_agt_top);
			begin
			for(int i=0 ; i<e_cfg.no_src_agt; i++)
				med_xtns.start(src_seqrh[i]);
			end
		begin
			if(addr == 0)
				dst_xtns.start(dst_seqrh[0]);
			
			if(addr == 1)
				dst_xtns.start(dst_seqrh[1]);

			if(addr == 2)
				dst_xtns.start(dst_seqrh[2]);
			end
	join
	endtask
endclass


/////////////////////////////////////////
/*       BIG PKT VIRTUAL SEQUENCE      */
/////////////////////////////////////////


class src_big_pkt_vseq extends router_vseq;

	`uvm_object_utils(src_big_pkt_vseq)

	function new(string name = "src_big_pkt_vseq");
		super.new(name);
	endfunction

	task body();
		super.body();

		big_xtns = src_big_pkt_xtn::type_id::create("big_xtns");
	dst_xtns  = dst_pkt_xtn::type_id::create("dst_xtns");
		
	fork
		if(e_cfg.has_src_agt_top);
			begin
			for(int i=0 ; i<e_cfg.no_src_agt; i++)
				big_xtns.start(src_seqrh[i]);
			end
		begin
			if(addr == 0)
				dst_xtns.start(dst_seqrh[0]);
			
			if(addr == 1)
				dst_xtns.start(dst_seqrh[1]);

			if(addr == 2)
				dst_xtns.start(dst_seqrh[2]);
			end
	join
	endtask
endclass


/////////////////////////////////////////
/*     RANDOM PKT VIRTUAL SEQUENCE     */
/////////////////////////////////////////


class src_rand_pkt_vseq extends router_vseq;

	`uvm_object_utils(src_rand_pkt_vseq)

	function new(string name = "src_rand_pkt_vseq");
		super.new(name);
	endfunction

	task body();
		super.body();

		rand_xtns = src_rand_pkt_xtn::type_id::create("rand_xtns");
	dst_xtns  = dst_pkt_xtn::type_id::create("dst_xtns");
		
	fork
		if(e_cfg.has_src_agt_top);
			begin
			for(int i=0 ; i<e_cfg.no_src_agt; i++)
				rand_xtns.start(src_seqrh[i]);
			end
		begin
			if(addr == 0)
				dst_xtns.start(dst_seqrh[0]);
			
			if(addr == 1)
				dst_xtns.start(dst_seqrh[1]);

			if(addr == 2)
				dst_xtns.start(dst_seqrh[2]);
			end
	join
	endtask
endclass














