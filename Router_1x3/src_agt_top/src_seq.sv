/***************************************************************
////////////////////////////////////////////////////////////////
					   SOURCE SEQUENCES
////////////////////////////////////////////////////////////////
***************************************************************/

class src_wbase_seq extends uvm_sequence #(src_xtn);

	`uvm_object_utils(src_wbase_seq)


	bit [1:0]addr;
	function new(string name = "src_wbase_seq");
		super.new(name);
	endfunction

endclass



////////////////////////////////////
/*		SMALL PACKET SEQUENCE     */
////////////////////////////////////


class src_small_pkt_xtn extends src_wbase_seq;

	`uvm_object_utils(src_small_pkt_xtn)

	function new (string name = "src_small_pkt_xtn");
		super.new(name);
	endfunction
	

	task body();
	begin
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
			`uvm_fatal(get_type_name(),"cant get config src seq ")
			req = src_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with{header [7:2] inside{[1:12]};
										header [1:0] == addr;})
			finish_item(req);
	end
	endtask

endclass


////////////////////////////////////
/*		MEDIUM PACKET SEQUENCE    */
////////////////////////////////////


class src_med_pkt_xtn extends src_wbase_seq;

	`uvm_object_utils(src_med_pkt_xtn)

	function new (string name = "src_med_pkt_xtn");
		super.new(name);
	endfunction


	task body();
		begin
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
			`uvm_fatal(get_type_name(),"cant get config src seq ")
			req = src_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with{header [7:2] inside{[12:30]};
										header [1:0]== addr;})
			finish_item(req);
		end
	endtask

endclass



////////////////////////////////////
/*		BIG PACKET SEQUENCE       */
////////////////////////////////////


class src_big_pkt_xtn extends src_wbase_seq;

	`uvm_object_utils(src_big_pkt_xtn)

	function new (string name = "src_big_pkt_xtn");
		super.new(name);
	endfunction

	task body();
		begin
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
			`uvm_fatal(get_type_name(),"cant get config src seq ")
			req = src_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with{header [7:2] inside{[30:63]};
										header [1:0] == addr;})
			finish_item(req);
		end
	endtask

endclass



////////////////////////////////////
/*		RANDOM PACKET SEQUENCE    */
////////////////////////////////////


class src_rand_pkt_xtn extends src_wbase_seq;

	`uvm_object_utils(src_rand_pkt_xtn)

	function new (string name = "src_rand_pkt_xtn");
		super.new(name);
	endfunction


	task body();
		begin
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
			`uvm_fatal(get_type_name(),"cant get config src seq ")
			req = src_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {header [1:0]== addr;})
			finish_item(req);
		end
	endtask

endclass


////////////////////////////////////
/*		 BAD PACKET SEQUENCE      */
////////////////////////////////////
/*
class src_err_pkt_xtn extends src_wbase_seq;
	
	`uvm_object_utils(src_err_pkt_xtn)

	function new (string name = "src_rand_pkt_xtn");
		super.new(name);
	endfunction

	task body();
		begin
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
			`uvm_fatal(get_type_name(),"cant get config src seq ")
			req = src_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with {header [1:0]== addr;})
			finish_item(req);
		end
	endtask
endclass

*/






