% generate new vocabList from the dataset

function vocabList = generateVocabList(mailCell)
  % initialize empty struct
  vocabList = struct();
  workingList = struct();
  
  % process mails
  for i=1:length(mailCell)
    printf("Processing mail %d....\n", i);
    
    % one mail per row
    % remove header and substitute words
    email_contents = removeHeader(mailCell{i});
    email_contents = substituteWords(email_contents);
    
    % process each word of the email string
    while ~isempty(email_contents)
      % Tokenize and also get rid of any punctuation
      [str, email_contents] = ...
         strtok(email_contents, ...
                [' @$/#.-:&*+=[]?!(){},''">_<;%' char(10) char(13)]);
     
      % Remove any non alphanumeric characters
      str = regexprep(str, '[^a-zA-Z0-9]', '');

      % Stem the word 
      % (the porterStemmer sometimes has issues, so we use a try catch block)
      try str = porterStemmer(strtrim(str)); 
      catch str = ''; continue;
      end;

      % Skip the word if it is too short
      if length(str) < 1
         continue;
      end
      
      % add the word to the vocabulary
      try
        vocabList.(str)++;
      catch
        % the word is not in vocabulary yet
        vocabList.(str) = 1;
      end_try_catch
      
    endwhile    
  endfor
  % now we have the struct, let's remove examples with less than 100 occurences
  % list all field names
  names = fieldnames(vocabList);
  
  printf("Stripping vocabulary of words with less than 100 occurences .... \n");
  % iterate over the struct and remove words with occurences lower than 100
  namesLen = length(names);
  j = 1;  
  for i=1:namesLen
    if (vocabList.(names{i}) >= 100)
      workingList.(names{i}) = j;
      j++;
    endif
  endfor
  
  vocabList = workingList;
  
endfunction
