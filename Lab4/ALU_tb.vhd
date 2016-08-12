-- Student name: Mengqi Li
-- Student ID number: 92059150

LIBRARY IEEE; 
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
use work.Glob_dcls.all;

entity ALU_tb is
end ALU_tb;

architecture ALU_tb_arch of ALU_tb is
-- component declaration
	component ALU is 
		PORT( op_code  : in ALU_opcode;
			  in0, in1 : in word;	
			  C	 : in std_logic_vector(4 downto 0);  -- shift amount	
			  ALUout   : out word;
			  Zero     : out std_logic
			);
	end component;
	
-- signal declaration
	signal op_code_s : ALU_opcode:="000";
	signal in0_s : word:="00000000000000000000000000000110";
	signal in1_s : word:="00000000000000000000000000000101";
	signal C_s : std_logic_vector(4 downto 0):="00011";
	signal ALUout_s : word;
	signal Zero_s : std_logic:='1';
begin
	portMapping : ALU port map(op_code => op_code_s, in0 => in0_s, in1 => in1_s,
							   C => C_s, ALUout => ALUout_s, Zero => Zero_s);
	process
	begin
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
	end process;
end ALU_tb_arch;

