library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tt_um_vhdl_fsm is
    port (
        ui_in   : in  std_logic_vector(7 downto 0);
        uo_out  : out std_logic_vector(7 downto 0);
        uio_in  : in  std_logic_vector(7 downto 0);
        uio_out : out std_logic_vector(7 downto 0);
        uio_oe  : out std_logic_vector(7 downto 0);
        ena     : in  std_logic;  -- unused
        clk     : in  std_logic;
        rst_n   : in  std_logic
    );
end tt_um_vhdl_fsm;

architecture rtl of tt_um_vhdl_fsm is
    signal reset_s    : std_logic;  -- active-high internal reset
    signal dispense_s : std_logic;
    signal change_s   : std_logic;
begin
    -- Convert active-low board reset to active-high internal reset
    reset_s <= not rst_n;

    -- Keep uio pins as inputs (don’t drive them)
    uio_out <= (others => '0');
    uio_oe  <= (others => '0');

    -- Map outputs: bit0=dispense, bit1=change, others low
    uo_out(0) <= dispense_s;
    uo_out(1) <= change_s;
    uo_out(7 downto 2) <= (others => '0');

    -- FSM instance
    u_vm : entity work.vending_machine
        port map (
            clk      => clk,
            reset    => reset_s,          -- active-high
            coin     => ui_in(0),         -- coin input
            btn      => ui_in(2 downto 1),-- 2-bit buttons
            dispense => dispense_s,
            change   => change_s
        );
end rtl;
