-- Student name: Mengqi Li
-- Student ID number: 92059150

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.Glob_dcls.all;

entity RegFile is 
  port(
        clk, wr_en                    : in STD_LOGIC;
        rd_addr_1, rd_addr_2, wr_addr : in REG_addr;
        d_in                          : in word; 
        d_out_1, d_out_2              : out word
  );
end RegFile;

architecture RF_arch of RegFile is
-- signal declaration
    type registerFile is array(0 to 31) of std_logic_vector(31 downto 0);
    signal registers : registerFile;
    
    begin
        process (clk)
        begin
            if rising_edge(clk) then
                if wr_addr /= "00000" then
                    d_out_1 <= registers(to_integer(unsigned(rd_addr_1)));
                    d_out_2 <= registers(to_integer(unsigned(rd_addr_2)));
                
                    if wr_en = '1' then
                        registers(to_integer(unsigned(wr_addr))) <= d_in;
                    
                        if rd_addr_1 = wr_addr then
                            d_out_1 <= d_in;
                        end if;
                    
                        if rd_addr_2 = wr_addr then
                            d_out_2 <= d_in;
                        end if;
                    end if;
                end if;
            end if;
       end process;
end RF_arch;
