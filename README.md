ONLINE JUDGE WITH A SPECIAL TOUCH

Online coding judge with the capability of Software Code Quality Analysis.

It contains the following functionalities: Contest Management, Code Evaluation, Plagiarism Detection, Comment Classification and Static Code Analysis. 

Contest Management includes contest creation, problem addition and participation by users. It uses AWS S3 Bucket for integration of client and server end. It acts as an intermediate storage platform for the server and the client side.
Developed using: Ruby on Rails, Amazon s3 buckets and Python

It checks the algorithmic correctness of the codes using test cases and algorithmic complexity by imposing time and memory limits. The user’s code is executed against some predefined test cases by matching the user’s output with the expected output and it should pass within the time and memory limit set in order to get accepted. This is how it does the Code Evaluation.
Developed using: C++

It checks for plagiarism amongst the accepted codes using the concept of Stanford’s MOSS (Method of Software Similarity).It modifies the codebase from the existing project: https://github.com/timfel/moss.rb 
Developed using: Ruby

Static Code Analysis looks for errors which the compiler can’t catch like uninitialized memory and null pointers. The online judge has been  with cppcheck, a well known Static Code Analysis tool for C/C++.

We have classified the comments into six categories on the basis of their context: Header, Task, Code, Section, Interface and Inline. This classification helps in analysing the importance given to comments in the given code.
We have performed the classification by using the Weka tool. We created our own dataset and then applied different Supervised Machine Learning algorithms in order to identify the best classifier.
Developed using: Weka
