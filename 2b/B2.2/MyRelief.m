function W = MyRelief(X,Y,m)
%MYRELIEF Determines feature relevance of categorical features using relief
%feature selection.
%   In: X - input data such that each row represents a datapoint and each 
%   column a feature, Y - a row vector of output labels (binary, 
%   only using values 0 and 1, or a logical array)
%   m - number of random samples to be taken from the training instances
%
%   Out: W - a matrix of feature weights

    % Nested util functions
    % Of note: Matlab allows one to use variables from the main function
    % Without needing to pass them in explicitly. I am not a fan, but
    % that is why the functions below have access to the data.
    
    function d = DistCat(p1, p2)
        d = 0;
        for j = 1:size(p1, 2)
            d = d + not(p1(j) == p2(j));
        end
    end
    
    function closest_idx = NearestPoint(idx, hit)
        
        point = X(idx);
        lab = Y(idx);
        
        if (not(hit))
            lab = not(lab);
        end
            
        
        closest_idx = -1;
        closest_dist = Inf;
        
        for j = 1:numDataPoints
            
            if (j == idx)
               continue 
            end
            
            if (Y(j) == lab)
                dist = DistCat(point, X(j));
                
                if (dist < closest_dist)
                   closest_dist = dist;
                   closest_idx = j;
                end
            end
        end
        
        assert(closest_idx > 0, "NearestPoint could not find a point in X with the same label as passed to it")
    end

    function d = DiffCat(featureValue1, featureValue2)
       d = not(featureValue1 == featureValue2);
    end



    % ---- BEGIN OF FUNCTION ---- %

    % Checks if Y is binary and if the labels in Y are either 0 or 1
    % Using this check instead of islogical allows the use of both logical
    % arrays and non-logical arrays only containing 0 and 1
    assert(size(unique(cat(2, Y, [0, 1])), 2) == 2, "class labels Y are not binary, or has members that are not 0 or 1!")

    [numDataPoints, numFeatures] = size(X);

    % We only sample each datapoint at most once
    assert(numDataPoints >= m, "The value of points to be sampled, m, was larger than the amount of points provided");

    W = zeros(1, numFeatures);
    randomOrdering = randperm(numDataPoints);

    for i = 1:m
        % randomly select target instance R_i
        idx = randomOrdering(i);
        
        nearestHit = X(NearestPoint(idx, true), :);
        nearestMiss = X(NearestPoint(idx, false), :);
        
        dp = X(idx, :);
        
        for f = 1:numFeatures
            
            W(f) = W(f) - (DiffCat(dp(f), nearestHit(f)))/m + ...
                          (DiffCat(dp(f), nearestMiss(f)))/m;
        end
    end
end

