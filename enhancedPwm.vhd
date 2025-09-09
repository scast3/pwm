library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.basicBuildingBlocks_package.all;

entity enhancedPwm is
    Port ( clk : in STD_LOGIC;
        resetn : in STD_LOGIC;
        dutyCycle : in STD_LOGIC_VECTOR (8 downto 0);
        enb : in STD_LOGIC;
        pwmSignal : out STD_LOGIC;
        pwmCount : out STD_LOGIC_VECTOR (7 downto 0);
        rollOver : out STD_LOGIC);
end enhancedPwm;

architecture Behavioral of enhancedPwm is
    signal E255, dutyGreaterCnt : STD_LOGIC;
    signal dutyCycle_int : STD_LOGIC_VECTOR (8 downto 0);
    signal pwmCount_int : STD_LOGIC_VECTOR (7 downto 0);
    signal pwmCount9_int : STD_LOGIC_VECTOR (8 downto 0);
    signal counterControl : STD_LOGIC_VECTOR (7 downto 0);

    process(clk, resetn)
    begin
        if resetn = '0' then
            pwmSignal <= '0';
        elsif rising_edge(clk) then
            pwmSignal <= dutyGreaterCnt;
        end if;
    end process;

    component genericCompare is
        generic(N: integer := 4);
        port(x,y : in std_logic_vector(N-1 downto 0);
            g,l,e: out std_logic);
    end component;

    component genericRegister is
        generic(N: integer := 4);
        port ( clk, reset,load: in std_logic;
            d: in std_logic_vector(N-1 downto 0);
            q: out std_logic_vector(N-1 downto 0) );
    end component;
    
    begin
    
    pwmCount9_int <= ("0" & pwmCount_int);
    comp_9bit : genericCompare
        GENERIC MAP(9)
        PORT MAP(x => dutyCycle_int, 
            y => pwmCount9_int, 
            g => dutyGreaterCnt, 
            l => open,
            e => open
        );

    comp_8bit : genericCompare
        GENERIC MAP(8)
        PORT MAP(x => x"FF", 
            y => pwmCount_int, 
            g => open, 
            l => open,
            e => E255
        );

    reg_inst: genericRegister
        GENERIC MAP(9)
        PORT MAP(clk => clk, 
            reset => resetn, 
            load => E255,
            d => dutyCycle, 
            q => dutyCycle_int
        );
    
    count_inst: genericCounter
        GENERIC MAP (8)
        PORT MAP(clk=>clk,
            resetn => resetn,
            c => counterControl,
            d => x"00",
            q => pwmCount_int
        );

    U_DFF: genericRegister
        GENERIC MAP (1)
        PORT MAP (
            clk    => clk,
            resetn => resetn,
            load   => '1',
            d      => dutyGreaterCnt,
            q      => pwmSignal
        );

    
    -- when/else logic for pwm goes here
    
end Behavioral;