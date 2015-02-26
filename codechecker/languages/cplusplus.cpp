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
#define MAX 100000

using namespace std;


void sighandler(int);
void setlimit(int);
void execute_file(int, string);


int main(int argc, char* argv[])
{
	string test_file,operation,path_test_file = HOME_DIRECTORY;
	string problem_name = argv[8];
	test_file = argv[2];
	path_test_file += problem_name + "/";
	string compilation_error_file = HOME_DIRECTORY;
	compilation_error_file += problem_name + "/compilation_error_file.txt";
	operation = "g++ "+ path_test_file + test_file + " -o test" + " 2>" + compilation_error_file;
	system(operation.c_str());																			//COMPILATION OF THE TEST FILE
	
	int length=0;
	ifstream diff_file;
	diff_file.open((compilation_error_file).c_str(), ios::binary);
	diff_file.seekg(0,ios::end);
	length = diff_file.tellg();

	if(length !=0)
	{
		cout<<"COMPILATION ERROR"<<endl;
		return 1;
	}	
	
	int files_count = atoi(argv[6]),i, time_limit = atoi(argv[4]);

	pid_t pids[MAX];
	int status;
	for(i=0; i<files_count; i++)
	{
		//signal(SIGXCPU, sighandler);
		pids[i] = fork();
		if(pids[i] < 0)
		{
			perror("Process could not be created");
			abort();
		}
		else if(pids[i] == 0 )
		{	
			struct timespec start_time,end_time;
			double exec_time;																	
  			//setlimit(time_limit);
			clock_gettime(CLOCK_REALTIME, &start_time);
			
			execute_file(i,problem_name);	
			
			clock_gettime(CLOCK_REALTIME, &end_time);
			exec_time = ( end_time.tv_sec - start_time.tv_sec )+( end_time.tv_nsec - start_time.tv_nsec )/1000000000.0;        //EXECUTION TIME
    		cout<<exec_time<<endl;													//SIGNAL HANDLER FOR TIME LIMIT
			exit(0);
		}	
		else
		{
			waitpid(-1,&status,0);
		}
	}
	return 0;
}

void execute_file(int file_number, string problem_name)
{
	int i,j;
	string path_output_directory = HOME_DIRECTORY, operation = "./test ";
	string path_input_directory = HOME_DIRECTORY;
	
	path_output_directory += problem_name + "/output/";
	path_input_directory += problem_name + "/input/";
	
	j=file_number%10; i=file_number/10;
	stringstream s1,s2;string num1,num2;
	s1<<i;
	s2<<j;
	num1= s1.str();
	num2 = s2.str();

	string input_filename = path_input_directory + "input" + num1 + num2 + ".txt";
	string output_filename = path_output_directory + "output" + num1 + num2 + ".txt";

	operation = operation + " <"+ input_filename + " >" + output_filename;
	system(operation.c_str());
}

void sighandler(int signum)																	//HANDLES THE RESOURCE MANAGEMENT
{
	printf("Time limit exceeded\n");																		//IF TIME LIMIT EXCEEDS, FLAG=1
    exit(1);
}
	
void setlimit(int time_limit)																		//SETS THE RESOURCE LIMIT
{
	struct rlimit64 rl; 
	getrlimit64(RLIMIT_CPU, &rl); 
    rl.rlim_cur = time_limit;
    setrlimit64(RLIMIT_CPU, &rl);  
}
