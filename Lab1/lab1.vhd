-- Student name: MENGQI LI
-- Student ID number: 92059150

library IEEE;
use IEEE.std_logic_1164.all;

entity lab1 is
   port(
          x : in  STD_LOGIC_VECTOR(3 downto 0);
          y : out STD_LOGIC_VECTOR(2 downto 0)
       );

end lab1;

architecture lab1_arch of lab1 is
  -- signal declaration

begin
  -- your code goes here
  process(x)
  --begin
	--if (x = "0000") OR (x = "1111") then
		--y <= "100"; --'4'
	--elsif (x = "0001") OR (x = "0010") OR (x = "0100") OR (x = "1000") OR (x = "1110") OR (x = "1101") OR (x = "1011") OR (x = "0111") then
		--y <= "010"; --'2'
	--else
		--y <= "000"; --'0'
	--end if;
	begin
	y(0) <= '0';
	y(1) <= (x(3) and not(x(2)) and not(x(1)) and not(x(0))) or (not(x(3)) and x(2)  and not(x(1)) and not(x(0))) or (not(x(3)) and not(x(2)) and x(1) and not(x(0))) or (x(3) and x(2) and x(1) and not(x(0))) or (not(x(3)) and not(x(2)) and not(x(1)) and x(0)) or (x(3) and x(2) and not(x(1)) and x(0)) or (x(3) and not(x(2)) and x(1) and x(0)) or (not(x(3)) and x(2) and x(1) and x(0));
	y(2) <= (not(x(3)) and  not(x(2)) and not(x(1)) and  not(x(0))) or (x(3) and x(2) and x(1) and x(0));
  END PROCESS;
end lab1_arch;
