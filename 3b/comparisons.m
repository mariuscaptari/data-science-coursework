%This script makes 25 independent experiments using the
%myFeatureSelectionwithGA function and plots the accuracy of the two
%methods (GA, all features)
clc;
clear;
%initialize values and matrices
numExperiments=15;
i=1;
accuracyGenetic=zeros(1,numExperiments);
accuracyAll=zeros(1,numExperiments);
bestChromosome=zeros(1,13);
numOfFeaturesSelected=zeros(1,numExperiments);
%run numExperiments times the experiment and store the corresponding
%accuracies and best chromosomes
for i=1:numExperiments
    [bestChromosome,accuracy]=myFeatureSelectionwithGA(0);
    accuracyGenetic(i)=accuracy(1);
    accuracyAll(i)=accuracy(2);
    numOfFeaturesSelected(i)=sum(bestChromosome);
end

%calculate maximum and minimum features selected by the genetci algorithm
maxNumberFeatures=max(numOfFeaturesSelected);
minNumberFeatures=min(numOfFeaturesSelected);

%calculatethe average accuracies of both methods
meanAccuracyGenetic=mean(accuracyGenetic);
meanAccuracyAll=mean(accuracyAll);

%print the results and make the plot
fprintf('min number of features %d\n',minNumberFeatures);
fprintf('max number of features %d\n',maxNumberFeatures);
fprintf('mean accuracy of all features %2.6f\n',meanAccuracyAll);
fprintf('mean accuracy of genetic algorithm %2.6f\n',meanAccuracyGenetic);


plot(accuracyGenetic,'r')
hold on
plot(accuracyAll,'b')
xlabel('Experiment');
ylabel('accuracy');
legend('Genetic Algorithm)','all features')
title('Comparison between feature selection using genetic algorithm and all features')
hold off