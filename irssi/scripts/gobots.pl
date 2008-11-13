use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(signal_add signal_stop window_find_name settings_add_str
             settings_get_str);
$VERSION = "0.01";
%IRSSI = (
    authors => 'Jesse Luehrs',
    contact => 'jluehrs2@uiuc.edu',
    name    => 'gobots',
    license => 'BSD',
    changed => 'July 29, 2008',
    description => 'Filters a list of nicks (typically bots) into a separate '.
                   '"bots" window',
);

use warnings;

signal_add 'message public' => sub {
    my ($server, $msg, $nick, $address, $target) = @_;
    my $window = window_find_name 'bots';
    return unless $window;

    my $botlist = settings_get_str 'gobots_filter_nicks';
    for (split /,/, $botlist) {
        if ($_ eq $nick) {
            $window->print(sprintf("<%s> %s", $nick, $msg),
                           MSGLEVEL_CLIENTCRAP | MSGLEVEL_NO_ACT);
            signal_stop;
            return;
        }
    }
};

my $window = window_find_name 'bots';
print 'Create a window named \'bots\'' unless $window;
settings_add_str 'misc', 'gobots_filter_nicks', '';
