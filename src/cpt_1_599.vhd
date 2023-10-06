library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- VALIDER AU TEST BENCH

entity cpt_1_599 is
    port(
        c_e : in std_logic; -- c_e affichage 10 Hz => periode de 100 ms --il faut que c_e soit a 1 pendant exactement 10 ns
        decr, incr : in std_logic;
        init : in std_logic;
        horloge : in std_logic;
        raz : in std_logic;
        sortie : out std_logic_vector(9 downto 0)
    );
end cpt_1_599;

architecture behav of cpt_1_599 is
    signal count : unsigned(9 downto 0) := "0000000000"; --tmp
begin
    process(decr, incr, horloge, raz, init)
        begin
            if (rising_edge(horloge)) then
                
                    if (raz = '1') then -- remise à zero synchrone sur l'horloge -- ATTENTION !!!!! logique incr decr voir sur le shema car les noms des entrée sont mal choisi
                        count <= "0000000001"; -- 1
                    elsif init = '1' then
                        count <= "0000000001"; -- 1
                    else
                        if (c_e = '1') then -- incr / decr syncrone à la frequence imposée par c_e

                            if (incr = '1') and (decr = '1') then -- mode incrementation
                                if count = "1001010111" then -- 599
                                    count <= "0000000000";
                                else count <= count + 1;
                                end if;
                            elsif (incr = '1') and (decr = '0') then -- mode decrementation
                                if count = "0000000000" then
                                    -- Rien faire on est au volume minimum 0
                                else
                                    count <= count - 1;
                                end if;
                            end if; -- si incr = 0 et decr = 0, on fait rien !

                        end if;

                    end if;

            end if;
    end process;
    sortie <= std_logic_vector(count);
end behav;