#!/usr/bin/perl
use strict;
use warnings;
:exe "call append(line('.'), 'package ".substitute(matchstr(expand("%"), '^lib/\zs.*\ze\.pm'), '/', '::', 'g').";')"


1;
:normal 5Go
:startinsert
