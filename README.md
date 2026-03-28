# Bit Manipulation Unit Project

## Overview
The Bit Manipulation Unit (BMU) project is designed to provide various bit manipulation operations efficiently. This document outlines the key components, testbench architecture, interfaces, sequences, and instructions for usage.

### Directory Structure

- `Design/packages&libs/` - Source file for the project design.
  - `Bit_Manibulation_Unit.sv`  

- `TestBench/` - UVM Components , Design interface
  - `TestBench/UVM_components/`
  - `TestBench/interfaces/`

- `BMU verification plan.docs` - The used verification plan.
- `BMU final report.docs` - Final project results.
- `specs.pdf` - Project given specification.
  
## Design Components
1. **Bit Manipulation Unit**: This is the core module that implements various bit operations such as AND, OR, NOT, XOR, shift left, shift right, and others.
2. **Control Unit**: This unit manages the operation execution based on the input commands.
3. **Data Path**: The data path handles the data flow within the BMU.


## Testbench UVM Architecture
The testbench for the BMU is built using the UVM (Universal Verification Methodology) framework, which allows for a structured verification process:
- **Environment**: The top-level component that includes all other components (drivers, monitors, sequencers, etc.).
- **Agent**: Responsible for communicating with the BMU. It includes a driver that drives the signals and a monitor that observes the signals.
- **Sequencer**: Generates the sequences of operations to be sent to the BMU.
- **Monitor**: Observes and captures the DUT (Design Under Test) outputs and input signals, creating transaction-level information from pin-level activity for
  analysis and verification.
- **Sequence**: Defines the stimulus patterns and test scenarios to be applied to the BMU, including specific operation sequences and edge cases for comprehensive 
  coverage.
- **Driver**: Converts sequences from the sequencer into pin-level activity.
- **Scoreboard**: Compares the expected outcomes with the actual results.
- **Subscriber**: Receives and processes monitored transactions from the monitor,performing real-time analysis, data collection, and coverage tracking for 
  advanced verification metrics.
 

## Usage Instructions
1. Clone the repository: `git clone https://github.com/Rayyr/OTI_Final_Project.git`
2. Navigate to the project directory: `cd OTI_Final_Project/TestBench/UVM_components/top.sv`
3. Include the operation sequences you need to verify : `include "/final_project/TestBench/UVM_components/sequences/.."
4. Run the test you need : run_test("op_test") in top.sv ;
5. Go to terminal and write the following cmds to run it :
   - **xrun -uvm -access +rwc -debug_opt verisium_interactive top.sv -coverage all -covworkdir coverage_db**
