-- Student name: Mengqi Li
-- Student ID number: 92059150

LIBRARY IEEE; 
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
package Glob_dcls is
    constant word_size : integer := 32;
    subtype word is std_logic_vector(word_size-1 downto 0);
    subtype ALU_opcode is std_logic_vector(2 downto 0);
    subtype REG_addr is std_logic_vector(4 downto 0);
end Glob_dcls;
    
