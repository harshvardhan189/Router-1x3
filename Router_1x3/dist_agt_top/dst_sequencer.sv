
/***************************************************************
////////////////////////////////////////////////////////////////
					 	DESTINATION SEQUENCER 
////////////////////////////////////////////////////////////////
***************************************************************/

class dst_sequencer extends uvm_sequencer #(dst_xtn);

	`uvm_component_utils(dst_sequencer)

	function new(string name = "dst_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction
	
endclass


