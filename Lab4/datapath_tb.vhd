-- Student name: Mengqi Li
-- Student ID number: 92059150

LIBRARY IEEE; 
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
use work.Glob_dcls.all;

entity datapath_tb is
end datapath_tb;

architecture datapath_tb_arch of datapath_tb is
-- component declaration
	component datapath is 
		PORT( 	clk        : in std_logic;
				op_code    : in ALU_opcode;
				wr_en      : in std_logic;
				rs, rt, rd : in REG_addr;   
				d_in       : in word;
				--Imm	   : in word;
				C	   : in std_logic_vector(4 downto 0);
				d_out      : out word;
				Zero       : out std_logic
			);
	end component;
-- component specification
	
-- signal declaration
	signal clk_s: std_logic;
	signal op_code_s : ALU_opcode;
	signal wr_en_s : std_logic;
	signal rs_s, rt_s, rd_s : REG_addr;
	signal d_in_s : word;
	signal C_s : std_logic_vector(4 downto 0) := "00011";
	signal d_out_s : word;
	signal Zero_s : std_logic;
begin
	PortMapping: datapath port map (clk => clk_s, op_code => op_code_s, wr_en => wr_en_s, rs => rs_s, rt => rt_s, rd => rd_s,
									d_in => d_in_s, C => C_s, d_out => d_out_s, Zero => Zero_s);

	clkProcess: process
        begin
            clk_s <= '0';
            wait for 5 ns;
            clk_s <= '1';
            wait for 5 ns;
		end process clkProcess;
	
	VectorProcess: process
		begin
		wr_en_s <= '1';
		wait for 10 ns;
		d_in_s <= "00000000000000000000000000000110";
		rd_s <= "00001";
		wait for 10 ns;
		rs_s <= "00001";
		wait for 10 ns;
		d_in_s <= "00000000000000000000000000000101";
		rd_s <= "00010";
		wait for 10 ns;
		rt_s <= "00010";
		wait for 10 ns;
		op_code_s <= "000";
		wait for 10 ns;		
		op_code_s <= "001";
		wait for 10 ns;
		op_code_s <= "010";
		wait for 10 ns;
		op_code_s <= "011";
		wait for 10 ns;
		op_code_s <= "100";
		wait for 10 ns;
		op_code_s <= "101";
		wait for 10 ns;
		op_code_s <= "110";
		wait for 10 ns;
		op_code_s <= "111";
		wait;
		
		
		
		
		end process VectorProcess;
	
end datapath_tb_arch;
