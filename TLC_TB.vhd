
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TLC_TB is
--  Port ( );
end TLC_TB;

architecture Behavioral of TLC_TB is

component TLC --I/O from main code
    Port (clk, S_n, S_s, S_w, S_e, S_nL, S_sL, S_wL, S_eL: in std_logic; -- sensors
R_N, R_NR, R_NL, R_E, R_ER, R_EL, R_S, R_SR, R_SL, R_W, R_WR, R_WL: inout std_logic;
Y_N, Y_NR, Y_NL, Y_E, Y_ER, Y_EL, Y_S, Y_SR, Y_SL, Y_W, Y_WR, Y_WL: inout std_logic;
G_N, G_NR, G_NL, G_E, G_ER, g_EL, G_S, G_SR, G_SL, G_W, G_WR, G_WL: inout std_logic;
timer: inout integer := 0);
end component;

--inputs 
signal wire_clk: std_logic;
signal S_n: std_logic;
signal S_s: std_logic;
signal S_e: std_logic;
signal S_w: std_logic;
signal S_nL: std_logic;
signal S_sL: std_logic;
signal S_wL: std_logic;
signal S_eL: std_logic;

--signal/outputs
signal R_N, R_NR, R_NL, R_E, R_ER, R_EL: std_logic;
signal R_S, R_SR, R_SL, R_W, R_WR, R_WL: std_logic;
signal Y_N, Y_NR, Y_NL, Y_E, Y_ER, Y_EL, Y_S: std_logic;
signal Y_SR, Y_SL, Y_W, Y_WR, Y_WL: std_logic;
signal G_N, G_NR, G_NL, G_E, G_ER, G_EL, G_S: std_logic;
signal G_SR, G_SL, G_W, G_WR, G_WL: std_logic;

--main output
type light is (R, Y, G);
signal lightN, lightNR, lightNL: light;
signal lightS, lightSR, lightSL: light;
signal lightE, lightER, lightEL: light;
signal lightW, lightWR, lightWL: light;
signal timer: integer;



    
begin

uut: TLC Port Map( --connecting the test bench to the main code
    clk => wire_clk,
    S_n => S_n,
    S_s => S_s,
    S_e => S_e,
    S_w => S_w,
    S_nL => S_nL,
    S_sL => S_sL,
    S_wL => S_wL,
    S_eL => S_eL,
    R_N => R_N, 
    R_NR => R_NR, 
    R_NL => R_NL, 
    R_E => R_E, 
    R_ER => R_ER, 
    R_EL => R_EL,
    R_S => R_S, 
    R_SR => R_SR, 
    R_SL => R_SL, 
    R_W => R_W, 
    R_WR => R_WR, 
    R_WL => R_WL,
    Y_N => Y_N, 
    Y_NR => Y_NR, 
    Y_NL => Y_NL, 
    Y_E => Y_E, 
    Y_ER => Y_ER,
    Y_EL => Y_EL,
    Y_S => Y_S,
    Y_SR => Y_SR, 
    Y_SL => Y_SL, 
    Y_W => Y_W, 
    Y_WR => Y_WR, 
    Y_WL => Y_WL,
    G_N => G_N, 
    G_NR => G_NR, 
    G_NL => G_NL, 
    G_E => G_E, 
    G_ER => G_ER,
    G_EL => G_EL,
    G_S => G_S,
    G_SR => G_SR, 
    G_SL => G_SL, 
    G_W => G_W, 
    G_WR => G_WR, 
    G_WL => G_WL,
    timer => timer
    );
    
    clk: process    -- 1 Hz clock
     begin
        wire_clk <= '0';
        wait for 0.5 sec;
        wire_clk <= '1';
        wait for 0.5 sec;
     end process;
    
  stim_proc: process    --simulating traffic
     begin
      S_s <= '0';
      S_w <= '0';
      S_e <= '0';
      S_nL <= '0'; 
      S_sL <= '0'; 
      S_wL <= '0';
      S_eL <= '0';
      S_n <= '1';
      wait for 10 sec;
      S_wL <= '1';
      wait for 70 sec;
      S_w <= '1';
      wait for 10 sec;
      S_wL <= '0';
      wait for 15 sec;
      S_sL <= '1';
      wait for 70 sec;
      assert false report "End of Simulation" severity failure;
        
      
  end process;
  
--Main outputs for ease of reading in simulation 
lightN <= R when R_N = '1' else Y when Y_N = '1' else G when G_N = '1';
lightS <= R when R_S = '1' else Y when Y_S = '1' else G when G_S = '1';
lightE <= R when R_E = '1' else Y when Y_E = '1' else G when G_E = '1';
lightW <= R when R_W = '1' else Y when Y_W = '1' else G when G_W = '1';
lightNR <= R when R_NR = '1' else Y when Y_NR = '1' else G when G_NR = '1';
lightNL <= R when R_NL = '1' else Y when Y_NL = '1' else G when G_NL = '1';
lightSR <= R when R_SR = '1' else Y when Y_SR = '1' else G when G_SR = '1';
lightSL <= R when R_SL = '1' else Y when Y_SL = '1' else G when G_SL = '1';
lightER <= R when R_ER = '1' else Y when Y_ER = '1' else G when G_ER = '1';
lightEL <= R when R_EL = '1' else Y when Y_EL = '1' else G when G_EL = '1';
lightWR <= R when R_WR = '1' else Y when Y_WR = '1' else G when G_WR = '1';
lightWL <= R when R_WL = '1' else Y when Y_WL = '1' else G when G_WL = '1';


end Behavioral;
