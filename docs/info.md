<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works
![Board](1758819126776.jpeg)

It’s a 4-state Moore FSM with states: idle → product_selected → (dispense_product | return_change) → idle.
Inputs :
coin (1 bit): a pulse meaning “money inserted”.
btn (2 bits): user choice while in product_selected. "11" → dispense product "01" → return change "10" → cancel (go back to idle) "00" → wait (stay in product_selected)

Outputs (Moore)
dispense = '1' only while in dispense_product (exactly one clock cycle).
change = '1' only while in return_change (exactly one clock cycle).

Timing/Reset
reset is asynchronous, active-high: immediately sends the FSM to idle.
State updates on the rising edge of clk. Inputs are sampled synchronously; give them setup/hold around the rising edge.
The “one-cycle pulse” behavior comes from those terminal states automatically returning to idle on the next clock.

## How to test
Scenarios exercised:
Scenario 1: coin pulse, then btn="11" → expect one cycle dispense='1', change='0'.
Scenario 2: coin pulse, then btn="01" → expect one cycle change='1', dispense='0'.
Scenario 3: coin pulse, then btn="10" (cancel) → no pulses, returns to idle.
Scenario 4: coin pulse, wait with btn="00", later btn="11" → eventually one cycle dispense='1'

PS: You should see each pulse aligned to a clock and lasting exactly one period.

On hardware (if you map it to a top):
Invert an active-low board reset (use reset <= not rst_n).
Drive coin from a button/DIP; drive btn(1 downto 0) from two buttons/DIPs.
Observe dispense/change on LEDs.
For clean behavior, add synchronizers + debouncing to real buttons.

## External hardware

FPGA demo (optional):
2x pushbuttons (or switches) → btn(1:0)
1x pushbutton (or switch) → coin
2x LEDs → dispense, change
System clock & reset.
