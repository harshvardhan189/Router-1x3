
/***************************************************************
////////////////////////////////////////////////////////////////
					   	  SCOREBOARD
////////////////////////////////////////////////////////////////
***************************************************************/

class scoreboard extends uvm_scoreboard;

	`uvm_component_utils(scoreboard)
	env_config e_cfg;

	uvm_tlm_analysis_fifo #(src_xtn) fifo_src[];
	uvm_tlm_analysis_fifo #(dst_xtn) fifo_dst[];

	src_xtn sxtn;
	dst_xtn dxtn;

	function new(string name = "scoreboard",uvm_component parent);
		super.new(name,parent);
		
		fifo_src = new[e_cfg.no_src_agt];
		fifo_dst = new[e_cfg.no_dst_agt];
		foreach(fifo_src[i])
			fifo_src[i] = new($sformatf("fifo_src[%0d]",i),this);
		
		foreach(fifo_dst[i])
			fifo_dst[i] = new($sformatf("fifo_dst[%0d]",i),this);
		

		src_cg = new;
		dst_cg = new;
		src_payload = new;

	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
			`uvm_fatal("CONFIG","can't get config")
		super.build_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
		
				$display("\n\n\n\n\n\n\nsrcgfhgdffffffffffffffff get data \n\n\n\n\n\n\n\n\n %s",sxtn);
		`uvm_info("SCOREBOARD","compvfvvvvvvvvvvvvvvvvklare SRC and DST HEADER",UVM_MEDIUM)
		forever 
		begin
				$display("srcgfhgdffffffffffffffff get data \n %s",sxtn);
			`uvm_info(get_full_name(),$sformatf("Data from Scorfddefwwwwwte3wwwwwwwwweboard DST ADDR 2'b00  \n %s",dxtn()),UVM_MEDIUM)
				begin
				fifo_src[0].get(sxtn);
				$display("src get data \n %s",sxtn);
			`uvm_info(get_type_name(),$sformatf("Data from Scoreboard SRC GET DATA \n %s",sxtn.sprint()),UVM_LOW)
				end

			if(sxtn.header[1:0] ==2'b00)
			begin
			`uvm_info(get_full_name(),$sformatf("Data from Scoreboard DST ADDR 2'b00  \n %s",dxtn.sprint()),UVM_LOW)
				fifo_dst[0].get(dxtn);
			`uvm_info(get_full_name(),$sformatf("Data from Scoreboard DST ADDR 2'b00  \n %s",dxtn.sprint()),UVM_LOW)
			end

			if(sxtn.header[1:0] ==2'b01)
			begin
				fifo_dst[1].get(dxtn);
			`uvm_info(get_full_name(),$sformatf("Data from Scoreboard DST ADDR 2'b01 \n %s",dxtn.sprint()),UVM_LOW);
			end

			if(sxtn.header[1:0] ==2'b10)
			begin
				fifo_dst[2].get(dxtn);
			`uvm_info(get_full_name(),$sformatf("Data from Scoreboard DST ADDR 2'b10\n %s",dxtn.sprint()),UVM_LOW);
			end
			
			sb_check();
		
			src_cg.sample();
			dst_cg.sample();

			foreach(sxtn.payload[i])
			src_payload.sample(i);
		end
	endtask

	task sb_check();

		if(sxtn.header == dxtn.header)
		`uvm_info("SCOREBOARD","compare SRC and DST HEADER SUCCESSFULLY",UVM_LOW)

		else
		`uvm_fatal("SCOREBOARD","HEADER doesn't match")
		
		foreach(sxtn.payload[i])
		begin
		if(sxtn.payload [i] == dxtn.payload [i])
		`uvm_info("SCOREBOARD",$sformatf("compare SRC and DST PAYLOAD [%0d] SUCCESSFULLY",i),UVM_LOW)

		else	
		`uvm_fatal("SCOREBOARD","PAYLOAD doesn't match")
		end

		if(sxtn.parity == dxtn.parity)
		`uvm_info("SCOREBOARD","compare SRC and DST PARITY SUCCESSFULLY",UVM_LOW)

		else
		`uvm_fatal("SCOREBOARD","PARITY doesn't match")

	endtask

	covergroup src_cg; 
	
		ADDRESS : coverpoint sxtn.header[1:0] { bins header[] = {2'b00,2'b01,2'b10} ;  illegal_bins ilegal = {2'b11};}
		PKT_LENGTH  : coverpoint sxtn.header[7:2]{bins small_pkt = {[1:12]} ; bins med_pkt = {[13:30]} ; bins big_pkt = {[31:63]} ;}
		ERROR : coverpoint sxtn.error;
		PARITY : coverpoint sxtn.parity;

		ADDRESS_x_PKT_LENGTH_x_ERROR : cross ADDRESS, PKT_LENGTH, ERROR;

	endgroup

	covergroup dst_cg;
		
		ADDR : coverpoint dxtn.header[1:0] { bins header = {0,1,2} ;  illegal_bins ilegal= {2'b11};}
		LEN  : coverpoint dxtn.header[7:2]{bins small_pkt = {[1:12]} ; bins med_pkt = {[13:30]} ; bins big_pkt = {[31:63]} ;}
		
	endgroup

	covergroup src_payload with function sample(int i);

	PAYLOAD : coverpoint sxtn.payload[i];

	endgroup
	

	function void report_phase(uvm_phase phase);
		`uvm_info(get_type_name(),$sformatf("Report:From SCOREBOARD \n %0d",e_cfg.has_sb),UVM_LOW);
	endfunction

endclass


	












































