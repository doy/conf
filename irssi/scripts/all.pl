use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(signal_add signal_stop window_find_name settings_add_str
             settings_get_str);
$VERSION = "0.01";
%IRSSI = (
    authors => 'Jesse Luehrs',
    contact => 'jluehrs2@uiuc.edu',
    name    => 'all',
    license => 'BSD',
    changed => 'September 22, 2008',
    description => 'Copy all incoming messages into a separate "all" window',
);

use warnings;

signal_add 'message public' => sub {
    my ($server, $msg, $nick, $address, $target) = @_;
    my $window = window_find_name 'all';
    return unless $window;
    return if $nick eq 'Henzell' || $nick eq 'Gretell' || $nick eq 'Doryen' ||
              $nick eq 'dataninja' || $nick eq 'arcaneh1' ||
              $msg =~ /^(?:\?\?|!|\@|#|arcaneh1:)/;
    $window->print(sprintf("%s: <%s> %s", $target, $nick, $msg),
                   MSGLEVEL_CLIENTCRAP | MSGLEVEL_NO_ACT);
};

my $window = window_find_name 'all';
print 'Create a window named \'all\'' unless $window;
