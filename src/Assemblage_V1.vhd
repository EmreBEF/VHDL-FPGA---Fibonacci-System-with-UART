-- =========================================================
-- Module      : Assemblage_V1
-- Description : Structural top-level assembly of the first
--               FPGA version of the project.
--
--               This version connects:
--               - the 16-bit Fibonacci generator
--               - four 7-segment decoders
--
--               The generated Fibonacci value is split into
--               four 4-bit groups and displayed in hexadecimal
--               on four 7-segment displays.
--
-- Inputs:
--   En   : Enable signal for Fibonacci generation
--   RAZ  : Synchronous reset
--   CLK  : System clock
--   N    : Number of Fibonacci terms to generate
--
-- Outputs:
--   unite    : Least significant hexadecimal digit
--   dizaine  : Second hexadecimal digit
--   centaine : Third hexadecimal digit
--   millier  : Most significant hexadecimal digit
--   Carry    : Overflow flag from the Fibonacci generator
--
-- Author     : Emre Bekci
-- =========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.ALL;

entity Assemblage_V1 is
    port(
        En       : in  STD_LOGIC;
        RAZ      : in  STD_LOGIC;
        CLK      : in  STD_LOGIC;
        N        : in  STD_LOGIC_VECTOR(7 downto 0);

        unite    : out STD_LOGIC_VECTOR(6 downto 0);
        dizaine  : out STD_LOGIC_VECTOR(6 downto 0);
        centaine : out STD_LOGIC_VECTOR(6 downto 0);
        millier  : out STD_LOGIC_VECTOR(6 downto 0);
        Carry    : out STD_LOGIC
    );
end Assemblage_V1;

architecture structur of Assemblage_V1 is

    -- Internal 16-bit bus carrying the current Fibonacci value
    signal data : STD_LOGIC_VECTOR(15 downto 0);

    -- Fibonacci generator with overflow detection
    component Fibo_carry
        port(
            Clk        : in  STD_LOGIC;
            Raz        : in  STD_LOGIC;                      -- Circuit reset
            EN         : in  STD_LOGIC;                      -- Enable signal
            N          : in  STD_LOGIC_VECTOR(7 downto 0);  -- Number of terms to generate
            Suite      : out STD_LOGIC_VECTOR(15 downto 0); -- Current Fibonacci value
            Carry_flag : out STD_LOGIC                      -- Overflow indicator
        );
    end component;

    -- 4-bit to 7-segment hexadecimal decoder
    component seven_seg
        port(
            in4  : in  STD_LOGIC_VECTOR(3 downto 0); -- 4-bit input value
            seg7 : out STD_LOGIC_VECTOR(0 to 6)      -- 7-segment output
        );
    end component;

begin

    -- Main Fibonacci generator instance
    fib1: Fibo_carry
        port map(
            Clk        => Clk,
            Raz        => Raz,
            EN         => En,
            N          => N,
            Suite      => data,
            Carry_flag => Carry
        );

    -- Display the 16-bit Fibonacci value as 4 hexadecimal digits
    dec_0: seven_seg port map(data(3 downto 0),   unite);
    dec_1: seven_seg port map(data(7 downto 4),   dizaine);
    dec_2: seven_seg port map(data(11 downto 8),  centaine);
    dec_3: seven_seg port map(data(15 downto 12), millier);

end structur;