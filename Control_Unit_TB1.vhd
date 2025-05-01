LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY Control_Unit_TB1 IS
END Control_Unit_TB1;
 
ARCHITECTURE behavior OF Control_Unit_TB1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Control_Unit
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         PC : IN  std_logic_vector(3 downto 0);
			jump_branch_addr : IN  std_logic_vector(3 downto 0);
         data : IN  std_logic_vector(15 downto 0);
         address : IN  std_logic_vector(9 downto 0);
			reg_address1 : IN  std_logic_vector(3 downto 0);
			reg_address2 : IN  std_logic_vector(3 downto 0);
			ALUtoReg_address : IN  std_logic_vector(3 downto 0);
			ALU_result : OUT std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal PC : std_logic_vector(3 downto 0) := (others => '0');
	signal jump_branch_addr : std_logic_vector(3 downto 0) := (others => '0');
   signal data : std_logic_vector(15 downto 0) := (others => '0');
   signal address : std_logic_vector(9 downto 0) := (others => '0');
	signal reg_address1 : std_logic_vector(3 downto 0) := (others => '0');
	signal reg_address2 : std_logic_vector(3 downto 0) := (others => '0');
	signal ALUtoReg_address : std_logic_vector(3 downto 0) := (others => '0');
	signal ALU_result : std_logic_vector(15 downto 0) := (others => '0');

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Control_Unit PORT MAP (
          clk => clk,
          rst => rst,
          PC => PC,
			 jump_branch_addr => jump_branch_addr,
          data => data,
          address => address,
			 reg_address1 => reg_address1,
			 reg_address2 => reg_address2,
			 ALUtoReg_address => ALUtoReg_address,
			 ALU_result => ALU_result
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

      --wait for clk_period*10;

      -- insert stimulus here 
		rst <= '1';
		wait for clk_period*5;
		rst <= '0';
		
		------------------------
		--Store to MEM and Load from MEM to REG
		------------------------
		
		wait for clk_period*5;
		PC <= "0110"; -- store
		data <= x"0001";
		address <= "0000000000";
		
		wait for clk_period*5;
		
		PC <= "0110"; --store
		data <= x"0011";
		address <= "0000000001";
		
		wait for clk_period*5;
		PC <= "0101"; --load
		address <= "0000000000";
		reg_address1 <= "0000";
		
		wait for clk_period*5;
		PC <= "0101"; --load
		address <= "0000000001";
		reg_address1 <= "0001"; 
		
		wait for clk_period*5;
		PC <= "1111"; --nothing
		wait for clk_period*5;
		
		------------------------
		--ALU operations test
		------------------------
		
		PC <= "0000"; --add
		reg_address1 <= "0000";
		reg_address2 <= "0001";
		
		wait for clk_period*10;
		PC <= "0001"; --sub
		reg_address1 <= "0000";
		reg_address2 <= "0001";
		
		wait for clk_period*5;
		PC <= "0010"; --and 
		reg_address1 <= "0000";
		reg_address2 <= "0001";
		
		wait for clk_period*5;
		PC <= "0011"; --or
		reg_address1 <= "0000";
		reg_address2 <= "0001";
		
		wait for clk_period*5;
		PC <= "0100"; --xor
		reg_address1 <= "0000";
		reg_address2 <= "0001";
		
		
		wait for clk_period*5;
		PC <= "1111"; --nothing
		wait for clk_period*5;
		
		------------------------
		--ALUtoREG, branch and jump test
		------------------------ 
		
		PC <= "0111"; -- branch 
		reg_address1 <= "0001"; --register address for comparison
		reg_address2 <= "0001"; --register address for comparison
		jump_branch_addr <= "1010"; --branch to ALUtoREG 
		ALUtoReg_address <= "0010"; -- register address to save alu result
		
		wait for clk_period*5;
		PC <= "1111"; --nothing
		wait for clk_period*5;
		
		PC <= "1000"; --jump
		jump_branch_addr <= "1010"; --jump to ALUtoREG
		ALUtoReg_address <= "0011"; -- register address to save alu result
		
		
		
      wait;
   end process;

END;
