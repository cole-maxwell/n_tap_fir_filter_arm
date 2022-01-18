library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity binary_to_decimal is
	port(inbcd : in std_logic_vector(13 downto 0);
		 outbcd : out std_logic_vector(17 downto 0));
end binary_to_decimal;

architecture Behavioral of binary_to_decimal is

component b2bcd is
			port(in_bcd : in std_logic_vector(3 downto 0);
			    out_bcd : out std_logic_vector(3 downto 0));
end component;

signal w1_i,w1_o,w2_i,w2_o,w3_i,w3_o,w4_i,w4_o,w5_i,w5_o,
		w6_i,w6_o,w7_i,w7_o,w8_i,w8_o,w9_i,w9_o,w10_i,w10_o,
		w11_i,w11_o,w12_i,w12_o,w13_i,w13_o,w14_i,w14_o,w15_i,w15_o,
		w16_i,w16_o,w17_i,w17_o,w18_i,w18_o,w19_i,w19_o,w20_i,w20_o,
		w21_i,w21_o,w22_i,w22_o,w23_i,w23_o,w24_i,w24_o,w25_i,w25_o: std_logic_vector(3 downto 0);
signal bit0 : std_logic := '0';

	begin
		bit0  <= '0';
	
		w1_i  <= bit0 & inbcd(13 downto 11);
		w2_i  <= w1_o(2 downto 0) & inbcd(10); 
		w3_i  <= w2_o(2 downto 0) & inbcd(9);
		w4_i  <= w3_o(2 downto 0) & inbcd(8);
		w5_i  <= w4_o(2 downto 0) & inbcd(7);
		w6_i  <= w5_o(2 downto 0) & inbcd(6);
		w7_i  <= w6_o(2 downto 0) & inbcd(5);
		w8_i  <= w7_o(2 downto 0) & inbcd(4);
		w9_i  <= w8_o(2 downto 0) & inbcd(3);
		w10_i  <= w9_o(2 downto 0) & inbcd(2);
		w11_i  <= w10_o(2 downto 0) & inbcd(1);
		w12_i  <= bit0 & w1_o(3) & w2_o(3) & w3_o (3);
		w13_i  <= w12_o(2 downto 0) & w4_o(3);
		w14_i  <= w13_o(2 downto 0) & w5_o(3);
		w15_i  <= w14_o(2 downto 0) & w6_o(3);
		w16_i  <= w15_o(2 downto 0) & w7_o(3);
		w17_i  <= w16_o(2 downto 0) & w8_o(3);
		w18_i  <= w17_o(2 downto 0) & w9_o(3);
		w19_i  <= w18_o(2 downto 0) & w10_o(3);
		w20_i  <= bit0 & w12_o(3) & w13_o(3) & w14_o (3);
		w21_i  <= w20_o(2 downto 0) & w15_o(3);
		w22_i  <= w21_o(2 downto 0) & w16_o(3);
		w23_i  <= w22_o(2 downto 0) & w17_o(3);
		w24_i  <= w23_o(2 downto 0) & w18_o(3);
		w25_i  <= bit0 & w21_o(3) & w22_o(3) & w23_o (3);
		
		outbcd   <= w20_o(3) & w25_o(3 downto 0) & w24_o(3 downto 0) & w19_o(3 downto 0) & w11_o(3 downto 0) & inbcd(0);

		U1 : b2bcd port map(in_bcd => w1_i, out_bcd => w1_o);
		U2 : b2bcd port map(in_bcd => w2_i, out_bcd => w2_o);
		U3 : b2bcd port map(in_bcd => w3_i, out_bcd => w3_o);
		U4 : b2bcd port map(in_bcd => w4_i, out_bcd => w4_o);
		U5 : b2bcd port map(in_bcd => w5_i, out_bcd => w5_o);
		U6 : b2bcd port map(in_bcd => w6_i, out_bcd => w6_o);
		U7 : b2bcd port map(in_bcd => w7_i, out_bcd => w7_o);
		U8 : b2bcd port map(in_bcd => w8_i, out_bcd => w8_o);
		U9 : b2bcd port map(in_bcd => w9_i, out_bcd => w9_o);
		U10 : b2bcd port map(in_bcd => w10_i, out_bcd => w10_o);
		
		U11 : b2bcd port map(in_bcd => w11_i, out_bcd => w11_o);
		U12 : b2bcd port map(in_bcd => w12_i, out_bcd => w12_o);
		U13 : b2bcd port map(in_bcd => w13_i, out_bcd => w13_o);
		U14 : b2bcd port map(in_bcd => w14_i, out_bcd => w14_o);
		U15 : b2bcd port map(in_bcd => w15_i, out_bcd => w15_o);
		U16 : b2bcd port map(in_bcd => w16_i, out_bcd => w16_o);
		U17 : b2bcd port map(in_bcd => w17_i, out_bcd => w17_o);
		U18 : b2bcd port map(in_bcd => w18_i, out_bcd => w18_o);
		U19 : b2bcd port map(in_bcd => w19_i, out_bcd => w19_o);
		U20 : b2bcd port map(in_bcd => w20_i, out_bcd => w20_o);
		
		U21 : b2bcd port map(in_bcd => w21_i, out_bcd => w21_o);
		U22 : b2bcd port map(in_bcd => w22_i, out_bcd => w22_o);
		U23 : b2bcd port map(in_bcd => w23_i, out_bcd => w23_o);
		U24 : b2bcd port map(in_bcd => w24_i, out_bcd => w24_o);
		U25 : b2bcd port map(in_bcd => w25_i, out_bcd => w25_o);
end Behavioral;

