library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d3_sequence_detector is
	port  (
		clk: in std_logic;
		rst: in std_logic;
		data: in std_logic;
		seq_found: out std_logic;
	);
end entity d3_sequence_detector;	

architecture rtl of d3_sequence_detector is
	signal i: natural range 0 to MAX;
begin
	P1: process(clk)
	begin
		if rising_edge(clk) then
			-- implement logic
		end if;
	end process;
	seq_found <= '1'; -- when state S4...
end architecture rtl;