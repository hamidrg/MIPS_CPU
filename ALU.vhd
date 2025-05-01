library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity ALU is
	generic (
		DATA_WIDTH : integer := 16
	);
	port(
		a : in std_logic_vector(DATA_WIDTH-1 downto 0);
		b : in std_logic_vector(DATA_WIDTH-1 downto 0);
		ALU_result : out std_logic_vector(DATA_WIDTH-1 downto 0);
		-- 000: Add, 001: Sub, 010: And, 011: Or, 100: Xor
		ALU_operation : in std_logic_vector (2 downto 0)
	);
end ALU;

architecture Behavioral of ALU is

begin
	process (a, b, ALU_operation)
		begin
			case ALU_operation is
				when "000" => ALU_result <= std_logic_vector(unsigned(a) + unsigned(b));
				when "001" => ALU_result <= std_logic_vector(unsigned(a) - unsigned(b));
				when "010" => ALU_result <= a and b;
				when "011" => ALU_result <= a or b;
				when "100" => ALU_result <= a xor b;
				when others => ALU_result <= (others => '0');
			end case;
		end process;
end Behavioral;

