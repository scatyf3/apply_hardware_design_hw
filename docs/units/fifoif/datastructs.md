---
title: Data structures
parent: Command-Response FIFO Interface
nav_order: 1
has_children: false
---

# Command and Response Data Structures

## Scalar Function Example
Similar to the [scalar function example](../scalar_fun/), we consider again implementing
a simple function of two variables.  In this unit, we will consider another simple scalar function
~~~C
    int c = a*b;
    int d = a+b; 
~~~
which takes two inputs `a` and `b` and two outputs `c` and `d`.  Obviously, again, this function is too simple to implement in a custom hardware accelerator.  The point is to illustrate general principles that
can be applied later to more complex functions.

Now, in the scalar function example, the inputs and outputs were written and read via
AXI-Lite registers.  As mentioned earlier, when this interface is used, the IP cannot do anything while the PS prepares the data and reads and writes the registers.  Hence, the IP often goes under-utilized.  The lack of utilization can be particularly high when the PS is occupied with other tasks as is common in more complex designs.  In this case, there can be a long unused period where the IP is waiting for the next input.
In addition, the PS must continuously poll the IP waiting for the response.

The **command-response interface** provides a more efficient method for interaction with the IP that enables
higher utilization on both the IP and PS.  To illustrate the interface, the repository contains a simple example in
~~~bash
    hwdesign/fifoif/fifo_fun_vitis
~~~ 

## Data Structures

In the command-response interface, the IP performs a sequence of **jobs**.
The instructions for each job is described by a **command** and the output is a **response**.
When the IP interfaces to the processing system (PS), the PS will send commands and then receive the responses.

For this class, we will follow a common convention and describe the command and response by data structures.
For the scalar function FIFO command-response function, the data structure for the command is in the file
`fifo_fun_vitis/src/cmd.h` which contains the data structure:
~~~C
class Cmd {
public:

    ap_int<16> trans_id; // Transaction ID
    ap_int<32> a; // Operand A
    ap_int<32> b; // Operand B
    ...
};
~~~
The structure has the two operands `a` and `b` along with a **transaction ID** `trans_id`.  
Each job is given a transaction ID which is echoed back in the response.  In this way,
missing or out-of-order responses can be tracked.
Similarly, the **response** is given in the file 
`fifo_fun_vitis/src/cmd.h` which contains the data structure:
~~~C
class Resp {
public:

    enum ErrCode : unsigned int {
        NO_ERR = 0,
        SYNC_ERR = 1
    };

    ap_int<16> trans_id; // Transaction ID
    ap_int<32> c; // Operand C
    ap_int<32> d; // Operand D
    ap_uint<8> err_code; // Error Code
    ...
};
~~~
Here, `c` and `d` are the outputs, `trans_id` is the echo of the ID from the command,
and `err_code` is an error code that indicates if there was some problem processing the command.

In addition to the fields in the data structure, there are a large number of functions
for processing the structure, particularly packing and unpacking the data from streams.

