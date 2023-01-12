library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Datapath_DMA_1_0_v1_0_M00_AXI is
	generic (
		-- Users to add parameters here
		BRIGHTNESS_WIDTH : integer := 6;
		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- The master will start generating data from the C_M_START_DATA_VALUE value
		C_M_START_DATA_VALUE	: std_logic_vector	:= x"AA000000";
		-- The master requires a target slave base address.
    -- The master will initiate read and write transactions on the slave with base address specified here as a parameter.
		C_M_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000000";
		-- Width of M_AXI address bus. 
    -- The master generates the read and write addresses of width specified as C_M_AXI_ADDR_WIDTH.
		C_M_AXI_ADDR_WIDTH	: integer	:= 32;
		-- Width of M_AXI data bus. 
    -- The master issues write data and accept read data where the width of the data bus is C_M_AXI_DATA_WIDTH
		C_M_AXI_DATA_WIDTH	: integer	:= 32;
		-- Transaction number is the number of write 
    -- and read transactions the master will perform as a part of this example memory test.
		C_M_TRANSACTIONS_NUM	: integer	:= 4
	);
	port (
		-- Users to add ports here
		X_in, Y_in: in std_logic_vector(10-1 downto 0);
		BUFF_ADDR_BIAS: in std_logic_vector(32-1 downto 0);
		H_Position, V_Position: in signed(10-1 downto 0); 
		Pixel_out: out std_logic_vector(24-1  downto 0);
		X_out, Y_out: out std_logic_vector(10-1 downto 0);
		B_out : out std_logic_vector(BRIGHTNESS_WIDTH-1 downto 0);
		-- User ports ends
		-- Do not modify the ports beyond this line

		-- Initiate AXI transactions
		INIT_AXI_TXN	: in std_logic;
		-- Asserts when ERROR is detected
		ERROR	: out std_logic;
		-- Asserts when AXI transactions is complete
		TXN_DONE	: out std_logic;
		-- AXI clock signal
		M_AXI_ACLK	: in std_logic;
		-- AXI active low reset signal
		M_AXI_ARESETN	: in std_logic;
		-- Master Interface Write Address Channel ports. Write address (issued by master)
		M_AXI_AWADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		-- Write channel Protection type.
    -- This signal indicates the privilege and security level of the transaction,
    -- and whether the transaction is a data access or an instruction access.
		M_AXI_AWPROT	: out std_logic_vector(2 downto 0);
		-- Write address valid. 
    -- This signal indicates that the master signaling valid write address and control information.
		M_AXI_AWVALID	: out std_logic;
		-- Write address ready. 
    -- This signal indicates that the slave is ready to accept an address and associated control signals.
		M_AXI_AWREADY	: in std_logic;
		-- Master Interface Write Data Channel ports. Write data (issued by master)
		M_AXI_WDATA	: out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		-- Write strobes. 
    -- This signal indicates which byte lanes hold valid data.
    -- There is one write strobe bit for each eight bits of the write data bus.
		M_AXI_WSTRB	: out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
		-- Write valid. This signal indicates that valid write data and strobes are available.
		M_AXI_WVALID	: out std_logic;
		-- Write ready. This signal indicates that the slave can accept the write data.
		M_AXI_WREADY	: in std_logic;
		-- Master Interface Write Response Channel ports. 
    -- This signal indicates the status of the write transaction.
		M_AXI_BRESP	: in std_logic_vector(1 downto 0);
		-- Write response valid. 
    -- This signal indicates that the channel is signaling a valid write response
		M_AXI_BVALID	: in std_logic;
		-- Response ready. This signal indicates that the master can accept a write response.
		M_AXI_BREADY	: out std_logic;
		-- Master Interface Read Address Channel ports. Read address (issued by master)
		M_AXI_ARADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		-- Protection type. 
    -- This signal indicates the privilege and security level of the transaction, 
    -- and whether the transaction is a data access or an instruction access.
		M_AXI_ARPROT	: out std_logic_vector(2 downto 0);
		-- Read address valid. 
    -- This signal indicates that the channel is signaling valid read address and control information.
		M_AXI_ARVALID	: out std_logic;
		-- Read address ready. 
    -- This signal indicates that the slave is ready to accept an address and associated control signals.
		M_AXI_ARREADY	: in std_logic;
		-- Master Interface Read Data Channel ports. Read data (issued by slave)
		M_AXI_RDATA	: in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		-- Read response. This signal indicates the status of the read transfer.
		M_AXI_RRESP	: in std_logic_vector(1 downto 0);
		-- Read valid. This signal indicates that the channel is signaling the required read data.
		M_AXI_RVALID	: in std_logic;
		-- Read ready. This signal indicates that the master can accept the read data and response information.
		M_AXI_RREADY	: out std_logic
	);
end Datapath_DMA_1_0_v1_0_M00_AXI;

architecture implementation of Datapath_DMA_1_0_v1_0_M00_AXI is
constant bright_width : integer :=  BRIGHTNESS_WIDTH;
	-- function called clogb2 that returns an integer which has the
	-- value of the ceiling of the log base 2
	function clogb2 (bit_depth : integer) return integer is            
	 	variable depth  : integer := bit_depth;                               
	 	variable count  : integer := 1;                                       
	 begin                                                                   
	 	 for clogb2 in 1 to bit_depth loop  -- Works for up to 32 bit integers
	      if (bit_depth <= 2) then                                           
	        count := 1;                                                      
	      else                                                               
	        if(depth <= 1) then                                              
	 	       count := count;                                                
	 	     else                                                             
	 	       depth := depth / 2;                                            
	          count := count + 1;                                            
	 	     end if;                                                          
	 	   end if;                                                            
	   end loop;                                                             
	   return(count);        	                                              
	 end;
	 	--function called addr_calc that returns an integer corresponding to the address in the DRAM of the corresponding pixel of coordinates (x,y)
	--Might need to add offsets 
	function addr_calc( x : std_logic_vector(10-1 downto 0); y : std_logic_vector(10-1 downto 0); H_Position, V_Position: signed(10-1 downto 0); bias : std_logic_vector(32-1 downto 0)) return integer is
		variable addr 		: integer :=0;
		constant offset_x 	: integer := 1920 / 2;
		constant offset_y 	: integer := 1080 / 2;
		constant base_x        : integer := 1920;
        constant base_y        : integer := 1080;
        constant x_translat : integer := 1920;
	begin	
		addr := (to_integer(signed(x)) + offset_x + to_integer(H_Position) + x_translat * (base_y - to_integer(signed(y)) - offset_y - to_integer(V_Position))) * 3 + to_integer(unsigned(bias));
		return (addr);
	end;
	 	--function called brightness that returns an std_logic corresponding to the brightness of the input pixel(r,g,b values)

	function brightness(r : std_logic_vector(8-1 downto 0); g: std_logic_vector(8-1 downto 0); b : std_logic_vector(8-1 downto 0)) return std_logic_vector is
		variable bright  : std_logic_vector(r'length -1 downto 0);
	begin
			bright  := std_logic_vector(((unsigned(r) + unsigned(g) + unsigned(b))) / 3);
			return (bright(BRIGHTNESS_WIDTH - 1 downto 0));
	end;                                                                    

	-- Example user application signals

	-- TRANS_NUM_BITS is the width of the index counter for
	-- number of write or read transaction..
	 constant  TRANS_NUM_BITS  : integer := clogb2(C_M_TRANSACTIONS_NUM-1);

	-- Example State machine to initialize counter, initialize write transactions, 
	 -- initialize read transactions and comparison of read data with the 
	 -- written data words.
	 type state is ( IDLE, -- This state initiates AXI4Lite transaction
	 							-- after the state machine changes state to INIT_WRITE
	 							-- when there is 0 to 1 transition on INIT_AXI_TXN
	 				INIT_READ);    -- This state initializes read transaction
	 							-- once reads are done, the state machine 
	 							-- changes state to INIT_COMPARE 
	

	 signal mst_exec_state  : state ; 

	-- AXI4LITE signals
	--read addresss
	signal axi_araddr	: std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);



	--A pulse to initiate a read transaction
	signal start_single_read	: std_logic;
	--Asserts when there is a read response error
	signal read_resp_error	: std_logic;
	--read address valid
	signal axi_arvalid	: std_logic;
	--read data acceptance
	signal axi_rready	: std_logic;

	--Asserts when a single beat read transaction is issued and remains asserted till the completion of read trasaction.
	signal read_issued	: std_logic;

	--flag that marks the completion of read trasactions. The number of read transaction is user selected by the parameter C_M_TRANSACTIONS_NUM
	signal reads_done	: std_logic;
	--The error register is asserted when any of the write response error, read response error or the data mismatch flags are asserted.
	signal error_reg	: std_logic;

	--index counter to track the number of read transaction issued
	signal read_index	: std_logic_vector(TRANS_NUM_BITS downto 0);

	signal init_txn_ff	: std_logic;
	signal init_txn_ff2	: std_logic;
	signal init_txn_edge	: std_logic;
	signal init_txn_pulse	: std_logic;
	--User Logic Signals
	signal user_raddr : std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
	signal X_addr : std_logic_vector(10-1 downto 0) := (others => '0');
	signal Y_addr : std_logic_vector(10-1 downto 0) := (others => '0');

begin
	-- I/O Connections assignments

	--Read Address (AR)
	M_AXI_ARADDR	<= std_logic_vector(unsigned(C_M_TARGET_SLAVE_BASE_ADDR) + unsigned(user_raddr));
	M_AXI_ARVALID	<= axi_arvalid;
	M_AXI_ARPROT	<= "001";
	--Read and Read Response (R)
	M_AXI_RREADY	<= axi_rready;
	--Example design I/O
	init_txn_pulse	<= ( not init_txn_ff2)  and  init_txn_ff;
	
	--User Logic

	--Generate a pulse to initiate AXI transaction.
	process(M_AXI_ACLK)                                                          
	begin                                                                             
	  if (rising_edge (M_AXI_ACLK)) then                                              
	      -- Initiates AXI transaction delay        
	    if (M_AXI_ARESETN = '0' ) then                                                
	      init_txn_ff <= '0';                                                   
	        init_txn_ff2 <= '0';                                                          
	    else                                                                                       
	      init_txn_ff <= INIT_AXI_TXN;
	        init_txn_ff2 <= init_txn_ff;                                                                     
	    end if;                                                                       
	  end if;                                                                         
	end process; 


	------------------------------
	--Read Address Channel
	------------------------------

	--start_single_read triggers a new read transaction. read_index is a counter to
	--keep track with number of read transaction issued/initiated

	  process(M_AXI_ACLK)                                                              
	  begin                                                                            
	    if (rising_edge (M_AXI_ACLK)) then                                             
	      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then                                               
	        read_index <= (others => '0');                                             
	      else                                                                         
	        if (start_single_read = '1') then                                          
	          -- Signals a new read address is                                         
	          -- available by user logic                                               
	          read_index <= std_logic_vector (unsigned(read_index) + 1);                                          
	        end if;                                                                    
	      end if;                                                                      
	    end if;                                                                        
	  end process;                                                                     
	                                                                                   
	  -- A new axi_arvalid is asserted when there is a valid read address              
	  -- available by the master. start_single_read triggers a new read                
	  -- transaction                                                                   
	  process(M_AXI_ACLK)                                                              
	  begin                                                                            
	    if (rising_edge (M_AXI_ACLK)) then                                             
	      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then                                               
	        axi_arvalid <= '0';                                                        
	      else                                                                         
	        if (start_single_read = '1') then                                          
	          --Signal a new read address command is available by user logic           
	          axi_arvalid <= '1';                                                      
	        elsif (M_AXI_ARREADY = '1' and axi_arvalid = '1') then                     
	        --RAddress accepted by interconnect/slave (issue of M_AXI_ARREADY by slave)
	          axi_arvalid <= '0';                                                      
	        end if;                                                                    
	      end if;                                                                      
	    end if;                                                                        
	  end process;                                                                     


	----------------------------------
	--Read Data (and Response) Channel
	----------------------------------

	--The Read Data channel returns the results of the read request 
	--The master will accept the read data by asserting axi_rready
	--when there is a valid read data available.
	--While not necessary per spec, it is advisable to reset READY signals in
	--case of differing reset latencies between master/slave.

	  process(M_AXI_ACLK)                                             
	  begin                                                                 
	    if (rising_edge (M_AXI_ACLK)) then                                  
	      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then                                    
	        axi_rready <= '1';                                              
	      else                                                              
	        if (M_AXI_RVALID = '1' and axi_rready = '0') then               
	         -- accept/acknowledge rdata/rresp with axi_rready by the master
	         -- when M_AXI_RVALID is asserted by slave                      
	          axi_rready <= '1';                                            
	        elsif (axi_rready = '1') then                                   
	          -- deassert after one clock cycle                             
	          axi_rready <= '0';                                            
	        end if;                                                         
	      end if;                                                           
	    end if;                                                             
	  end process;                                                          
	                                                                        
	--Flag write errors                                                     
	  read_resp_error <= (axi_rready and M_AXI_RVALID and M_AXI_RRESP(1));  


	----------------------------------
	--User Logic
	----------------------------------

	--Address/Data Stimulus

	--Address/data pairs for this example. The read and write values should
	--match.
	--Modify these as desired for different address patterns.

                                                                 
	                                                                                       
	-- Read Addresses                                                                      
	    process(M_AXI_ACLK)                                                                
	   	  begin                                                                         
	   	    if (rising_edge (M_AXI_ACLK)) then                                          
	   	      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1' ) then                                            
	   	        axi_araddr <= (others => '0');                                          
	   	      elsif (M_AXI_ARREADY = '1' and axi_arvalid = '1') then                    
	   	        -- Signals a new write address/ write data is                           
	   	        -- available by user logic
	   	        user_raddr <= std_logic_vector(to_unsigned(addr_calc(X_addr, Y_addr, H_Position, V_Position, BUFF_ADDR_BIAS),C_M_AXI_DATA_WIDTH));
				X_addr <= X_in;
				Y_addr <= Y_in;                                 
	   	      end if;                                                                   
	   	    end if;                                                                     
	   	  end process;                                                                  
		                                                                                    
                                                                 
		                                                                                    
		                                                                                                                                                    
	  --implement master command interface state machine                                           
	  MASTER_EXECUTION_PROC:process(M_AXI_ACLK)                                                         
	  begin                                                                                             
	    if (rising_edge (M_AXI_ACLK)) then                                                              
	      if (M_AXI_ARESETN = '0' ) then                                                                
	        -- reset condition                                                                          
	        -- All the signals are ed default values under reset condition                              
	        mst_exec_state  <= IDLE;                                                                                                                                
	        start_single_read  <= '0';                                                                  
	        read_issued  <= '0';                                                                                                                                           
	        ERROR <= '0'; 
	      else                                                                                          
	        -- state transition                                                                         
	        case (mst_exec_state) is                                                                    
	                                                                                                    
	          when IDLE =>                                                                      
	            -- This state is responsible to initiate
	            -- AXI transaction when init_txn_pulse is asserted 
	            if ( init_txn_pulse = '1') then    
	              mst_exec_state  <= INIT_READ;                                                        
	              ERROR <= '0';
	            else                                                                                    
	              mst_exec_state  <= IDLE;  
	              reads_done <= '0';                                                    
	            end if;                                                                                 
	                                                                                                    
                                                                           
	                                                                                                    
	          when INIT_READ =>                                                                         
	            -- This state is responsible to issue start_single_read pulse to                        
	            -- initiate a read transaction. Read transactions will be                               
	            -- issued until last_read signal is asserted.                                           
	            -- read controller                                                                                                                                     
	            mst_exec_state  <= INIT_READ;                                                         
	                                                                                                    
	            if (axi_arvalid = '0' and M_AXI_RVALID = '0'  and start_single_read = '0' and read_issued = '0') then                                 
	                start_single_read <= '1';                                                           
	                read_issued   <= '1';                                                               
	              elsif (axi_rready = '1') then                                                         
	                read_issued   <= '0';                                                               
	              else                                                                                  
	                start_single_read <= '0'; --Negate to generate a pulse 
	                reads_done <= '1';                                
	              end if;                                                                                                                                                             
	                                                                                                    
                                                                
	          when others  =>                                                                           
	              mst_exec_state  <= IDLE;  
	              reads_done <= '0';                                                    
	        end case  ;                                                                                 
	      end if;                                                                                       
	    end if;                                                                                         
	  end process;                                                                                      
                                                                             
	--------------                                                                                      
	--Read example                                                                                      
	--------------                                                                                      
	                                                                                                    
                                                                          
                                                                          
	                                                                                                    
	------------------------------/                                                                     
	--Example design error register                                                                     
	------------------------------/                                                                     
                                                                          
	                                                                                                    
	-- Register and hold any data mismatches, or read/write interface errors                            
	  process(M_AXI_ACLK)                                                                               
	  begin                                                                                             
	    if (rising_edge (M_AXI_ACLK)) then                                                              
	      if (M_AXI_ARESETN = '0' or init_txn_pulse = '1') then                                                                
	        error_reg <= '0';                                                                           
	      else                                                                                          
	        if ( read_resp_error = '1') then            
	          --Capture any error types                                                                 
	          error_reg <= '1';                                                                         
	        end if;                                                                                     
	      end if;                                                                                       
	    end if;                                                                                         
	  end process;                                                                                      

	-- Add user logic here
	process(M_AXI_ACLK)                                                                               
	  begin                                                                                             
	    if (rising_edge (M_AXI_ACLK)) then                       
	         if(reads_done = '1') then
	               B_out <= brightness(M_AXI_RDATA(8-1 downto 0), M_AXI_RDATA(16-1 downto 8), M_AXI_RDATA(24-1 downto 16));
	               Pixel_out <= M_AXI_RDATA(24-1 downto 0);
             else 
                   B_out <= (others => '0');
	               Pixel_out <= (others => '0');
	         end if;        
	         X_out <= X_addr;
             Y_out <= Y_addr;             
	    end if;                                                                                         
	  end process;
	
	TXN_DONE <= reads_done;
	-- User logic ends

end implementation;
