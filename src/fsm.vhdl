library ieee;
use ieee.std_logic_1164.all;
-- (No non-standard arithmetic packages; none are needed here.)

entity vending_machine is
  port (
    clk      : in  std_logic;                    -- Clock input
    reset    : in  std_logic;                    -- Async, active-high reset
    coin     : in  std_logic;                    -- Coin detected
    btn      : in  std_logic_vector(1 downto 0); -- Buttons (selection/cancel/etc.)
    dispense : out std_logic;                    -- Dispense pulse (Moore)
    change   : out std_logic                     -- Change/refund pulse (Moore)
  );
end vending_machine;

architecture rtl of vending_machine is

  -- Four-state FSM (unchanged)
  type state_type is (idle, product_selected, dispense_product, return_change);
  signal current_state, next_state : state_type;

begin

  --------------------------------------------------------------------------

  --------------------------------------------------------------------------
  process(clk, reset)
  begin
    if reset = '1' then
      current_state <= idle;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process;

  --------------------------------------------------------------------------

  --------------------------------------------------------------------------
  process(current_state, coin, btn)
  begin
    next_state <= current_state;  -- default: hold

    case current_state is
      when idle =>
        if coin = '1' then
          next_state <= product_selected;
        end if;

      when product_selected =>
        if    btn = "11" then
          next_state <= dispense_product;  -- select/confirm
        elsif btn = "01" then
          next_state <= return_change;     -- ask for change/refund
        elsif btn = "10" then
          next_state <= idle;              -- cancel
        else
          next_state <= product_selected;  -- keep waiting for a choice
        end if;

      when dispense_product =>
        next_state <= idle;                -- one-cycle dispense pulse

      when return_change   =>
        next_state <= idle;                -- one-cycle change/refund pulse
    end case;
  end process;

  --------------------------------------------------------------------------

  --------------------------------------------------------------------------
  with current_state select
    dispense <= '1' when dispense_product,
                '0' when others;

  with current_state select
    change   <= '1' when return_change,
                '0' when others;

end architecture rtl;
