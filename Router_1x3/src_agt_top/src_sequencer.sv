/***************************************************************
////////////////////////////////////////////////////////////////
					 	SOURCE SEQUENCER 
////////////////////////////////////////////////////////////////
***************************************************************/

class src_sequencer extends uvm_sequencer #(src_xtn);

	`uvm_component_utils(src_sequencer)

	function new(string name = "src_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction
	
endclass



