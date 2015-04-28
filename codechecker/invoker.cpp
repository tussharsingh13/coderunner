//CALL THIS FILE AS ./A.OUT -N TEST_FILENAME -M PROBLEM_NAME -C CONTEST_NAME -T TIME_LIMIT -F MEMORY_LIMIT	
//							 1		2		  3		4		  5		6		  7		8		9	    10     
#include<unistd.h>
#include<iostream>
#include<stdlib.h>
#include<string.h>
#include<stdio.h>
#include<fstream>
#include<sys/types.h>
#include<unistd.h>
#include<sys/time.h>
#include<sys/resource.h>
#include<sys/wait.h>
#include<signal.h>
#include<time.h>
#include<sstream>

#define HOME_DIRECTORY "/home/suraj/Desktop/coderunner/codechecker/"

using namespace std;

int main(int argc, char* argv[])
{
	string test_filename = argv[2], problem_name = argv[4], contest_name = argv[6], time_limit = argv[8], memory_limit = argv[10];
	string path_codechecker_directory = HOME_DIRECTORY,codechecker_filename ="codechecker.cpp";
	string executable_name = test_filename;
	executable_name.erase(executable_name.end()-4,executable_name.end());

	string operation1 = "g++ ", codechecker_out_filename = executable_name + "_codechecker";
	string operation2 = "./";
	operation1 = operation1 + path_codechecker_directory + codechecker_filename + " -o " + codechecker_out_filename;
	operation2 = operation2 + codechecker_out_filename + " -n " + test_filename + " -m " + problem_name + " -t " + time_limit + " -c " + contest_name + " -f " + memory_limit;
	system(operation1.c_str());
	system(operation2.c_str());
	return 0;
}


//    ./a.out -n problem01.cpp -m problem01 -c contest01 -t 1 -m 100
