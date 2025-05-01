library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Control_Unit is
	generic(
		DATA_WIDTH : integer := 16;
		REG_ADDRESS_WIDTH : integer := 4;
		MEM_ADDRESS_WIDTH : integer := 10;
		INS_WIDTH : integer := 4;
		INS_MEM_ADDR_WIDTH : integer := 4
	); 
	port(
		clk : in std_logic;
		rst : in std_logic;
		
		PC : in std_logic_vector(INS_MEM_ADDR_WIDTH-1 downto 0);
		jump_branch_addr : in std_logic_vector(INS_MEM_ADDR_WIDTH-1 downto 0);
		data : in std_logic_vector(DATA_WIDTH-1 downto 0);
		address : in  std_logic_vector(MEM_ADDRESS_WIDTH-1 downto 0);
		reg_address1 : in  std_logic_vector(REG_ADDRESS_WIDTH-1 downto 0);
		reg_address2 : in  std_logic_vector(REG_ADDRESS_WIDTH-1 downto 0);
		ALUtoReg_address : in  std_logic_vector(REG_ADDRESS_WIDTH-1 downto 0);
		ALU_result : out std_logic_vector(DATA_WIDTH-1 downto 0)
	);

end Control_Unit;

architecture Behavioral of Control_Unit is
type state is (Fetch, Decode, EXE, MEM, WB);
signal present_state, next_state : state;

signal opcode : std_logic_vector(INS_WIDTH-1 downto 0);
signal write_mem_en : std_logic := '0';
signal read_mem_en : std_logic := '0';
signal reg_write_en : std_logic := '0';
signal alu_en : std_logic := '0';
signal ALUtoREG : std_logic := '0';
signal jump, branch : std_logic := '0';

--register signals
signal write_reg_dest : std_logic_vector(REG_ADDRESS_WIDTH-1 downto 0) := (others => '0');
signal write_reg_data : std_logic_vector(DATA_WIDTH-1 downto 0);
signal read_reg_add_1 : std_logic_vector(REG_ADDRESS_WIDTH-1 downto 0);
signal read_reg_add_2 : std_logic_vector(REG_ADDRESS_WIDTH-1 downto 0);
signal read_reg_data_1 : std_logic_vector(DATA_WIDTH-1 downto 0);
signal read_reg_data_2 : std_logic_vector(DATA_WIDTH-1 downto 0);

--ALU signals
signal a : std_logic_vector(DATA_WIDTH-1 downto 0);
signal b : std_logic_vector(DATA_WIDTH-1 downto 0);
signal alu_op : std_logic_vector(2 downto 0);
signal ALU_temp : std_logic_vector(DATA_WIDTH-1 downto 0);
signal ALU_to_REG_temp : std_logic_vector(DATA_WIDTH-1 downto 0);

--Memory signals
signal mem_address : std_logic_vector(MEM_ADDRESS_WIDTH-1 downto 0);
signal write_mem_data : std_logic_vector(DATA_WIDTH-1 downto 0);
signal read_mem_data : std_logic_vector(DATA_WIDTH-1 downto 0);

--Instruction Memory signals
signal instruction : std_logic_vector(INS_WIDTH-1 downto 0);

begin
	--register instance
	reg_instance1 : entity work.Reg_file
	generic map(
		DATA_WIDTH => DATA_WIDTH,
		REG_ADDRESS_WIDTH => REG_ADDRESS_WIDTH
	)
	port map(
		clk => clk,
		rst => rst,
		reg_write_en => reg_write_en,
		write_reg_dest => write_reg_dest,
		write_reg_data => write_reg_data,
		read_reg_add_1 => read_reg_add_1,
		read_reg_add_2 => read_reg_add_2,
		read_reg_data_1 => read_reg_data_1,
		read_reg_data_2 => read_reg_data_2
	);
	
	--ALU instance
	alu_instance1 : entity work.ALU
	generic map(
		DATA_WIDTH => DATA_WIDTH
	)
	port map(
		a => a,
		b => b,
		ALU_result => ALU_temp,
		ALU_operation => alu_op
	);
	
	--Memory instance
	mem_instance1 : entity work.Data_Mem
	generic map(
		DATA_WIDTH => DATA_WIDTH,
		MEM_ADDRESS_WIDTH => MEM_ADDRESS_WIDTH
	)
	port map(
		clk => clk,
		mem_address => mem_address,
		write_mem_en => write_mem_en,
		write_mem_data => write_mem_data,
		read_mem_en => read_mem_en,
		read_mem_data => read_mem_data
	);
	
	--Instruction MEM instance
	ins_mem_instance1 : entity work.Instruction_Mem
	generic map(
		INS_WIDTH => INS_WIDTH,
		INS_MEM_ADDR_WIDTH => INS_MEM_ADDR_WIDTH
	)
	port map(
		PC => PC,
		instruction => instruction
	);
	
	
	
	--transitions
	process (clk, rst)
	begin
		if rst = '1' then
			present_state <= Fetch;
		elsif rising_edge(clk) then
			present_state <= next_state;
		end if;
	end process;
	
	
	process (clk, present_state, opcode)
	variable reg1_temp, reg2_temp : std_logic_vector(DATA_WIDTH-1 downto 0);
	begin
		write_mem_data <= data; 
		mem_address <= address;
		case present_state is
			when Fetch =>
				opcode <= instruction;
				next_state <= Decode;
			when Decode =>
				case opcode is
					when "0001" => --ADD
						alu_en <= '1';
						alu_op <= "000";
						next_state <= EXE;
					when "0010" => --SUB
						alu_en <= '1';
						alu_op <= "001";
						next_state <= EXE;
					when "0011" => --AND
						alu_en <= '1';
						alu_op <= "010";
						next_state <= EXE;
					when "0100" => --OR
						alu_en <= '1';
						alu_op <= "011";
						next_state <= EXE;
					when "0101" => --XOR
						alu_en <= '1';
						alu_op <= "100";
						next_state <= EXE;
					when "0110" => --LOAD
						read_mem_en <= '1';
						reg_write_en <= '1';
						next_state <= MEM;
					when "0111" => --STORE
						write_mem_en <= '1';
						next_state <= MEM;
					when "1000" => --BRANCH
						branch <= '1';
						read_reg_add_1 <= reg_address1;
						read_reg_add_2 <= reg_address2;
						reg1_temp := read_reg_data_1;
						reg2_temp := read_reg_data_2;
						next_state <= EXE;
					when "1001" => --JUMP
						jump <= '1';
						next_state <= EXE;
					when "1010" => --ALUtoREG
						ALUtoREG <= '1';
						reg_write_en <= '1';
						next_state <= WB;
					when others =>
						write_mem_en <= '0';
						read_mem_en <= '0';
						reg_write_en <= '0';
						alu_en <= '0';
						jump <= '0';
						branch <= '0';
						ALUtoREG <= '0';
						alu_op <= "111";
						next_state <= Fetch;
				end case;
			when EXE =>
				if alu_en = '1' then --ALU operations
					read_reg_add_1 <= reg_address1;
					read_reg_add_2 <= reg_address2;
					a <= read_reg_data_1;
					b <= read_reg_data_2;
					ALU_result <= ALU_temp;
					ALU_to_REG_temp <= ALU_temp;
					alu_en <= '0';
					next_state <= Fetch;
				elsif jump = '1' then --JUMP operation
					opcode <= jump_branch_addr;
					jump <= '0';
					next_state <= Decode;
				elsif branch = '1' then --BRANCH operation
					if reg1_temp = reg2_temp then
						opcode <= jump_branch_addr;
						next_state <= Decode;
					else
						next_state <= Fetch;
					end if;
					branch <= '0';
				end if;
			when MEM =>
				if read_mem_en = '1' and reg_write_en = '1' then --LOAD operation
					mem_address <= address;
					write_reg_dest <= reg_address1;
					write_reg_data <= read_mem_data;
					read_mem_en <= '0';
					reg_write_en <= '0';
				elsif write_mem_en = '1' then --STORE operation
					mem_address <= address;
					write_mem_data <= data;
					write_mem_en <= '0';
				end if;
				next_state <= Fetch;
			when WB =>
				if ALUtoREG = '1' and reg_write_en = '1' then 
					write_reg_dest <= ALUtoReg_address;
					write_reg_data <= ALU_to_REG_temp;
					ALUtoREG <= '0';
					reg_write_en <= '0';
				end if; 
				next_state <= Fetch; 
			when others =>
				write_mem_en <= '0';
				read_mem_en <= '0';
				reg_write_en <= '0';
				alu_en <= '0';
				jump <= '0';
				branch <= '0';
				ALUtoREG <= '0';
				alu_op <= "111";
				next_state <= Fetch;
		end case;
	end process;

end Behavioral;

