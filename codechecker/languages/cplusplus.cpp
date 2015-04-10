#include <unistd.h>
#include <iostream>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <fstream>
#include <sys/types.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <signal.h>
#include <time.h>
#include <sstream>
#include <ulimit.h>

#define HOME_DIRECTORY "/home/suraj/Desktop/coderunner/codechecker/"
#define MAX 1000

using namespace std;


void signal_handler(int);
void setlimit(int);
void execute_file(int, string, string);

void signal_handler(int signum)																	//HANDLES THE RESOURCE MANAGEMENT
{
	cout<<"TIME LIMIT EXCEEDED"<<endl<<endl;																	//IF TIME LIMIT EXCEEDS, FLAG=1
    exit(0);
}

int main(int argc, char* argv[])
{
	string test_file,operation,path_test_file = HOME_DIRECTORY;
	string compilation_error_file = HOME_DIRECTORY;
	string problem_name = argv[8];
	test_file = argv[2];
	path_test_file += problem_name + "/";
	compilation_error_file += problem_name + "/compilation_error_file.txt";
	operation = "g++ "+ path_test_file + test_file + " -o " + path_test_file + "test" + " 2>" + compilation_error_file;
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

			setlimit(time_limit);
		
			clock_gettime(CLOCK_REALTIME, &start_time);
			/*struct sigaction act[3];
			act[i].sa_handler = signal_handler;
			sigemptyset(&act[i].sa_mask);
			act[i].sa_flags = 0;
			sigaction(SIGXCPU,&act[i],0);*/

			execute_file(i,problem_name,argv[4]);

			clock_gettime(CLOCK_REALTIME, &end_time);
			exec_time = ( end_time.tv_sec - start_time.tv_sec ) + ( end_time.tv_nsec - start_time.tv_nsec )/1000000000.0;        //EXECUTION TIME
    		//cout<<"FILE "<<i<<"  "<<exec_time<<endl;															//SIGNAL HANDLER FOR TIME LIMIT
			exit(20);
		}	
		else
		{
			waitpid(-1,&status,0);
		}
	}
	return 0;
}

void execute_file(int file_number, string problem_name, string string_time_limit)
{
	int i,j;
	string path_output_directory = HOME_DIRECTORY; 
	//string operation = "ulimit -t ";
	string operation = "LD_PRELOAD=/home/suraj/Desktop/coderunner/codechecker/EasySandbox/EasySandbox.so ";
	string path_input_directory = HOME_DIRECTORY;
	string path_log_file_directory = HOME_DIRECTORY;
	string path_executable_directory = HOME_DIRECTORY;

	path_output_directory += problem_name + "/output/";
	path_input_directory += problem_name + "/input/";
	path_log_file_directory += problem_name + "/log_files/";
	path_executable_directory += problem_name + "/";
	
	j=file_number%10; i=file_number/10;
	stringstream s1,s2;string num1,num2;
	s1<<i;
	s2<<j;
	num1= s1.str();
	num2 = s2.str();

	string input_filename = path_input_directory + "input" + num1 + num2 + ".txt";
	string output_filename = path_output_directory + "output" + num1 + num2 + ".txt";
	string log_filename = path_log_file_directory + "log_file" + num1 + num2 + ".txt";
	setlimit(timelimit);
	//operation = operation + string_time_limit + ";" + path_executable_directory + "./test <"+ input_filename + " >" + output_filename + " 2>" + log_filename;
	operation = operation + path_executable_directory + "./test <"+ input_filename + " >" + output_filename + " 2>" + log_filename;
	system(operation.c_str());
}
	
void setlimit(int time_limit)																		//SETS THE RESOURCE LIMIT
{
	struct rlimit rl; 
    rl.rlim_cur = time_limit;
    rl.rlim_max = time_limit + 1;
    setrlimit(RLIMIT_CPU, &rl);  
}
