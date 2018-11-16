function email_contents = removeHeader(email_contents)
  hdrstart = strfind(email_contents, ([char(10) char(10)]));
  email_contents = email_contents(hdrstart(1):end);
endfunction
