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
#include <sys/stat.h>


#define HOME_DIRECTORY "/home/suraj/Desktop/coderunner/codechecker/"

using namespace std;

int input_files_count(string);
void comparer(int,string, string, string, string);
bool exists(string);
bool check_file(string, string, string,string);
void deleteGeneratedFiles(string,string,string,string);

int main(int argc, char* argv[])
{	
	string filename,path_file,operation1,operation2,time_limit,test_filename,path_testfile, problem_name = argv[4];
	string checker_directory = "languages/";
	test_filename = argv[2];
	time_limit = argv[6];
	string path_log_file_directory = HOME_DIRECTORY; path_log_file_directory += problem_name + "/log_files/";
	string diff_directory = HOME_DIRECTORY;  diff_directory += problem_name + "/diff_directory/";
	string path_output_directory = HOME_DIRECTORY;path_output_directory += problem_name + "/output/";
	path_file = HOME_DIRECTORY + checker_directory;
	path_testfile = HOME_DIRECTORY;
	int length_test_filename = test_filename.length();
	int count = input_files_count(problem_name);
	stringstream s;string count_files;
	s<<count;

	count_files = s.str();

	if(test_filename[length_test_filename-1] == 'p' && test_filename[length_test_filename-2] == 'p' && test_filename[length_test_filename-3] == 'c')
	{
		filename = "cplusplus.cpp";
		operation1= "g++ "+ path_file + filename + " -o cplusplus";
		operation2= "./cplusplus -n "+ test_filename +" -t "+ time_limit + " -m " + count_files + " -p " + problem_name;
		
		system(operation1.c_str());							//COMPILATION OF THE CPLUSPLUS FILE
		system(operation2.c_str());							//EXECUTION OF CPLUSPLUS FILE
	}

	int length=0;
	string compilation_error_file = HOME_DIRECTORY;
	compilation_error_file += problem_name + "/compilation_error_file.txt";
	ifstream diff_file;
	diff_file.open((compilation_error_file).c_str(), ios::binary);
	diff_file.seekg(0,ios::end);
	length = diff_file.tellg();

	if(length == 0)
	{
		comparer(count,problem_name, path_output_directory, path_log_file_directory, diff_directory);
	}	
	

	deleteGeneratedFiles(path_output_directory, diff_directory,path_log_file_directory,problem_name);
	return 0;
}

int input_files_count(string problem_name)																		//EXECUTES THE PROGRAM TO BE TESTED
{
	int count = 0,flag=0;
	string path_input_directory = HOME_DIRECTORY;
	path_input_directory+= problem_name + "/input/";	
	//cout<<path_input_directory<<endl;
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
				//cout<<filename<<endl;
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
void comparer(int count_files, string problem_name, string path_output_directory, string path_log_file_directory, string diff_directory)																		//COMPARES THE OUTPUT
{	
	int i,j,p;
	//string path_output_directory = HOME_DIRECTORY;
	string path_actual_output_directory = HOME_DIRECTORY;
	//path_output_directory += problem_name + "/output/";
	path_actual_output_directory += problem_name + "/actual_output/";
	//string diff_directory = HOME_DIRECTORY;  diff_directory += problem_name + "/diff_directory/";
	//string path_log_file_directory = HOME_DIRECTORY; path_log_file_directory += problem_name + "/log_files/";
	
	for(p=0;p<count_files;p++)
	{
		j = p%10; i = p/10;
		stringstream s1,s2;string num1,num2;
		s1<<i;
		s2<<j;
		num1 = s1.str();
		num2 = s2.str();	

		string output_filename = path_output_directory + "output" + num1 + num2 + ".txt";
		string actual_output_filename = path_actual_output_directory + "actual_output" + num1 + num2 + ".txt";


		string operation = "diff ";
		operation += output_filename + " " + actual_output_filename + " >" + diff_directory + "diff" + num1 + num2 + ".txt";
		system(operation.c_str());
		
		if(!check_file(path_log_file_directory, num1,num2,"log_file"))
			cout<<"FILE NUMBER = "<<p<<" TIME LIMIT EXCEEDED"<<endl;
		else if(check_file(diff_directory,num1,num2,"diff"))
			cout<<"FILE NUMBER = "<<p<<" "<<"ACCEPTED"<<endl;
		
		else
			cout<<"FILE NUMBER = "<<p<<" "<<"WRONG ANSWER"<<endl;
	}
}
/*
bool check_diff_file(string diff_directory, string num1, string num2)
{
	string diff_file = diff_directory;
	diff_file += "diff" + num1 + num2 + ".txt";
	int length=0;
	ifstream file;
	file.open((diff_file).c_str(), ios::binary);
	file.seekg(0,ios::end);
	length = file.tellg();
	if(length!=0)
	{
		return false;
	}
	else return true;
}*/

bool check_file(string directory, string num1, string num2, string name)
{
	string file_to_be_checked = directory;
	file_to_be_checked += name + num1 + num2 + ".txt";

	//cout<<file_to_be_checked<<endl<<endl;
	int length=0;
	ifstream file;
	file.open(file_to_be_checked.c_str(), ios::binary);
	file.seekg(0,ios::end);
	length = file.tellg();
	if(length!=0)
	{
		return false;
	}
	else return true;
}

void deleteGeneratedFiles(string path_output_directory, string diff_directory, string path_log_file_directory, string problem_name)
{
	string operation1 = "rm -rf ",operation2 = "rm -rf ",operation3 = "rm -rf ", operation4 = "rm -f ";
	operation1 = operation1 + path_output_directory + "*";
	operation2 = operation2 + diff_directory + "*";
	operation3 = operation3 + path_log_file_directory + "*";
	operation4 = operation4 + HOME_DIRECTORY + problem_name + "/compilation_error_file.txt";
	//cout<<operation1<<endl<<operation2<<endl<<operation3<<endl<<operation4<<endl;
	system(operation1.c_str());
	system(operation2.c_str());
	system(operation3.c_str());
	system(operation4.c_str());
}