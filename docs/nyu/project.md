---
title: Class Project
parent: NYU class
nav_order: 2
has_children: true
---
# Project Guidelines

## Overview
As part of this course, you will complete a hardware design project on a topic of your choice. Your goal is to design and implement a hardware IP block or accelerator in any domain that interests you — robotics, scientific computing, wireless communication, graphics, compression, cryptography, or anything else you find compelling.

Your project must include:
- A clearly defined hardware IP block (RTL or HLS)
- A well‑specified interface and integration model with a host system
- A testbench and evaluation methodology
- Documentation that allows others to reproduce your results

The expected scope is roughly equivalent to 3-4 weeks of focused engineering work for a small team.

Note:   Since the physical FPGA boards are limited at this point, it is completely acceptable if your submission is entirely in simulation.  That being said, you are more than welcome to deploy your IP on real hardware.  The NYU Wireless lab may have some more powerful RFSoC boards
if you need hardware for wireless communications.  Just let me know.

---

## Groups
You must work in a group of **2 to 4 students**.  
Individual projects are **not permitted** unless you receive explicit approval from the instructor.

---

## Submission Requirements
All work must be submitted through a **GitHub repository** that you create for this project (e.g., `hwdesign_project`).  
Place **all** project materials in this repository, including:

- Source code (RTL/HLS, host code, scripts)
- Testbenches and simulation artifacts
- Synthesis reports and evaluation results
- Documentation, diagrams, and presentation materials
- A top‑level `README.md` with build/run instructions

Your submission on Gradescope will consist of a single file containing:

- The **URL** of your GitHub repository  
- The **names and NetIDs** of all group members

The instructor will grade your project directly from the repository.  
Your repo should be organized so that a technically skilled reader can reproduce your results without guesswork.

---

## Grading (25 points total)

### 1. IP Definition and Interface (5 points)
- Is the purpose of the IP clearly defined and appropriate for the chosen task?  
- Is the boundary between hardware and software well‑justified?  
- Are the interfaces (e.g., AXI, custom handshake, streaming) clearly documented and sensible?

---

### 2. IP Implementation (5 points)
- Is the implementation efficient, correct, and thoughtfully structured?  
- Is the code well‑commented, readable, and maintainable?  
- Are design choices explained (e.g., pipelining, buffering, parallelism)?

---

### 3. Evaluation (5 points)
- Is the testbench comprehensive and does it cover corner cases?  
- Are different design options or tradeoffs explored?  
- Are performance, resource usage, and area reported and interpreted?  
- Are results reproducible from the repository?

---

### 4. Development Process (5 points)
This component is graded **entirely from your GitHub commit history**.

Full credit requires:
- Regular, incremental commits over the duration of the project  
- Meaningful commit messages  
- Evidence of collaborative development  
- No “large dump” of code near the deadline

You are **encouraged to use AI tools**, but you must document:
- How you used AI  
- What prompts or workflows were effective  
- How you validated AI‑generated code

Include this in a short section of your README.

---

### 5. Presentation (5 points)
Your repository must include a clear, polished presentation of your project.  
This may take the form of:
- A README  
- A slide deck  
- A Jupyter notebook  
- A short video (optional)

Your presentation should communicate:
- The problem you solved  
- Your design and implementation  
- Your evaluation results  
- What you learned

Assume a prospective employer is skimming your GitHub page — make it compelling, clear, and professional.