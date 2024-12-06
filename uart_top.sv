


interface uart_if;
  logic clk;
  logic rst;
  logic [3:0] length;
  logic [16:0] baud;
  logic tx_start;
  logic rx_start;
  logic parity_en;
  logic parity_type;
  logic [7:0] tx_data;
  logic [7:0] rx_out;
  logic tx_done;
  logic rx_done;
  logic tx_error;
  logic rx_error;
  
endinterface



module uart_top(
  input clk,rst,
  input [16:0] baud,
  input [3:0] length,
  input rx_start,tx_start,
  input parity_en,parity_type,
  input [7:0] tx_data,
  output reg [7:0] rx_out,
  output rx_done,rx_error,tx_done,tx_error);
  wire  rx_clk,tx_clk;
  wire tx_rx;
  
  uart_clk q1(baud,clk,rst,rx_clk,tx_clk);
  uart_tx q2(tx_clk,rst,tx_data,length,parity_type,parity_en,tx_start,tx_rx,tx_done,tx_error);
  uart_rx q3(rx_clk,rst,tx_rx,length,parity_en,parity_type,rx_start,rx_done,rx_error,rx_out);
  
endmodule 
  
  




  
  module uart_clk(
    input [16:0] baud,
    input clk,
    input rst,
    output reg rclk,tclk);
    
    int tx_max,tcount,rx_max,rcount;
    
    always @(posedge clk)
      begin
      
      if(rst)begin
        tclk<=0;
        rclk<=0;
      end
      else begin
        case(baud)
          
          4800 : begin
            tx_max<=16'd10416;
            rx_max<=16'd1736;
          end
          
          9600 : begin
            tx_max<=16'd5208;
            rx_max<=16'd868;
          end
          
          14400: begin
            tx_max<=16'd3472;
            rx_max<=16'd579;
          end
          
          19200 : begin
            tx_max<=16'd1302;
            rx_max<=16'd217;
          end
          
          57600 : begin
            tx_max<=16'd868;
            rx_max<=16'd144;
          end
          
          default : begin
            tx_max<=16'd5208;
            rx_max<=16'd868;
          end
        endcase
      end
    end
    
    always @(posedge clk)begin
      if(rst)begin
        rcount<=16'd0;
        rclk<=16'd0;
        rx_max<=11'd0;
      end
      else begin
        if(rcount<=rx_max/2)
          rcount=rcount+1;
        else begin
          rclk<=~rclk;
          rcount<=0;
        end
      end
    end
    
    always @(posedge clk)begin
      if(rst) begin
        tcount<=0;
        tx_max<=0;
        tclk<=0;
      end
      else begin
        if(tcount<=tx_max/2)
          tcount<=tcount+1;
        else begin
          tcount<=0;
          tclk<=~tclk;
        end
      end
    end
    
   
  endmodule
  
  module uart_tx(
    input tx_clk,rst,
    input [7:0] tx_data,
    input [3:0]length,
    input parity_type,
    input parity_en,
    input tx_start,output reg tx,tx_done,tx_error);
    
    logic [7:0] tx_reg;
    logic start_bit =0;
    logic stop_bit= 1;
    integer count=0;
    logic parity_bit=0;
    
    typedef enum bit [2:0] { idle =0, start=1, send_data =2,send_parity=3,stop=4,done=5} state_type;
    state_type state=idle ,next_state=idle;
    
    always @(posedge tx_clk)begin
      if(parity_type==1)begin
        case(length)
          4'd5 : parity_bit=^(tx_data[4:0]);
          4'd6 : parity_bit=^(tx_data[5:0]);
          4'd7: parity_bit=^(tx_data[6:0]);
          4'd8: parity_bit=^(tx_data[7:0]);
        endcase
      end
      else begin
        case (length)
          4'd5 : parity_bit=~^(tx_data[4:0]);
          4'd6 : parity_bit=~^(tx_data[5:0]);
          4'd7: parity_bit=~^(tx_data[6:0]);
          4'd8: parity_bit=~^(tx_data[7:0]);
        endcase
      end
    end
    
    always@(*)begin
      case(state)
        idle : begin
          tx=1'b1;
          tx_done=1'b0;
          tx_error=1'b0;
          tx_reg={(8){1'b0}};
          if(tx_start)
            next_state=start;
          else
            next_state=idle;
        end
        
        start: begin
          tx_reg=tx_data;
          tx=start_bit;
          next_state=send_data;
        end
        
        send_data: begin
          if(count<length-1)begin
            tx=tx_reg[count];
            next_state=send_data;
          end
          else if (parity_en) begin
            tx=tx_reg[count];
            next_state=send_parity;
          end
          else begin
            tx=tx_data[count];
          next_state=stop;
          end
        end
        
        send_parity: begin
          tx=parity_bit;
          next_state=stop;
        end
        
        stop : begin
          tx=stop_bit;
          next_state=done;
        end
        
        done: begin
          tx_done=1'b1;
        next_state=idle;
        end
      endcase
    end
    
    always@(posedge tx_clk) begin
      if(rst)
        state<=idle;
      else
        state<=next_state;
    end
    
    always@(posedge tx_clk) begin
      case(state)
        idle : count<=0;
        start :count<=0;
        send_data : count<=count+1;
        send_parity: count<=0;
        stop: count<=0;
        done: count<=0;
      endcase
    end
    
  endmodule
  
  
  module uart_rx(
    input rx_clk,rst,rx,
    input [3:0] length,
    input parity_en,parity_type,
    input rx_start,
    output logic rx_done,rx_error,
    output reg [7:0] rx_data);
    
    int count=0;
    int bit_count=0;
    logic parity=0;
    logic [7:0] rx_reg;
    
    typedef enum bit[2:0] { idle =0,start_bit=1,receive_data=2,check_parity=3,stop=4,done=5} state_type;
    state_type state=idle , next_state=idle;
    
    always@(posedge rx_clk) begin
      if(rst)
        state<=idle ;
      else 
        state<=next_state;
    end
    
    always@(*)begin
      case (state)
        
        idle : begin
          rx_done=1'b0;
          rx_error=1'b0;
          if(rx_start && !rx)
            next_state=start_bit;
          else
            next_state=idle;
        end
        
        start_bit : begin
          if(count==3 && rx)
            next_state=idle ;
          else if (count==7)
            next_state=receive_data;
          else 
            next_state=start_bit;
        end
        
        receive_data : begin
          if(count==7)
            rx_reg[7:0]={rx,rx_reg[7:1]};
          else if ( count==15 && bit_count==(length-1))
            begin
              case(length)
                4'd5 : rx_data=rx_reg[7:3];
                4'd6 : rx_data=rx_reg[7:2];
                4'd7 : rx_data=rx_reg[7:1];
                4'd8 : rx_data=rx_reg[7:0];
                default : rx_data=8'h00;
              endcase
              if(parity_type)
                parity=^rx_reg;
              else 
                parity=~^rx_reg;
              if (parity_en)
                next_state=check_parity;
              else 
                next_state=stop;
            end
        end
        
        check_parity : begin
          if(count==7)
            begin if(rx==parity)
              rx_error=1'b0;
              else 
                rx_error=1'b1;
            end
          else if (count==15)
            next_state=stop;
          else 
            next_state=check_parity;
        end
        
        stop : begin
          if (count==7)begin
            if(rx==1'b1)
              rx_error=1'b0;
            else 
              rx_error=1'b1;
          end
          else if (count==15)
            next_state=done;
          else 
            next_state=stop;
        end
        
        done : begin
          rx_done=1'b1;
          rx_error=1'b0;
          next_state=idle;
        end
      endcase
    end
    
    
    always @(posedge rx_clk)
      begin
        case(state)
          idle : begin
            count<=0;
            bit_count<=0;
          end
          
          start_bit : begin
            if(count<15)
              count<=count+1;
            else 
              count<=0;
          end
          
          receive_data : begin
            if (count <15)
              count<=count+1;
            else
              count<=0;
            bit_count<=bit_count+1;
          end
          
          check_parity : begin
            if(count<15)
              count<=count+1;
            else 
              count<=0;
          end
          
          stop: begin
            if(count<15)
              count<=count+1;
            else 
              count<=0;
          end
          
          done : begin
            count<=0;
            bit_count<=0;
          end
        endcase 
      end
  endmodule 
  
  
 

                
        
        
          
    
    
            
