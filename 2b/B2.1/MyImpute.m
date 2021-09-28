 function Xfull=MyImpute(Xmissing,S)
 %This function gets as input a cell array Xmissing of size n x p and a
 %vector S of size p which describes the p columns of Xmissing, Si=0 for categorical data
 %and Si=1 for continuous data. Xmissing has some NaN values which they have to be replaced. If the
 %corresponding data is categorical then they have to be replaced with the
 %mode of that column and if the data is continuous then it has to be
 %replaced with the mean of that column. 
 %The resulting Xfull is returned as the output of this function

%Below is an example how to use this function

%  Xmissing={"c",1, nan , 4;
%             nan,2, 5 , 1;
%             "c",7, 7 , nan;
%             "b",7, 7 , nan;
%             "a", nan, 7 , nan }
% S=[1,0,1,0] %1 for categorical, 0 for continuous
% 
% Xfull=MyImpute(Xmissing,S)
 
 
[n,p]=size(Xmissing); %get the size of the matrix
i=1;
%loop through the columns-variables
for i=1:p
   if(S(i)==1) %categorical data
       replaceValue=mode(categorical([Xmissing{:,i}])); %find the mode
       j=1;
       for j=1:n
          if(ismissing(categorical([Xmissing{j,i}]))) %replace all the nan values with the mode
              if (class([Xmissing{:,i}])=='string') %if the original type is string then keep it string
                [Xmissing{j,i}]=string(replaceValue);
              else
                  [Xmissing{j,i}]=str2double(string(replaceValue)); %if the original type is double then make the replaced value a double
              end
          end
       end
       
   else %numerical data
      replaceValue=mean([Xmissing{:,i}],'omitnan'); %calculate the mean excluding the nans
       j=1;
       for j=1:n
          if(isnan(Xmissing{j,i}))
              Xmissing{j,i}=replaceValue; %replace of the nans with the mean
          end
              
          end
   end
    
end
Xfull=Xmissing; %return the resulting matrix
end