library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- setup ports as usual
entity d3_sequence_detector is
	port  (
		clk: in std_logic;
		rst: in std_logic;
		data: in std_logic;
		seq_found: out std_logic
	);
end entity d3_sequence_detector;	

architecture fsm of d3_sequence_detector is
	type state_type is (S0, S1, S2, S3, S4); 	-- declare states
	signal state, nx_state: state_type := S0; -- initialize state
begin
	-- for synchronization and reset-functionality
	P1: process(clk, rst)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				state <= S0;
			else
				state <= nx_state;
			end if;
		end if;
	end process;
	
	-- logic for detecting the sequence 1011
	P2: process(all)
	begin
		case state is
			when S0 =>
				-- have to identify 1 until further progress
				if data='1' then
					nx_state <= S1;
				else
					nx_state <= S0;
				end if;
			when S1 =>
				-- sequence ...1 detected
				if data='0' then
					nx_state <= S2;
				else
					nx_state <= S1; 
					-- go back (...11) to continue looking for 0
				end if;
			when S2 =>
				-- sequence ...10 achieved
				if data='1' then
					nx_state <= S3;
				else
					-- would result in 100 reset needed
					nx_state <= S0;
				end if;
			when S3 =>
				if data='1' then
					nx_state <= S4;
				else
					-- 10[10] go to s2 because we now have detected [10] already
					nx_state <= S2;
				end if;
			when S4 =>
				-- 1011
				nx_state <= S1;
			when others =>
				nx_state <= S0;
		end case;
	end process;

seq_found <= '1' when state = S4 else '0'; -- if S4 set seqfound high all other states low

end architecture fsm;


-- shift register implementation
architecture shiftreg of d3_sequence_detector is
	signal r1: std_logic_vector(3 downto 0) := (others => '0');
	signal flag_found: std_logic := '0';
begin

	process(clk)
		variable tmp_reg: std_logic_vector(3 downto 0);
	begin
		if rising_edge(clk) then
			if rst='1' then
				r1 <= (others => '0');
				flag_found <= '0';
			else
				tmp_reg := r1(2 downto 0) & data; -- shift incoming data value into r1 register
				r1 <= tmp_reg;
				
				-- identify if current gliding window is 1011
				if tmp_reg="1011" then
					flag_found <= '1';
				else
					flag_found <= '0';
				end if;
			end if;
		end if;
	end process;

seq_found <= flag_found;

end architecture shiftreg;

configuration config of d3_sequence_detector is
	for fsm end for;
end configuration;
