//  ./out  -n test_filename -m problem_name -t time_limit -c contest_name -f memory_limit
//			1	    2		 3		4		 5 	   6	   7	   8	   9	  10
#include <unistd.h>
#include <iostream>
#include <stdio.h>
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
#include <sys/stat.h>


#define HOME_DIRECTORY "/home/suraj/Desktop/coderunner/codechecker/"																	
using namespace std;

int input_files_count(string, string);
int comparer(int,string, string, string, string, string, string, string);
bool exists(string);
bool check_file(string, string, string, string);
void deleteGeneratedFiles(string, string, string, string, string, string);
void displayOutput(string, string, string,string, string);

int main(int argc, char* argv[])
{	
	string test_filename = argv[2], problem_name = argv[4], time_limit = argv[6], contest_name = argv[8], memory_limit = argv[10];
	string filename,path_file,operation1,operation2;
	string checker_directory = "languages/"; 
	string path_log_file_directory = HOME_DIRECTORY; path_log_file_directory += contest_name + "/" + problem_name + "/log_files/";
	string diff_directory = HOME_DIRECTORY;  diff_directory += contest_name + "/" + problem_name + "/diff_directory/";
	string path_output_directory = HOME_DIRECTORY;  path_output_directory += contest_name + "/" + problem_name + "/generated_output/";
	path_file = HOME_DIRECTORY + checker_directory;

	int length_test_filename = test_filename.length();
	int count = input_files_count(problem_name, contest_name);
	stringstream s;string count_files;
	s<<count;

	count_files = s.str();

	string executable_name = test_filename;
	executable_name.erase(executable_name.end()-4,executable_name.end());

	if(test_filename[length_test_filename-1] == 'p' && test_filename[length_test_filename-2] == 'p' && test_filename[length_test_filename-3] == 'c')
	{
		filename = "cplusplus.cpp";
		operation1= "g++ "+ path_file + filename + " -o " + executable_name + "_cplusplus";
		operation2= "./" + executable_name + "_cplusplus -n "+ test_filename +" -t "+ time_limit + " -m " + count_files + " -p " + problem_name + " -c " + contest_name + " -f " + memory_limit;
		
		system(operation1.c_str());							
		if(exists(executable_name + "_cplusplus"))
			system(operation2.c_str());		
		else
		{
			cout<<endl<<"Server Error : "<<executable_name + "_cplusplus"<<" Not Found"<<endl<<endl;					
			return -1;
		}
	}

	int length=0;
	string compilation_error_file = HOME_DIRECTORY;
	compilation_error_file += contest_name + "/" + problem_name + "/compilation_error_files/" + executable_name + "_compilation_error_file.txt";
	
	if(exists(compilation_error_file))
	{
		ifstream diff_file;
		diff_file.open((compilation_error_file).c_str(), ios::binary);
		diff_file.seekg(0,ios::end);
		length = diff_file.tellg();
	}
	else
	{
		cout<<endl<<"Server Error : "<<compilation_error_file<<" Not Found"<<endl<<endl;
		return -1;
	}

	if(length == 0)
	{
		comparer(count,problem_name, path_output_directory, path_log_file_directory, diff_directory, test_filename, contest_name, executable_name);
	}	
	
	deleteGeneratedFiles(path_output_directory, diff_directory, path_log_file_directory, problem_name, contest_name, executable_name);
	
	return 0;
}

int input_files_count(string problem_name, string contest_name)																		
{
	int count = 0,flag=0;
	string path_input_directory = HOME_DIRECTORY;
	path_input_directory+= contest_name + "/" + problem_name + "/input/";	

	for(int i=0;i<=9;i++)
	{
		for(int j=0;j<=9;j++)
		{
			stringstream s1,s2;string num_str1,num_str2;
			s1<<i;
			s2<<j;
			num_str1 = s1.str();
			num_str2 = s2.str();
			string filename = path_input_directory + "input" + num_str1 + num_str2 + ".txt";
			if(exists(filename))
			{
				count++;
			}
			else
			{
				flag=1;
				break;
			}
		}
		if(flag==1)
			break;
	}	
	return count;													
}

bool exists(string filename)
{  
	struct stat buffer;
  	return (stat(filename.c_str(), &buffer) == 0); 
}
int comparer(int count_files, string problem_name, string path_output_directory, string path_log_file_directory, string diff_directory, string test_filename, string contest_name, string executable_name)	
{	
	int i,j,p;
	string path_actual_output_directory = HOME_DIRECTORY;path_actual_output_directory += contest_name + "/" + problem_name + "/output/";
	string result_file = HOME_DIRECTORY;   result_file += contest_name + "/" + problem_name + "/results/" + executable_name + "_result.txt";
	
	for(p=0;p<count_files;p++)
	{
		j = p%10; i = p/10;
		stringstream s1,s2;string num1,num2;
		s1<<i;
		s2<<j;
		num1 = s1.str();
		num2 = s2.str();	

		string output_filename = path_output_directory + executable_name + "_output" + num1 + num2 + ".txt";
		string actual_output_filename = path_actual_output_directory + "/output" + num1 + num2 + ".txt";
		string diff_filename = diff_directory + executable_name + "_diff" + num1 + num2 + ".txt";

		string operation = "diff ";
		operation += output_filename + " " + actual_output_filename + " > " + diff_filename;
	
		if(exists(output_filename))
			system(operation.c_str());

		else
		{
			cout<<endl<<"Server Error : "<<output_filename<<" Not Found"<<endl<<endl;
			return -1;
		}

		if(check_file(path_log_file_directory, num1,num2,executable_name + "_log_file") == -1)
		{
			cout<<endl<<"Server Error : "<<executable_name<<"_log_file"<<num1<<num2<<".txt"<<" Not Found"<<endl<<endl;
			return -1;
		}
		else if(check_file(path_log_file_directory, num1,num2,executable_name + "_log_file") == 0)
		{
			//cout<<test_filename<<" "<<"TLE"<<endl;
			displayOutput(path_log_file_directory, num1, num2,executable_name + "_log_file", test_filename);
			break;	
		}
		if(check_file(diff_directory,num1,num2,executable_name + "_diff") == -1)
		{
			cout<<endl<<"Server Error : "<<executable_name<<"_diff"<<num1<<num2<<".txt"<<" Not Found"<<endl<<endl;
			return -1;
		}
	    else if(check_file(diff_directory,num1,num2,executable_name + "_diff") == 0)
		{
			cout<<test_filename<<" "<<"WA"<<endl;
			break;
		}
		
	}
	if(p == count_files)
		cout<<test_filename<<" "<<"ACC"<<endl;
}


bool check_file(string directory, string num1, string num2, string name)
{
	string file_to_be_checked = directory;
	file_to_be_checked += name + num1 + num2 + ".txt";
	if(exists(file_to_be_checked))
	{
		int length=0;
		ifstream file;
		file.open(file_to_be_checked.c_str(), ios::binary);
		file.seekg(0,ios::end);
		length = file.tellg();
		if(length == 0)
		{
			return true;
		}
		else return false;
	}
	else
		return -1;
}

void displayOutput(string directory, string num1, string num2, string name, string test_filename)
{
	string file_to_be_checked = directory;
	file_to_be_checked += name + num1 + num2 + ".txt";

	ifstream infile(file_to_be_checked.c_str());

    if (infile.good())
    {
    	string sLine;
    	getline(infile, sLine);
    	
    	if(strcmp(sLine.c_str(),"Terminated")==0)
    			cout<<test_filename<<" "<<"RE (SIGTERM)"<<endl;

		else if(strcmp(sLine.c_str(),"Segmentation fault (core dumped)")==0)
			cout<<test_filename<<" "<<"RE (SIGSEGV)"<<endl;

		else if(strcmp(sLine.c_str(),"Illegal instruction (core dumped)")==0)
			cout<<test_filename<<" "<<"RE (SIGILL)"<<endl;

		else if(strcmp(sLine.c_str(),"Floating point exception (core dumped)")==0)
			cout<<test_filename<<" "<<"RE (SIGFPE)"<<endl;

		else if(strcmp(sLine.c_str(),"Aborted (core dumped)")==0) 
			cout<<test_filename<<" "<<"RE (SIGABRT)"<<endl;

		else if(strcmp(sLine.c_str(),"File size limit exceeded (core dumped)")==0) 
			cout<<test_filename<<" "<<"RE (SIGXFSZ)"<<endl;

		else if(strcmp(sLine.c_str(),"Killed")==0) 
			cout<<test_filename<<" "<<"RE (TLE)"<<endl;
    }

    infile.close();
}

void deleteGeneratedFiles(string path_output_directory, string diff_directory, string path_log_file_directory, string problem_name, string contest_name, string executable_name)
{
	string operation1 = "rm -rf ",operation2 = "rm -rf ",operation3 = "rm -rf ", operation4 = "rm -f ", operation5 = "rm -f ", operation6 = "rm -f ", operation7 = "rm -f ";
	operation1 = operation1 + path_output_directory + "*";
	operation2 = operation2 + diff_directory + "*";
	operation3 = operation3 + path_log_file_directory + "*";
	operation4 = operation4 + HOME_DIRECTORY + contest_name + "/" + problem_name + "/compilation_error_files/" + executable_name + "_compilation_error_file.txt";
	operation5 = operation5 + HOME_DIRECTORY + contest_name + "/" + problem_name + "/user_codes/" + executable_name;
	operation6 = operation6 + HOME_DIRECTORY + executable_name + "_cplusplus";
	operation7 = operation7 + HOME_DIRECTORY + executable_name + "_codechecker";

	system(operation1.c_str());
	system(operation2.c_str());
	system(operation3.c_str());
	system(operation4.c_str());
	system(operation5.c_str());
	system(operation6.c_str());
	system(operation7.c_str());
}
