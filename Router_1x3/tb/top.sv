/***************************************************************
////////////////////////////////////////////////////////////////
							TOP
////////////////////////////////////////////////////////////////
***************************************************************/


module top;
	
	import pkg::*;
	
	import uvm_pkg::*;	
	
	bit clock;

	always #10 clock = !clock;

	Router_src_if si0(clock);
	Router_dst_if di0(clock);
	Router_dst_if di1(clock);
	Router_dst_if di2(clock);

	Router_top DUT(.clock(clock),
				   .resetn(si0.resetn),
				   .read_enb({di2.read_enb,di1.read_enb,di0.read_enb}),
				   .data_in(si0.data_in),
				   .pkt_valid(si0.pkt_valid),
				   .data_out_0(di0.data_out), 
				   .data_out_1(di1.data_out),
				   .data_out_2(di2.data_out),
				   .valid_out_0(di0.vld_out),
				   .valid_out_1(di1.vld_out),
				   .valid_out_2(di2.vld_out),
				   .error(si0.error),
				   .busy(si0.busy));

	
       	initial 
		begin

			`ifdef VCS
         		$fsdbDumpvars(0, top);
				`endif
		uvm_config_db #(virtual Router_src_if)::set(null,"*","svif_0",si0);
		uvm_config_db #(virtual Router_dst_if)::set(null,"*","dvif_0",di0);
		uvm_config_db #(virtual Router_dst_if)::set(null,"*","dvif_1",di1);
		uvm_config_db #(virtual Router_dst_if)::set(null,"*","dvif_2",di2);

				run_test();
			end
endmodule



