---
title: Scalar Function
parent: Hardware Design
nav_order: 3
has_children: true
---

# Getting Started with a Scalar Function

In this unit, we will build our first *accelerator*, a simple function on scalars, such as adding two scalars.  The accelerator will run in the FPGA and read and write data to a processing system.   Obviously, this function is so simple there is no reason to use an FPGA or any custom hardware.  However the process introduces the essential steps for hardware/software co-design and illustrates the key components of the process.

By completing this demo, you will learn how to:

* Design and synthesize a simple **Vitis IP** that performs a basic mathematical operation using an **AXI-Lite interface**
* Simulate the synthesized Vitis IP and view the **timing diagrams** in a VCD
* Create a minimal **Vivado project** that integrates the IP
* Synthesize the design to generate a **bitstream**
* Build a **PYNQ overlay** that loads the bitstream onto the FPGA board and interact with the IP through Python



## Pre-Requirements
Prior to doing this demo, you will need to follow the [software set-up](../sw_installation/)
for Vitis, Vivado, and Python.  If you want to run the IP on the FPGA board, you
will need to purchase the board and follow the [hardwre set-up](../hw_setup/) as well. 
 

## Next Steps

If you want to build the IP, add it to the Vivado project, and create the overlay, start from the begining with [building the IP in Vitis HLS](./vitis_ip.md).

Alternatively, the github repo already includes a pre-built overlay file.  So, you can just skip to [accessing the Vitis IP from PYNQ](./pynq.md).



 
