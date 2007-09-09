# my silly prompt {{{
autoload -U promptinit
promptinit
prompt adam2 gray yellow green white
RPS1='[%*]'
# }}}
# use completion cache {{{
zstyle ':completion::complete:*' use-cache 1
# }}}
# history {{{
HISTFILE=$HOME/.history
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history
setopt share_history
setopt hist_ignore_space
# }}}
# miscellaneous options {{{
setopt correctall # yes it's annoying. but only half the time
setopt nobeep # I hates the beeps
setopt auto_cd # typing just a directory name cds into it
setopt multios # built-in tee
setopt extended_glob
setopt nullglob # it's not an error for a glob to expand to nothing
setopt list_ambiguous
setopt no_nomatch
setopt interactivecomments # Allow comments even in the interactive shell
setopt listpacked # column width doesn't have to be constant
# }}}
# key bindings {{{
bindkey -v                       # Use vim bindings
bindkey "^A" beginning-of-line   # Like in bash, for memory
bindkey "^E" end-of-line         # Like in bash
bindkey "^N" accept-and-infer-next-history # Enter; pop next history event
bindkey "^O" push-line           # Pushes line to buffer stack
bindkey "^P" get-line            # Pops top of buffer stack
bindkey "^R" history-incremental-search-backward # Like in bash, but should !
bindkey "^T" transpose-chars     # Transposes adjacent chars (xp in vim)
bindkey "^Z" accept-and-hold     # Enter and push line
bindkey " " magic-space          # Expands from hist (!vim )
bindkey "\e[3~" delete-char      # Enable delete
# }}}
# stuff we don't want to correct {{{
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias cp='nocorrect cp'
# }}}
# replace default utilities {{{
alias man="man -P vimmanpager"
#alias top="htop"
# }}}
# add color to some things {{{
alias ls='ls -G'
alias ll='ls -lhA'
alias ack='ack --color'
# see also ~/.zshenv
# }}}
# telnet services (nao, termcast, etc) {{{
alias nao="(TERM='rxvt'; telnet nethack.alt.org)"
alias cao="telnet crawl.akrasiac.org"
alias termcast="telnet noway.ratry.ru 37331"
alias sporkhack='telnet nethack.nineball.org'
# }}}
# shell accounts {{{
alias katron="ssh katron.org"
alias arcane="ssh 66.41.105.165"
alias jsn="ssh noway.ratry.ru"
alias akrasiac="ssh henzell@crawl.akrasiac.org"
alias diesel="ssh diesel.bestpractical.com"
alias rax="ssh sartak.org"
alias home='ssh $HOMEIP'
# }}}
# shortcuts {{{
alias starcraft="cd /home/sartak/.wine/drive_c/Program\ Files/Starcraft && sudo wine StarCraft.exe"
alias i='sudo apt-get install'
alias ci='sudo cpan -i'
# }}}
# darcs shortcuts {{{
alias dwn="darcs whatsnew"
alias darcsify="darcs init && darcs add \$(darcs whatsnew -ls | awk '/^a\ / {print \$2}') && darcs record -a -m'Initial import'"
alias dpl="darcs pull"
alias dps="darcs push"
alias dp="darcs pull && darcs push"
alias dr="darcs record"
alias dar="darcs amend-record"
alias db="darcs revert"
alias dqm="darcs query manifest"
# }}}
# work shortcuts {{{
alias rtp='PERL5LIB=/opt/rt3/local/lib:/opt/rt3/lib:$PERL5LIB RT_DBA_USER=postgres RT_DBA_PASSWORD='' sudo prove -l -I/opt/rt3/local/lib'
alias rtpv='PERL5LIB=/opt/rt3/local/lib:/opt/rt3/lib:$PERL5LIB RT_DBA_USER=postgres RT_DBA_PASSWORD='' sudo perl -Ilib -I/opt/rt3/local/lib'
alias grtp='PERL5LIB=/opt/rt3/local/lib:/opt/rt3/lib:$PERL5LIB RT_DBA_USER=postgres RT_DBA_PASSWORD='' sudo g prove -l -I/opt/rt3/local/lib'
alias grmt='PERL5LIB=/opt/rt3/local/lib:/opt/rt3/lib:$PERL5LIB RT_DBA_USER=postgres RT_DBA_PASSWORD='' sudo g make test'
alias unrt="ps aux -ww | grep standalone | sudo perl -lane 'system(qq{kill \$F[1]})'"
alias rert="unrt && sudo make start-httpd"
# }}}
# global shortcuts (don't need to be in the command position) {{{
alias -g L='|less'
alias -g G='|egrep'
alias -g H='|head'
alias -g T='|tail'
alias -g W='|wc'
# }}}
# fortune {{{
fortune.pl
# }}}

