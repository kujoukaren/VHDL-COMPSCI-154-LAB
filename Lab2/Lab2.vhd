-- Student name: Mengqi Li
-- Student ID number: 92059150
-- Student name: NA
-- Student ID number: NA

library IEEE;
use IEEE.std_logic_1164.all;

entity lab2 is
   port(
          clk     : in  STD_LOGIC;
          reset_N : in  STD_LOGIC;
          count   : out STD_LOGIC_VECTOR(2 downto 0)
       );
end lab2;


architecture lab2_arch of lab2 is
    component function_f is
        port (
                current_value : in std_logic_vector(2 downto 0);
                next_value   : out std_logic_vector(2 downto 0)
             );
    end component;
    
    component D_FF is
        port (  
                 clock : in std_logic;
                 reset : in  STD_LOGIC;
                 input_value   : in std_logic_vector(2 downto 0);
                 reset_value : out std_logic_vector(2 downto 0);
                 count_value : out  std_logic_vector(2 downto 0)  
             );
    end component;
    
    signal function_F_OUT : std_logic_vector(2 downto 0);
    signal D_FF_OUT : std_logic_vector(2 downto 0);
      
begin
    m_fuction_f : function_f port map (current_value => D_FF_OUT,
                                       next_value =>function_F_OUT);
                                       
    m_D_FF : D_FF port map (clock => clk, 
                            reset => reset_N, 
                            input_value => function_F_OUT, 
                            count_value => count, 
                            reset_value => D_FF_OUT);
end lab2_arch;


library IEEE;
use IEEE.std_logic_1164.all;

entity function_f is
    port(
            current_value : in std_logic_vector(2 downto 0);
            next_value   : out std_logic_vector(2 downto 0)
        );
end function_f;

architecture function_f_arch of function_f is
begin
    next_value(2) <= (current_value(2) and current_value(1) and current_value(0)) or (not(current_value(2)) and not(current_value(0))) or (not(current_value(2)) and not(current_value(1))) ;
    next_value(1) <= (current_value(1) and not(current_value(0))) or (not(current_value(1)) and current_value(0));
    next_value(0) <= not(current_value(0));
end function_f_arch;

library IEEE;
use IEEE.std_logic_1164.all;

entity D_FF is
    port(   
            clock : in std_logic;
            reset : in  STD_LOGIC;
            input_value   : in std_logic_vector(2 downto 0);
            reset_value : out std_logic_vector(2 downto 0):="000";
            count_value : out  std_logic_vector(2 downto 0):="000"
        );
end D_FF;

architecture D_FF_arch of D_FF is
begin
    process(clock, reset, input_value)
    begin
        if reset = '0' then
            count_value <= "000";
            reset_value <= "000";   
        elsif (clock'event and clock = '1') then
            count_value <= input_value;
            reset_value <= input_value;
        end if;
    end process;
end D_FF_arch;


  