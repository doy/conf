# Print hilighted messages & private messages to window named "hilight"
# for irssi 0.7.99 by Timo Sirainen
use Irssi;
use vars qw($VERSION %IRSSI);
use POSIX qw(strftime);

# Tom <tom@tomaw.net:
# Timestamps
# Replace colour codes in text
# Timestamps format

$VERSION = "0.03";
%IRSSI = (
    authors	=> "Timo \'cras\' Sirainen",
    contact	=> "tss\@iki.fi", 
    name	=> "hilightwin",
    description	=> "Print hilighted messages & private messages to window named \"hilight\"",
    license	=> "Public Domain",
    url		=> "http://irssi.org/",
    changed	=> "2007-04-17T08:38-0500"
);

sub sig_printtext {
  my ($dest, $text, $stripped) = @_;

  if (($dest->{level} & (MSGLEVEL_HILIGHT|MSGLEVEL_MSGS|MSGLEVEL_DCCMSGS)) &&
      ($dest->{level} & MSGLEVEL_NOHILIGHT) == 0) {
    $window = Irssi::window_find_name('hilight');

    if ($dest->{level} & MSGLEVEL_PUBLIC) {
      $text = $dest->{target}.": ".$text;
    }
    $text =~ s/\%/%%/g;
    $now_string = strftime(Irssi::settings_get_str('hilightwin_timestamp'), localtime);
    $window->print($now_string . ": " . $text, MSGLEVEL_NEVER) if ($window);
  }
}

$window = Irssi::window_find_name('hilight');
Irssi::print("Create a window named 'hilight'") if (!$window);

Irssi::signal_add('print text', 'sig_printtext');

Irssi::settings_add_str('misc', 'hilightwin_timestamp', Irssi::settings_get_str('timestamp_format'));
