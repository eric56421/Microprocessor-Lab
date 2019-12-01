// shaking stick table generator give inverse order
// this program is to reverse it

#include <iostream>
#include <stack>

using namespace std;

int main(void)
{
    stack<string> table;
    string input;

    while (getline(cin, input))
        table.push(input);
    
    while (table.size()) {
        cout<<table.top()<<endl;
        table.pop();
    }

    return 0;
}