#include<iostream>
#include<algorithm>
#include<vector>
using namespace std;

// stdout for debug
#ifdef _DEBUG 
#define debug_1(x1) cout<<#x1<<": "<<x1<<endl
#define debug_2(x1,x2) cout<<#x1<<": "<<x1<<", "#x2<<": "<<x2<<endl
#define debug_3(x1,x2,x3) cout<<#x1<<": "<<x1<<", "#x2<<": "<<x2<<", "#x3<<": "<<x3<<endl
#define debug_4(x1,x2,x3,x4) cout<<#x1<<": "<<x1<<", "#x2<<": "<<x2<<", "#x3<<": "<<x3<<", "#x4<<": "<<x4<<endl
#define debug_5(x1,x2,x3,x4,x5) cout<<#x1<<": "<<x1<<", "#x2<<": "<<x2<<", "#x3<<": "<<x3<<", "#x4<<": "<<x4<<", "#x5<<": "<<x5<<endl
#define GET_MACRO(_1, _2, _3, _4, _5, NAME, ...) NAME
#define debug(...) GET_MACRO(__VA_ARGS__,debug_5,debug_4,debug_3,debug_2,debug_1) (__VA_ARGS__)
#else
#define debug(...)
#endif

void debug_vv(vector<vector<int>> v){
	int n=v.size();
	int m=v[0].size();
	
	// print out Col Number
	cout << "  ";
	for(int i=0; i<m; i++){
		cout << " " << i;
	}
	cout << endl;
	
	// Horizonal Line
	cout << "  ";
	for(int i=0; i<m; i++){
		cout << " " << "-";
	}

	for(int i=0; i<n; i++){
		cout << endl;
		
		// print out Row Number
		cout << i << "| ";

		// print out Contents
		for(int j=0; j<m; j++)
			cout << v[i][j] << " ";
	}
	cout << endl;
}


void debug_v(vector<int> v){
	for(int i : v)
		cout << i << " ";
	cout << endl;
}

int distance(int i, int j){
	int rval = i-j;
	if(rval<0) rval *=-1;
	return rval;
}

int main(){

	int ans=0;

	cout << ans << endl;
	return 0;
}
