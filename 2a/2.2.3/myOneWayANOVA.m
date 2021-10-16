 function F = myOneWayANOVA(IV ,DV)
    %This function gets as input the vectors of the Independent Variables
    %(observations) and a vector of the Dependent Variables (classes) and
    %returns the F-statistic, if only one unique class in the DV then
    %raises an error
    
    %below is an example code how to use the function
    %IV = [9, 7, 6.5, 8, 7.5, 7, 9.5, 8, 6.5, 7.5, 8, 6, 7, 6.5, 7.5, 8, 6, 6, 6.5, 6.5];
    %DV = [1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3];
    %myOneWayANOVA(IV,DV)
    
    %First, count how many unique classes are in the DV vector
    classes=unique(DV);
    numClasses=size(classes(:));
    numClasses=numClasses(1);
    %if only one class then raise an error
    if numClasses==1
       msg = 'Error occurred, there is only 1 unique class in the Dependent Variables';
       error(msg) 
    end
    %count how many observations
    numObservations=size(DV(:));
    numObservations=numObservations(1);
    
    %initialize variables
    occurences=zeros(numClasses,1);
    observations=cell(numClasses,1);
    means=zeros(numClasses,1);
    variances=zeros(numClasses,1);
    averageMeans=0;
    i=1;
    %loop through the classes and count the occurences of each class, their
    %corresponding observations, the mean for each class, variance of each
    %class and add-up the means of all the classes
    for i=1:numClasses
        occurences(i)=sum(DV(:)==classes(i));
        observations{i}=IV(DV==classes(i));
        means(i)=mean(observations{i});
        variances(i)=var(observations{i});
        averageMeans=averageMeans+occurences(i)*means(i);
    end
   %compute the average of the means
   averageMeans=averageMeans/numObservations;
   sumSquaresBetween=0;
   sumSquaresWithin=0;
   %loop through the classes and compute the sumSquaresBetween and
   %sumSquaresWithin
for i=1:numClasses
       sumSquaresBetween=sumSquaresBetween+occurences(i)*((means(i)-averageMeans)^2);
       sumSquaresWithin=sumSquaresWithin+(occurences(i)-1)*variances(i);
   end
   sumSquaresBetween=sumSquaresBetween/(numClasses-1);
   sumSquaresWithin=sumSquaresWithin/(numObservations-numClasses);
   %Compute the f-statistic and output it
   F=sumSquaresBetween/sumSquaresWithin;
 end
   
    