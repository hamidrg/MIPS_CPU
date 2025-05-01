library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_Mem is
	generic(
		INS_WIDTH : integer := 4;
		INS_MEM_ADDR_WIDTH : integer := 4
	);
	port(
		PC : in std_logic_vector(INS_MEM_ADDR_WIDTH-1 downto 0);
		instruction : out std_logic_vector(INS_WIDTH-1 downto 0)
	);
end Instruction_Mem;

architecture Behavioral of Instruction_Mem is
type ins_mem_type is array (0 to ((2**INS_MEM_ADDR_WIDTH)-1)) of std_logic_vector (INS_WIDTH-1 downto 0);
constant instruction_mem : ins_mem_type :=(
"0001",--ADD PC = 0
"0010",--SUB PC = 1
"0011",--AND PC = 2
"0100",--OR  PC = 3
"0101",--XOR PC = 4
"0110",--LOAD PC = 5
"0111",--STORE PC = 6
"1000",--BRANCH PC = 7
"1001",--JUMP PC = 8
"1010",--ALUtoREG PC = 9
others => "0000"
);
begin
	instruction <= instruction_mem(to_integer(unsigned(PC)));
end Behavioral;

