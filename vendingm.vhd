library IEEE;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.ALL;

entity vending is
port (clk,in_dime, in_nickel, rest: in bit;
			num_item: in integer;
			return_dime: out integer;
			return_nickel: out integer;
			return_deposit: out integer;
			release_num_gums: out integer;
			display_num_gums: out integer;
			message: out integer;
			display_total_deposit: out integer
			);
end vending;

architecture arch_vending of vending is
  type state_type is (idle, buying, reset, finish);
  signal current_s,release_s, next_s: state_type; 
  signal num_gums_wanted: integer:=0;
  signal deposit_cents: integer:=0;
  signal counter: integer:=0;
  signal total_price: integer:=0;
begin
  process(num_item)
    begin
      num_gums_wanted <= num_item;
      total_price  <= 20 * num_item;
  end process;
  
  process(clk, rest)
    begin 
      if (rest='1') then
        current_s <= reset;
      elsif (num_item > 0 ) then
        current_s <= buying;
        counter <= counter+1;
      end if;
		end process;
		
		process(counter, current_s, in_dime, in_nickel, next_s)
		  begin
		    if(num_item > 0) then
		      if (current_s = reset) then
		        message<=0;
		        display_total_deposit<=0;
		        display_num_gums<=0;
		        return_deposit<=0;
		        return_nickel<=0;
		        return_dime<=0;
		      elsif (next_s = finish) then
		        release_num_gums <= num_gums_wanted;
		        return_deposit <= deposit_cents - total_price;  
		        message<=0;
		        display_total_deposit<=0;
		        display_num_gums<=0;
		      elsif (in_dime='1') then
		        deposit_cents <= deposit_cents + 5;
		        display_total_deposit <= deposit_cents;
		        
		        if (deposit_cents >= total_price) then
		          release_s <= finish;
		        end if;
		      elsif (in_nickel = '1') then
		        deposit_cents <= deposit_cents + 10;
		        display_total_deposit <= deposit_cents;
		        
		        if (deposit_cents >= total_price) then
		          release_s <= finish;
		        end if;
		      end if;
		     end if;
		end process;
		
		process(release_s)
		  begin
		  if (num_item > 0) then
		    if (release_s = finish) then
		      next_s <= finish;
		    end if;
		  end if;
		end process;
end arch_vending;