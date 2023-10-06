library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- rising edge d flip flop
entity detect_impulsion is
    port (
        clock : in std_logic;
        input : in std_logic;
        output : out std_logic
    );
end detect_impulsion;


architecture behav of detect_impulsion is
signal one_detect : std_logic := '0';

begin
    process(clock, input)
    begin
        if (rising_edge(clock)) then
            if input = '1' and one_detect = '0' then
                output <= '1';
                one_detect <= '1';
            elsif input = '1' and one_detect = '1' then
                output <= '0';
                one_detect <= '1';
            elsif input = '0' then
                output <= '0';
                one_detect <= '0';
            end if;
        end if;
    end process;

end behav ; 