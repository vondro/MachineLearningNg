% utility to process spam e-mails

spamIndices = {};
spamFeatures = [];

vocabList = getVocabList();

% load content of spam mails
printf("Loading content of spam mails ....\n");
spamMails = loadDir("spam");

% process spam mails
for i=1:length(spamMails)
  processed = processEmail(spamMails{i}, vocabList);
  spamIndices  = [spamIndices; processed'];
endfor

save spamIndices.mat spamIndices;