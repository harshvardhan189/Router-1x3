
/***************************************************************
////////////////////////////////////////////////////////////////
						DESTINATION SEQUENCE 
////////////////////////////////////////////////////////////////
***************************************************************/

class dst_wbase_seq extends uvm_sequence #(dst_xtn);
	
	`uvm_object_utils(dst_wbase_seq)

	function new(string name = "dst_wbase_seq");
		super.new(name);
	endfunction

endclass


///////////////////////////////////////////
/*  	  	  SMALL PKT SEQUENCE	  	 */
///////////////////////////////////////////

class dst_pkt_xtn extends dst_wbase_seq;
	`uvm_object_utils(dst_pkt_xtn)

	function new(string name = "dst_pkt_xtn" );
		super.new(name);
	endfunction

	task body();
		begin
		req = dst_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with{no_of_cycle < 28;})
		finish_item(req);
		end
	endtask
endclass




