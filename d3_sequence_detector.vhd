library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d3_sequence_detector is
	port  (
		clk: in std_logic;
		rst: in std_logic;
		data: in std_logic;
		seq_found: out std_logic
	);
end entity d3_sequence_detector;	

architecture rtl of d3_sequence_detector is
	type state_type is (S0, S1, S2, S3, S4);
	signal state, nx_state: state_type := S0;
begin


	P1: process(clk, rst)
	begin
		if rising_edge(clk) then
			if rst='0' then
				state <= S0;
			else
				state <= nx_state;
			end if;
		end if;
	end process;
	
	-- detect 1011
	P2: process(all)
	begin
		case state is
			when S0 =>
				if data='1' then
					nx_state <= S1;
				else
					nx_state <= S0;
				end if;
			when S1 =>
				if data='0' then
					nx_state <= S2;
				else
					nx_state <= S1;
				end if;
			when S2 =>
				if data='1' then
					nx_state <= S3;
				else
					nx_state <= S0;
				end if;
			when S3 =>
				if data='1' then
					nx_state <= S4;
				else
					nx_state <= S2;
				end if;
			when S4 =>
				nx_state <= S1;
		end case;
	end process;
	
	seq_found <= '1' when state = S4 else '0';
	
end architecture rtl;