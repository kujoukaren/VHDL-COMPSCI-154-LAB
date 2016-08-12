-- Student name: Mengqi Li
-- Student ID number: 92059150
-- Student name: NA
-- Student ID number: NA

library IEEE;
use IEEE.std_logic_1164.all;

entity lab2_tb is
end lab2_tb;

architecture lab2_tb_arch of lab2_tb is
-- component declaration	
-- component specification
-- signal declaration
    component lab2 is
        port(
                clk     : in  STD_LOGIC;
                reset_N : in  STD_LOGIC;
                count   : out STD_LOGIC_VECTOR(2 downto 0)
            );
    end component;
    
    signal clk_s, reset_N_s : std_logic;
    signal count_s : std_logic_vector(2 downto 0);
begin
-- your code goes here
    CompToTest : lab2 port map (clk => clk_s, reset_N => reset_N_s, count => count_s);
    
    clkProcess: process
        begin
            clk_s <= '0';
            wait for 5 ns;
            clk_s <= '1';
            wait for 5 ns;
    end process clkProcess;
    
    VectorProcess: process
        begin
            -- when reset is upper signal count 10 clock cycles
            reset_N_s <= '1';
            WAIT for 100 ns;
            -- when reset is low signal count 2 clock cycles
            reset_N_s <= '0';
            Wait for 20 ns;
            -- when reset is upper signal count 10 clock cycles again
            reset_N_s <= '1';
            WAIT for 100 ns;
            reset_N_s <= '0';
            WAIT for 80 ns;
            reset_N_s <= '1';
            WAIT;
    end process VectorProcess;
end lab2_tb_arch;