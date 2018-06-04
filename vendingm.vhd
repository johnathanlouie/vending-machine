library IEEE;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.ALL;

entity vending is
port (clk : in bit;
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
			display_total_deposit: out integer
			);
end vending;

architecture arch_vending of vending is
  type state_type is (initial, selectQ, coins,output,reset);
  signal current_s, next_s: state_type; 
  signal num_gums_wanted: integer:=0;
  signal deposit_cents: integer:=0;
  signal counter: integer:=0;
  signal total_price: integer:=0;
begin

  
  process(clk, rest, num_item)
    begin 
      if (rest='1') then
        current_s <= reset;
      elsif (num_item > 0) then
        current_s <= selectQ;
      else
        current_s <= next_s;
      end if;
		end process;
		
		process(clk, current_s)
		  begin
		    if (current_s = selectQ) then
		      num_gums_wanted <= num_item;
		      total_price <= 20*num_item;
		      next_s <= coins;
		    elsif (current_s = coins) then
		      if (in_dime='1') then
		        deposit_cents <= deposit_cents + 5;
		        display_total_deposit <= deposit_cents+5;
		        if (deposit_cents >= total_price) then
		          release_num_gums <= num_gums_wanted;
		          return_deposit <= deposit_cents - total_price;
		          deposit_cents<=0;  
		          message<=0;
		          display_total_deposit<=0;
		          display_num_gums<=0;
		          next_s<=output;
		        end if;
		      elsif (in_nickel = '1') then
		        deposit_cents <= deposit_cents + 10;
		        display_total_deposit <= deposit_cents + 10;
		        if (deposit_cents >= total_price) then
		          release_num_gums <= num_gums_wanted;
		          return_deposit <= deposit_cents - total_price;
		          deposit_cents<=0;  
		          message<=0;
		          display_total_deposit<=0;
		          display_num_gums<=0;
		          next_s<=output;
		        end if;
		        elsif (in_quarter = '1') then
		        deposit_cents <= deposit_cents + 25;
		        display_total_deposit <= deposit_cents + 25;
		        if (deposit_cents >= total_price) then
		          release_num_gums <= num_gums_wanted;
		          return_deposit <= deposit_cents - total_price;
		          deposit_cents<=0;  
		          message<=0;
		          display_total_deposit<=0;
		          display_num_gums<=0;
		          next_s<=output;
		        end if;
		       elsif (in_half_dollar = '1') then
		        deposit_cents <= deposit_cents + 50;
		        display_total_deposit <= deposit_cents + 50;
		        if (deposit_cents >= total_price) then
		          release_num_gums <= num_gums_wanted;
		          return_deposit <= deposit_cents - total_price;
		          deposit_cents<=0;  
		          message<=0;
		          display_total_deposit<=0;
		          display_num_gums<=0;
		          next_s<=output;
		        end if;
		       elsif (in_dollar = '1') then
		        deposit_cents <= deposit_cents + 100;
		        display_total_deposit <= deposit_cents + 100;
		        if (deposit_cents >= total_price) then
		          release_num_gums <= num_gums_wanted;
		          return_deposit <= deposit_cents - total_price;
		          deposit_cents<=0;  
		          message<=0;
		          display_total_deposit<=0;
		          display_num_gums<=0;
		          next_s<=output;
		        end if;
		      end if; 
		    elsif (current_s = output) then
		        message<=0;
		        display_total_deposit<=0;
		        display_num_gums<=0;
		        return_deposit<=0;
		        return_nickel<=0;
		        return_dime<=0;
		        release_num_gums<=0;
		        num_gums_wanted <=0;
		        deposit_cents<=0;
		        next_s <= initial;
		     elsif (current_s = reset) then
	          message<=0;
		        display_total_deposit<=0;
		        display_num_gums<=0;
		        return_deposit<=deposit_cents;
		        return_nickel<=0;
		        return_dime<=0;
		        num_gums_wanted <=0;
		        deposit_cents<=0;
		        next_s <= initial;
		     end if;
		end process;
		
end arch_vending;