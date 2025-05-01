library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Data_Mem is
	generic(
		DATA_WIDTH : integer := 16;
		MEM_ADDRESS_WIDTH : integer := 10
	);
	port(
		clk : in std_logic;
		--
		mem_address : in std_logic_vector(MEM_ADDRESS_WIDTH-1 downto 0);
		--
		write_mem_en : in std_logic;
		write_mem_data : in std_logic_vector(DATA_WIDTH-1 downto 0);
		--
		read_mem_en : in std_logic;
		read_mem_data : out std_logic_vector(DATA_WIDTH-1 downto 0)
	);
end Data_Mem;

architecture Behavioral of Data_Mem is
type mem_type is array (0 to ((2**MEM_ADDRESS_WIDTH)-1)) of std_logic_vector (DATA_WIDTH-1 downto 0);
signal Memory: mem_type := (others => (others => '0'));
begin

	process(clk)
	begin
		if rising_edge(clk) then
			if write_mem_en = '1' then
				Memory(to_integer(unsigned(mem_address))) <= write_mem_data;
			elsif read_mem_en = '1' then
				read_mem_data <= Memory(to_integer(unsigned(mem_address)));
			end if;
		end if;
	end process;


end Behavioral;

