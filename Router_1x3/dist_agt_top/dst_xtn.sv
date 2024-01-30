/***************************************************************
////////////////////////////////////////////////////////////////
						DESTINATION TRANSACTION
////////////////////////////////////////////////////////////////
***************************************************************/

class dst_xtn extends uvm_sequence_item;

	`uvm_object_utils(dst_xtn)

	rand bit [4:0] no_of_cycle ;// for softreset
		 bit [7:0] header;
		 bit [7:0] parity;
		 bit [7:0] payload [];

	constraint CYCLE{no_of_cycle < 28;}

	function new(string name = "dst_xtn");
		super.new(name);
	endfunction

	 function void do_print(uvm_printer printer);
	 	super.do_print(printer);
		
		printer.print_field("HEADER" , this.header     , 8 , UVM_BIN);
		
		foreach(payload[i])
		printer.print_field($sformatf("PAYLOAD[%0d]",i), this.payload[i] , 8 , UVM_DEC);

		printer.print_field("PARITY" , this.parity     , 8 , UVM_DEC);

		printer.print_field("NO_OF_CYCLE"  , this.no_of_cycle      , 5 , UVM_DEC);

	endfunction


	

	
endclass


