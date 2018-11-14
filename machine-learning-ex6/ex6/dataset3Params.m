function [C, sigma] = dataset3Params(X, y, Xval, yval)
%DATASET3PARAMS returns your choice of C and sigma for Part 3 of the exercise
%where you select the optimal (C, sigma) learning parameters to use for SVM
%with RBF kernel
%   [C, sigma] = DATASET3PARAMS(X, y, Xval, yval) returns your choice of C and 
%   sigma. You should complete this function to return the optimal C and 
%   sigma based on a cross-validation set.
%

% You need to return the following variables correctly.
C = 0.01;
initialSigma = 0.01;
sigma = initialSigma;

% ====================== YOUR CODE HERE ======================
% Instructions: Fill in this function to return the optimal C and sigma
%               learning parameters found using the cross validation set.
%               You can use svmPredict to predict the labels on the cross
%               validation set. For example, 
%                   predictions = svmPredict(model, Xval);
%               will return the predictions on the cross validation set.
%
%  Note: You can compute the prediction error using 
%        mean(double(predictions ~= yval))
%

% get model - with svmTrain function
% train with each out of 64 combinations of C and sigma
% validate against CV set
% save the values of C and sigma when we get the lowest prediction error

lowestError = inf;

while (C <= 30)
  while (sigma <= 30)
    % train the model with given C, sigma
    model= svmTrain(X, y, C, @(x1, x2) gaussianKernel(x1, x2, sigma));

    % compute predictions on the CV set using the trained model
    predictions = svmPredict(model, Xval);

    % compute the prediction error
    error = mean(double(predictions ~= yval));

    % save the error value if lower then previous lowest
    % save the values of C and sigma
    if (error < lowestError)
      lowestError = error;
      bestC = C;
      bestSigma = sigma;
    endif
    % increment sigma
    sigma = sigma * 3;
  endwhile
  % reset sigma
  sigma = initialSigma;
  % increment C
  C = C * 3;
endwhile

C = bestC;
sigma = bestSigma;



% =========================================================================

end
