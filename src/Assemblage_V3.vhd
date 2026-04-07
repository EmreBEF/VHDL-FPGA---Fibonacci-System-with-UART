-- =========================================================
-- Module      : Assemblage_V3
-- Description : Final structural top-level assembly of the
--               FPGA project.
--
--               This version integrates:
--               - the 16-bit Fibonacci generator
--               - the 1 Hz enable generator
--               - four 7-segment display decoders
--               - the baud rate generator
--               - the UART transmitter
--
--               The system generates Fibonacci values at an
--               approximate 1 Hz rate, displays the current
--               16-bit value in hexadecimal on four 7-segment
--               displays, and transmits a status character
--               through UART:
--
--               - 'B' when no overflow is detected
--               - 'E' when an overflow occurs
--
--               UART baud rate can be selected between
--               9600 baud and 19200 baud.
--
-- Inputs:
--   RAZ      : Synchronous reset
--   CLK      : System clock
--   StartTr  : External transmission start input (declared but
--              not used in this version)
--   Test_TX  : Test input (declared but not used in this version)
--   N        : Number of Fibonacci terms to generate
--   VITESSE  : UART baud rate selector
--
-- Outputs:
--   unite    : Least significant hexadecimal digit
--   dizaine  : Second hexadecimal digit
--   centaine : Third hexadecimal digit
--   millier  : Most significant hexadecimal digit
--   Carry    : Overflow flag from Fibonacci generator
--   TxD      : UART serial transmission output
--
-- Notes:
--   In this implementation, UART transmission is automatically
--   triggered by the 1 Hz enable signal through StartTr_int.
--
-- Author     : Emre Bekci
-- =========================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.ALL;

entity Assemblage_V3 is
    port(
        RAZ      : in  STD_LOGIC;
        CLK      : in  STD_LOGIC;
        StartTr  : in  STD_LOGIC;
        Test_TX  : in  STD_LOGIC;
        N        : in  STD_LOGIC_VECTOR(7 downto 0);
        VITESSE  : in  STD_LOGIC;

        unite    : out STD_LOGIC_VECTOR(6 downto 0);
        dizaine  : out STD_LOGIC_VECTOR(6 downto 0);
        centaine : out STD_LOGIC_VECTOR(6 downto 0);
        millier  : out STD_LOGIC_VECTOR(6 downto 0);
        Carry    : out STD_LOGIC;
        TxD      : out STD_LOGIC
    );
end Assemblage_V3;

architecture structur of Assemblage_V3 is

    -- Internal 16-bit bus carrying the current Fibonacci value
    signal data        : STD_LOGIC_VECTOR(15 downto 0);

    -- 1 Hz enable signal used to update the Fibonacci sequence
    signal Enable      : STD_LOGIC;

    -- Baud rate enable signal for UART transmission
    signal BaudEn      : STD_LOGIC;

    -- Character sent through UART:
    -- 'B' when no overflow occurs, 'E' when overflow is detected
    signal data_char   : STD_LOGIC_VECTOR(7 downto 0);

    -- Internal overflow signal from Fibonacci generator
    signal carry_sig   : STD_LOGIC;

    -- Internal UART transmission start signal
    signal StartTr_int : STD_LOGIC;

    -- Unused internal signal kept from development/debug phase
    signal TxD_out     : STD_LOGIC;

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

    -- Clock divider / pulse generator for 1 Hz enable
    component CADENCE_1HZ
        port(
            CLK    : in  STD_LOGIC;
            RAZ    : in  STD_LOGIC;
            SORTIE : out STD_LOGIC
        );
    end component;

    -- Baud rate generator for UART transmission
    component BaudGen
        port(
            CLK     : in  STD_LOGIC;
            VITESSE : in  STD_LOGIC;
            BaudEn  : out STD_LOGIC
        );
    end component;

    -- UART transmitter
    component USART
        port(
            Clk, RAZ, StartTr, BaudEn : in  STD_LOGIC := '0';
            DataIn                    : in  STD_LOGIC_VECTOR(7 downto 0);
            TxD                       : out STD_LOGIC
        );
    end component;

begin

    -- Fibonacci generator instance
    fib1: Fibo_carry
        port map(
            Clk        => Clk,
            Raz        => Raz,
            EN         => Enable,
            N          => N,
            Suite      => data,
            Carry_flag => carry_sig
        );

    -- 1 Hz enable generation
    cadence: CADENCE_1HZ
        port map(
            CLK    => CLK,
            RAZ    => RAZ,
            SORTIE => Enable
        );

    -- Display the 16-bit Fibonacci value as 4 hexadecimal digits
    dec_0: seven_seg port map(data(3 downto 0),   unite);
    dec_1: seven_seg port map(data(7 downto 4),   dizaine);
    dec_2: seven_seg port map(data(11 downto 8),  centaine);
    dec_3: seven_seg port map(data(15 downto 12), millier);

    -- UART baud rate generation
    BaudGen1: BaudGen
        port map(
            CLK     => Clk,
            VITESSE => VITESSE,
            BaudEn  => BaudEn
        );

    -- UART transmitter instance
    USART1: USART
        port map(
            Clk     => Clk,
            RAZ     => Raz,
            StartTr => StartTr_int,
            BaudEn  => BaudEn,
            DataIn  => data_char,
            TxD     => TxD
        );

    -- Export internal overflow signal to top-level output
    Carry <= carry_sig;

    -- Automatically trigger UART transmission at each 1 Hz update
    StartTr_int <= Enable;

    -- Select UART status character depending on overflow state
    process(carry_sig)
    begin
        if carry_sig = '1' then
            data_char <= "01000101"; -- ASCII 'E' = Error / Overflow
        else
            data_char <= "01000010"; -- ASCII 'B' = Valid Fibonacci value
        end if;
    end process;

end structur;