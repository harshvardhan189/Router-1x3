
/***************************************************************
////////////////////////////////////////////////////////////////
						DESTINATION DRIVER 
////////////////////////////////////////////////////////////////
***************************************************************/


class dst_drv extends uvm_driver #(dst_xtn);
	
	// Factory Registration
	`uvm_component_utils(dst_drv)
	
	// Define Properties
	virtual Router_dst_if.DST_DRV dvif;
	dst_agt_cfg d_cfg;

	// create constructor 
	function new(string name = "dst_drv",uvm_component parent);
		super.new(name,parent);	
	endfunction

	// Build Phase
	// call parent build phase
	// get the config from source config
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(dst_agt_cfg)::get(this,"","dst_agt_cfg",d_cfg))
			`uvm_fatal("CONFIG","can't get config from driver")
		super.build_phase(phase);
	endfunction

	// Connect Phase 
	// connect virtual interface to config interface
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		dvif= d_cfg.dvif;
	endfunction


	//	RUN PHASE
	task run_phase(uvm_phase phase);
	forever
		begin
		seq_item_port.get_next_item(req);
		sent_data(req);
		seq_item_port.item_done();
		end
	endtask

	task sent_data(dst_xtn xtn);
		
		`uvm_info("DST_DRIVER",$sformatf("Data from DST Driver \n %s",xtn.sprint()),UVM_LOW);
	
		//@(dvif.dst_drv_cb);
		//@(dvif.dst_drv_cb);
	while(dvif.dst_drv_cb.vld_out !== 1)
		@(dvif.dst_drv_cb);

	repeat(xtn.no_of_cycle)
		@(dvif.dst_drv_cb);
	
		dvif.dst_drv_cb.read_enb <= 1;
		@(dvif.dst_drv_cb);
	
	while(dvif.dst_drv_cb.vld_out !==0)
		@(dvif.dst_drv_cb);
	
		dvif.dst_drv_cb.read_enb <= 0;
		@(dvif.dst_drv_cb);
	


	d_cfg.drv_sent_xtn_cnt++;
	endtask



	// Report From Driver
	function void report_phase(uvm_phase phase);
		`uvm_info(get_type_name,$sformatf("Report: From DST Driver \n %0d",d_cfg.drv_sent_xtn_cnt),UVM_LOW);
	endfunction

endclass



