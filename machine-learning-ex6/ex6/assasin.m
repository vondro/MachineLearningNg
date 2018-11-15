% training model with data from  SpamAssassin Public Corpus
% http://spamassassin.apache.org/old/publiccorpus/

%% Initialization
clear ; close all; clc

  % one row per e-mail example
  regularIndices = {};
  spamIndices = {};
  regularFeatures = [];
  spamFeatures = [];

% check for indices in files
if (!exist("spamIndices.mat", "file") || !exist("regularIndices.mat", "file"))
  % load content of regular mails
  printf("Loading content of regular mails ....\n");
  regularMails = loadDir("not_spam");

  % load content of spam mails
  printf("Loading content of spam mails ....\n");
  spamMails = loadDir("spam");

  % process regular mails (using vocabulary from the course
  for i=1:length(regularMails)
  % for i=1:2
    processed = processEmail(regularMails{i});
    % one mail per row
    regularIndices  = [regularIndices; processed'];
  endfor

  % process spam mails
  for i=1:length(spamMails)
  % for i=1:2
    processed = processEmail(spamMails{i});
    spamIndices  = [spamIndices; processed'];
  endfor

  % save indices to file
  save spamIndices.mat spamIndices;
  save regularIndices.mat regularIndices;
else
  load("spamIndices.mat");
  load("regularIndices.mat");
endif


% extract features from regular mails
for i=1:length(regularIndices)
% for i=1:2
  regularFeatures = [regularFeatures; emailFeatures(regularIndices{i})'];
endfor

% extract features from spam mails
for i=1:length(spamIndices)
% for i=1:2
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

