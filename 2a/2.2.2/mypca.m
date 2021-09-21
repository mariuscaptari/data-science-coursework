function [pc, eigenValues] = mypca(data)
%MYPCA Performs Principal Component Analysis on an MxN input matrix, data
%   Performs Principal Component Analysis on an MxN input matrix where
%   each row represents one observation, and each column a variable

    [numObs, numVars] = size(data);
    
    % Step one: Compute the average and subtract this from each entry to
    % center the data
    means = mean(data);
    centered = data - means;
    
    % Step two: Obtain A, which is a vector such that each column is
    % one observation, and each row is all observations of a feature
    A = zeros(numVars, numObs);
    
    for i = 1:numObs
        A(:, i) = centered(i,:).';
    end
    
    %Step three:
    % Obtain eigenvalues from A^T A.
    A = A ./ (numObs - 1);
    [eigenVectorsTmp, eigenValues] = eig(A.' * A);

    
    eigenValues = diag(eigenValues);
    
    % Step four: The eigenvalues of the covariance matrix are identical
    % to that of the previous result, and the eigenvectors that
    % correspond can be found using: u_i = Av_i, where v_i is an
    % eigenvector of A^T A and u_i is an eigenvector of AA^T
    pc = A * eigenVectorsTmp;

    % Step five: Sort eigenvalues and principal components in order of most
    % influence, and normalize.
    [mx, srtidx] = sort(eigenValues, 'descend');
    eigenValues = eigenValues(srtidx);
    pc = pc(:, srtidx);
    
    pc = normc(pc);

end

