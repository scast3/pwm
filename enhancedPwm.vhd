library work;
use work.basicBuildingBlocksVhdl_package.all;

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
    signal E255, dutyGreateCnt : STD_LOGIC;
    signal dutyCycle_int STD_LOGIC_VECTOR (8 downto 0);
    signal pwmCount_int STD_LOGIC_VECTOR (8 downto 0): 