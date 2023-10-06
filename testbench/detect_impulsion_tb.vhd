library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- a OK

entity detect_impulsion_tb is
end detect_impulsion_tb;

architecture behav of detect_impulsion_tb is
component detect_impulsion
    port (
        clock : in std_logic;
        input : in std_logic;
        output : out std_logic
    );
end component;

signal clock, input, output : std_logic := '0';

begin

    uut: detect_impulsion
    port map (
        clock => clock,
        input => input,
        output => output
    );

    clock_porcess: process
    begin
        clock <= '1';
        wait for 5 ns;
        clock <= '0';
        wait for 5 ns;

    end process;

    test: process
    begin
        input <= '1';
        wait for 10 ns;
        input <= '0';
        wait;
    end process;


end architecture;