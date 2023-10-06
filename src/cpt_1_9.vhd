library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity cpt_1_9 is
    port(
        decr, incr : in std_logic;
        horloge : in std_logic;
        raz : in std_logic;
        sortie : out std_logic_vector(3 downto 0)
    );
end cpt_1_9;

architecture behav of cpt_1_9 is
    signal count : unsigned(3 downto 0); --tmp
begin
    process(decr, incr, horloge, raz)
    begin
        if (rising_edge(horloge)) then
            if (raz = '1') then
                count <= "0101"; -- 5 RAZ
            else
                if (incr = '1') and (decr = '0') then -- mode incrementation
                    if count = "1001" then -- 9
                        count <= "0000";
                    else count <= count + 1;
                    end if;
                elsif (incr = '0') and (decr = '1') then -- mode decrementation
                    if count = "0000" then
                        -- Rien faire on est au volume minimum 0
                    else
                        count <= count - 1;
                    end if;
                end if; -- si incr = 0 et decr = 0, on fait rien !
            end if;
        end if;
    end process;
    sortie <= std_logic_vector(count);
end behav;