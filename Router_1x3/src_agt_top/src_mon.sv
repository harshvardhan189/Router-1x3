
/***************************************************************
////////////////////////////////////////////////////////////////
					 	SOURCE MONITOR 
////////////////////////////////////////////////////////////////
***************************************************************/

class src_mon extends uvm_monitor;

	`uvm_component_utils(src_mon)
	
	virtual Router_src_if.SRC_MON_MP svif;
	src_agt_cfg s_cfg;

	uvm_analysis_port #(src_xtn) mport;

	function new (string name= "src_mon",uvm_component parent);
		super.new(name,parent);
		mport=new("mport",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(src_agt_cfg)::get(this,"","src_agt_cfg",s_cfg))
			`uvm_fatal("CONFIG","can't get config")
	endfunction 

	function void connect_phase(uvm_phase phase);
		svif = s_cfg.svif;
	endfunction

	task run_phase(uvm_phase phase);
		forever
			collect_data();
	endtask

	task collect_data();
		src_xtn sxtn;

		sxtn = src_xtn::type_id::create("sxtn");

		while(svif.src_mon_cb.pkt_valid !== 1)
		@(svif.src_mon_cb);

		while(svif.src_mon_cb.busy == 1)
		@(svif.src_mon_cb);

		sxtn.header = svif.src_mon_cb.data_in;
		sxtn.payload = new[sxtn.header [7:2]];
		@(svif.src_mon_cb);

		foreach(sxtn.payload[i])
		begin
			while(svif.src_mon_cb.busy)
			@(svif.src_mon_cb);
			sxtn.payload[i] = svif.src_mon_cb.data_in;
			@(svif.src_mon_cb);
		end

		//@(svif.src_mon_cb);

		while(svif.src_mon_cb.busy == 1)
		@(svif.src_mon_cb);
		
		sxtn.parity = svif.src_mon_cb.data_in;

		@(svif.src_mon_cb);
		@(svif.src_mon_cb);
		
		 sxtn.error = svif.src_mon_cb.error;
		@(svif.src_mon_cb);
		//@(svif.src_mon_cb);
		
		mport.write(sxtn);
		`uvm_info("SRC_MONITOR",$sformatf("Data from MONITORr \n %s",sxtn.sprint()),UVM_LOW)
		s_cfg.mon_rcvd_xtn_cnt++;
		

	endtask

	function void report_phase(uvm_phase phase);
		`uvm_info(get_type_name,$sformatf("Report:From SRC Monitor \n %0d",s_cfg.mon_rcvd_xtn_cnt),UVM_LOW);
	endfunction

endclass



