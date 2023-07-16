#!/usr/bin/env perl
use 5.014;
use warnings;

my $char = $ARGV[0] eq 'root' ? '#' : '\\\\$';
my $user = $ARGV[0] eq 'root' ? 'bright-red' : 'bright-blue';
my $host = {
  'mz-doy1' => 'bright-white',
  'tozt' => 'bright-yellow',
  'partofme' => 'magenta',
  'mail' => 'green',
  'hornet' => 'red',
}->{$ARGV[1]} // 'yellow';

while (<DATA>) {
  s/\@\@CHAR\@\@/$char/;
  s/\@\@USER\@\@/$user/;
  s/\@\@HOST\@\@/$host/;
  print;
}

__DATA__
format = """
 [\\(](host)$directory([|](host)$git_branch$git_commit$git_status([|](host)$git_state))[\\)](host)( $aws)( $kubernetes)( $pulumi) $fill ($cmd_duration )($battery )$username[@](bg)$hostname [\\[](host)$time[\\]](host) $line_break\
$status [@@CHAR@@](user) 
"""
right_format = '$character'
add_newline = false
palette = 'local'

[directory]
format = '[$path]($style)[$read_only]($read_only_style)'
style = 'bg'
repo_root_format = '[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style)'
repo_root_style = 'git'
fish_style_pwd_dir_length = 1

[git_state]
format = '[$state(:$progress_current/$progress_total)]($style)'
style = 'git'
rebase = 'r'
merge = 'm'
revert = 'v'
cherry_pick = 'c'
bisect = 'b'
am = 'a'
am_or_rebase = 'r'

[git_branch]
format = '[$branch(:$remote_branch)]($style)'
style = 'git'
ignore_branches = ['main', 'master']

[git_commit]
format = '[$hash$tag]($style)'
style = 'git'

[git_status]
format = '[$all_status$ahead_behind]($style)'
style = 'bold git'
modified = '*'
stashed = ''
diverged = '+$ahead_count-$behind_count'
ahead = '+$count'
behind = '-$count'

[aws]
format = '[$symbol$profile]($style)'
symbol = '☁️'
style = 'bg'

[kubernetes]
disabled = false
format = '[$symbol$context]($style)'
symbol = '☸'
style = 'bg'

[pulumi]
format = '[$symbol$stack]($style)'
symbol = ''
style = 'bg'

[fill]
symbol = '─'
style = 'bg'

[cmd_duration]
format = '[\($duration\)]($style)'
style = 'bg'

[battery]
format = '[$symbol]($style)'
unknown_symbol = '  ??'

[[battery.display]]
threshold = 5
charging_symbol = '⚡️'
discharging_symbol = '  '
style = 'bright-red'

[[battery.display]]
threshold = 15
charging_symbol = '⚡️'
discharging_symbol = '  '
style = 'red'

[[battery.display]]
threshold = 40
charging_symbol = '⚡️ '
discharging_symbol = '   '
style = 'yellow'

[[battery.display]]
threshold = 80
charging_symbol = '⚡️ '
discharging_symbol = '   '
style = 'bright-black'

[[battery.display]]
threshold = 100
charging_symbol = '⚡️ '
discharging_symbol = '   '
style = 'green'

[username]
disabled = false
format = '[$user]($style)'
style_user = 'user'
show_always = true

[hostname]
disabled = false
format = '[$hostname]($style)'
style = 'host'
ssh_only = false

[time]
disabled = false
format = '[$time]($style)'
style = 'bg'

[line_break]

[status]
disabled = false
format = '[$status]($style)'

[character]
format = '$symbol'
success_symbol = ''
error_symbol = ''
vimcmd_symbol = '[\[NOR\]](bright-yellow)'

[palettes.local]
bg = 'bright-black'
git = 'green'
user = '@@USER@@'
host = '@@HOST@@'
