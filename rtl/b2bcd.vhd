library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity b2bcd is
	port(in_bcd : in std_logic_vector(3 downto 0);
			out_bcd : out std_logic_vector(3 downto 0));
end b2bcd;

architecture Behavioral of b2bcd is

begin
	process(in_bcd)
	begin
		case in_bcd is
			when "0000" => out_bcd <= "0000";
			when "0001" => out_bcd <= "0001";
			when "0010" => out_bcd <= "0010";
			when "0011" => out_bcd <= "0011";
			when "0100" => out_bcd <= "0100";
			when "0101" => out_bcd <= "1000";
			when "0110" => out_bcd <= "1001";
			when "0111" => out_bcd <= "1010";
			when "1000" => out_bcd <= "1011";
			when "1001" => out_bcd <= "1100";
			when others => out_bcd <= "1111";
		end case;
	end process;
end Behavioral;

