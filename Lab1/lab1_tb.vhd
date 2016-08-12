library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity lab1_tb is
end lab1_tb;

architecture lab1_tb_arch of lab1_tb is
  -- component declaration	
  -- component specification
  -- signal declaration
  COMPONENT lab1 is
	PORT (
			x : in STD_LOGIC_VECTOR(3 downto 0);
			y : out STD_LOGIC_VECTOR(2 downto 0)
		 );
	END COMPONENT;
	
	SIGNAL xs : STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL ys : STD_LOGIC_VECTOR(2 downto 0);
begin
  -- your code goes here
  PortMap: lab1 PORT MAP( x => xs, y => ys);
  TestProcess: PROCESS
	BEGIN
		xs <= "0000";
		ASSERT (ys /= "100")
			REPORT "OUTPUT Y IS INCORRECT WHEN X = 0000"
			SEVERITY NOTE;
		WAIT FOR 10 ns;
		xs <= "0001";
		ASSERT (ys /= "010")
			REPORT "OUTPUT Y IS INCORRECT WHEN X = 0001"
			SEVERITY NOTE;
		WAIT FOR 10 ns;
		xs <= "0010";
		WAIT FOR 10 ns;
		xs <= "0011";
		ASSERT (ys /= "000")
			REPORT "OUTPUT Y IS INCORRECT WHEN X = 0011"
			SEVERITY NOTE;
		WAIT FOR 10 ns;
		xs <= "0100";
		ASSERT (ys /= "010")
			REPORT "OUTPUT Y IS INCORRECT WHEN X = 0100"
			SEVERITY NOTE;
		WAIT FOR 10 ns;
		xs <= "0101";
		ASSERT (ys /= "000")
			REPORT "OUTPUT Y IS INCORRECT WHEN X = 0101"
			SEVERITY NOTE;
		WAIT FOR 10 ns;
		xs <= "0110";
		WAIT FOR 10 ns;
		xs <= "0111";
		ASSERT (ys /= "010")
			REPORT "OUTPUT Y IS INCORRECT WHEN X = 0111"
			SEVERITY NOTE;
		WAIT FOR 10 ns;
		xs <= "1000";
		WAIT FOR 10 ns;
		xs <= "1001";
		ASSERT (ys /= "000")
			REPORT "OUTPUT Y IS INCORRECT WHEN X = 1001"
			SEVERITY NOTE;
		WAIT FOR 10 ns;
		xs <= "1010";
		WAIT FOR 10 ns;
		xs <= "1011";
		ASSERT (ys /= "010")
			REPORT "OUTPUT Y IS INCORRECT WHEN X = 1011"
			SEVERITY NOTE;
		WAIT FOR 10 ns;
		xs <= "1100";
		ASSERT (ys /= "000")
			REPORT "OUTPUT Y IS INCORRECT WHEN X = 1100"
			SEVERITY NOTE;
		WAIT FOR 10 ns;
		xs <= "1101";
		ASSERT (ys /= "010")
			REPORT "OUTPUT Y IS INCORRECT WHEN X = 1101"
			SEVERITY NOTE;
		WAIT FOR 10 ns;
		xs <= "1110";
		WAIT FOR 10 ns;
		xs <= "1111";
		ASSERT (ys /= "100")
			REPORT "OUTPUT Y IS INCORRECT WHEN X = 1111"
			SEVERITY NOTE;
		WAIT;
	END PROCESS;
		
end lab1_tb_arch;
