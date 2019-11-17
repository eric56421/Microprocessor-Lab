#include <iostream>

using namespace std;

int main(void)
{
    int r5, r6, r7; // outter to inner

    cout<<"input r5 r6 r7:"<<endl;
    while (cin>>r5>>r6>>r7) {
        int dt = 3+3*r5+2*r5*r6*r7+3*r6*r7;
        dt /= 6;
        cout<<dt<<" us"<<endl;
        cout<<dt/1000<<" ms"<<endl;
    }

    return 0;
}