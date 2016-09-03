#include<bits/stdc++.h>
#include<functional>
using namespace std;


unsigned long hash(unsigned char *str)
{
    unsigned long hash = 5381;
    int c;

    while ((c = *str++))
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */

    return hash;
}

class SymbolInfo
{
    public:
        string name;
        string type;
        SymbolInfo *next;
};

class SymbolTable
{
public:
    SymbolTable(int n);
    void insert(int n,string s,string ty);
    int lookUp(int n,string s);
    void delete2(int n,string s);
    void print(int size);

private:
    SymbolInfo **arr;
    SymbolInfo **tail;

};

SymbolTable::SymbolTable(int n)
{

    arr=new SymbolInfo*[n];
    tail=new SymbolInfo*[n];
    for(int i=0;i<n;i++)
    {
        arr[i]=0;
        tail[i]=0;
    }
}

int SymbolTable::lookUp (int n,string s)
{
    SymbolInfo *temp=arr[n];int p=0;
    while(temp!=0)
    {
        if(temp->name==s)
        {
            //cout<<"found at position "<<n<<", "<<p<<"\n";
            return -1;
        }
        temp=temp->next;
        p++;
    }
    //cout<<"not found\n";
    return p;
}

void SymbolTable::insert (int n,string s,string ty)
{
    SymbolInfo *newN;
    int p=lookUp (n,s);
    if(p==-1)
    {
        cout<<"alredy exists\n";
        return;
    }
    newN=new SymbolInfo;
    newN->name=s;
    newN->type=ty;
    newN->next=0;
    if(arr[n]==0)
    {
        arr[n]=newN;
        tail[n]=newN;

    }
    else
    {
        tail[n]->next=newN;
        tail[n]=newN;
    }
    cout<<"inserted at position "<<n<<","<<p<<"\n";

}

void SymbolTable::delete2 (int n,string s)
{
    SymbolInfo *temp, *prev=0; int p=0;
    temp=arr[n];
    while(temp!=0)
    {
        if(temp->name==s)
        {
            if(prev==0)
            {
                arr[n]=temp->next;
                free(temp);
            }
        }
    }

}

void SymbolTable::print (int size)
{
     SymbolInfo *temp;
    for(int i=0;i<size;i++)
    {
        cout<<i<< " -->";
        temp=arr[i];
        while(temp!=0)
        {
            cout<<" <"<<temp->name<<" : "<<temp->type<<">";
            temp=temp->next;
        }
        cout<<"\n";

    }
}



int main()
{
    int n;
    //cin>>n;
    SymbolTable obj(7);
    obj.insert (123%7,"123","NUMBER");
    obj.insert (123%7,"123","NUMBER");
    obj.insert (119%7,"523","NUMBER");
    obj.print (7);



}



