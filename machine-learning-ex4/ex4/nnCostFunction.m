function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%


% Part 1 - feedforward the neural network

% convert y vector to 5000x10 matrix
yMat = zeros(size(y, 1), num_labels);
for i=1:size(yMat, 1)
  yMat(i, y(i)) = 1;
endfor

% disp (yMat(1:1000, :));

% Add ones to the X data matrix
X_bias = [ones(m, 1) X];

% activation of the second layer
Z2 = X_bias*Theta1';
A2 = sigmoid(Z2);

% adding bias to the second layer activation vector
A2_bias = [ones(size(A2, 1), 1) A2];

% activation of the output layer -> hypothesis result
Z3 = A2_bias*Theta2';
A3 = sigmoid(Z3);

% put the pieces together -> compute the cost
J = sum(sum((1/m) * ((-yMat.*log(A3)) - ((1-yMat).*log(1-A3)))), 2);


% Part 2 - regularization
% computing the regularization term and adding it to already computed J

% compute the regularization term (skip the first column - corresponding to the bias units)
regTerm = (lambda/(2*m)) * (sum(sum(Theta1(:, [2:end]).^2)) + sum(sum(Theta2(:, [2:end]).^2)));

% add the regularization term to the cost
J = J + regTerm;

% Part 3 - backpropagation

% compute delta3 - deltas for each training example are in rows
delta3 = A3 - yMat;

% compute delta2 - deltas for each training example are in rows
delta2 = (delta3*Theta2)(:, [2:end]) .* sigmoidGradient(Z2);

% compute the gradient
Theta1_grad = (1/m) * (delta2'*X_bias);
Theta2_grad = (1/m) * (delta3'*A2_bias);

% regularization term
regTerm1BP = (lambda/m) * Theta1(:, [2:end]);
regTerm2BP = (lambda/m) * Theta2(:, [2:end]);

%regularization
Theta1_grad(:, [2:end]) += regTerm1BP;
Theta2_grad(:, [2:end]) += regTerm2BP;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
