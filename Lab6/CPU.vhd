-- Student name: your name goes here
-- Student ID number: your student id # goes here

LIBRARY IEEE; 
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
USE work.Glob_dcls.all;

entity CPU is
  
  port (
    clk     : in std_logic;
    reset_N : in std_logic;         -- active-low signal for reset
	
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

end CPU;

architecture CPU_arch of CPU is
-- signal declaration
	signal PCUpdate, IorD, MemRead, MemWrite, ALUSrcA : STD_LOGIC;
	signal IRWrite, RegWrite, zero : STD_LOGIC;
	signal dp_opcode, dp_funct : opcode;
	signal MemtoReg, RegDst, ALUSrcB, PCSource : STD_LOGIC_VECTOR(1 downto 0);
	signal ALUControl : ALU_opcode;
	signal PC_t, AlU_t, ma_t, mdr_t : word;
	signal rs, rt, rd : reg_addr;
	signal current_state : STD_LOGIC_VECTOR(3 downto 0);
-- component declaration
	
	-- Datapath (from Lab 5)
	component datapath is
		port (	clk        : in  std_logic;
				reset_N    : in  std_logic;
				PCUpdate   : in  std_logic;     -- write_enable of PC
				IorD       : in  std_logic;     -- Address selection for memory (PC vs. store address)
				MemRead    : in  std_logic;		-- read_enable for memory
				MemWrite   : in  std_logic;		-- write_enable for memory
				IRWrite    : in  std_logic;         -- write_enable for Instruction Register
				MemtoReg   : in  std_logic_vector(1 downto 0);  -- selects ALU or MEMORY or PC to write to register file.
				RegDst     : in  std_logic_vector(1 downto 0);  -- selects rt, rd, or "31" as destination of operation
				RegWrite   : in  std_logic;         -- Register File write-enable
				ALUSrcA    : in  std_logic;         -- selects source of A port of ALU
				ALUSrcB    : in  std_logic_vector(1 downto 0);  -- selects source of B port of ALU
				ALUControl : in  ALU_opcode;	-- receives ALU opcode from the controller
				PCSource   : in  std_logic_vector(1 downto 0);  -- selects source of PC
				opcode_out : out opcode;	-- send opcode to controller
				func_out   : out opcode;		-- send func field to controller
				zero       : out std_logic;
				
				-- Additional Test Signal Output
				PC_Value : out word;
				rs_value : out reg_addr;
				rt_value : out reg_addr;
				rd_value : out reg_addr;
				AlU_out : out word;
				Memory_address : out word;
				MDR_value : out word);
	end component;
	-- Controller (you just built)
	component control is 
		port(	clk   	    : IN STD_LOGIC; 
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
				STATE       : out STD_LOGIC_VECTOR(3 downto 0));
	end component;
-- component specification
	for all : datapath use entity work.datapath(datapath_arch)
	port map(clk=>clk, reset_N=>reset_N, PCUpdate=>PCUpdate, IorD=>IorD, MemRead=>MemRead,
			 MemWrite=>MemWrite, IRWrite=>IRWrite, MemtoReg=>MemtoReg, RegDst=>RegDst,
			 RegWrite=>RegWrite, ALUSrcA=>ALUSrcA, ALUSrcB=>ALUSrcB, ALUControl=>ALUControl,
			 PCSource=>PCSource, opcode_out=>dp_opcode, func_out=>dp_funct, zero=>zero, 
			 PC_Value=>PC_t, rs_value=>rs, rt_value=>rt, rd_value=>rd,
			 AlU_out=>AlU_t, Memory_address=>ma_t,MDR_value=>mdr_t);
	
	for all : control use entity work.control(control_arch)
	port map(clk=>clk, reset_N=>reset_N, opcode_in=>dp_opcode, funct=>dp_funct, zero=>zero,
			 PCUpdate=>PCUpdate, IorD=>IorD, MemRead=>MemRead, 
			 MemWrite=>MemWrite, IRWrite=>IRWrite,
			 MemtoReg=>MemtoReg, RegDst=>RegDst, RegWrite=>RegWrite, ALUSrcA=>ALUSrcA, ALUSrcB=>ALUSrcB,
			 ALUControl=>ALUControl, PCSource=>PCSource, STATE=>current_state);
	
	begin
		Datapath_Process : datapath port map (clk, reset_N, PCUpdate, IorD, MemRead,
											  MemWrite, IRWrite, MemtoReg, RegDst,
											  RegWrite, ALUSrcA, ALUSrcB, ALUControl,
											  PCSource, dp_opcode, dp_funct, zero);
		Control_Process : control port map (clk, reset_N, dp_opcode, dp_funct, zero,
											PCUpdate, IorD, MemRead, MemWrite, IRWrite,
											MemtoReg, RegDst, RegWrite, ALUSrcA, ALUSrcB,
											ALUControl, PCSource);
		STATE_t 	   <= current_state;
		PC             <= PC_t;
		rs_value       <= rs;
		rt_value       <= rt;
		rd_value       <= rd;
		opcode_out     <= dp_opcode;
		func_out       <= dp_funct;
		zero_out       <= zero;
		ALU_Control    <= ALUControl;
		AlU_out        <= AlU_t;
		Memory_address <= ma_t;
		MDR_value      <= mdr_t; 
	
end CPU_arch;
