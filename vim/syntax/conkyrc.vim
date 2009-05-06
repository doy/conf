" Vim syntax file
" Language:	conkyrc
" Author:	Ciaran McCreesh <ciaranm@gentoo.org>
" Version:	20050923
" Copyright:	Copyright (c) 2005 Ciaran McCreesh
" Licence:	You may redistribute this under the same terms as Vim itself

if exists("b:current_syntax")
  finish
endif

syn region ConkyrcComment start=/^\s*#/ end=/$/

syn keyword ConkyrcSetting
      \ alignment background border_margin border_width cpu_avg_samples
      \ color0 color1 color2 color3 color4 color5 color6 color7 color8 color9
      \ top_cpu_separate draw_graph_borders imap max_port_monitor_connections
      \ max_specials max_user_text text_buffer_size music_player_interval
      \ default_color default_shade_color default_outline_color double_buffer
      \ draw_borders draw_shades draw_outline font gap_x gap_y no_buffers
      \ mail_spool maximum_width minimum_size mpd_host mpd_port mpd_password
      \ net_avg_samples override_utf8_locale own_window own_window_transparent
      \ own_window_class own_window_hints own_window_title own_window_type
      \ own_window_colour pad_percents stippled_borders total_run_times
      \ temperature_unit update_interval uppercase use_spacer use_xft
      \ out_to_console pop3 short_units xftalpha xftfont

syn keyword ConkyrcConstant yes no top_left top_right top_middle bottom_left bottom_right bottom_middle middle_left middle_right tl tr tm bl br bm ml mr none right left fahrenheit celcius

syn match ConkyrcNumber /\S\@<!\d\+\(\.\d\+\)\?\(\S\@!\|}\@=\)/
      \ nextgroup=ConkyrcNumber,ConkyrcColour skipwhite
syn match ConkyrcColour /\S\@<!#\?[a-fA-F0-9]\{6\}\(\S\@!\|}\@=\)/
      \ nextgroup=ConkyrcNumber,ConkyrcColour skipwhite

syn region ConkyrcText start=/^TEXT$/ end=/\%$/ contains=ConkyrcVar

syn region ConkyrcVar start=/\${/ end=/}/ contained contains=ConkyrcVarStuff
syn region ConkyrcVar start=/\$\w\@=/ end=/\W\@=\|$/ contained contains=ConkyrcVarName

syn match ConkyrcVarStuff /{\@<=/ms=s contained nextgroup=ConkyrcVarName

syn keyword ConkyrcVarName contained nextgroup=ConkyrcNumber,ConkyrcColour skipwhite
      \ addr addrs acpiacadapter acpifan acpitemp acpitempf adt746xcpu
      \ adt746xfan alignr alignc apm_adapter apm_battery_life apm_battery_time
      \ audacious_bar audacious_bitrate audacious_channels audacious_filename
      \ audacious_frequency audacious_length audacious_length_seconds
      \ audacious_playlist_position audacious_playlist_length audacious_position
      \ audacious_position_seconds audacious_status audacious_title
      \ battery battery_bar battery_percent battery_time
      \ bmpx_artist bmpx_album bmpx_title bmpx_track bmpx_bitrate bmpx_uri
      \ buffers cached color color0 color1 color2 color3 color4 color5 color6
      \ color7 color8 color9 conky_version conky_build_date conky_build_arch
      \ cpu cpubar cpugraph diskio diskiograph diskio_read diskiograph_read
      \ diskio_write diskiograph_write disk_protect downspeed downspeedf
      \ downspeedgraph else endif entropy_avail entropy_bar entropy_poolsize
      \ exec execbar execgraph execi execibar execigraph execp execpi font freq
      \ freq_g freq_dyn freq_dyn_g fs_bar fs_free fs_free_perc fs_size fs_type
      \ fs_used goto gw_iface gw_ip hddtemp head hr hwmon iconv_start
      \ iconv_stop i2c i8k_ac_status i8k_bios i8k_buttons_status i8k_cpu_temp
      \ i8k_cpu_tempf i8k_left_fan_rpm i8k_left_fan_status i8k_right_fan_rpm
      \ i8k_right_fan_status i8k_serial i8k_version ibm_fan ibm_temps
      \ ibm_volume ibm_brightness if_empty if_gw if_running if_existing
      \ if_mounted if_smapi_bat_installed if_up imap_messages imap_unseen
      \ ioscheduler kernel laptop_mode loadavg machine mails mboxscan mem
      \ membar memmax memperc mpd_artist mpd_album mpd_bar mpd_bitrate
      \ mpd_status mpd_title mpd_vol mpd_elapsed mpd_length mpd_percent
      \ mpd_random mpd_repeat mpd_track mpd_name mpd_file mpd_smart nameserver
      \ new_mails nodename outlinecolor pb_battery platform pop3_unseen
      \ pop3_used pre_exec processes running_processes shadecolor smapi
      \ smapi_bat_perc smapi_bat_bar stippled_hr swapbar swap swapmax swapperc
      \ sysname tcp_portmon texeci offset rss tab tail time utime tztime
      \ totaldown top top_mem totalup updates upspeed upspeedf upspeedgraph
      \ uptime uptime_short user_number user_names user_terms user_times
      \ voffset voltage_mv voltage_v wireless_essid wireless_mode
      \ wireless_bitrate wireless_ap wireless_link_qual wireless_link_qual_max
      \ wireless_link_qual_perc wireless_link_bar xmms2_artist xmms2_album
      \ xmms2_title xmms2_genre xmms2_comment xmms2_decoder xmms2_transport
      \ xmms2_url xmms2_tracknr xmms2_bitrate xmms2_id xmms2_duration
      \ xmms2_elapsed xmms2_size xmms2_percent xmms2_status xmms2_bar
      \ xmms2_smart

hi def link ConkyrcComment   Comment
hi def link ConkyrcSetting   Keyword
hi def link ConkyrcConstant  Constant
hi def link ConkyrcNumber    Number
hi def link ConkyrcColour    Special

hi def link ConkyrcText      String
hi def link ConkyrcVar       Identifier
hi def link ConkyrcVarName   Keyword

let b:current_syntax = "conkyrc"

