autoload -U promptinit
promptinit
prompt adam2 gray yellow green white
RPS1='[%*]'

# uses completion cache
zstyle ':completion::complete:*' use-cache 1

HISTFILE=$HOME/.history
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history
setopt share_history
setopt hist_ignore_space

setopt correctall
setopt nobeep
setopt auto_cd
setopt multios
setopt extended_glob
setopt nullglob
setopt list_ambiguous
setopt no_nomatch
setopt interactivecomments # Allow comments even in the interactive shell
setopt listpacked # column width isn't constant

# Bindkeys {{{
bindkey -v                       # Use vim bindings
bindkey "^A" beginning-of-line   # Like in bash, for memory
bindkey "^E" end-of-line         # Like in bash
bindkey "^N" accept-and-infer-next-history # Enter; pop next history event
bindkey "^O" push-line           # Pushes line to buffer stack
bindkey "^P" get-line            # Pops top of buffer stack
bindkey "^R" history-incremental-search-backward # Like in bash, but should !
bindkey "^T" transpose-chars     # Transposes adjacent chars
bindkey "^Z" accept-and-hold     # Enter and push line
bindkey " " magic-space          # Expands from hist (!vim )
bindkey "^\\" pound-insert       # As an alternative to ctrl-c; will go in hist
bindkey "\e[3~" delete-char      # Enable delete
# }}}

alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias cp='nocorrect cp'

# the default utilities are so laaaame
alias man="man -P vimmanpager"
#alias top="htop"

# colorify utilities
alias ls='ls -G'
alias ll='ls -lhA'
alias ack='ack --color'
# see also ~/.zshenv

# services
alias nao="(TERM='rxvt'; telnet nethack.alt.org)"
alias cao="telnet crawl.akrasiac.org"
alias termcast="telnet noway.ratry.ru 37331"
alias sporkhack='telnet nethack.nineball.org'

# shell accounts
alias katron="ssh katron.org"
alias dk="ssh darcs.katron.org"
alias arcane="ssh 66.41.105.165"
alias jsn="ssh noway.ratry.ru"
alias akrasiac="ssh henzell@crawl.akrasiac.org"
alias diesel="ssh diesel.bestpractical.com"
alias rax="ssh sartak.org"
alias home='ssh $HOMEIP'

# shortcuts
alias tdA="todo -f children"
alias dwn="darcs whatsnew"
alias emacs="emacs -nw"
alias darcsify="darcs init && darcs add \$(darcs whatsnew -ls | awk '/^a\ / {print \$2}') && darcs record -a -m'Initial import'"
alias dpl="darcs pull"
alias dps="darcs push"
alias dp="darcs pull && darcs push"
alias dr="darcs record"
alias dar="darcs amend-record"
alias db="darcs revert"
alias starcraft="cd /home/sartak/.wine/drive_c/Program\ Files/Starcraft && sudo wine StarCraft.exe"
alias rtp='PERL5LIB=/opt/rt3/local/lib:/opt/rt3/lib:$PERL5LIB RT_DBA_USER=postgres RT_DBA_PASSWORD='' sudo prove -l -I/opt/rt3/local/lib'
alias rtpv='PERL5LIB=/opt/rt3/local/lib:/opt/rt3/lib:$PERL5LIB RT_DBA_USER=postgres RT_DBA_PASSWORD='' sudo perl -Ilib -I/opt/rt3/local/lib'
alias grtp='PERL5LIB=/opt/rt3/local/lib:/opt/rt3/lib:$PERL5LIB RT_DBA_USER=postgres RT_DBA_PASSWORD='' sudo g prove -l -I/opt/rt3/local/lib'
alias grmt='PERL5LIB=/opt/rt3/local/lib:/opt/rt3/lib:$PERL5LIB RT_DBA_USER=postgres RT_DBA_PASSWORD='' sudo g make test'
alias i='sudo apt-get install'
alias ci='sudo cpan -i'
alias unrt="ps aux -ww | grep standalone | sudo perl -lane 'system(qq{kill \$F[1]})'"
alias rert="unrt && sudo make start-httpd"

# global shortcuts
alias -g L='|less'
alias -g G='|egrep'
alias -g H='|head'
alias -g T='|tail'
alias -g W='|wc'
alias -g '...'='../..'
alias -g '....'='../../..'
alias -g '.....'='../../../..'
alias -g '......'='../../../../..'

fortune.pl
