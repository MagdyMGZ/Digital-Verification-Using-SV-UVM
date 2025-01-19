package Wrapper_seq_item ;

	import Wrapper_pack ::*; 
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class Wrapper_seq_item extends uvm_sequence_item ;
		`uvm_object_utils(Wrapper_seq_item)

		rand logic MOSI,SS_n,rst_n;
		rand logic [10:0] data_holder ;
		logic MISO ;
		integer rand_no ;
		bit address_sent;

		function void pre_randomize();
			if(SS_n)
				rand_no=0;
			if(!rst_n) begin
				address_sent=0;
				rand_no=0;
			end	
			else begin
				rand_no=rand_no+1;
				if(data_holder[10:8] == 3'b110) 
					address_sent =1;
				else if(data_holder[10:8] == 3'b111)
					address_sent =0 ;
			end
			
		endfunction

		constraint wrapper_c
		{
			rst_n dist {0:=1 , 1:=800} ;

			if(address_sent && data_holder[10])
			{
			   
			   data_holder[9:8] == 2'b11; 
			}

			else
			{
			    data_holder[10:8] inside{3'b110,3'b001,3'b000};
			}

		} 

		function new(string name = "Wrapper_seq_item");
			super.new(name);
			data_holder =0 ;
			rand_no=0;
		endfunction
		
		function string convert2string();
			return $sformatf("%s reset = %b , SS_n = %b , MOSI = %b , MISO = %b ,address_sent =%b" 
				,super.convert2string(),rst_n,SS_n,MOSI,MISO,address_sent); 
		endfunction

		function string convert2string_op();
			return $sformatf("%s reset = %b , SS_n = %b , MOSI = %b , data_holder = %h ,address_sent =%b" 
				,super.convert2string(),rst_n,SS_n,MOSI,data_holder,address_sent); 
		endfunction
		
		function string convert2string_stimulus();
			return $sformatf("%s reset = %b , SS_n = %b , MOSI = %b " 
				,super.convert2string(),rst_n,SS_n,MOSI); 
		endfunction 
	endclass 
endpackage 			