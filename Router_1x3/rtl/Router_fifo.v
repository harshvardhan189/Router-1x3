module Router_fifo(

	input clock,resetn,
	input we,
	input re,
	input lfd_state,
	input soft_reset,
    input [7:0]data_in,
	
	output full,empty,
	output reg [7:0]data_out
	);

	reg [8:0]mem[0:15];
	reg [4:0]wp,rp;
	reg [6:0]count;
	integer i,p;
	reg lfd_state_r;

	assign full  = (wp == ({~rp[4],rp[3:0]}));
	assign empty = (rp == wp); 

//	assign full  = (wp == 5'b10000)? 1'b1:1'b0;
//	assign empty = (wp ==5'b0)?((rp==5'b0)? 1'b1:1'b0):1'b0;


//////////// write \\\\\\\\\\\\\\\\\\
	always@(posedge clock)
	begin
		if(!resetn)
			lfd_state_r <= 0;
		else
			lfd_state_r <= lfd_state;
	end

	always@(posedge clock)
	begin
		if(!resetn)
		begin
			for(i=0;i<16;i=i+1)
			mem[i] <= 0;
		end	
		
		else if(soft_reset)
		begin 
			for(p=0;p<16;p=p+1)
			mem[p]<=0;
		end

		else if(we && ~full)
		begin
			if(lfd_state_r)
			begin
				mem[wp[3:0]][8] <=1;
				mem[wp[3:0]][7:0] <= data_in;
			end

			else
			begin
				mem[wp[3:0]][8] <=0;
				mem[wp[3:0]][7:0] <= data_in;
			end
		end
	end

/////////////// read \\\\\\\\\\\\\\\\\\
	always@(posedge clock)
	begin
		if(!resetn)
		begin
			data_out <=0;
		end

		else if(soft_reset)
		data_out<=8'bz;

	///	else if(mem[wp[3:0]-1][8]==1)
	///	count <= mem[wp-1][7:2]+2'd2;


		else if(re && !empty)
		begin
			data_out <= mem[rp[3:0]][7:0];
		end

		else if(count==0)
			data_out = 8'bz;
	end


	always@(posedge clock)
	begin
		if(!resetn)
		wp <= 0;

		else if(we && ~full)
		wp <= wp+1;
	end
	
	
	always@(posedge clock)
	begin
		if(!resetn)
		rp <= 0;

		else if(re && ~empty)
		rp <= rp+1;
	end
	
	
	always@(posedge clock)
	begin
		if(re && ~empty)
		begin
			if((mem[rp[3:0]][8])==1)
			count <= mem[rp[3:0]][7:2]+1;
			else if(count !=0)
			count <= count -1;	
		end
	end
endmodule
