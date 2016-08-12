-- Student name: Mengqi Li
-- Student ID number: 92059150

LIBRARY IEEE; 
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use work.Glob_dcls.all;

entity ALU is 
  PORT( op_code  : in ALU_opcode;
        in0, in1 : in word;	
        C	 : in std_logic_vector(4 downto 0);  -- shift amount	
        ALUout   : out word;
        Zero     : out std_logic
	   );
end ALU;

architecture ALU_arch of ALU is
-- signal declaration
	signal temp : std_logic_vector(32 downto 0);
	signal result : std_logic_vector(31 downto 0);
begin
	process(op_code, in0, in1, temp)
	begin
		case op_code is
			when "000" => --ADD out = in0 + in1
				temp <= std_logic_vector(unsigned("0" & in0) + unsigned(in1));
				result <= temp(31 downto 0);
				ALUout <= temp(31 downto 0);
			when "001" => --SUB out = in0 - in1
				result <= std_logic_vector(unsigned(in0) - unsigned(in1));
				ALUout <= std_logic_vector(unsigned(in0) - unsigned(in1));
			when "010" => -- SLL out = in0 << C
				result <= std_logic_vector(unsigned(in0) sll to_integer(unsigned(C)));
				ALUout <= std_logic_vector(unsigned(in0) sll to_integer(unsigned(C)));
			when "011" => -- SRL out = in0 >> C
				result <= std_logic_vector(unsigned(in0) srl to_integer(unsigned(C)));
				ALUout <= std_logic_vector(unsigned(in0) srl to_integer(unsigned(C)));
			when "100" => -- AND out = in0 & in1
				result <= in0 and in1;
				ALUout <= in0 and in1;
			when "101" => -- OR out = in0 | in1
				result <= in0 or in1;
				ALUout <= in0 or in1;
			when "110" => -- XOR out = in0 ^ in1
				result <= in0 xor in1;
				ALUout <= in0 xor in1;
			when "111" => -- NOR out = ~(in0 | in1)
				result <= in0 nor in1;
				ALUout <= in0 nor in1;
			when others => -- do nothing.
		end case;
		
		if (result = "00000000000000000000000000000000") then
			zero <='1';
		else
			zero <='0';
		end if;
		
	end process;
end ALU_arch;
