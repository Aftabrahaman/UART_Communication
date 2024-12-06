// Code your testbench here
// or browse Examples

`include "uvm_macros.svh"
import uvm_pkg::*;

class uart_config extends uvm_object;
  `uvm_object_utils(uart_config)
  
  uvm_active_passive_enum is_active= UVM_ACTIVE;
  
  function new(string name="uart_config");
    super.new(name);
  endfunction
  
endclass

typedef enum bit [3:0] {rand_baud_stop=0,rand_length_stop=1,length5wp=2,length6wp=3,length7wp=4,length8wp=5,length5wop=6,length6wop=7,length7wop=8,length8wop=9} op_mode;

class trans extends uvm_sequence_item;
  `uvm_object_utils(trans)
  
  function new(string name="trans");
    super.new(name);
  endfunction
  
  op_mode op;
  logic tx_start,rx_start;
  logic rst;
  rand logic [7:0] tx_data;
  rand logic [16:0] baud;
  rand logic [3:0] length;
  rand logic parity_type,parity_en;
  logic tx_error,rx_error,tx_done,rx_done;
  logic [7:0] rx_out;
  
  constraint baud_c { baud inside{4800,9600,14400,19200,38400,57600};}
  constraint length_c { length inside {5,6,7,8};}
  
endclass

class r_baud_stop extends uvm_sequence#(trans);
  `uvm_object_utils(r_baud_stop)
  
  trans tr;
  
  function new(string name="r_baud_stop");
    super.new(name);
  endfunction
  
  virtual task body();
    tr=trans::type_id::create("tr");
    repeat(5) begin
      start_item(tr);
      assert(tr.randomize);
      tr.op= rand_baud_stop;
      tr.length= 5;
      tr.rst=1'b0;
      tr.tx_start=1'b1;
      tr.rx_start=1'b1;
      tr.parity_en=1'b1;
      finish_item(tr);
    end
  endtask
endclass


class r_length_stop extends uvm_sequence#(trans);
  `uvm_object_utils(r_length_stop)
  
  trans tr;
  
  function new(string name="r_length_stop");
    super.new(name);
  endfunction
  
  virtual task body();
    tr=trans::type_id::create("tr");
    repeat(5) begin
      start_item(tr);
      assert(tr.randomize);
      tr.op= rand_length_stop;
      tr.baud =4800;
      tr.rst=1'b0;
      tr.tx_start=1'b1;
      tr.rx_start=1'b1;
      tr.parity_en=1'b1;
      finish_item(tr);
    end
  endtask
endclass


class rlength5wp extends uvm_sequence#(trans);
  `uvm_object_utils(rlength5wp)
  
  trans tr;
  
  function new(string name="rlength5wp");
    super.new(name);
  endfunction
  
  virtual task body();
    tr=trans::type_id::create("tr");
    repeat(5) begin
      start_item(tr);
      assert(tr.randomize);
      tr.op= length5wp;
      tr.rst=1'b0;
      tr.tx_data={3'b000,tr.tx_data[7:3]};
      tr.length= 5;
      tr.tx_start=1'b1;
      tr.rx_start=1'b1;
      tr.parity_en=1'b1;
      finish_item(tr);
    end
  endtask
endclass

class rlength6wp extends uvm_sequence#(trans);
  `uvm_object_utils(rlength6wp)
  
  trans tr;
  
  function new(string name="rlength6wp");
    super.new(name);
  endfunction
  
  virtual task body();
    tr=trans::type_id::create("tr");
    repeat(5) begin
      start_item(tr);
      assert(tr.randomize);
      tr.op= length6wp;
      tr.rst=1'b0;
      tr.tx_data={2'b00,tr.tx_data[7:2]};
      tr.length= 6;
      tr.tx_start=1'b1;
      tr.rx_start=1'b1;
      tr.parity_en=1'b1;
      finish_item(tr);
    end
  endtask
endclass

class rlength7wp extends uvm_sequence#(trans);
  `uvm_object_utils(rlength7wp)
  
  trans tr;
  
  function new(string name="rlength7wp");
    super.new(name);
  endfunction
  
  virtual task body();
    tr=trans::type_id::create("tr");
    repeat(5) begin
      start_item(tr);
      assert(tr.randomize);
      tr.op= length7wp;
      tr.rst=1'b0;
      tr.tx_data={1'b0,tr.tx_data[7:1]};
      tr.length= 7;
      tr.tx_start=1'b1;
      tr.rx_start=1'b1;
      tr.parity_en=1'b1;
      finish_item(tr);
    end
  endtask
endclass

class rlength8wp extends uvm_sequence#(trans);
  `uvm_object_utils(rlength8wp)
  
  trans tr;
  
  function new(string name="rlength8wp");
    super.new(name);
  endfunction
  
  virtual task body();
    tr=trans::type_id::create("tr");
    repeat(5) begin
      start_item(tr);
      assert(tr.randomize);
      tr.op= length8wp;
      tr.rst=1'b0;
      tr.length= 8;
      tr.tx_start=1'b1;
      tr.rx_start=1'b1;
      tr.parity_en=1'b1;
      finish_item(tr);
    end
  endtask
endclass

class rlength5wop extends uvm_sequence#(trans);
  `uvm_object_utils(rlength5wop)
  
  trans tr;
  
  function new(string name="rlength5wop");
    super.new(name);
  endfunction
  
  virtual task body();
    tr=trans::type_id::create("tr");
    repeat(5) begin
      start_item(tr);
      assert(tr.randomize);
      tr.op= length5wop;
      tr.rst=1'b0;
      tr.tx_data={3'b000,tr.tx_data[7:3]};
      tr.length= 5;
      tr.tx_start=1'b1;
      tr.rx_start=1'b1;
      tr.parity_en=1'b0;
      finish_item(tr);
    end
  endtask
endclass

class rlength6wop extends uvm_sequence#(trans);
  `uvm_object_utils(rlength6wop)
  
  trans tr;
  
  function new(string name="rlength6wop");
    super.new(name);
  endfunction
  
  virtual task body();
    tr=trans::type_id::create("tr");
    repeat(5) begin
      start_item(tr);
      assert(tr.randomize);
      tr.op= length6wop;
      tr.rst=1'b0;
      tr.tx_data={2'b00,tr.tx_data[7:2]};
      tr.length= 6;
      tr.tx_start=1'b1;
      tr.rx_start=1'b1;
      tr.parity_en=1'b0;
      finish_item(tr);
    end
  endtask
endclass

class rlength7wop extends uvm_sequence#(trans);
  `uvm_object_utils(rlength7wop)
  
  trans tr;
  
  function new(string name="rlength7wop");
    super.new(name);
  endfunction
  
  virtual task body();
    tr=trans::type_id::create("tr");
    repeat(5) begin
      start_item(tr);
      assert(tr.randomize);
      tr.op= length7wop;
      tr.rst=1'b0;
      tr.tx_data={1'b0,tr.tx_data[7:1]};
      tr.length= 7;
      tr.tx_start=1'b1;
      tr.rx_start=1'b1;
      tr.parity_en=1'b0;
      finish_item(tr);
    end
  endtask
endclass

class rlength8wop extends uvm_sequence#(trans);
  `uvm_object_utils(rlength8wop)
  
  trans tr;
  
  function new(string name="rlength8wop");
    super.new(name);
  endfunction
  
  virtual task body();
    tr=trans::type_id::create("tr");
    repeat(5) begin
      start_item(tr);
      assert(tr.randomize);
      tr.op= length8wop;
      tr.rst=1'b0;
      tr.tx_data={3'b000,tr.tx_data[7:3]};
      tr.length= 5;
      tr.tx_start=1'b1;
      tr.rx_start=1'b1;
      tr.parity_en=1'b0;
      finish_item(tr);
    end
  endtask
endclass


class driver extends uvm_driver#(trans);
  `uvm_component_utils(driver)
  
  trans tr;
  virtual uart_if uif;
  
  function new(string path="driver",uvm_component p);
    super.new(path,p);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr=trans::type_id::create("tr");
    if (!uvm_config_db#(virtual uart_if)::get(this,"","uif",uif))
        `uvm_error("DRV","Unable to access the interface");
  endfunction
  
  task reset_dut();
    repeat(3)begin
    uif.rst<=1'b1;
    uif.tx_start<=1'b0;
    uif.rx_start<=1'b0;
    uif.tx_data<=8'h00;
    uif.parity_en<=1'b0;
    uif.baud<=16'h0;
    uif.length<=4'h0;
    `uvm_info("DRV","Sytem reset Done ",UVM_MEDIUM);
      @(posedge uif.clk);
    end
  endtask
  
  task drive();
    reset_dut();
    forever begin
      seq_item_port.get_next_item(tr);
      uif.rst<=1'b0;
      uif.tx_start<=tr.tx_start;
      uif.rx_start<=tr.rx_start;
      uif.tx_data<=tr.tx_data;
      uif.parity_en<=tr.parity_en;
      uif.parity_type<=tr.parity_type;
      uif.length<=tr.length;
      uif.baud<=tr.baud;
      `uvm_info("DRV",$sformatf("BAUD:%0d LEN:%0d PAR_T:%0d PAR_EN:%0d TX_DATA:%0d", tr.baud, tr.length, tr.parity_type, tr.parity_en,  tr.tx_data),UVM_NONE);
      @(posedge uif.clk);
      @(posedge uif.tx_done);
      @(posedge uif.rx_done);
      seq_item_port.item_done();
    end
  endtask
  
  virtual task run_phase(uvm_phase phase);
    drive();
  endtask
  
endclass

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  trans tr;
  virtual uart_if uif;
  uvm_analysis_port#(trans) send;
  
  function new(string path="monitor",uvm_component parent=null);
    super.new(path,parent);
  endfunction
  
  virtual function void  build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr=trans::type_id::create("tr");
    send=new("send",this);
    if(!uvm_config_db#(virtual uart_if)::get(this,"","uif",uif))
      `uvm_error("MON " ,"Unable to access data fro DUT");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge uif.clk);
      if(uif.rst)begin
        tr.rst=1'b1;
        `uvm_info ("MON ","RESET DONE ",UVM_NONE);
        send.write(tr);
      end
      else 
        @(posedge uif.tx_done);
          tr.rst=1'b0;
          tr.tx_start=uif.tx_start;
          tr.rx_start=uif.rx_start;
          tr.baud=uif.baud;
          tr.length=uif.length;
          tr.tx_data=uif.tx_data;
          tr.parity_en=uif.parity_en;
          tr.parity_type=uif.parity_type;
          @(posedge uif.rx_done);
          tr.rx_out=uif.rx_out;
          send.write(tr);
          `uvm_info("MON ",$sformatf("baud : %0d , length :%0d , parity_t : %0b  , parity_E : %0b  , tx_data  : %0d , RX_out  : %0d ",tr.baud, tr.length,tr.parity_type,tr.parity_en,tr.tx_data,tr.rx_out),UVM_NONE);
        
    end
  endtask
endclass


class score extends uvm_scoreboard;
  `uvm_component_utils(score)
  
  uvm_analysis_imp#(trans,score) recv;
  
  function new(string path="score",uvm_component parent=null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    recv= new("recv",this);
  endfunction
  
  virtual function void write(trans tr);
    `uvm_info("SCO ",$sformatf("BAUD:%0d LEN:%0d PAR_T:%0d PAR_EN:%0d  TX_DATA:%0d RX_DATA:%0d", tr.baud, tr.length, tr.parity_type, tr.parity_en,  tr.tx_data, tr.rx_out), UVM_NONE);
    if (tr.rst==1'b1)
      `uvm_info("SCO", "System Reset", UVM_NONE)
    else if(tr.tx_data==tr.rx_out)
      `uvm_info("SCO", "System passed", UVM_NONE)
    else 
      `uvm_info("SCO", "System Failed ", UVM_NONE)
    $display("---------------------------------------------------------------");
  endfunction
endclass

class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  driver d;
  monitor m;
  uvm_sequencer#(trans) seqr;
  uart_config cfg;
  
  function new(string path="agent", uvm_component parent=null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cfg=uart_config::type_id::create("cfg");
    m=monitor::type_id::create("m",this);
    
    if(cfg.is_active==UVM_ACTIVE)
      d=driver::type_id::create("d",this);
    seqr=uvm_sequencer#(trans)::type_id::create("seqr",this);
    
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(cfg.is_active==UVM_ACTIVE)begin
    d.seq_item_port.connect(seqr.seq_item_export);
    end
  endfunction
endclass


class env extends uvm_env;
  `uvm_component_utils(env)
  
  score s;
  agent a;
  
  function new(string path="env", uvm_component p);
    super.new(path,p);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    s=score::type_id::create("s",this);
    a=agent::type_id::create("a",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a.m.send.connect(s.recv);
  endfunction
endclass

class top extends uvm_test;
  `uvm_component_utils(top)
  
  env e;
  r_baud_stop rbs;
  r_length_stop rls;
  rlength5wp l5wp;
  rlength6wp l6wp;
  rlength7wp l7wp;
  rlength8wp l8wp;
  rlength5wop l5wop;
  rlength6wop l6wop;
  rlength7wop l7wop;
  rlength8wop l8wop;
  
  function new(string path="top",uvm_component p);
    super.new(path,p);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    e       = env::type_id::create("env",this);
   rbs     = r_baud_stop::type_id::create("rbs");
    rls=r_length_stop::type_id::create("rls");
  /////////////fixed length var baud with parity
    l5wp=rlength5wp::type_id::create("l5wp");
    l6wp=rlength6wp::type_id::create("l6wp");
    l7wp=rlength7wp::type_id::create("l7wp");
    l8wp=rlength8wp::type_id::create("l8wp");
  
  ///////////////fixed len var baud without parity
    l5wop=rlength5wop::type_id::create("l5wop");
    l6wop=rlength6wop::type_id::create("l6wop");
    l7wop=rlength7wop::type_id::create("l7wop");
    l8wop=rlength8wop::type_id::create("l8wop");
    
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rbs.start(e.a.seqr);
    #20;
    phase.drop_objection( this);
  endtask
endclass

module tb;
  uart_if uif();
  initial uif.clk<=0;
  uart_top dut(.clk(uif.clk),.rst(uif.rst),.baud(uif.baud),.length(uif.length),.rx_start(uif.rx_start),.tx_start(uif.tx_start),.parity_en(uif.parity_en),.parity_type(uif.parity_type),.tx_data(uif.tx_data),.rx_out(uif.rx_out),.rx_done(uif.rx_done),.rx_error(uif.rx_error),.tx_done(uif.tx_done),.tx_error(uif.tx_error));
  
  always begin
    #10 uif.clk=~uif.clk;
  end
  
  initial begin
    uvm_config_db#(virtual uart_if)::set(null,"*","uif",uif);
    run_test("top");
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
endmodule 
  
  
