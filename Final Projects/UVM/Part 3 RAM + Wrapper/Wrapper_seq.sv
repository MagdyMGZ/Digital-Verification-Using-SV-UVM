package sequences ;
	import Wrapper_pack ::*;
	import Wrapper_seq_item::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	Wrapper_seq_item seq_item_static ;

	class Wrapper_reset_seq extends uvm_sequence #(Wrapper_seq_item);
		`uvm_object_utils(Wrapper_reset_seq) 

		function new( string name = "Wrapper_reset_seq");
			super.new(name);
		endfunction : new

		task body ; 
			seq_item_static = Wrapper_seq_item::type_id::create("seq_item_static");
			start_item(seq_item_static);
			seq_item_static.rst_n =0;
			seq_item_static.SS_n =0 ;
			seq_item_static.MOSI = 0;
			finish_item(seq_item_static); 
		endtask	
	endclass : Wrapper_reset_seq

	class Wrapper_main_seq extends uvm_sequence #(Wrapper_seq_item) ;
		`uvm_object_utils(Wrapper_main_seq)
		Wrapper_seq_item seq_item_main,seq_item_static;

		function new(string name = "Wrapper_main_seq");
			super.new(name);
		endfunction : new

		task body ;
			seq_item_static = Wrapper_seq_item::type_id::create("seq_item_static"); 
			repeat(10000) begin
				seq_item_main = Wrapper_seq_item::type_id::create("seq_item_main");
				start_item(seq_item_main);
				assert(seq_item_static.randomize() with {SS_n==0;});
				update_seq_item();
				finish_item(seq_item_main);
			end
		endtask

		task update_seq_item();
			seq_item_main.rst_n = seq_item_static.rst_n;
			seq_item_main.SS_n = seq_item_static.SS_n;
			seq_item_main.MOSI = seq_item_static.MOSI;
			seq_item_main.MISO = seq_item_static.MISO;
			seq_item_main.data_holder = seq_item_static.data_holder;
			seq_item_main.address_sent = seq_item_static.address_sent;
		endtask

		/*
		task update_flags();
			if(! seq_item_static.rst_n) begin	
					 seq_item_static.address_sent=0;
			end
			else begin
				case ( seq_item_static.current_state)
				IDLE: begin
						 seq_item_static.update=0;
						 seq_item_static.counter =0;
					 	if(! seq_item_static.SS_n)
							 seq_item_static.next_state = CHK_CMD;
						else 
							 seq_item_static.next_state = IDLE ;
					end	

				CHK_CMD: begin
						 seq_item_static.check =0 ;
					if(! seq_item_static.MOSI)
						 seq_item_static.next_state =WRITE ;
					else if( seq_item_static.address_sent)
						 seq_item_static.next_state = READ_DATA ;
					else
						 seq_item_static.next_state =READ_ADD;
				end
				WRITE: begin
					 seq_item_static.counter = seq_item_static.counter+1 ;
					if(! seq_item_static.SS_n)begin
						 seq_item_static.update = 1;
						 seq_item_static.next_state=WRITE;
					end 
					else begin
						 seq_item_static.next_state =IDLE;
						 seq_item_static.check=1;
					end
						
				end

				READ_ADD: begin
					 seq_item_static.counter = seq_item_static.counter+1 ;
					if(! seq_item_static.SS_n)begin
						 seq_item_static.update = 1;
						 seq_item_static.next_state =READ_ADD ;
					end	
					else begin
						 seq_item_static.check =1;
						 seq_item_static.next_state = IDLE;
						 seq_item_static.address_sent=1;
					end
				end	

				READ_DATA: begin
					 seq_item_static.counter =  seq_item_static.counter +1 ;

					if(! seq_item_static.SS_n) begin
						 seq_item_static.next_state =READ_DATA ;
						if( seq_item_static.counter<11)
							 seq_item_static.update=1;
						else begin
							 seq_item_static.update=0;
							 seq_item_static.check =1 ;
						end	
					end	
					else begin
						 seq_item_static.next_state = IDLE ;
						 seq_item_static.address_sent =0;
					end
				end	

				endcase
			end	
		endtask	
		*/
	endclass : Wrapper_main_seq		

endpackage 	
						