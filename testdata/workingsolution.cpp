#include<bits/stdc++.h>

using namespace std;

//gcd template
int gcd(int a,int b)
{
return __gcd(a,b);
}

int add(int a, int b)
{
 int* sum = new(int);
 *sum = a+b;
 return *sum;
}
int main()
{
	int c,a,b;
	cin>>a>>b;
	c=(a+b)/2;
	cout<<c;
	return 0;
}
