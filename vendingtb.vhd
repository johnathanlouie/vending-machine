LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 

 
ENTITY tb_vending IS
END tb_vending;
 
ARCHITECTURE behavior OF tb_vending IS
 
-- Component Declaration for the Unit Under Test (UUT)
 
COMPONENT vending
PORT(
      clk : in bit;
      in_dime: in bit;
      in_nickel: in bit;
      in_quarter: in bit;
      in_half_dollar: in bit;
      in_dollar: in bit;
      rest: in bit;
			num_item: in integer;
			return_dime: out integer;
			return_nickel: out integer;
			return_quarter: out integer;
			return_half_dollar: out integer;
			return_dollar: out integer;
			return_deposit: out integer;
			release_num_gums: out integer;
			display_num_gums: out integer;
			message: out integer;
			display_total_deposit: out integer;
			testc: out integer;
			state: out integer
);
END COMPONENT;
 
--Inputs
signal clk : bit:='0';
signal in_dime: bit:='0';
signal in_nickel: bit:='0';
signal in_quarter: bit:='0';
signal in_half_dollar: bit:='0';
signal in_dollar: bit:='0';
signal rest: bit:='0';
signal num_item: integer:=0;
 
--Outputs
signal return_dime : integer:=0;
signal return_nickel : integer:=0;
signal return_quarter : integer:=0;
signal return_half_dollar : integer:=0;
signal return_dollar : integer:=0;
signal return_deposit : integer:=0;
signal release_num_gums : integer:=0;
signal display_num_gums : integer:=0;
signal message : integer:=0;
signal display_total_deposit : integer:=0; 
signal testc: integer:=0;
signal state: integer:=0;
-- Clock period definitions
constant clock_period : time := 100 ps;
 
BEGIN
 
-- Instantiate the Unit Under Test (UUT)
uut: vending PORT MAP (
      clk => clk,
      in_dime => in_dime,
      in_nickel => in_nickel,
      in_quarter => in_quarter,
      in_half_dollar => in_half_dollar,
      in_dollar => in_dollar,
      rest => rest,
			num_item => num_item,
			return_dime => return_dime,
			return_nickel => return_nickel,
			return_quarter => return_quarter,
			return_half_dollar => return_half_dollar,
			return_dollar  => return_dollar,
			return_deposit => return_deposit,
			release_num_gums => release_num_gums,
			display_num_gums => display_num_gums,
			message => message,
			display_total_deposit => display_total_deposit,
			testc => testc,
			state => state
);
 
-- Clock process definitions
generate_clock : PROCESS 
begin
clk <= '0';
wait for clock_period/2;
clk <= '1';
wait for clock_period/2;
end process;
 
-- Stimulus process
stim_proc: process
begin
-- 1 gum with nickels and reset
wait for 100 ps;
num_item <= 1;
wait for 200 ps;
num_item <= 0;
wait for 100 ps;
in_nickel <= '1';
wait for 100 ps;
in_nickel <= '1';
wait for 100 ps;
in_nickel <= '1';
wait for 100 ps;
in_nickel <= '0';
rest <= '1';
wait for 100 ps;
rest <= '0';

  -- 1 gum with dollar coins
wait for 200 ps;
num_item <= 1;
wait for 200 ps;
num_item <= 0;
wait for 100 ps;
in_dollar <= '1';
wait for 200 ps;
in_dollar <= '0';

  -- 1 gum with half dollar coins
wait for 200 ps;
num_item <= 1;
wait for 200 ps;
num_item <= 0;
wait for 100 ps;
in_half_dollar <= '1';
wait for 200 ps;
in_half_dollar <= '0';

-- 1 gum with quarters
wait for 200 ps;
num_item <= 1;
wait for 200 ps;
num_item <= 0;
wait for 100 ps;
in_quarter <= '1';
wait for 200 ps;
 in_quarter <= '0';
 
-- 1 gum with dimes
wait for 200 ps;
num_item <= 1;
wait for 200 ps;
num_item <= 0;
wait for 200 ps;
in_dime <= '1';
wait for 200 ps;
in_dime <= '1';
wait for 200 ps;
in_dime <= '0';

-- 1 gum with nickels
wait for 200 ps;
num_item <= 1;
wait for 200 ps;
num_item <= 0;
wait for 200 ps;
in_nickel <= '1';
wait for 200 ps;
in_nickel <= '1';
wait for 200 ps;
in_nickel <= '1';
wait for 200 ps;
in_nickel <= '1';
wait for 200 ps;
in_nickel <= '0';

  -- 2 gum with dollar coins
wait for 200 ps;
num_item <= 2;
wait for 200 ps;
num_item <= 0;
wait for 200 ps;
in_dollar <= '1';
wait for 200 ps;
in_dollar <= '0';

  -- 2 gum with half dollar coins
wait for 200 ps;
num_item <= 2;
wait for 200 ps;
num_item <= 0;
wait for 200 ps;
in_half_dollar <= '1';
wait for 200 ps;
in_half_dollar <= '0';
  
-- 2 gum with dime and quarter
wait for 200 ps;
num_item <= 2;
wait for 200 ps;
num_item <= 0;
wait for 200 ps;
in_dime <= '1';
wait for 100 ps;
in_dime <= '0';
in_quarter <= '1';
wait for 100 ps;
in_quarter <= '1';
wait for 200 ps;
in_quarter <= '0';
wait;
end process;
 
END;