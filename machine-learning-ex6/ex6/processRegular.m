% utility to process regular e-mails

regularIndices = {};
regularFeatures = [];

vocabList = getVocabList();

% load content of regular mails
printf("Loading content of regular mails ....\n");
regularMails = loadDir("not_spam");

for i=1:length(regularMails)
  processed = processEmail(regularMails{i}, vocabList);
  % one mail per row
  regularIndices  = [regularIndices; processed'];
endfor

save regularIndices.mat regularIndices;