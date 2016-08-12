-- Student name: Mengqi Li
-- Student ID number: 92059150

LIBRARY IEEE; 
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
use work.Glob_dcls.all;

entity testbench is
end testbench;

architecture tb_arch of testbench is
-- component declaration
component datapath is
	port (
			clk        : in  std_logic;
			reset_N    : in  std_logic;
			PCUpdate   : in  std_logic;         -- write_enable of PC
			IorD       : in  std_logic;         -- Address selection for memory (PC vs. store address)
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
			opcode_out : out opcode;		-- send opcode to controller
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

end component;
	
-- signal declaration

	signal	Sclk        :  std_logic;
	signal	Sreset_N    :  std_logic;
	signal	SPCUpdate   :  std_logic;
	signal	SIorD       :  std_logic;
	signal	SMemRead    :  std_logic;
	signal	SMemWrite   :  std_logic;
	signal	SIRWrite    :  std_logic;
	signal	SMemtoReg   :  std_logic_vector(1 downto 0);
	signal	SRegDst     :  std_logic_vector(1 downto 0);
	signal	SRegWrite   :  std_logic;
	signal	SALUSrcA    :  std_logic;
	signal	SALUSrcB    :  std_logic_vector(1 downto 0);
	signal	SALUControl :  ALU_opcode;
	signal	SPCSource   :  std_logic_vector(1 downto 0);
	signal	Sopcode_out :  opcode;
	--signal  Srs_out:  reg_addr;
	--signal	Srt_out:  reg_addr;
	--signal	Srd_out:  reg_addr;signal  Sa_out, SRF1, SRF2, SPCO, SMem_addr: word;
	signal  Sa_out, SPCO, SMD, Sm_out, SMem_addr: word;
	signal	Sfunc_out   :  opcode;
	signal	Sshamt_out  :  reg_addr;
	signal	Szero       :  std_logic;	

begin
	portMapping : datapath port map(	clk => Sclk,
										reset_N  => Sreset_N,
										PCUpdate => SPCUpdate,
										IorD     => SIorD,
										MemRead  => SMemRead,
										MemWrite => SMemWrite,
										IRWrite  => SIRWrite,
										MemtoReg  => SMemtoReg,
										RegDst    => SRegDst,
										RegWrite  => SRegWrite,
										ALUSrcA   => SALUSrcA,
										ALUSrcB   => SALUSrcB,
										ALUControl => SALUControl,
										PCSource   => SPCSource,
										opcode_out => Sopcode_out,
										--rs_out => Srs_out,
										--rt_out=> Srt_out,
										--rd_out=> Srd_out,
										a_out => Sa_out,
										--RF1 => SRF1,
										--RF2 => SRF2,
										PCO => SPCO,
										MD => SMD,
										m_out => Sm_out,
										Mem_addr => SMem_addr,
										func_out   => Sfunc_out,
										shamt_out  => Sshamt_out,
										zero       => Szero);
										
	clkProcess: process
        begin
            Sclk <= '0';
            wait for CLK_PERIOD / 2;
            Sclk <= '1';
            wait for CLK_PERIOD / 2;
		end process clkProcess;
	
	VectorProcess: process
		begin
			-- Test on Instruction Fetch  addi r1, r0, 1   -- r1 = 1;
			Sreset_N <= '1';
			SRegWrite <= '0';
		  	SMemToReg <= "00";
			SIorD <= '1';
			SMemRead <= '1';
			SIRWrite <= '1';
			SPCSource <= "00";
			SPCUpdate <= '1';
			wait for CLK_PERIOD *2;
			SIRWrite <= '0';
			SIorD <= '0';
			SMemRead <= '0';
			SMemWrite <= '0';
			SPCUpdate <= '0';
			wait for CLK_PERIOD*2;
			-- Execute Instruction
			SALUControl <= "000";
			SRegWrite <= '1';
			SRegDst <= "11";
			SALUSrcA <= '1';
			SALUSrcB <= "01";
			wait for CLK_PERIOD*2;
			SRegWrite <= '1';
			SRegDst <= "00";
			wait for CLK_PERIOD*2;
			-- PC + 4
			SRegWrite <= '1';
			SRegDst <= "11";
			SALUSrcA <= '1';
			SALUSrcB <= "11";
			SPCUpdate <= '1';
			wait for CLK_PERIOD*2;
			-- fetch second Instruction add  r2, r1, r1  -- r2 = r1*2
			SRegWrite <= '0';
			SMemToReg <= "00";
			SIorD <= '1';
			SMemRead <= '1';
			SIRWrite <= '1';
			wait for CLK_PERIOD*2;
			SIRWrite <= '0';
			SIorD <= '0';
			SMemRead <= '0';
			SMemWrite <= '0';
			SPCUpdate <= '0';
			wait for CLK_PERIOD *2;
			-- Execute Instruction
			SALUControl <= "000";
			SRegWrite <= '1';
			SRegDst <= "11";
			SALUSrcA <= '1';
			SALUSrcB <= "00";
			wait for CLK_PERIOD*2;
			-- PC + 4
			SRegWrite <= '1';
			SRegDst <= "11";
			SALUSrcA <= '0';
			SALUSrcB <= "11";
			SPCUpdate <= '1';
			wait for CLK_PERIOD;
			-- fetch 3rd Instruction  lw   r3, 124(r0) -- r3 = 111....11
			SRegWrite <= '0';
			SMemToReg <= "00";
			SIorD <= '1';
			SMemRead <= '1';
			SIRWrite <= '1';
			SPCUpdate <= '0';
			wait for CLK_PERIOD*2;
			SIRWrite <= '0';
			SIorD <= '0';
			SMemRead <= '0';
			SMemWrite <= '0';
			wait for CLK_PERIOD*2;
			-- Execute Instruction
			SALUControl <= "000";
			SRegWrite <= '1';
			SRegDst <= "00";
			SALUSrcA <= '1';
			SALUSrcB <= "01";
			wait for CLK_PERIOD;
			SIorD <= '0';
			SMemRead <= '1';
			SMemToReg <= "01";
			wait for CLK_PERIOD*2;
			SMemRead <= '0';
			wait for CLK_PERIOD*2;
			-- PC + 4
			SRegWrite <= '1';
			SRegDst <= "11";
			SALUSrcA <= '0';
			SALUSrcB <= "11";
			SPCUpdate <= '1';
			wait for CLK_PERIOD;
			-- fetch 4th Instruction  and r4, r0, r0   -- this block shifts right r3 by r2 times (2 times r1)
			SRegWrite <= '0';
			SMemToReg <= "00";
			SIorD <= '1';
			SMemRead <= '1';
			SPCUpdate <= '1';
			SIRWrite <= '1';
			SPCUpdate <= '0';
			wait for CLK_PERIOD*2;
			SIRWrite <= '0';
			SIorD <= '0';
			SMemRead <= '0';
			SMemWrite <= '0';
			wait for CLK_PERIOD*2;
			-- Execute Instruction
			SALUControl <= "100";
			SRegWrite <= '1';
			SRegDst <= "11";
			SALUSrcA <= '1';
			SALUSrcB <= "00";
			wait for CLK_PERIOD*3;
			-- PC + 4
			SALUControl <= "000";
			SRegWrite <= '1';
			SRegDst <= "11";
			SALUSrcA <= '0';
			SALUSrcB <= "11";
			SPCUpdate <= '1';
			wait for CLK_PERIOD;
			-- fetch 4th Instruction  and r4, r0, r0   -- this block shifts right r3 by r2 times (2 times r1)
			SRegWrite <= '0';
			SMemToReg <= "00";
			SIorD <= '1';
			SMemRead <= '1';
			SPCUpdate <= '1';
			SIRWrite <= '1';
			SPCUpdate <= '0';
			wait for CLK_PERIOD*2;
			SIRWrite <= '0';
			SIorD <= '0';
			SMemRead <= '0';
			SMemWrite <= '0';
			-- Execute Instruction
			SALUControl <= "110";
			SRegWrite <= '1';
			SRegDst <= "11";
			SALUSrcA <= '1';
			SALUSrcB <= "00";
			wait for CLK_PERIOD*3;
			SPCUpdate <= '1';
			SPCSource <= "10";
			wait for CLK_PERIOD*2;
			SRegWrite <= '0';
			SMemToReg <= "00";
			SIorD <= '1';
			SMemRead <= '1';
			SPCUpdate <= '1';
			SIRWrite <= '1';
			SPCUpdate <= '0';
			
			--wait for CLK_PERIOD*3;
			--Sreset_N <= '0';
			--wait for CLK_PERIOD;
			--Sreset_N <= '1';
			--SIRWrite <= '1';
			--SALUControl <= "000";
			--SRegWrite <= '1';
			--SRegDst <= "11";
			--SALUSrcA <= '0';
			--SALUSrcB <= "10";
			--SPCUpdate <= '1';
			--wait for CLK_PERIOD * 2;
			-- fetch line 3
			--SRegWrite <= '0';
			--SMemToReg <= "00";
			--SIorD <= '1';
			--SMemRead <= '1';
			--SPCUpdate <= '1';
			--SIRWrite <= '1';
			--SPCUpdate <= '0';
			--wait for CLK_PERIOD*2;
			--SIRWrite <= '0';
			--SIorD <= '0';
			--SMemRead <= '0';
			--SMemWrite <= '0';
			wait for CLK_PERIOD*2;
			
			wait;
	end process VectorProcess;
end tb_arch;