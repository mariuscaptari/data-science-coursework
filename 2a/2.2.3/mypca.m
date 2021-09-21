function [pc, eigenValues] = mypca(A)
%MYPCA Performs Principal Component Analysis on an N^2xM input matrix, data
%   Performs Principal Component Analysis on an N^2xM input matrix where
%   each row represents a variable, and each column one observation

    [numVars, numObs] = size(A);
    
    %Step one:
    % Obtain eigenvalues from A^T A.
    A = A ./ (numObs - 1);
    [eigenVectorsTmp, eigenValues] = eig(A.' * A);

    eigenValues = diag(eigenValues);
    
    % Step two: The eigenvalues of the covariance matrix are identical
    % to that of the previous result, and the eigenvectors that
    % correspond can be found using: u_i = Av_i, where v_i is an
    % eigenvector of A^T A and u_i is an eigenvector of AA^T
    pc = A * eigenVectorsTmp;

    % Step three: Sort eigenvalues and principal components in order of most
    % influence, and normalize.
    [mx, srtidx] = sort(eigenValues, 'descend');
    eigenValues = eigenValues(srtidx);
    pc = pc(:, srtidx);
    
    pc = normc(pc);
end

