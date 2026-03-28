# Bit Manipulation Unit Project

## Overview
The Bit Manipulation Unit (BMU) project is designed to provide various bit manipulation operations efficiently. This document outlines the key components, testbench architecture, interfaces, sequences, and instructions for usage.

## Design Components
1. **Bit Manipulation Unit**: This is the core module that implements various bit operations such as AND, OR, NOT, XOR, shift left, shift right, and others.
2. **Control Unit**: This unit manages the operation execution based on the input commands.
3. **Data Path**: The data path handles the data flow within the BMU.
4. **Status Register**: A register that holds the status of the last operation performed.

## Testbench UVM Architecture
The testbench for the BMU is built using the UVM (Universal Verification Methodology) framework, which allows for a structured verification process:
- **Environment**: The top-level component that includes all other components (drivers, monitors, sequencers, etc.).
- **Agent**: Responsible for communicating with the BMU. It includes a driver that drives the signals and a monitor that observes the signals.
- **Sequencer**: Generates the sequences of operations to be sent to the BMU.
- **Driver**: Converts sequences from the sequencer into pin-level activity.
- **Scoreboard**: Compares the expected outcomes with the actual results.

## Interfaces
The BMU comprises several interfaces:
- **Command Interface**: Accepts commands for operations to be performed on the input bits.
- **Status Interface**: Provides the status of operation execution, including error handling.
- **Data Interface**: Handles data input and output operations.

## Sequences
Examples of sequences that can be executed include:
1. **AND Operation Sequence**: Takes two inputs and executes the AND operation.
2. **OR Operation Sequence**: Takes two inputs and executes the OR operation.
3. **Shift Sequence**: Allows left or right shifts of the input data.

## Usage Instructions
1. Clone the repository: `git clone https://github.com/Rayyr/OTI_Final_Project.git`
2. Navigate to the project directory: `cd OTI_Final_Project`
3. Compile the BMU module: `make compile`
4. Run the simulations: `make run`
5. Analyze results in the `results` folder.

For further information, please refer to the individual component documentation provided in the repository.