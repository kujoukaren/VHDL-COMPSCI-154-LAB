-- Student name: your name goes here
-- Student ID number: your student id # goes here

LIBRARY IEEE; 
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.std_logic_unsigned.all;
USE work.Glob_dcls.all;

entity datapath is
  
  port (
    clk        : in  std_logic;
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
	--rs_out: out reg_addr;
	--rt_out: out reg_addr;
	--rd_out: out reg_addr;
	a_out: out word;
	--RF1 : out word;
	--RF2 : out word;
	PCO : out word;
	MD : out word;
	m_out : out word;
	Mem_addr : out word;
    func_out   : out opcode;		-- send func field to controller
    shamt_out  : out reg_addr;		-- send shamt field to controller
	zero       : out std_logic);	-- send zero to controller (cond. branch)

end datapath;


architecture datapath_arch of datapath is
	component ALU is 
		port( 
				op_code  : IN ALU_opcode;
				in0, in1 : IN word;	
				out1     : OUT word;
				Zero     : OUT std_logic
			);
	end component;

	component RegFile is
		port(
				clk, wr_en, reset_N	      	  : IN STD_LOGIC;
				rd_addr_1, rd_addr_2, wr_addr : IN REG_addr;
				d_in                          : IN word; 
				d_out_1, d_out_2              : OUT word
			);
	end component;
	
	component reg is
		port(	
				clk, wr_en, reset_N	: IN STD_LOGIC;
				d_in    : IN word;
				d_out   : OUT word
			);
	end component;
	
	component mem IS
		PORT(
				MemRead	: IN std_logic;
				MemWrite	: IN std_logic;
				d_in		: IN   word;		 
				address	: IN   word;
				d_out		: OUT  word 
			);
	END component;


	signal PCValue, RFout1, RFout2, RFin, ALUout, ALUout_im, SrcA, SrcB : word;
	signal IRout, PCout, MDRout, RegAout, RegBout, ALUout_val : word;
	signal mem_address, Md_out : word;
	signal rs, rt, rd : reg_addr;
	signal jump_addr, sign_extended_immediate, shifted_extended_immediate : word;
	
-- component specification
	for all : ALU use entity work.ALU(ALU_arch)
	port map(op_code=>ALUControl, in0=>SrcA, in1=>SrcB, out1=>ALUOut, Zero=>Zero);
	for all : RegFile use entity work.RegFile(RF_arch)
	port map(clk=>clk, wr_en=>RegWrite, reset_N=>reset_N,
			 rd_addr_1=>rs, rd_addr_2=>rt, wr_addr=>rd, 
			 d_in=>RFin, d_out_1=>RFout1, d_out_2=>RFout2);
	for all : mem use entity work.mem(mem_arch)
	port map(MemRead=>MemRead, MemWrite=>MemWrite, d_in=>RegBout,
			 address=>mem_address, d_out=>Md_out);
	for all : reg use entity work.reg(reg_arch);
-- signal declaration
	

begin
	ALU_MAPPING 	: ALU port map(ALUControl, SrcA, SrcB, ALUOut, Zero);
	RegFile_MAPPING : RegFile port map(clk, RegWrite, reset_N, rs, rt, rd, RFin, RFout1, RFout2);
	MEM_MAPPING		: mem port map(MemRead, MemWrite, regBout, mem_address, Md_out);
	ALUout_MAPPING	: reg port map(clk, clk, reset_N, ALUout, ALUout_val);
	IR_MAPPING		: reg port map(clk, IRWrite, reset_N, Md_out, IRout);
	PC_MAPPING		: reg port map(clk, PCUpdate, reset_N, PCValue, PCout);
	MDR_MAPPING		: reg port map(clk, MemRead, reset_N, Md_out, MDRout);
	RegA_MAPPING	: reg port map(clk, clk, reset_N, RFout1, RegAout);
	RegB_MAPPING	: reg port map(clk, clk, reset_N, RFout2, RegBout);

	with IorD select 
		mem_address <= ALUout_val when '0',
					   PCout when others;
	with MemtoReg select
		RFin <= ALUout_val when "00",
				MDRout when "01",
				PCout when others;	
	with PCSource select
		PCValue <= ALUout_im when "00",
				   ALUout_val when "01",
				   jump_addr when "10",
				   ALUout_im when others;
	with ALUSrcA select
		SrcA <=	PCout when '0',
				RegAout when '1',
				PCout when others;

	with ALUSrcB select
		SrcB <= RegBout when "00",
				sign_extended_immediate when "01",
				shifted_extended_immediate when "10",
				(2=>'1', others=>'0') when "11",
				RegBout when others;
				
	ALUout_im <= ALUOut;
	sign_extended_immediate <= (31 downto 16 => IRout(15)) & IRout(15 downto 0);
	shifted_extended_immediate <= (31 downto 18 => IRout(15)) & IRout(15 downto 0) & "00";
	jump_addr <= PCout(31 downto 8) & IRout(5 downto 0) & "00";
	rs <= IRout(25 downto 21);
	rt <= IRout(20 downto 16);
	
	with RegDst select
		rd <= IRout(20 downto 16) when "00", -- rt
			  (others=>'1') when "01",  -- 31
			  IRout(15 downto 11) when others;  --rd

    opcode_out <= IRout(31 downto 26);
	a_out <= ALUOut;
	--RF1 <= RFout1;
	--RF2 <= RFout2;
	PCO <= PCout;
	MD <= MDRout;
	m_out <= Md_out; 
	Mem_addr <= mem_address;
	--rs_out <= IRout(25 downto 21);
	--rt_out <= IRout(20 downto 16);
	--rd_out <= IRout(15 downto 11);
	shamt_out <= IRout(10 downto 6);
	func_out <= IRout(5 downto 0);
end datapath_arch;
