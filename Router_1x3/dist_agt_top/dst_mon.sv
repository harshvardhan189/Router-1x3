
/***************************************************************
////////////////////////////////////////////////////////////////
					 	DESTINATION MONITOR 
////////////////////////////////////////////////////////////////
***************************************************************/

class dst_mon extends uvm_monitor;

	`uvm_component_utils(dst_mon)
	
	virtual Router_dst_if.DST_MON dvif;
	dst_agt_cfg d_cfg;

	uvm_analysis_port #(dst_xtn) mport;

	function new (string name= "dst_mon",uvm_component parent);
		super.new(name,parent);
		mport=new("mport",this);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(dst_agt_cfg)::get(this,"","dst_agt_cfg",d_cfg))
			`uvm_fatal("CONFIG","can't get config")
		super.build_phase(phase);
	endfunction 

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		dvif = d_cfg.dvif;
	endfunction

	//	Run Phase
	task run_phase(uvm_phase phase);
		forever
			collect_data();
	endtask

	task collect_data();
	
		dst_xtn dxtn;
			
		dxtn = dst_xtn::type_id::create("dxtn");
		
	//@(dvif.dst_mon_cb);
		
		while(dvif.dst_mon_cb.read_enb !== 1)
		@(dvif.dst_mon_cb);
	
		
		@(dvif.dst_mon_cb);
		dxtn.header = dvif.dst_mon_cb.data_out;
		dxtn.payload = new[dxtn.header[7:2]];

		@(dvif.dst_mon_cb);
	

		foreach(dxtn.payload[i])
		begin
			dxtn.payload[i] = dvif.dst_mon_cb.data_out;
			@(dvif.dst_mon_cb);
		end

		dxtn.parity = dvif.dst_mon_cb.data_out;

		@(dvif.dst_mon_cb);
		//@(dvif.dst_mon_cb);


		mport.write(dxtn);
		`uvm_info("DST_MONITOR",$sformatf("Data from DST Monitor \n %s",dxtn.sprint()),UVM_LOW);
		d_cfg.mon_rcvd_xtn_cnt++;

		endtask


	function void report_phase(uvm_phase phase);
		`uvm_info(get_type_name(),$sformatf("Report:From DST Monitor \n %0d",d_cfg.mon_rcvd_xtn_cnt),UVM_LOW);
	endfunction

endclass



