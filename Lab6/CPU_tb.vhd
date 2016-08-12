-- Student name: your name goes here
-- Student ID number: your student id # goes here

LIBRARY IEEE; 
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
USE work.Glob_dcls.all;

entity CPU_tb is
end CPU_tb;

architecture CPU_test of CPU_tb is
-- signal declaration
	-- You'll need clock and reset.
	signal clk 			  : STD_LOGIC := '0';
	signal reset_N 		  : STD_LOGIC;
	signal PC_Value		  : word;
	signal rs	 		  : reg_addr;
	signal rt 			  : reg_addr;
	signal rd 			  : reg_addr;
	signal opcode_out 	  : opcode;
	signal func   		  : opcode;
	signal zero       	  : std_logic;
	signal ALU_Control 	  : ALU_opcode;
	signal ALU_out 		  : word;
	signal Memory_address : word;
	signal MDR 		   	  : word;
	signal STATE 		  : STD_LOGIC_VECTOR(3 downto 0);
-- component declaration
	-- CPU (you just built)
	component CPU is
		port (	clk     : in std_logic;
				reset_N : in std_logic;      -- active-low signal for reset
				-- Additional Test Signal Output
				STATE_t : out STD_LOGIC_VECTOR(3 downto 0);
				PC: out word;
				rs_value : out reg_addr;
				rt_value : out reg_addr;
				rd_value : out reg_addr;
				opcode_out : out opcode;
				func_out   : out opcode;
				zero_out       : out std_logic;
				ALU_Control : out  ALU_opcode;
				AlU_out : out word;
				Memory_address : out word;
				MDR_value : out word);
	end component;
	
-- component specification
	for all : CPU use entity work.CPU(CPU_arch)
	port map(clk=>clk, reset_N=>reset_N,STATE_t=>STATE,
			 PC=>PC_Value, rs_value=>rs, rt_value=>rt, rd_value=>rd,
			 opcode_out=>opcode_out, func_out=>func, zero_out=>zero,
			 ALU_Control=>ALU_Control, AlU_out=>ALU_out, Memory_address=>Memory_address,
			 MDR_value=>MDR);

begin
	CPU_process : CPU port map(clk=>clk, reset_N=>reset_N,STATE_t=>STATE,
							   PC=>PC_Value, rs_value=>rs, rt_value=>rt, rd_value=>rd,
							   opcode_out=>opcode_out, func_out=>func, zero_out=>zero,
							   ALU_Control=>ALU_Control, AlU_out=>ALU_out, Memory_address=>Memory_address,
							   MDR_value=>MDR);
	
	clkProcess: process
        begin
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
		end process clkProcess;
	
	VectorProcess: process
	begin
			
		reset_N <= '0';
		wait for CLK_PERIOD * 3.5;
		reset_N <= '1';
		wait;
	end process VectorProcess;
end CPU_test;
