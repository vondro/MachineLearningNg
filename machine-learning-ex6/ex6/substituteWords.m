% function to generate indices from processed email
function email_contents = substituteWords(email_contents)
  % Lower case
  email_contents = lower(email_contents);

  % Strip all HTML
  % Looks for any expression that starts with < and ends with > and replace
  % and does not have any < or > in the tag it with a space
  email_contents = regexprep(email_contents, '<[^<>]+>', ' ');

  % Handle Numbers
  % Look for one or more characters between 0-9
  email_contents = regexprep(email_contents, '[0-9]+', 'number');

  % Handle URLS
  % Look for strings starting with http:// or https://
  email_contents = regexprep(email_contents, ...
                             '(http|https)://[^\s]*', 'httpaddr');

  % Handle Email Addresses
  % Look for strings with @ in the middle
  email_contents = regexprep(email_contents, '[^\s]+@[^\s]+', 'emailaddr');

  % Handle $ sign
  email_contents = regexprep(email_contents, '[$]+', 'dollar');
endfunction
