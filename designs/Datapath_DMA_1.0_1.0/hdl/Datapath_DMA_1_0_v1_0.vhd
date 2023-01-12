library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Datapath_DMA_1_0_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 6;

		-- Parameters of Axi Master Bus Interface M00_AXI
		C_M00_AXI_START_DATA_VALUE	: std_logic_vector	:= x"AA000000";
		C_M00_AXI_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000000";
		C_M00_AXI_ADDR_WIDTH	: integer	:= 32;
		C_M00_AXI_DATA_WIDTH	: integer	:= 32;
		C_M00_AXI_TRANSACTIONS_NUM	: integer	:= 4
	);
	port (
		-- Users to add ports here
		Rout, Gout, Bout, Iout: out std_logic_vector (8-1 downto 0);
        Xout, Yout: out std_logic_vector (10-1 downto 0);
        ctr_Scanner_External_Ramp_in: in std_logic_vector(16-1 downto 0);--External Ramp in
        clk_w_11M52, clk_11M52_lckd: in std_logic;         -- clk for frame processor
        clk_sync: out std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic;

		-- Ports of Axi Master Bus Interface M00_AXI
		-- m00_axi_init_axi_txn	: in std_logic;
		m00_axi_error	: out std_logic;
		m00_axi_txn_done	: out std_logic;
		m00_axi_aclk	: in std_logic;
		m00_axi_aresetn	: in std_logic;
		m00_axi_awaddr	: out std_logic_vector(C_M00_AXI_ADDR_WIDTH-1 downto 0);
		m00_axi_awprot	: out std_logic_vector(2 downto 0);
		m00_axi_awvalid	: out std_logic;
		m00_axi_awready	: in std_logic;
		m00_axi_wdata	: out std_logic_vector(C_M00_AXI_DATA_WIDTH-1 downto 0);
		m00_axi_wstrb	: out std_logic_vector(C_M00_AXI_DATA_WIDTH/8-1 downto 0);
		m00_axi_wvalid	: out std_logic;
		m00_axi_wready	: in std_logic;
		m00_axi_bresp	: in std_logic_vector(1 downto 0);
		m00_axi_bvalid	: in std_logic;
		m00_axi_bready	: out std_logic;
		m00_axi_araddr	: out std_logic_vector(C_M00_AXI_ADDR_WIDTH-1 downto 0);
		m00_axi_arprot	: out std_logic_vector(2 downto 0);
		m00_axi_arvalid	: out std_logic;
		m00_axi_arready	: in std_logic;
		m00_axi_rdata	: in std_logic_vector(C_M00_AXI_DATA_WIDTH-1 downto 0);
		m00_axi_rresp	: in std_logic_vector(1 downto 0);
		m00_axi_rvalid	: in std_logic;
		m00_axi_rready	: out std_logic
	);
end Datapath_DMA_1_0_v1_0;

architecture arch_imp of Datapath_DMA_1_0_v1_0 is
	-- User defined wires
	signal Rout_i, Gout_i, Bout_i, Iout_i: std_logic_vector(8-1 downto 0);
	signal Xout_i, Yout_i, Xsel_i, Ysel_i, X_sync, Y_sync: std_logic_vector(10-1 downto 0);
	signal H_Position, V_Position: signed(10-1 downto 0); 
	signal FSM_STATUS: std_logic_vector(4-1 downto 0);
	signal PIXEL_DATA: std_logic_vector(24-1 downto 0);
	signal m00_axi_init_axi_txn, m00_axi_txn_done_buff, m00_axi_error_buff: std_logic;
	signal addr_bias: std_logic_vector(32-1 downto 0);
	
	-- component declaration
	component Datapath_DMA_1_0_v1_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 6
		);
		port (
		Rout, Gout, Bout, Iout: out std_logic_vector(8-1  downto 0);
		Xout, Yout, Xsel, Ysel: out std_logic_vector (10-1 downto 0);
		PIXEL_IN: in std_logic_vector(24-1 downto 0);
		Xsync, Ysync: in std_logic_vector (10-1 downto 0);
		ctr_Scanner_External_Ramp_in: in std_logic_vector(16-1 downto 0);--External Ramp in
		clk_w_11M52, clk_11M52_lckd: in std_logic;         -- clk for frame processor
		clk_sync: out std_logic;
		H_Position, V_Position: out signed(10-1 downto 0); 
		addr_bias : out std_logic_vector(32-1 downto 0);
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component Datapath_DMA_1_0_v1_0_S00_AXI;

	component Datapath_DMA_1_0_v1_0_M00_AXI is
		generic (
		C_M_START_DATA_VALUE	: std_logic_vector	:= x"AA000000";
		C_M_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000000";
		C_M_AXI_ADDR_WIDTH	: integer	:= 32;
		C_M_AXI_DATA_WIDTH	: integer	:= 32;
		C_M_TRANSACTIONS_NUM	: integer	:= 4
		);
		port (
		X_in, Y_in: in std_logic_vector(10-1 downto 0);
		BUFF_ADDR_BIAS: in std_logic_vector(32-1 downto 0);
		H_Position, V_Position: in signed(10-1 downto 0); 
		Pixel_out: out std_logic_vector(24-1  downto 0);
		X_out, Y_out: out std_logic_vector(10-1 downto 0);
		B_out : out std_logic_vector(6-1 downto 0);
		
		INIT_AXI_TXN	: in std_logic;
		ERROR	: out std_logic;
		TXN_DONE	: out std_logic;
		M_AXI_ACLK	: in std_logic;
		M_AXI_ARESETN	: in std_logic;
		M_AXI_AWADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		M_AXI_AWPROT	: out std_logic_vector(2 downto 0);
		M_AXI_AWVALID	: out std_logic;
		M_AXI_AWREADY	: in std_logic;
		M_AXI_WDATA	: out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		M_AXI_WSTRB	: out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
		M_AXI_WVALID	: out std_logic;
		M_AXI_WREADY	: in std_logic;
		M_AXI_BRESP	: in std_logic_vector(1 downto 0);
		M_AXI_BVALID	: in std_logic;
		M_AXI_BREADY	: out std_logic;
		M_AXI_ARADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		M_AXI_ARPROT	: out std_logic_vector(2 downto 0);
		M_AXI_ARVALID	: out std_logic;
		M_AXI_ARREADY	: in std_logic;
		M_AXI_RDATA	: in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		M_AXI_RRESP	: in std_logic_vector(1 downto 0);
		M_AXI_RVALID	: in std_logic;
		M_AXI_RREADY	: out std_logic
		);
	end component Datapath_DMA_1_0_v1_0_M00_AXI;

begin

-- Instantiation of Axi Bus Interface S00_AXI
Datapath_DMA_1_0_v1_0_S00_AXI_inst : Datapath_DMA_1_0_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
		Rout => Rout,
	    Gout => Gout, 
	    Bout => Bout, 
	    Iout => Iout,
	    Xout => Xout,
	    Yout => Yout, 
	    Xsel => Xsel_i,
	    Ysel => Ysel_i, 
	    Xsync => X_sync,
	    Ysync => Y_sync,
		PIXEL_IN => PIXEL_DATA,
        ctr_Scanner_External_Ramp_in => ctr_Scanner_External_Ramp_in,
        clk_w_11M52 => clk_w_11M52,
        clk_11M52_lckd => clk_11M52_lckd,        -- clk for frame processor
		clk_sync => clk_sync,
		H_Position => H_Position,
		V_Position => V_Position,
		addr_bias =>addr_bias,
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

-- Instantiation of Axi Bus Interface M00_AXI
Datapath_DMA_1_0_v1_0_M00_AXI_inst : Datapath_DMA_1_0_v1_0_M00_AXI
	generic map (
		C_M_START_DATA_VALUE	=> C_M00_AXI_START_DATA_VALUE,
		C_M_TARGET_SLAVE_BASE_ADDR	=> C_M00_AXI_TARGET_SLAVE_BASE_ADDR,
		C_M_AXI_ADDR_WIDTH	=> C_M00_AXI_ADDR_WIDTH,
		C_M_AXI_DATA_WIDTH	=> C_M00_AXI_DATA_WIDTH,
		C_M_TRANSACTIONS_NUM	=> C_M00_AXI_TRANSACTIONS_NUM
	)
	port map (
		X_in => Xsel_i,
		Y_in => Ysel_i,
		BUFF_ADDR_BIAS => addr_bias,
		H_Position => H_Position,
		V_Position => V_Position,
		X_out => X_sync,
		Y_out => Y_sync,
		Pixel_out => PIXEL_DATA,
		INIT_AXI_TXN	=> m00_axi_init_axi_txn,
		ERROR	=> m00_axi_error_buff,
		TXN_DONE	=> m00_axi_txn_done_buff,
		M_AXI_ACLK	=> m00_axi_aclk,
		M_AXI_ARESETN	=> m00_axi_aresetn,
		M_AXI_AWADDR	=> m00_axi_awaddr,
		M_AXI_AWPROT	=> m00_axi_awprot,
		M_AXI_AWVALID	=> m00_axi_awvalid,
		M_AXI_AWREADY	=> m00_axi_awready,
		M_AXI_WDATA	=> m00_axi_wdata,
		M_AXI_WSTRB	=> m00_axi_wstrb,
		M_AXI_WVALID	=> m00_axi_wvalid,
		M_AXI_WREADY	=> m00_axi_wready,
		M_AXI_BRESP	=> m00_axi_bresp,
		M_AXI_BVALID	=> m00_axi_bvalid,
		M_AXI_BREADY	=> m00_axi_bready,
		M_AXI_ARADDR	=> m00_axi_araddr,
		M_AXI_ARPROT	=> m00_axi_arprot,
		M_AXI_ARVALID	=> m00_axi_arvalid,
		M_AXI_ARREADY	=> m00_axi_arready,
		M_AXI_RDATA	=> m00_axi_rdata,
		M_AXI_RRESP	=> m00_axi_rresp,
		M_AXI_RVALID	=> m00_axi_rvalid,
		M_AXI_RREADY	=> m00_axi_rready
	);
	m00_axi_txn_done <= m00_axi_txn_done_buff;
    m00_axi_error <= m00_axi_error_buff;
    
	-- Add user logic here
	-- FSM for automatic reading process
	PROC_INIT: process(m00_axi_aresetn, m00_axi_aclk)
	begin
	   if(m00_axi_aresetn = '0') then
	       m00_axi_init_axi_txn <= '0';
	       FSM_STATUS <= "0001";
	   else
           if(rising_edge(m00_axi_aclk)) then
                case FSM_STATUS is
                    when "0001" => -- Beginning to issue a read request
                        if m00_axi_txn_done_buff = '0' then
                            m00_axi_init_axi_txn <= not m00_axi_init_axi_txn;
                            FSM_STATUS <= "0010";
                        end if;
                    when "0010" => -- Waiting for result
                        if m00_axi_txn_done_buff = '1' or m00_axi_error_buff = '1' then
                            FSM_STATUS <= "0001";
                        end if;
                    when others => -- Exceptions
                        m00_axi_init_axi_txn <= '0';
	                    FSM_STATUS <= "0001";
                end case;
           end if;
       end if;

        -- Always reading
        
	end process;
	
	-- User logic ends

end arch_imp;
