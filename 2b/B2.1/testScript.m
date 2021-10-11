clear all;
clc;
format compact;
Xmissing={"c",1, nan , 4;
            nan,2, 5 , 1;
            "c",7, 7 , nan;
            "b",7, 7 , nan;
            "a", nan, 7 , nan }
S=[1,0,1,0] %1 for categorical, 0 for continuous

Xfull=MyImpute(Xmissing,S)
