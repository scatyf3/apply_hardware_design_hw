---
title: Simple Scalar Function Module 
parent: Basic Digital Logic
nav_order: 1
has_children: false
---

# A Simple Module and Testbench

## A Scalar Function Module

All the code for the demo is in the directory:
~~~bash
    hwdesign/demos/basic_logic
~~~
To illustrate the most simple logic, we implement
a simple scalar function of two variables.
In the directory `basic_logic`, the code is in 
`simp_fun.sv`.  This file is in **SystemVerilog**,
a so-called **Register Transfer Language** or RTL
that describes the functionality that is to occur in each clock cycle.  The code in `simp_fun.sv` is quite self-explanatory:

* The top of the module defines its inputs and outputs:
~~~systemverilog
    module simp_fun #(
        parameter WIDTH = 16
    )(
        input  logic              clk,
        input  logic              rst,   // synchronous reset
        input  logic [WIDTH-1:0]  a_in,
        input  logic [WIDTH-1:0]  b_in,
        output logic [WIDTH-1:0]  c_out
    );
~~~
The inputs are two operands `a_in` and `b_in` as well as a clock and reset.
The outpus is `c_out`.  They have a programmable bitwidth.

* The inputs are registered on each clock cycle:
~~~systemverilog
    // Register the inputs
    always_ff @(posedge clk) begin
        if (rst) begin
            a_reg <= '0;
            b_reg <= '0;
        end else begin
            a_reg <= a_in;
            b_reg <= b_in;
        end
    end
~~~

* The output is computed with a simple function like multiplication.
The output is not registered.  Instead it is the ouptut of a
**combinational path** so that it is available within the propagation delay 
from registering the inputs.
~~~systemverilog
    // Registered output
    always_comb begin
       c_out = a_reg * b_reg;
    end
~~~


## A Simple Testbench

The testbench is in `tb_simp_fun.sv` and is also a SV file.
It loops through a set of values for `a` and `b` and feeds them to the module.
In each case, the module output is read and displayed.



---

Go to [Simulating the example](./simulation.md).