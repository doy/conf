#!/usr/bin/perl
use strict;
use warnings;
:exe "normal ipackage ".substitute(matchstr(expand("%"), '^lib/\zs.*\ze\.pm'), '/', '::', 'g').";\<CR>"


1;
:normal 5Go
:startinsert
