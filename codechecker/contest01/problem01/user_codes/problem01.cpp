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
using namespace std;

int main()
{
	int i,t;
	cin>>t;
	for(i=0;i<t;i++)
	{
		cout<<i<<endl;
	}
	return 0;
}