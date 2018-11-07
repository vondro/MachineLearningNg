function [J, grad] = linearRegCostFunction(X, y, theta, lambda)
%LINEARREGCOSTFUNCTION Compute cost and gradient for regularized linear 
%regression with multiple variables
%   [J, grad] = LINEARREGCOSTFUNCTION(X, y, theta, lambda) computes the 
%   cost of using theta as the parameter for linear regression to fit the 
%   data points in X and y. Returns the cost in J and the gradient in grad

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost and gradient of regularized linear 
%               regression for a particular choice of theta.
%
%               You should set J to the cost and grad to the gradient.
%

% size(X) = 12 2 (including added ones)
% size(y) = 12 1
% size(theta) = 2 1

% non-regularized cost function
nonReg = (1/(2*m)) * sum(((X*theta)-y).^2);

% regularization term
regTerm = (lambda/(2*m)) * sum(theta(2:end).^2);

% regularize the cost
J = nonReg + regTerm;

% computing the gradient
% gradient regularization term
gradRegTerm = zeros(size(theta));
gradRegTerm(2:end) = (lambda/m) * theta(2:end);

% non-regularized gradient
nonRegGrad = (1/m) * sum(((X*theta)-y).*X)';

% adding the gradient regularization term
grad = nonRegGrad + gradRegTerm;



% =========================================================================

grad = grad(:);

end
