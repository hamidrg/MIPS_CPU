LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY Data_Mem_TB IS
END Data_Mem_TB;
 
ARCHITECTURE behavior OF Data_Mem_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Data_Mem
    PORT(
         clk : IN  std_logic;
         mem_address : IN  std_logic_vector(9 downto 0);
         write_mem_en : IN  std_logic;
         write_mem_data : IN  std_logic_vector(15 downto 0);
         read_mem_en : IN  std_logic;
         read_mem_data : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal mem_address : std_logic_vector(9 downto 0) := (others => '0');
   signal write_mem_en : std_logic := '0';
   signal write_mem_data : std_logic_vector(15 downto 0) := (others => '0');
   signal read_mem_en : std_logic := '0';

 	--Outputs
   signal read_mem_data : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Data_Mem PORT MAP (
          clk => clk,
          mem_address => mem_address,
          write_mem_en => write_mem_en,
          write_mem_data => write_mem_data,
          read_mem_en => read_mem_en,
          read_mem_data => read_mem_data
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
		
		--write into memory
		write_mem_en <= '1';
		wait for clk_period*10;
		mem_address <= "0000000000";
		write_mem_data <= x"0040";
		
		wait for clk_period*10;
		mem_address <= "0000000001";
		write_mem_data <= x"0001";
		
		wait for clk_period*10;
		mem_address <= "0000000010";
		write_mem_data <= x"0011";
		
		wait for clk_period*10;
		write_mem_en <= '0';
		
		-- read from memory
		wait for clk_period*10;
		read_mem_en <= '1';
		
		mem_address <= "0000000000";
		
		wait for clk_period*10;
		mem_address <= "0000000001";
		
		wait for clk_period*10;
		mem_address <= "0000000010";
		
		wait for clk_period*10;
		read_mem_en <= '0';
		
      wait;
   end process;

END;
