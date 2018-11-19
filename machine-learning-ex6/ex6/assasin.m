% training model with data from  SpamAssassin Public Corpus
% http://spamassassin.apache.org/old/publiccorpus/

%% Initialization
clear ; close all; clc

regularIndices = {};
spamIndices = {};
regularFeatures = [];
spamFeatures = [];

if (!exist("vocabList.mat", "file"))
  vocabList = getVocabList();
else
  load("vocabList.mat");
endif

% check for indices in files
if (!exist("spamIndices.mat", "file") || !exist("regularIndices.mat", "file"))
  % load content of regular mails
  printf("Loading content of regular mails ....\n");
  regularMails = loadDir("not_spam");

  % load content of spam mails
  printf("Loading content of spam mails ....\n");
  spamMails = loadDir("spam");

  % process regular mails (using vocabulary from the course
  printf("Generating regular mail indices ....\n");
  for i=1:length(regularMails)
    processed = processEmail(regularMails{i}, vocabList);
    % one mail per row
    regularIndices  = [regularIndices; processed'];
  endfor

  % process spam mails
  printf("Generating spam mail indices ....\n");
  for i=1:length(spamMails)
    processed = processEmail(spamMails{i}, vocabList);
    spamIndices  = [spamIndices; processed'];
  endfor

  % save indices to file
  save regularIndices.mat regularIndices;
  save spamIndices.mat spamIndices;
else
  printf("Loading processed mails with indices ....\n");
  load("spamIndices.mat");
  load("regularIndices.mat");
endif

% generating custom vocabulary from processed mails
% using struct to count occurences of words (word = field in struct, count = field value)


if (!exist("assasinX.mat", "file") || !exist("assasiny.mat", "file"))

  printf("Extracting features from processed mails ....\n");
  % extract features from regular mails
  for i=1:length(regularIndices)
    regularFeatures = [regularFeatures; emailFeatures(regularIndices{i})'];
  endfor

  % extract features from spam mails
  for i=1:length(spamIndices)
    spamFeatures = [spamFeatures; emailFeatures(spamIndices{i})'];
  endfor

  % concatenate feature to one feature matrix_type
  % m x 1899 one mail per row
  X = [regularFeatures; spamFeatures];

  % add one column of ones to X
  X = [ones(size(X)(1), 1) X];

  % create result vector
  y = [zeros(size(regularFeatures)(1), 1); ones(size(spamFeatures)(1), 1)];

  % safe features to files
  save assasinX.mat X;
  save assasiny.mat y;
else
  printf("Loading saved features ....\n");
  load("assasinX.mat");
  load("assasiny.mat");
endif

% split the dataset into training set, CV set, test set
% 60% training, 20% CV, 20% test

printf("Generating training set (60%%), cv set (20%%) and test set (20%%)\n");

nRows = size(X)(1);
trainSample = floor(nRows *0.6);
testSample = floor(nRows *0.2);

rndIDX = randperm(nRows);

% test set
Xtest = X(rndIDX(1:testSample), :);
ytest = y(rndIDX(1:testSample), :);

% cross-validation set
Xcv = X(rndIDX((testSample+1):(2*testSample)), :);
ycv = y(rndIDX((testSample+1):(2*testSample)), :);

% training set
X = X(rndIDX([(2*testSample+1):end]), :);
y = y(rndIDX([(2*testSample+1):end]), :);

% compute training parameters (just once, for performance reasons)
%[C, sigma] = dataset3Params(X, y, Xcv, ycv);
C = 0.01;
sigma =  2.43;

% train the model
% we don't use sigma since we use linear kernel
model = svmTrain(X, y, C, @linearKernel);

% make prediction 
p = svmPredict(model, X);

fprintf('Training Accuracy: %f\n', mean(double(p == y)) * 100);

% check the test set prediction
p = svmPredict(model, Xtest);

fprintf('Test Accuracy: %f\n', mean(double(p == ytest)) * 100);

% TODO
% making my own vocabulary
% VOCABULARY ISSUES:
% - too few features (~ 900 in processed examples from spamassasin
% - vocabulary is not generated on trainings set, but the whole dataset (dependency)
%  ... but the accuracy is higher with custom vocabulary
% -> what fetures to add?
% trying to use highly optimized SVM toolboxes such as LIBSVM
% with full dataset - use the gaussian kernel and compare results to linear

