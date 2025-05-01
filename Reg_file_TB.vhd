LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY Reg_file_TB IS
END Reg_file_TB;
 
ARCHITECTURE behavior OF Reg_file_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Reg_file
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         reg_write_en : IN  std_logic;
         write_reg_dest : IN  std_logic_vector(3 downto 0);
         write_reg_data : IN  std_logic_vector(15 downto 0);
         read_reg_add_1 : IN  std_logic_vector(3 downto 0);
         read_reg_add_2 : IN  std_logic_vector(3 downto 0);
         read_reg_data_1 : OUT  std_logic_vector(15 downto 0);
         read_reg_data_2 : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal reg_write_en : std_logic := '0';
   signal write_reg_dest : std_logic_vector(3 downto 0) := (others => '0');
   signal write_reg_data : std_logic_vector(15 downto 0) := (others => '0');
   signal read_reg_add_1 : std_logic_vector(3 downto 0) := (others => '0');
   signal read_reg_add_2 : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal read_reg_data_1 : std_logic_vector(15 downto 0);
   signal read_reg_data_2 : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Reg_file PORT MAP (
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

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		rst <= '1';
		wait for clk_period*10;
		rst <= '0';
		
		reg_write_en <= '1';
		wait for clk_period*10;
		write_reg_dest <= "0000";
		write_reg_data <= x"0009";
		wait for clk_period*10;
		write_reg_dest <= "0001";
		write_reg_data <= x"0010";
		wait for clk_period*10;
		write_reg_dest <= "0010";
		write_reg_data <= x"0011";
		wait for clk_period*10;
		reg_write_en <= '0';
		
		wait for clk_period*10;
		read_reg_add_1 <= "0001";
		read_reg_add_2 <= "0010";
		
      wait;
   end process;

END;
