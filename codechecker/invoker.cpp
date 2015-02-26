//CALL THIS FILE AS ./A.OUT -N TEST_FILENAME -M PROBLEM_NAME -T TIME_LIMIT	

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
	string path_codechecker_directory = HOME_DIRECTORY,test_filename = argv[2],codechecker_filename ="codechecker.cpp";
	string operation1 = "g++ ", codechecker_out_filename= "codechecker",problem_name = argv[4];
	string operation2 = "./", time_limit = argv[6];
	operation1 = operation1 + path_codechecker_directory + codechecker_filename + " -o " + codechecker_out_filename;
	operation2 = operation2 + codechecker_out_filename + " -n " + test_filename + " -m " + problem_name + " -t " + time_limit;
	system(operation1.c_str());
	system(operation2.c_str());
	return 0;
}