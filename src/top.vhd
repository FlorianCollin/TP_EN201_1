library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top is
    port(
        button_center : in std_logic;
        button_down : in std_logic;
        button_left : in std_logic;
        button_right : in std_logic;
        button_up : in std_logic;
        raz : in std_logic;
        horloge : in std_logic;

        sept_segments : out std_logic_vector(6 downto 0); -- sortie du mux8
        an : out std_logic_vector(7 downto 0) -- bus 8 bit
    );
end top;

architecture behav of top is

-- declaration de component
component detect_impulsion is
    port (
        clock : in std_logic;
        input : in std_logic;
        output : out std_logic
    );
end component;

component cpt_1_9 is
    port(
        decr, incr : in std_logic;
        horloge : in std_logic;
        raz : in std_logic;
        sortie : out std_logic_vector(3 downto 0)
    );
end component;

component cpt_1_599 is
    port(
        c_e : in std_logic; -- c_e affichage 10 Hz => periode de 100 ms --il faut que c_e soit a 1 pendant exactement 10 ns
        decr, incr : in std_logic;
        init : in std_logic;
        horloge : in std_logic;
        raz : in std_logic;
        sortie : out std_logic_vector(9 downto 0)
    );
end component;

component FSM is 
    Port (
        CLOCK : in std_logic;
        RESET : in std_logic;
        B_UP : in std_logic;
        B_DOWN : in std_logic;
        B_CENTER : in std_logic;
        B_LEFT : in std_logic;
        B_RIGHT : in std_logic;

        PLAY_PAUSE : out std_logic;
        RESTART : out std_logic;
        FORWARD : out std_logic;
        VOLUME_UP : out std_logic;
        VOLUME_DW : out std_logic
    );
end component;

component gestion_freq is
    port(
        horloge : in std_logic; -- f = 100 MHz / Th = 10 ns 
        raz : in std_logic; -- remise à zero synchrone sur l'horloge
        ce_affichage : out std_logic; -- f = 10 Hz / T = 100 ms = 1 000 000 * Th / pour l'actualisation du compteur cpt_1_599
        ce_perception : out std_logic -- f = 3 kHz / T = 333 333 ns ~= 33 333 * Th
        -- pour la creation de signal de commande du mux produit par le compteur modulo 8 (frequence de balayage des  7 seg)
    );
end component;

component mod8 is
    port (
        horloge, c_e, raz : in std_logic;
        AN : out std_logic_vector(7 downto 0);
        sortie : out std_logic_vector(2 downto 0)
    );
end component;

component mux8 is
    port (
        commande : in std_logic_vector(2 downto 0);
        e0, e1, e2, e3, e4, e5, e6, e7 : in std_logic_vector(6 downto 0);
        s : out std_logic_vector(6 downto 0)
    );
end component;

component trans is
    port (
        forward, play_pause, restart : in std_logic;
        nb_binaire : in std_logic_vector(9 downto 0); -- sortie de cpt_1_599
        nb_binaire_volume : in std_logic_vector(3 downto 0); --sortie de cpt_1_9
        s_cent, s_diz, s_unit : out std_logic_vector(6 downto 0);
        s_unit_vol : out std_logic_vector(6 downto 0);
        sortie1, sortie2, sortie3, sortie4 : out std_logic_vector(6 downto 0)
    );
end component;

-- fin de la declaration des components

-- Declaration de signaux :

-- signaux pour les boutons
signal s_bd, s_bc, s_bl, s_br, s_bu : std_logic := '0'; -- s_ pour signal
-- signal pour l'horloge
signal s_clk : std_logic := '0';
-- signal  pour la remise à zero
signal s_raz : std_logic := '0';

signal sr_bd, sr_bc, sr_bl, sr_br, sr_bu : std_logic := '0'; -- sr_ pour signal register

signal s_forward, s_play_pause, s_restart, s_volume_up, s_volume_down : std_logic := '0';

signal s_ce_p, s_ce_a : std_logic;

signal s_volume : std_logic_vector(3 downto 0);
signal s_time : std_logic_vector(9 downto 0);

-- signaux de l'encodage 7 seg pour chaque digit
signal s_time_unit, s_time_diz, s_time_cent, s_volume_unit, s_sortie1, s_sortie2, s_sortie3, s_sortie4 : std_logic_vector(6 downto 0);

signal s_mux_command : std_logic_vector(2 downto 0) := "000";

begin
    s_bd <= button_down;
    s_bc <= button_center;
    s_bl <= button_left;
    s_br <= button_right;
    s_bu <= button_up;
    s_raz <= raz;
    s_clk <= horloge;

    -- instanciation

    -- instanciation des detecteurs d'impulsion pour les 4 différents boutons.

    reg_b_down: detect_impulsion
    port map (
        clock => s_clk,
        input => s_bd,
        output => sr_bd
    );

    reg_b_center: detect_impulsion
    port map (
        clock => s_clk,
        input => s_bc,
        output => sr_bc
    );

    reg_b_left: detect_impulsion
    port map (
        clock => s_clk,
        input => s_bl,
        output => sr_bl
    );

    reg_b_right: detect_impulsion
    port map (
        clock => s_clk,
        input => s_br,
        output => sr_br
    );

    reg_b_up: detect_impulsion
    port map (
        clock => s_clk,
        input => s_bu,
        output => sr_bu
    );

    inst_fsm: fsm
    port map (
        CLOCK => s_clk,
        RESET => s_raz,
        B_UP => sr_bu,
        B_DOWN => sr_bd,
        B_CENTER => sr_bc,
        B_LEFT => sr_bl,
        B_RIGHT => sr_br,

        PLAY_PAUSE => s_play_pause,
        RESTART => s_restart,
        FORWARD => s_forward,
        VOLUME_UP => s_volume_up,
        VOLUME_DW => s_volume_down
        
    );

    inst_gestion_f: gestion_freq
    port map (
        horloge => s_clk,
        raz => s_raz,
        ce_affichage => s_ce_a,
        ce_perception => s_ce_p
    );

    inst_cpt_1_9: cpt_1_9
    port map(
        decr => s_volume_down,
        incr => s_volume_up,
        horloge => s_clk,
        raz => s_raz,
        sortie => s_volume

    );

    inst_cpt_1_599: cpt_1_599
    port map (
        c_e => s_ce_a, -- signal enable affichage
        decr => s_forward,
        incr => s_play_pause,
        init => s_restart,
        horloge => s_clk,
        raz => s_raz,
        sortie => s_time
    );

    inst_trans: trans
    port map (
        forward => s_forward,
        play_pause => s_play_pause,
        restart => s_restart,
        nb_binaire => s_time,
        nb_binaire_volume => s_volume ,

        s_cent => s_time_cent,
        s_diz => s_time_diz,
        s_unit => s_time_unit,
        s_unit_vol => s_volume_unit,
        sortie1 => s_sortie1,
        sortie2 => s_sortie2,
        sortie3 => s_sortie3,
        sortie4 => s_sortie4
    );

    inst_mod8: mod8
    port map (
        horloge => s_clk,
        c_e => s_ce_p,
        raz => s_raz,
        AN => an, -- sortie de top
        sortie => s_mux_command
    );

    inst_mux8: mux8
    port map(
        commande => s_mux_command,
        e0 => s_volume_unit,
        e1 => s_time_cent,
        e2 => s_time_diz,
        e3 => s_time_unit,
        e4 => s_sortie1,
        e5 => s_sortie2,
        e6 => s_sortie3,
        e7 => s_sortie4,
        s => sept_segments -- sortie de top
    );


end behav;