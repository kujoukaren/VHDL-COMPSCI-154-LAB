-- Student name: your name goes here
-- Student ID number: your student id # goes here

LIBRARY IEEE; 
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
USE work.Glob_dcls.all;

entity control is 
   port(
        clk   	    : IN STD_LOGIC; 
        reset_N	    : IN STD_LOGIC; 
        
        opcode_in      : IN opcode;     -- declare type for the 6 most significant bits of IR
        funct       : IN opcode;     -- declare type for the 6 least significant bits of IR 
     	zero        : IN STD_LOGIC;
        
     	PCUpdate    : OUT STD_LOGIC; -- this signal controls whether PC is updated or not
     	IorD        : OUT STD_LOGIC;
     	MemRead     : OUT STD_LOGIC;
     	MemWrite    : OUT STD_LOGIC;

     	IRWrite     : OUT STD_LOGIC;
     	MemtoReg    : OUT STD_LOGIC_VECTOR (1 downto 0); -- the extra bit is for JAL
     	RegDst      : OUT STD_LOGIC_VECTOR (1 downto 0); -- the extra bit is for JAL
     	RegWrite    : OUT STD_LOGIC;
     	ALUSrcA     : OUT STD_LOGIC;
     	ALUSrcB     : OUT STD_LOGIC_VECTOR (1 downto 0);
     	ALUcontrol  : OUT ALU_opcode;
     	PCSource    : OUT STD_LOGIC_VECTOR (1 downto 0);
		STATE  : out STD_LOGIC_VECTOR(3 downto 0)
	);
end control;

architecture control_arch of control is
-- component declaration
	
-- component specification

-- signal declaration
	signal current_state, next_state, next_state_decode, next_state_mem : STD_LOGIC_VECTOR(3 downto 0):= "0000";
	signal ALU_immediate_control, ALU_R_type_control : ALU_opcode;
	signal ALUSrcBWhenShift : STD_LOGIC_VECTOR(1 downto 0);
	
	begin 
		-- ALU Source selection
		with current_state select
			ALUSrcA <= '0' when "0000",
					   '0' when "0001",
					   '1' when "0010",
					   '1' when "0100",
					   '1' when "0101",
					   '1' when "0111",
					   '1' when others;
		
		with current_state select
			ALUSrcB <= "11" when "0000",
					   "10" when "0001",
					   "01" when "0010",
					   "01" when "0111",
					   "00" when others;
					   
		-- ALU control
		with opcode_in select
			ALU_immediate_control <= "000" when "001000",
									 "100" when "001100",
									 "101" when others;
		
		with funct select
			ALU_R_type_control <= "000" when "100000",
								  "001" when "100010",
								  "100" when "100100",
								  "101" when "100101",
								  "010" when "000000",
								  "011" when "000010",
								  ALU_immediate_control when others;
		
		with current_state select
			ALUControl <= "000" when "0000",
						  "000" when "0001",
						  "000" when "0010",
						  "001" when "0100",
						  "001" when "0101",
						  ALU_R_type_control when others;
		
		-- State Calculation
		with current_state select
				next_state <= "0001" when "0000",          -- Go Decode
					next_state_decode when "0001",         
					next_state_mem when "0010",            
					"1010" when "0011",                    -- Go Return Fetch
					"1011" when "0111",		               -- Go Return Fetch
					"1100" when "1000",                    -- Go Load 2nd stage
					"0000" when others;	                   -- Go Fetch
										
		with opcode_in select
			next_state_decode <= "0010" when "100011",     -- Go Memory address Computation
								 "0010" when "101011",     -- Go Memory address Computation
								 "0011" when "000000",     -- Go Execute with Non-immediate
								 "0100" when "000101",     -- Go Execute BNE
								 "0101" when "000100",     -- Go Execute BEQ
								 "0110" when "000010",     -- Go Jump
								 "0111" when others;       -- Go Execute with immediate

		with opcode_in select
			next_state_mem <= "1000" when "100011",        -- Go Load 1st stage
							  "1001" when others;          -- Go Store
							  
		
		-- Generate signal
		process
		begin
			STATE <= current_state;
			-- Fetch
			if (current_state = "0000") then
				RegWrite <= '0';
				MemtoReg <= "00";
				IorD <= '1';
				MemRead <= '1' after 1 ns;
				IRWrite <= '1';
				PCSource <= "00";
				PCUpdate <= '1';
				
			-- Decode
			elsif (current_state = "0001") then
				IRWrite <= '0';
				IorD <= '0';
				MemRead <= '0';
				MemWrite <= '0';
				PCUpdate <= '0';

			-- Execute with Non-immediate
			elsif (current_state = "0011") then
				RegDst <= "11";
				
			-- Execute with immediate
			elsif (current_state = "0111") then
				RegDst <= "00";
			
			-- Load 1st stage
			elsif (current_state = "1000") then
				MemRead <= '1' after 1 ns;
				RegDst <= "00";
			
			-- Load 2nd stage
			elsif (current_state = "1100") then
				MemtoReg <= "01";
				PCUpdate <= '0';
				MemRead <= '0';
				IorD <= '1';
				RegWrite <= '1';
			
			-- Store
			elsif (current_state = "1001") then
				IorD <= '0' after 2 ns, '1' after 6 ns;
				MemWrite <= '1' after 4 ns, '0' after 6 ns;
			
			-- Execute BNE
			elsif (current_state = "0100") then
				-- wait for zero to stabilize
				wait for 2 ns;
				
				if (zero = '0') then
					PCSource <= "01";
					PCUpdate <= '1';
				else
					IorD <= '1';
				end if;
			
			-- Execute BEQ
			elsif (current_state = "0101") then
				-- wait for zero to stabilize
				wait for 2 ns;
				
				if (zero = '1') then
					PCSource <= "01";
					PCUpdate <= '1';
				else
					IorD <= '1';
				end if;
			
			-- Jump
			elsif (current_state = "0110") then
				PCSource <= "10";
				PCUpdate <= '1';
			
			-- Return Fetch
			elsif (current_state = "1010" OR current_state = "1011") then
				PCUpdate <= '0';
				MemRead <= '0';
				IorD <= '1';
				RegWrite <= '1';
			else
				null;
			end if;
			
			-- wait for state changed
			wait until current_state'event;
			
		end process;
		
		-- Update state
		process(clk)
		begin
			if(clk'event AND clk = '1') then
				current_state <= next_state;
			end if;
		end process;
		
		

end control_arch;



