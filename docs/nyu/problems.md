---
title: Submitting Problem Sets
parent: NYU class
nav_order: 1
has_children: true
---

# Submitting Problem Sets

## Overview

A small component of the course is based on problem sets with each unit.
These are not worth much of the overall grade, and you can any tool you want to solve 
the problems -- including AI and your friends.  Whatever helps you learn.
Just remember, you will need to be able to complete comparable problems on the midterm and final 
**without these aids**.  So, use the submission process as part of the learning process.

We are experimenting with an [AI-Autograder](../aiautograder/) for grading problem sets.
If successful, you will be able to get immediate, detailed feedback from an AI engine.
Follow the following steps to prepare and submit solutions. 

## Problem Set Submission

In each unit, you will find a directory such as:

```bash
hwdesign/
└── units/
    └── unit01_basic_logic/
        └── prob/
            ├── basic_logic_prob.tex
            └── basic_logic_prob.pdf
```

The file, such as `basic_logic_prob.tex`, is the source
latex file for the problems to be answered and `basic_logic_prob.pdf`
is the compiled version.  The latex files have the following structure.

```latex
<front matter>
\beign{enumerate}

\item Question 1  

\begin{solution}  Enter your solution here
\end{solution}

\item Question 2
\begin{solution}  Enter your solution here
\end{solution}
...
\end{enumerate}
```

Rename the file, say `my_soln.tex`, and 
just fill in each solution section for the requested problems
and submit the file, `my_soln.tex`.  Do not submit the PDF.
You do not need to compile the `tex` file.  In fact, it
does not even need to compile.  The grader or auto-grader will just directly look at the text.
Since we are using a simple grader, it will not look at any figures.  
So, you do not need to submit anything more than text.  But, for the midterm and final,
you will have to know how to draw the figures if requested.


## Running the Auto-Grader Yourself

Before submitting, use our [LLM-Based Autograder Tool](../aiautograder/) to check your answers.
That tool will compare your answer with a pre-loaded correct answer and give you feedback.
You can use this tool as many times as you like to ensure you have a perfect submission.


## Feedback, Please!  

This is all experimental,  so not sure how well this work.  
We are entering a new era for teaching.  We would love to get your feedback.

