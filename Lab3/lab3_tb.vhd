-- Student name: Mengqi Li
-- Student ID number: 92059150

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity lab3_tb is
end lab3_tb;

architecture behavioral of lab3_tb is
-- component declaration
    component RegFile is 
        port(
                clk, wr_en                    : in STD_LOGIC;
                rd_addr_1, rd_addr_2, wr_addr : in STD_LOGIC_VECTOR(4 downto 0);
                d_in                          : in STD_LOGIC_VECTOR(31 downto 0); 
                d_out_1, d_out_2              : out STD_LOGIC_VECTOR(31 downto 0)
            );
    end component;
-- signal declaration
    signal clk_s: std_logic;
	signal wr_en_s : std_logic:= '1';
    signal d_in_s : std_logic_vector(31 downto 0);
	signal d_out_1_s, d_out_2_s : std_logic_vector(31 downto 0);
    signal rd_addr_1_s, rd_addr_2_s, wr_addr_s : std_logic_vector(4 downto 0):="00000";
begin
    PortMapping: RegFile port map (clk => clk_s, wr_en => wr_en_s,
                                   rd_addr_1 => rd_addr_1_s, rd_addr_2 => rd_addr_2_s, wr_addr => wr_addr_s,
                                   d_in => d_in_s, d_out_1 => d_out_1_s, d_out_2 => d_out_2_s);
                                   
    clkProcess: process
        begin
            clk_s <= '0';
            wait for 5 ns;
            clk_s <= '1';
            wait for 5 ns;
    end process clkProcess;
	
	VectorProcess : process
	   begin
		wr_en_s <= '1';
		wait for 10 ns;
		d_in_s <= (others => '0');
		wr_addr_s <= "00001";
		wait for 10 ns;
		rd_addr_1_s <= "00001";
		wait for 10 ns;
		d_in_s <= (others => '1');
		wr_addr_s <= "00010";
		rd_addr_2_s <= "00010";
		wait for 10 ns;
		wr_en_s <= '0';
		wait for 10 ns;
		d_in_s <= (others => '0');
		wr_addr_s <= "00011";
		wait for 10 ns;
		rd_addr_1_s <= "00011";
		wait for 10 ns;
		d_in_s <= (others => '1');
		wr_addr_s <= "00100";
		rd_addr_2_s <= "00100";
		wait;
	   end process VectorProcess;
end behavioral;