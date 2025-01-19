package score_board_pkg;
import uvm_pkg::*;
import squence_item_pkg::*;
`include"uvm_macros.svh" 
class ram_scoreboard extends uvm_scoreboard;
`uvm_component_utils(ram_scoreboard)
uvm_analysis_export #(ram_seq_item) sb_export;
uvm_tlm_analysis_fifo #(ram_seq_item) sb_fifo;
ram_seq_item seq_item_sb;
logic [7:0] dout_ref;
logic tx_valid_ref ;
logic [7:0] rd_add_ref;
logic [7:0] wr_add_ref;
logic [7:0] mem_ref [255:0];
int error_count=0;
int correct_count=0;
int count ;
    function new(string name ="ram_scoreboard",uvm_component parent =null);
        super.new(name,parent);
    endfunction //new()
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq_item_sb = new("seq_item_sb");
    sb_export =new("sb_export",this);
    sb_fifo=new("sb_fifo",this);
endfunction
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        sb_fifo.get(seq_item_sb);

        if(((seq_item_sb.dout !==dout_ref)||(seq_item_sb.tx_valid !== tx_valid_ref))&& (seq_item_sb.rx_valid==1))
        begin
            error_count=error_count+1; `uvm_error("run_phase",$sformatf("comparasion_failed,transaction recieved by dut : %s while the refrence dout:0b%0b and tx_valid_ref :0b%0b ",seq_item_sb.convert2string(),dout_ref,tx_valid_ref)) 
        end
       else begin
            correct_count= correct_count+1 ;
            `uvm_info("run_phase",$sformatf("correct data out :%s",seq_item_sb.convert2string()),UVM_HIGH)
        end 

        ref_model(seq_item_sb);
         
    end    
endtask
/////////////////////////////////////////////////////////////////////////////
task ref_model(ram_seq_item seq_item_chk);
      if(!seq_item_chk.rst_n)begin
        dout_ref=0;
        rd_add_ref=0;
        wr_add_ref=0;
        tx_valid_ref=0;
        foreach (mem_ref[i]) begin
            mem_ref[i]=0;
        end
      end
        else if(seq_item_chk.rx_valid)begin
            case (seq_item_chk.din[9:8])
                2'b00:begin
                    wr_add_ref=seq_item_chk.din[7:0];
                    tx_valid_ref=0;
                end   
                2'b01:begin
                    mem_ref[wr_add_ref]=seq_item_chk.din[7:0];
                    tx_valid_ref=0;
                end  
                    2'b10:begin
                    rd_add_ref=seq_item_chk.din[7:0];
                    tx_valid_ref=0;
                end   
                    2'b11:begin
                    dout_ref=mem_ref[rd_add_ref];
                    tx_valid_ref=1;
                end
            endcase
        end
endtask
function void report_phase(uvm_phase phase) ;
    super.report_phase(phase);
    `uvm_info("report phase",$sformatf("total successful transactions is %0d",correct_count),UVM_MEDIUM)

    `uvm_info("report phase",$sformatf("total wrong transactions is %0d",error_count),UVM_MEDIUM)
endfunction
endclass //className extends superClass
endpackage