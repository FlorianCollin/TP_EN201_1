library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod8 is
    port (
        horloge, c_e, raz : in std_logic;
        AN : out std_logic_vector(7 downto 0);
        sortie : out std_logic_vector(2 downto 0)
    );
end mod8;

architecture behav of mod8 is
    signal count : unsigned(2 downto 0):="000"; -- signal pour le compteur
begin
    process(horloge, c_e, raz)
    begin
    if (raz = '1') then
        count <= "000";
    else
        if (rising_edge(horloge)) then
            if (c_e = '1') then
                if count = "111" then -- 8
                    count <= "000";
                else
                    count <= count + 1; -- on incrémente
                end if;
            end if;
        end if;
    end if;
    
      case (count) is
         when "000" => AN <= "01111111";
         when "001" => AN <= "10111111"; 
         when "010" => AN <= "11011111"; 
         when "011" => AN <= "11101111"; 
         when "100" => AN <= "11110111"; 
         when "101" => AN <= "11111011"; 
         when "110" => AN <= "11111101"; 
         when "111" => AN <= "11111110"; 
    end case;
    
    end process;
    

       
    sortie <= std_logic_vector(count); -- permet de créer un signal de selection pour le mux
    
end behav;