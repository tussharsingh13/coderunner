//  ./cplusplus -n test_filename -t time_limit -m count_files -p problem_name -c contest_name -f memory_limit
//               1	    2		  3	     4		5      6       7      8        9        10    11      12
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
#define MAX 110

using namespace std;


void signal_handler(int);
void setlimit(int);
void execute_file(int, string, string, string, string, string);

void signal_handler(int signum)																	
{
	cout<<"TIME LIMIT EXCEEDED"<<endl<<endl;
    exit(0);
}

int main(int argc, char* argv[])
{
	string test_file = argv[2], problem_name = argv[8], contest_name = argv[10], memory_limit = argv[12];
	int time_limit = atoi(argv[4]), files_count = atoi(argv[6]);
	
	string executable_name = test_file;
	executable_name.erase(executable_name.end()-4,executable_name.end());								

	string path_test_file = HOME_DIRECTORY;  path_test_file += contest_name + "/" + problem_name + "/user_codes/";
	string compilation_error_file = HOME_DIRECTORY;  compilation_error_file += contest_name + "/" + problem_name + "/compilation_error_files/" + executable_name + "_compilation_error_file.txt";
	string result_file = HOME_DIRECTORY;   result_file += contest_name + "/" + problem_name + "/results/" + executable_name + "_result.txt";

	string operation;
	operation = "g++ "+ path_test_file + test_file + " -o " + path_test_file + executable_name + " 2>" + compilation_error_file;
	system(operation.c_str());	

	int length = 0;
	ifstream diff_file;
	diff_file.open((compilation_error_file).c_str(), ios::binary);
	diff_file.seekg(0,ios::end);
	length = diff_file.tellg();

	if(length !=0)
	{
		cout<<test_file<<" "<<"COMPILATION ERROR"<<endl;
		return 1;
	}	

	pid_t pids[MAX];
	int status;
	for(int i=0; i<files_count; i++)
	{
		pids[i] = fork();

		if(pids[i] < 0)
		{
			perror("Process could not be created");
			abort();
		}
			
		else if(pids[i] == 0 )
		{	
			//struct timespec start_time,end_time;
			//double exec_time;																	

			//clock_gettime(CLOCK_REALTIME, &start_time);

			execute_file(i, problem_name, argv[4], executable_name, contest_name, executable_name);

			//clock_gettime(CLOCK_REALTIME, &end_time);

			//exec_time = ( end_time.tv_sec - start_time.tv_sec ) + ( end_time.tv_nsec - start_time.tv_nsec )/1000000000.0;        //EXECUTION TIME

			exit(20);
		}	
		
		else
		{
			waitpid(-1,&status,0);
		}

	}
	
	return 0;
}

void execute_file(int file_number, string problem_name, string string_time_limit,string test_file, string contest_name, string executable_name)
{
	int i,j;
	string operation = "ulimit -t ";
	string path_output_directory = HOME_DIRECTORY; 
	string path_input_directory = HOME_DIRECTORY;
	string path_log_file_directory = HOME_DIRECTORY;
	string path_executable_directory = HOME_DIRECTORY;

	path_output_directory += contest_name + "/" + problem_name + "/generated_output/";
	path_input_directory += contest_name + "/" + problem_name + "/input/";
	path_log_file_directory += contest_name + "/" + problem_name + "/log_files/";
	path_executable_directory += contest_name + "/" + problem_name + "/user_codes/";
	
	j=file_number%10; i=file_number/10;
	stringstream s1,s2;string num1,num2;
	s1<<i;
	s2<<j;
	num1= s1.str();
	num2 = s2.str();

	string input_filename = path_input_directory + "input" + num1 + num2 + ".txt";
	string output_filename = path_output_directory + "/" + executable_name + "_output" + num1 + num2 + ".txt";
	string log_filename = path_log_file_directory + "/" + executable_name + "_log_file" + num1 + num2 + ".txt";

	operation = operation + string_time_limit + ";" + path_executable_directory + "./" + test_file + " <"+ input_filename + " >" + output_filename + " 2>" + log_filename;
	system(operation.c_str());
}
	
void setlimit(int time_limit)																		//SETS THE RESOURCE LIMIT
{
	struct rlimit rl; 
    rl.rlim_cur = time_limit;
    rl.rlim_max = time_limit + 1;
    setrlimit(RLIMIT_CPU, &rl);  
}
