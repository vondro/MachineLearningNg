% load all files in directory

function mails = loadDir(path)
  [files, err, msg] = readdir (path);
  mails = {};
  fileCount = length(files);
  for i=1:fileCount
    if (!strcmp(files{i}, ".") && !strcmp(files{i}, ".."))   
      content = readFile([path "/" files{i}]);
      mails = [mails; content];
    end
  end  
endfunction
