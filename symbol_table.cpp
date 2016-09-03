#include<bits/stdc++.h>
#include<functional>
using namespace std;


unsigned long hash2(string str)
{
    unsigned long hash = 5381,c;
    int i=0;

    while ((c = str[i++]))
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
    int lookUp(int n,string s, bool g);
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

int SymbolTable::lookUp (int n,string s,bool g)
{
    SymbolInfo *temp=arr[n];int p=0;
    while(temp!=0)
    {
        if(temp->name==s)
        {
            if(g)cout<<"<"<<s<<"," <<temp->type<<"> "<<"found at position "<<n<<", "<<p<<"\n\n";
            return -1;
        }
        temp=temp->next;
        p++;
    }
    if(g)cout<< s<<ends<<"not found\n\n";
    return p;
}

void SymbolTable::insert (int n,string s,string ty)
{
    SymbolInfo *newN;
    int p=lookUp (n,s,false);
    if(p==-1)
    {
        cout<<"alredy exists\n\n";
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
    cout<<"inserted at position "<<n<<","<<p<<"\n\n";

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
            else
            {
                prev->next=temp->next;
                if(tail[n]==temp)tail[n]= prev;
                free(temp);
            }
            cout<<"Deleted from "<<n<<", "<<p<<"\n\n";
            return;

        }
        prev=temp;
        temp=temp->next;
        p++;
    }
    cout<<s<<" not found\n\n";

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
            cout<<" < "<<temp->name<<" : "<<temp->type<<">";
            temp=temp->next;
        }
        cout<<"\n";

    }
    cout<<"\n\n";
}



int main()
{
    int n;
    cin>>n;
    SymbolTable obj(n);
    string a,p,t;

    while(true)
    {
        cin>>a;
        if(a=="I")
        {

            cin>>p>>t;
            int hs=(hash2 (p)%n);
            cout<<"<"<<p<<","<<t<<"> ";
            obj.insert (hs,p,t);


        }
        else if(a=="L")
        {
            cin>>p;
            int hs=(hash2 (p)%n);
            obj.lookUp (hs,p,true);

        }
        else if(a=="D")
        {
            cin>>p;
            int hs=(hash2 (p)%n);
            obj.delete2 (hs,p);

        }
        else if(a=="P")
        {
            obj.print (n);
        }

    }





}



