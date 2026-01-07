---
title: AI-Based Autograding
parent: NYU class
nav_order: 1
has_children: true
---

# AI-Based Autograding

## Overview
As an experimental part of the project, we are attempting 
to build an LLM-based autograder.  Right now, it only works
on text based problems with no figures.  If successful,
you will be able to get immediate AI feedback on your problems
without waiting for office hours.

## Manual grading

We first discuss the process for manual grading,
which will likely need to be done in many cases, since we are
just building the auto-grader.
In each unit, you will find a directory such as:

```bash
hwdesign/
└── units/
    └── basic_logic/
        └── prob/
            ├── basic_logic_prob.tex
            ├── basic_logic_prob.pdf
            └── grade_schema.csv
```

The file, such as `basic_logic_prob.tex`, is the source
latex file for the problems to be answered and `basic_logic_prob.pdf`
is the compiled version.
For standard grading, you should complete the 
solutions to the requested problems, scan them,
create a PDF and submit the PDF on Gradescope.
Do not submit the source latex.  You are free to use any way to write the
solutions.  You can latex the solutions, but you can also just handwrite 
them and scan them.


## AI-Based Autograding
We are also experimenting with AI-based autograding.
The problem file, such as `basic_logic_prob.tex`, has the following format:

```latex
\beign{enumerate}

\item Question 1  

\begin{solution}  Enter your solution here
\end{solution}

\item Question 2
\begin{solution}  Enter your solution here
\end{solution}
...
```
Rename the file, say `my_soln.tex`, and 
just fill in each solution section for the requested problems
and submit the file, `my_soln.tex`.  
You do not need to compile the `tex` file.  In fact, it
does not even need to compile.  The AI-autograder
will try to compare your solution with a reference solution 
and grading notes to compare accuracy.

You can check to see if the solution is parsed correctly
activatng the virtual environment with `xilinxutilss` and running:

```bash
check_latex_soln --solution my_soln.tex -schema grade_schema.csv -o parsed_text.txt
```

Then inspect `parsed_text.txt` to check that it detected and parsed
your solutions to the problem.  
Our plan is that you will be given an unlimited number of 
attempts until all the problems are correct.

## Running the Auto-Grader Yourself
If you are provided the correct solutions, you can use
AI to compare the solutions yourself.  Suppose you are given
the correct solutions, `basic_prob_soln.tex`.  
In these solutions, you will see there are one correct set
of solutions for each problem, plus potentially some `gradingnotes` to help the AI grader.  

You can then call the AI grader yourself by first activating
the virtual environment with the `xilinxutils` package and then running:

```bash
    autograde_llm_latex --ref basic_prob_soln.tex --student my_soln.tex --schema grading_schema.csv --output results.tex [--model model]
```

The AI engine will attempt to provide feedback on the problems and put them in `results.txt`.

The `model` parameter by default is by default `gpt-5-mini` in the [OpenAI model](https://platform.openai.com/docs/models).  You can select a more complex model.  You will need to get 
an anccount from the [OpenAI platform](https://platform.openai.com/docs/overview), get an OpenAI key and store it in your environment variables.


## Feedback, Please!  

This is all experimental,  so not sure how well this work.  
We are entering a new era for teaching.  We would love to get your feedback.

