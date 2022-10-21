# 宏郎のzshrc

# homebrewの設定
# https://zenn.dev/sprout2000/articles/bd1fac2f3f83bc
# ↓m1m2mac以外ではやらない
typeset -U path PATH
path=(
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  /usr/bin
  /usr/sbin
  /bin
  /sbin
  /usr/local/bin(N-/)
  /usr/local/sbin(N-/)
  /Library/Apple/usr/bin
)


# # 他のファイルを読み込む
# function loadlib() {
#    lib=${1:?"You have to specify a library file"}
#    if [ -f "$lib" ];then #ファイルの存在を確認
#            . "$lib"
#    fi
# }
# 
# loadlib ./reactIncRc.sh

# pureの設定
fpath+=/opt/homebrew/share/zsh/site-functions
autoload -U promptinit; promptinit
prompt pure

# zplugの設定
# ↓ m1m2以外のmac用
# export ZPLUG_HOME=/usr/local/opt/zplug
# source $ZPLUG_HOME/init.zsh
export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "mollifier/anyframe", defer:2
zplug "zsh-users/zsh-completions", defer:2
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:2
zplug "mrowa44/emojify", defer:2

bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

zplug load


# # javaの環境設定
# export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
# 
# #pyenv
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"
# 
# # nvm
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
# source ~/.nvm/nvm.sh

# node_modules
#export NODE_PATH= ~/node_modules
export PATH=$PATH:./node_modules/.bin

# #ruby
# export PATH="$HOME/.rbenv/shims:$PATH"
# eval "$(rbenv init -)"
# ########################################
# 
# #go
# export GOENV_ROOT="$HOME/.goenv"
# export PATH="$GOENV_ROOT/bin:$PATH"
# eval "$(goenv init -)"
# export PATH="$PATH:$GOPATH/bin"

# 環境変数
export LANG=ja_JP.UTF-8

# # PostgreSQL
# export PGDATA=/usr/local/var/postgres

## peco
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(history -n 1 | eval $tac | awk '!a[$0]++' | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    # zle clear-screen
}
zle -N peco-select-history

bindkey '^R' peco-select-history

### nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH

# gcp
# source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
# source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt HIST_IGNORE_DUPS           # 前と重複する行は記録しない
setopt HIST_IGNORE_ALL_DUPS       # 履歴中の重複行をファイル記録前に無くす
setopt HIST_IGNORE_SPACE          # 行頭がスペースのコマンドは記録しない
setopt HIST_FIND_NO_DUPS          # 履歴検索中、(連続してなくとも)重複を飛ばす
setopt HIST_REDUCE_BLANKS         # 余分な空白は詰めて記録
setopt HIST_NO_STORE              # histroyコマンドは記録しない
setopt HIST_EXPIRE_DUPS_FIRST


# プロンプト
# 1行表示
# PROMPT="%~ %# "

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

########################################
# キーバインド

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
# bindkey '^R' history-incremental-pattern-search-backward

########################################
# エイリアス

## コマンド系
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias cd..='cd ..'

## mosquitto
alias mosquitto='/usr/local/opt/mosquitto/sbin/mosquitto'

## git
alias ga='git add .'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gcane='git commit -a --amend --no-edit'

alias gb='git branch'
alias gbd='git branch -d'
alias gbD='git branch -D'

alias gco='git checkout'
alias gcob='git checkout -b'

alias gpom='git push origin main'
alias gpoh='git push origin HEAD'

alias grh='git reset --hard'
alias grs='git reset --soft'
alias grh2='git reset --hard @~'

alias grbi='git rebase -i'

alias gs='git stash'
alias gsp='git stash pop'

export PATH="/usr/local/bin:$PATH"

## python
alias pyrn='python manage.py runserver 0.0.0.0:8080'
alias pymake='python manage.py makemigrations '
alias pymakeg='python manage.py makemigrations general'
alias pymig='python manage.py migrate'
alias pycsu='python manage.py createsuperuser'

## sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

## グローバル
alias -g L='| less'
alias -g G='| grep'

## 趣味
alias kyoko='imgcat ~/Pictures/ゆるゆり/kyoko.jpg'

## terminal 更新
alias relogin='exec $SHELL -l'

# 便利シェルスクリプト
## pipの中身を全部消す
pipDelete() {
  pip freeze |  xargs pip uninstall -y
}

## flask_tutorialを作成する
flt(){
  cp -rf ~/work/samples/flask_sample/ ./
  touch requirements.txt
  echo Flask > requirements.txt
  echo Flask-SQLAlchemy >> requirements.txt
  pip install -r requirements.txt
  python create_db.py
  pip freeze -l > requirements.txt
}

## zsh_historyの中身を整理
azh(){
  python ~/arrange_zsh_history.py
  relogin
}

# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi



########################################
# OS 別の設定
case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        #Linux用の設定
        alias ls='ls -F --color=auto'
        ;;
esac


export NVM_DIR="~/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
# vim:set ft=zsh:
eval "$(direnv hook zsh)"
