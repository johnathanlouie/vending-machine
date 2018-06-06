library IEEE;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.ALL;

entity vending is
	port (
		clk                   : in  bit;
		in_nickel             : in  bit;
		in_dime               : in  bit;
		in_quarter            : in  bit;
		in_half_dollar        : in  bit;
		in_dollar             : in  bit;
		rest                  : in  bit;
		num_item              : in  integer;
		return_nickel         : out integer;
		return_dime           : out integer;
		return_quarter        : out integer;
		return_half_dollar    : out integer;
		return_dollar         : out integer;
		release_num_gums      : out integer;
		display_num_gums      : out integer;
		message               : out integer;
		display_total_deposit : out integer;
		testc                 : out integer; -- just for testing purpose
		state                 : out integer  -- fot testing as well
	);
end vending;

architecture arch_vending of vending is
	type   state_type is (initial, selectQ, coins, output, reset);
	signal current_s, next_s   : state_type;
	signal num_gums_wanted     : integer := 0;
	signal deposit_cents       : integer := 0;
	signal counter             : integer := 0; -- just for testing
	signal total_price         : integer := 0;
	signal num_gums            : integer := 0;
	signal num_gums_stored     : integer := 1000;
	signal num_nickels_stored  : integer := 1000;
	signal num_dimes_stored    : integer := 1000;
	signal num_quarters_stored : integer := 1000;
	signal num_halfs_stored    : integer := 1000;
	signal num_dollars_stored  : integer := 1000;

begin

	process(clk, rest, num_item)
	begin
		if rest = '1' then
			current_s <= reset;
			num_gums <= 0;
			state <= 1;
		elsif num_item > 0 then
			current_s <= selectQ;
			num_gums <= num_item;
			state <= 2;
		else
			current_s <= next_s;
			if next_s = coins then
				state <= 3;
			elsif next_s = output then
				state <= 4;
				num_gums <= 0;
			end if;
		end if;
	end process;

	process(clk)

		procedure get_change (cents2 : in integer) is
			variable cents : integer := cents2;
			variable c5, c10, c25, c50, c100 : integer := 0;
			variable c5s   : integer := num_nickels_stored;
			variable c10s  : integer := num_dimes_stored;
			variable c25s  : integer := num_quarters_stored;
			variable c50s  : integer := num_halfs_stored;
			variable c100s : integer := num_dollars_stored;
		begin
			while cents > 0 loop
				if cents >= 100 and c100s >= 1 then
					cents := cents - 100;
					c100s := c100s - 1;
					c100 := c100 + 1;
				elsif cents >= 50 and num_halfs_stored >= 1 then
					cents := cents - 50;
					c50s := c50s - 1;
					c50 := c50 + 1;
				elsif cents >= 25 and num_quarters_stored >= 1 then
					cents := cents - 25;
					c25s := c25s - 1;
					c25 := c25 + 1;
				elsif cents >= 10 and num_dimes_stored >= 1 then
					cents := cents - 10;
					c10s := c10s - 1;
					c10 := c10 + 1;
				elsif cents >= 5 and num_nickels_stored >= 1 then
					cents := cents - 5;
					c5s := c5s - 1;
					c5 := c5 + 1;
				else
					exit;
				end if;
			end loop;
			if cents = 0 then
				return_nickel <= c5;
				return_dime <= c10;
				return_quarter <= c25;
				return_half_dollar <= c50;
				return_dollar <= c100;
				num_nickels_stored <= c5s;
				num_dimes_stored <= c10s;
				num_quarters_stored <= c25s;
				num_halfs_stored <= c50s;
				num_dollars_stored <= c100s;
				deposit_cents <= 0;
			else
				message <= 3;
				next_s <= reset;
			end if;
		end get_change;

		procedure add_deposit (coin_value : in integer) is
		begin
			deposit_cents <= deposit_cents + coin_value;
			display_total_deposit <= deposit_cents + coin_value;
			if deposit_cents >= total_price then
				release_num_gums <= num_gums_wanted;
				get_change(deposit_cents - total_price);
				message <= 0;
				display_total_deposit <= 0;
				display_num_gums <= 0;
				next_s <= output;
			end if;
		end add_deposit;

	begin
		if clk'event and clk = '1' then
			if current_s = selectQ then
				if num_gums_stored >= num_item then
					num_gums_wanted <= num_gums;
					total_price <= 20 * num_gums;
					testc <= total_price;
					next_s <= coins;
				else
					message <= 2;
					next_s <= reset;
				end if;
			elsif current_s = coins then
				if in_nickel = '1' then
					num_nickels_stored <= num_nickels_stored + 1;
					add_deposit(5);
				elsif in_dime = '1' then
					num_dimes_stored <= num_dimes_stored + 1;
					add_deposit(10);
				elsif in_quarter = '1' then
					num_quarters_stored <= num_quarters_stored + 1;
					add_deposit(25);
				elsif in_half_dollar = '1' then
					num_halfs_stored <= num_halfs_stored + 1;
					add_deposit(50);
				elsif in_dollar = '1' then
					num_dollars_stored <= num_dollars_stored + 1;
					add_deposit(100);
				end if;
			elsif current_s = output then
				message <= 0;
				display_total_deposit <= 0;
				display_num_gums <= 0;
				return_nickel <= 0;
				return_dime <= 0;
				return_quarter <= 0;
				return_half_dollar <= 0;
				return_dollar <= 0;
				release_num_gums <= 0;
				num_gums_wanted <= 0;
				next_s <= initial;
			elsif current_s = reset then
				message <= 0;
				display_total_deposit <= 0;
				display_num_gums <= 0;
				get_change(deposit_cents);
				num_gums_wanted <= 0;
				next_s <= initial;
			end if;
		end if;
	end process;

end arch_vending;