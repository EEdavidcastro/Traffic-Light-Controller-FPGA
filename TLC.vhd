
--have the trigger for the counter off the TB clk instead of the slow clk
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- n = north,  s = south,  w = west,  e = east
-- L = left,   R = Right,  
-- R = red,    G = Green,   y = yellow
-- ex. R_NL = Red light that is for north side intersection going left
-- S = sensor , ex = S_s = South sensor
entity TLC is
Port (clk, S_n, S_s, S_w, S_e, S_nL, S_sL, S_wL, S_eL: in std_logic; -- sensors
R_N, R_NR, R_NL, R_E, R_ER, R_EL, R_S, R_SR, R_SL, R_W, R_WR, R_WL: inout std_logic;
Y_N, Y_NR, Y_NL, Y_E, Y_ER, Y_EL, Y_S, Y_SR, Y_SL, Y_W, Y_WR, Y_WL: inout std_logic;
G_N, G_NR, G_NL, G_E, G_ER, g_EL, G_S, G_SR, G_SL, G_W, G_WR, G_WL: inout std_logic;
timer: inout integer := 0);
end TLC;


architecture Behavioral of TLC is

signal state, nextstate : integer range 0 to 11;
type light is (R, Y, G);
signal lightN, lightNR, lightNL: light;
signal lightS, lightSR, lightSL: light;
signal lightE, lightER, lightEL: light;
signal lightW, lightWR, lightWL: light;
signal clkCnt: integer := 0;
signal slowClk: std_logic; 
signal rst_timer: std_logic := '0';



begin

--clk scaler with 100 MHz clk
  Prescaler: Process(clk)
   begin
    if rising_edge(clk) then
        if clkCnt = 100000000 - 1 then -- if counts up to 100 million  
            clkCnt <= 0;    -- when one second passes reset counter
        else 
            clkCnt <= clkCnt + 1; --incrementing counter to simulate seconds
        end if;
    end if;
  end process Prescaler;

process(state, S_n, S_s, S_w, S_e, S_nL, S_sL, S_wL, S_eL)
  begin 
        --initial setup of all the lights
        R_N <= '0';
        R_NR <= '0';
        R_NL <= '0';
        R_S <= '0';
        R_SR <= '0';
        R_SL <= '0';
        R_E <= '0';
        R_ER <= '0';
        R_EL <= '0';
        R_W <= '0';
        R_WR <= '0';
        R_WL <= '0';
        
        Y_N <= '0';
        Y_NR <= '0';
        Y_NL <= '0';
        Y_S <= '0';
        Y_SR <= '0';
        Y_SL <= '0';
        Y_E <= '0';
        Y_ER <= '0';
        Y_EL <= '0';
        Y_W <= '0';
        Y_WR <= '0';
        Y_WL <= '0';
        
        G_N <= '0';
        G_NR <= '0';
        G_NL <= '0';
        G_S <= '0';
        G_SR <= '0';
        G_SL <= '0';
        G_E <= '0';
        G_ER <= '0';
        G_EL <= '0';
        G_W <= '0';
        G_WR <= '0';
        G_WL <= '0';
        
    case state is
        when 0 =>   --when north and south straights are green
            R_NR <= '1';
            R_NL <= '1';
            R_SR <= '1';
            R_SL <= '1';
            R_E <= '1';
            R_ER <= '1';
            R_EL <= '1';
            R_W <= '1';
            R_WR <= '1';
            R_WL <= '1';
            
            G_N <= '1';
            G_S <= '1';
            
            --checking the sensors
            if S_e = '1' or S_w = '1' or S_nL = '1' or S_sL = '1' or S_wL = '1' or S_eL = '1' then
                nextstate <= state + 1;
            end if;
            
        when 1 =>       -- when transition from Green to Yellow for north and south
            R_NR <= '1';
            R_NL <= '1';
            R_SR <= '1';
            R_SL <= '1';
            R_E <= '1';
            R_ER <= '1';
            R_EL <= '1';
            R_W <= '1';
            R_WR <= '1';
            R_WL <= '1';
            
            Y_N <= '1';
            Y_S <= '1';
            
            nextstate <= 2; --automatically go to next state after timer
        
        when 2 =>  --red lights (dead-time)
            R_N <= '1';
            R_NR <= '1';
            R_NL <= '1';
            R_S <= '1';
            R_SR <= '1';
            R_SL <= '1';
            R_E <= '1';
            R_ER <= '1';
            R_EL <= '1';
            R_W <= '1';
            R_WR <= '1';
            R_WL <= '1';   
            
            --checking sensors
            if S_e = '1' or S_w = '1' then
                nextstate <= 6; -- go to west and east green straights
            
            elsif S_eL = '1' or S_wL = '1' then
                nextstate <= 3; -- go to east and west left
            
            elsif S_nL = '1' or S_sL = '1' then
                nextstate <= 9; -- go to north and south left
            end if;
            
        when 3 => -- the East and West green left lights
            R_N <= '1';
            R_NL <= '1';
            R_S <= '1';
            R_SL <= '1';
            R_E <= '1';
            R_ER <= '1';
            R_W <= '1';
            R_WR <= '1';
                     
            G_NR <= '1';
            G_SR <= '1';
            G_EL <= '1';
            G_WL <= '1';
            
            --checking the sensors
            if S_e = '1' or S_w = '1' or S_nL = '1' or S_sL = '1' or S_s = '1' or S_s = '1'  then
                 nextstate <= 4; 
            end if;
            
        when 4  => -- the East and West yellow left lights
            R_N <= '1';
            R_NL <= '1';
            R_S <= '1';
            R_SL <= '1';
            R_E <= '1';
            R_ER <= '1';
            R_W <= '1';
            R_WR <= '1';
                     
            Y_NR <= '1';
            Y_SR <= '1';
            Y_EL <= '1';
            Y_WL <= '1';
            
            nextstate <= 5; --atuotmatically go to next lights after timer
            
        when 5 => -- all read lights
            R_N <= '1';
            R_NR <= '1';
            R_NL <= '1';
            R_S <= '1';
            R_SR <= '1';
            R_SL <= '1';
            R_E <= '1';
            R_ER <= '1';
            R_EL <= '1';
            R_W <= '1';
            R_WR <= '1';
            R_WL <= '1';
            
            if S_e = '1' or S_w = '1' then
                nextstate <= 6; -- go to west and east green straights
            
            elsif S_n = '1' or S_s = '1' then
                nextstate <= 0; -- go to north and sourth green straights
            
            elsif S_nL = '1' or S_sL = '1' then
                nextstate <= 9; -- go to north and south left
            end if;
        
        
        when 6 =>       -- green and west green straights
            R_N <= '1';
            R_NR <= '1';
            R_NL <= '1';
            R_S <= '1';
            R_SR <= '1';
            R_SL <= '1';
            R_ER <= '1';
            R_EL <= '1';
            R_WR <= '1';
            R_WL <= '1';
        
            G_W <= '1';
            G_E <= '1';
            
           --checking sensors
           if S_s = '1' or S_n = '1' or S_nL = '1' or S_sL = '1' or S_wL = '1' or S_eL = '1'  then
                 nextstate <= 7; 
            end if;
            
        when 7 =>         -- east and west yellow straights
            R_N <= '1';
            R_NR <= '1';
            R_NL <= '1';
            R_S <= '1';
            R_SR <= '1';
            R_SL <= '1';
            R_ER <= '1';
            R_EL <= '1';
            R_WR <= '1';
            R_WL <= '1';
        
            Y_W <= '1';
            Y_E <= '1';
            
            nextstate <= 8;
        
        when 8 => -- all red lights 
            R_N <= '1';
            R_NR <= '1';
            R_NL <= '1';
            R_S <= '1';
            R_SR <= '1';
            R_SL <= '1';
            R_E <= '1';
            R_ER <= '1';
            R_EL <= '1';
            R_W <= '1';
            R_WR <= '1';
            R_WL <= '1';
            
            if S_nL = '1' or S_sL = '1' then
                nextstate <= 9; -- go to north and south left
            
            elsif S_n = '1' or S_s = '1' then
                nextstate <= 0; -- go to north and sourth green straights
            
            elsif S_wL = '1' or S_eL = '1' then
                nextstate <= 3;
            end if;
            
        when 9 =>   -- green for north and south left 
            R_N <= '1';
            R_NR <= '1';
            R_S <= '1';
            R_SR <= '1';
            R_E <= '1';
            R_EL <= '1';
            R_W <= '1';
            R_WL <= '1';
        
            G_NL <= '1';
            G_SL <= '1';
            G_ER <= '1';
            G_WR <= '1';
            
            --checking sensors for any cars
            if S_s = '1' or S_n = '1' or S_w = '1' or S_e = '1' or S_wL = '1' or S_eL = '1'  then
                 nextstate <= 10; 
            end if;
            
        when 10 =>  --yellow for north and south left
            R_N <= '1';
            R_NR <= '1';
            R_S <= '1';
            R_SR <= '1';
            R_E <= '1';
            R_EL <= '1';
            R_W <= '1';
            R_WL <= '1';
        
            Y_NL <= '1';
            Y_SL <= '1';
            Y_ER <= '1';
            Y_WR <= '1';
        
            --automatically go to next state after timer
            nextstate <= 11;
        
        when 11 =>  -- all red lights
            R_N <= '1';
            R_NR <= '1';
            R_NL <= '1';
            R_S <= '1';
            R_SR <= '1';
            R_SL <= '1';
            R_E <= '1';
            R_ER <= '1';
            R_EL <= '1';
            R_W <= '1';
            R_WR <= '1';
            R_WL <= '1';
        
            if S_n = '1' or S_s = '1' then
                nextstate <= 0; -- go to north and sourth green straights
            
            elsif S_wL = '1' or S_eL = '1' then
                nextstate <= 3;     -- go to east and west green left
                
            elsif S_w = '1' or S_e = '1' then
                nextstate <= 6; -- go to west and east green
            end if;
     end case;
    end process;
    
process(timer) -- this transitions to the next state and is triggered of a timer in seconds
  begin
  
    --reseting the timer reset 
    if rst_timer = '1' then rst_timer <= '0'; end if;
  
    if state = 0 then
      if timer = 60 then    -- when 60 seconds
        state <= nextstate;
        rst_timer <= '1';
      end if;
    end if;
    
    if state = 1 then
        if timer = 6 then   -- when 6 seconds
          state <= nextstate;
          rst_timer <= '1';
        end if;
    end if;
    
    if state = 2 then
        if timer = 2 then   -- when 2 seconds
            state <= nextstate;
            rst_timer <= '1';
        end if;
    end if;
    
    if state = 3 then
        if S_wL = '0' and S_eL = '0' then -- when no more cars
            state <= nextstate;
            rst_timer <= '1';
        end if;
    end if;
    
    if state = 4 then
        if timer = 6 then -- when 6 seconds
            state <= nextstate;
            rst_timer <= '1';
        end if;
    end if;
    
    if state = 5 then
        if timer = 2 then --when 2 seconds 
            state <= nextstate;
            rst_timer <= '1';
        end if;
    end if;
    
    if state = 6 then
        if timer = 60 then  -- when 60 seconds
            state <= nextstate;
            rst_timer <= '1';
        end if;
    end if;
    
    if state = 7 then
        if timer = 6 then       -- when 6 seconds
            state <= nextstate;
            rst_timer <= '1';
        end if;
    end if;
    
    if state = 8 then
        if timer = 2 then       -- when 2 seconds
            state <= nextstate;
            rst_timer <= '1';
        end if;
    end if;
    
    if state = 9 then
        if S_nL = '0' and S_sL = '0' then   -- when no more cars
            state <= nextstate;
            rst_timer <= '1';
        end if;
    end if;
    
    if state = 10 then
        if timer = 6 then   -- when 6 seconds
            state <= nextstate;
            rst_timer <= '1';
        end if;
    end if;
   
    if state = 11 then
        if timer = 2 then -- when 2 seconds 
            state <= nextstate;
            rst_timer <= '1';
        end if;
    end if;
end process;

-- right now functions off a 1 Hz clk in the testbench and not the slowclk
second_timer: Process(clk,rst_timer)      -- this acts as a second counter
  begin
        if(rising_edge(clk)) then       --increments until reset timer is triggered
            timer <= timer + 1;
        end if;
        if(rst_timer = '1') then
            timer <= 0;
        end if;
  end process;
  
--this would be the slowclk that converts 100Mhz to 1Hz  
slowClk <= '1' when clkCnt = 100000000 - 1 else '0';


--This is an easier way of displaying the lights in the simulation/testbench
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



