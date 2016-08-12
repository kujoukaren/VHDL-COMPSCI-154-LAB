-- Student name: Mengqi Li
-- Student ID number: 92059150

LIBRARY IEEE; 
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
USE work.Glob_dcls.all;

-- Among the ports below of the datapath
-- rs, rt, rd correspond to  rd_addr_1, rd_addr_2, wr_addr of the Register file
-- d_in corresponds to d_in of the Register file
-- d_out is output from the register ALUout  

entity datapath is 
  PORT( clk        : in std_logic;
        op_code    : in ALU_opcode;
        wr_en      : in std_logic;
        rs, rt, rd : in REG_addr;   
        d_in       : in word;
        --Imm	   : in word;
		C	   : in std_logic_vector(4 downto 0);
        d_out      : out word;
        Zero       : out std_logic
  );
end datapath;

architecture datapath_arch of datapath is
-- component declaration
	component RegFile is 
		port(
				clk, wr_en                    : in STD_LOGIC;
				rd_addr_1, rd_addr_2, wr_addr : in REG_addr;
				d_in                          : in word; 
				d_out_1, d_out_2              : out word
			);
	end component;
	
	component ALU is 
		PORT( op_code  : in ALU_opcode;
			  in0, in1 : in word;	
			  C	 : in std_logic_vector(4 downto 0);  -- shift amount	
			  ALUout   : out word;
			  Zero     : out std_logic
			);
	end component;
-- signal declaration
	signal d_out_A, d_out_B : word;
begin
	Reg_file_Part : RegFile port map (clk => clk, wr_en => wr_en, rd_addr_1 => rs, rd_addr_2 => rt, wr_addr => rd, d_in => d_in, d_out_1 => d_out_A, d_out_2 => d_out_B);
	ALU_Part : ALU port map (op_code => op_code, in0 => d_out_A, in1 => d_out_B, C => C, ALUout => d_out, Zero => Zero);
end datapath_arch;
