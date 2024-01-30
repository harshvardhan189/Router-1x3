
/***************************************************************
////////////////////////////////////////////////////////////////
						SOURCE DRIVER 
////////////////////////////////////////////////////////////////
***************************************************************/


class src_drv extends uvm_driver #(src_xtn);
	
	`uvm_component_utils(src_drv)
	
	virtual Router_src_if.SRC_DRV_MP svif;
	src_agt_cfg s_cfg;

	function new(string name = "src_drv",uvm_component parent);
		super.new(name,parent);	
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(src_agt_cfg)::get(this,"","src_agt_cfg",s_cfg))
			`uvm_fatal("CONFIG","can't get config from driver")
	endfunction

	function void connect_phase(uvm_phase phase);
		svif= s_cfg.svif;
	endfunction

	task run_phase(uvm_phase phase);
	
		//@(svif.src_drv_cb);
		svif.src_drv_cb.resetn <= 0;
		@(svif.src_drv_cb);
		@(svif.src_drv_cb);
		svif.src_drv_cb.resetn <= 1;

	forever
		begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
		end
	endtask

	task send_to_dut(src_xtn xtn);
		
		`uvm_info("SRC_DRIVER",$sformatf("Data from Driver \n %s",xtn.sprint()),UVM_LOW);
		
		//@(svif.src_drv_cb);
		
		while(svif.src_drv_cb.busy ==1)
		@(svif.src_drv_cb);

		svif.src_drv_cb.pkt_valid <= 1'b1;
		svif.src_drv_cb.data_in   <= xtn.header;

		@(svif.src_drv_cb);
		foreach(xtn.payload[i])
		begin
			while(svif.src_drv_cb.busy ==1)
			@(svif.src_drv_cb);

			svif.src_drv_cb.data_in <= xtn.payload[i];
			@(svif.src_drv_cb);
		end
		//@(svif.src_drv_cb);

		while(svif.src_drv_cb.busy == 1)
		@(svif.src_drv_cb);
		
		svif.src_drv_cb.pkt_valid <= 1'b0;
		svif.src_drv_cb.data_in <= xtn.parity;

		@(svif.src_drv_cb);
		@(svif.src_drv_cb);
		
		xtn.error = svif.src_drv_cb.error;
		@(svif.src_drv_cb);

		s_cfg.drv_sent_xtn_cnt++;
	endtask

	function void report_phase(uvm_phase phase);
		`uvm_info(get_type_name,$sformatf("Report: From SRC Driver \n %0d",s_cfg.drv_sent_xtn_cnt),UVM_LOW);
	endfunction  



endclass

