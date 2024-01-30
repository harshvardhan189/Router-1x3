
/***************************************************************
////////////////////////////////////////////////////////////////
						SOURCE TRANSACTION
////////////////////////////////////////////////////////////////
***************************************************************/

class src_xtn extends uvm_sequence_item;

	`uvm_object_utils(src_xtn)
	
	rand bit [7:0] header;
	rand bit [7:0] payload [];
		 bit [7:0] parity;
	 	 logic error;

	constraint C1{header[1:0] != 3;}
	constraint C2{header[7:2] inside{[1:63]};}
	constraint C3{payload.size == header[7:2];}

	function new(string name = "src_xtn");
		super.new("src_xtn");
	endfunction

	function void post_randomize();
		parity = header ^ 0;
		foreach(payload[i])
		parity = parity^payload[i];
	endfunction

	/*function void do_copy(uvm_object rhs);
		src_xtn rhs_;

		if(!$cast(rhs_,rhs))
			`uvm_fatal("do_copy","cast of the rhs object failed")

		super.do_copy(rhs);
		
		this.header = rhs_.header;
		this.heapayload = rhs_.payload;
		this.heaparity = rhs_.parity;
//		this.heaerror = rhs_.error;

	endfunction */

	 function void do_print(uvm_printer printer);
	 	super.do_print(printer);
		
		printer.print_field("HEADER" , this.header     , 8 , UVM_BIN);
		
		foreach(payload[i])
		printer.print_field($sformatf("PAYLOAD[%0d]",i), this.payload[i] , 8 , UVM_DEC);

		printer.print_field("PARITY" , this.parity     , 8 , UVM_DEC);
		printer.print_field("ERROR"  , this.error      , 1 , UVM_DEC);

	endfunction

endclass


class src_err_xtn extends src_xtn;
	
	`uvm_object_utils(src_err_xtn)

	function new(string name = "src_err_xtn");
		super.new(name);
	endfunction
	
	function void post_randomize();
		parity = 0;
	endfunction


endclass
