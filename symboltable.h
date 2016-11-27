#ifndef SYMBOLTABLE_H
#define SYMBOLTABLE_H
#include<bits/stdc++.h>
#include<functional>
using namespace std;

class SymbolInfo
{
public:
    string name;
    string type;
    string datatype; //int,float
    double value;
    int arrLen;
    int line;
    int index;
    double *val_array;
    SymbolInfo *next;
    SymbolInfo (const char *n,const char *t,int ln=-1)
    {
        this->name=n;
        this->type=t;
        this->datatype="null";
        this->value=-999999;
        this->arrLen=-1;
        this->line=ln;
        this->val_array=0;
        this->index=-1;
    }
};


class SymbolTable
{
public:

    int sz;
    SymbolTable(int n)
    {
        sz=n;
        arr=new SymbolInfo*[n];
        tail=new SymbolInfo*[n];
        for(int i=0; i<n; i++)
        {
            arr[i]=0;
            tail[i]=0;
        }
    }
    ~SymbolTable()
    {

        delete[]arr;
        delete[]tail;
    }

    int lookUp(int n,string s, bool g)
    {
        SymbolInfo *temp=arr[n];
        int p=0;
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

    SymbolInfo *lookUp(int n,SymbolInfo *sym)
    {
        SymbolInfo *temp=arr[n];
        int p=0;
        string s=sym->name;
        while(temp!=0)
        {
            if(temp->name==s)
            {
                return temp;
            }
            temp=temp->next;
            p++;
        }
        return 0;
    }

    void insert(int n,string s,string ty)
    {
        SymbolInfo *newN;
        int p=lookUp (n,s,false);
        if(p==-1)
        {
            //fout<<"<"<<s<<", "<<ty<<">"<<"alredy exists\n";
            this->print(sz);
            return;
        }
        newN=new SymbolInfo(s.c_str(),ty.c_str());

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
        this->print(sz);
        //cout<<"inserted at position "<<n<<","<<p<<"\n\n";

    }
    void insert(int n, SymbolInfo *sym)
    {
        int p=lookUp(n,string(sym->name),false);

        if(p==-1)
        {
            cout<<"Error at line "<<sym->line<<": Multiple Declaration of "<<sym->name<<"\n\n";
            return;
        }
        sym->next=0;
        if(arr[n]==0)
        {
            arr[n]=sym;
            tail[n]=sym;

        }
        else
        {
            tail[n]->next=sym;
            tail[n]=sym;
        }
        //cout<<sym->name<<"\n\n";
        //cout<<"inserted at position "<<n<<","<<p<<"\n\n";
        //print(sz);
    }


    void delete2(int n,string s)
    {
        SymbolInfo *temp, *prev=0;
        int p=0;
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
    void print(int size)
    {

        SymbolInfo *temp;
        for(int i=0; i<size; i++)
        {
            if(arr[i]!=0)
            {
                cout<<i<< " -->";
                temp=arr[i];
                while(temp!=0)
                {
                    if(temp->arrLen==-1)cout<<" < "<<temp->name<<", "<<temp->type<<", "<<temp->value<<"> ";
                    else
                    {
                        cout<<" < "<<temp->name<<", "<<temp->type<<", "<<"{";
                        for(int i=0;i<temp->arrLen-1;i++)cout<<temp->val_array[i]<<", ";
                        cout<<temp->val_array[temp->arrLen-1]<<"}> ";
                    }
                    temp=temp->next;
                }
                cout<<"\n";
            }

        }
        cout<<"\n";
    }

private:
    SymbolInfo **arr;
    SymbolInfo **tail;

};






//int main()
//{
//    ifstream fin;
//    fin.open ("input.txt");
//    int n;
//    fin>>n;
//    SymbolTable obj(n);
//    string a,p,t;
//    int cx=0;
//    while(!fin.eof())
//    {
//        cx++;
//        fin>>a;
//        if(a=="I")
//        {
//
//            fin>>p>>t;
//            int hs=(hash2 (p)%n);
//            cout<<"<"<<p<<","<<t<<"> ";
//            obj.insert (hs,p,t);
//
//
//        }
//        else if(a=="L")
//        {
//            fin>>p;
//            int hs=(hash2 (p)%n);
//            obj.lookUp (hs,p,true);
//
//        }
//        else if(a=="D")
//        {
//            fin>>p;
//            int hs=(hash2 (p)%n);
//            obj.delete2 (hs,p);
//
//        }
//        else if(a=="P")
//        {
//            obj.print (n);
//        }
//
//    }
//
//
//
//
//
//}
//


#endif
