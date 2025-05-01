library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Reg_file is
	generic(
		DATA_WIDTH : integer := 16;
		REG_ADDRESS_WIDTH : integer := 4
	);
	port(
		clk : in std_logic;
		rst : in std_logic;
		--
		reg_write_en : in std_logic;
		write_reg_dest : in std_logic_vector(REG_ADDRESS_WIDTH-1 downto 0);
		write_reg_data : in std_logic_vector(DATA_WIDTH-1 downto 0);
		--
		read_reg_add_1 : in std_logic_vector(REG_ADDRESS_WIDTH-1 downto 0);
		read_reg_add_2 : in std_logic_vector(REG_ADDRESS_WIDTH-1 downto 0);
		read_reg_data_1 : out std_logic_vector(DATA_WIDTH-1 downto 0);
		read_reg_data_2 : out std_logic_vector(DATA_WIDTH-1 downto 0)
	);
end Reg_file;

architecture Behavioral of Reg_file is
type reg_type is array (0 to ((2**REG_ADDRESS_WIDTH)-1)) of std_logic_vector (DATA_WIDTH-1 downto 0);
signal reg_array: reg_type;

begin
	process(clk, rst, read_reg_add_1, read_reg_add_2)
	begin
		if rst = '1' then
			reg_array <= (others => (others => '0'));
		elsif rising_edge(clk) then
			if reg_write_en = '1' then
			reg_array(to_integer(unsigned(write_reg_dest))) <= write_reg_data;
			end if;
		end if;
		read_reg_data_1 <= reg_array(to_integer(unsigned(read_reg_add_1)));
		read_reg_data_2 <= reg_array(to_integer(unsigned(read_reg_add_2)));
	end process;
	

end Behavioral;

