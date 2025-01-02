# my note
#   curl https://github.com/a690700752.keys >> ~/.ssh/authorized_keys
#
# gradle
#   systemProp.http.proxyHost=127.0.0.1
#   systemProp.https.proxyHost=127.0.0.1
#   systemProp.https.proxyPort=7890
#   systemProp.http.proxyPort=7890
#
#   systemProp.https.nonProxyHosts=nexus.yzw.cn|devops.cscec.com|localhost
#   systemProp.http.nonProxyHosts=nexus.yzw.cn|devops.cscec.com|localhost
#
# zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# zstyle ':omz:plugins:nvm' lazy yes
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=180'
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(
  git
  z
  zsh-autosuggestions
  colored-man-pages
  vscode
  # nvm
  # thefuck
  brew
  rbenv
  fnm
  # adb
  yarn
  # vi-mode
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias vim='nvim'
alias vi='nvim'
alias tls='todo.sh -c ls'
alias tadd='todo.sh -c add'
alias tla='todo.sh -c ls | grep \(A'
alias tdo='todo.sh -c do'
alias tedit='todo.sh -c edit'
alias gcz='cz'
alias windsurf='open -a Windsurf'

[[ ! -f ~/.p.env ]] || source ~/.p.env

killnx()
{
  ps -ef | grep 'nx/src/daemon' | grep -v 'grep' | awk '{print $2}' | xargs kill
}

git-cfg-user() {
  if [ `git remote -v | grep yzw.cn | wc -l` -eq 0 ]; then
      git config user.name moonveil
      git config user.email tz59pk@gmail.com
  else
      git config user.name $P_NAME
      git config user.email $P_EMAIL_WORK
  fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# 
# proxy
#
alias proxy='export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890'
alias noproxy='export https_proxy= http_proxy= all_proxy='
proxy
export no_proxy=::1,127.0.0.1
# alias ssh="env -i TERM=xterm-256color ssh"
# alias ssh="kitty +kitten ssh"
alias rm='safe-rm'
ssh-home() {
  env -i TERM=xterm-256color ssh home
}
ssh-mi () {
  env -i TERM=xterm-256color ssh mi
}
# 
# adb
#
alias adb-input-menu='adb shell input keyevent 82'
alias adb-scrcpy='scrcpy -S -m 1080 >/dev/null 2>&1 &'
alias adb-noproxy="adb shell settings put global http_proxy :0"
adb-proxy() {
  if [ -z "$1" ]; then
	echo "Usage: adb-proxy <proxy-port>"
	return 1
  fi
  ifconfig | grep -Eo '(172|192)[.0-9]+' | head -1 | xargs -I{} echo adb shell settings put global http_proxy {}:$1
  ifconfig | grep -Eo '(172|192)[.0-9]+' | head -1 | xargs -I{} adb shell settings put global http_proxy {}:$1
}
adb-reverse-tcp() {
  adb reverse tcp:$1 tcp:$1
}
alias feilian-vpn="sudo route delete '0/1' && sudo route -n add -host 10.107.15.99 -interface utun3"

# 
# env
#
export EDITOR='nvim'
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_NDK=$HOME/Library/Android/sdk/ndk/21.4.7075529

export PATH=$HOME/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$HOME/bin/apache-maven-3.8.6/bin
export PATH="$(brew --prefix)/opt/python@3.10/libexec/bin:$PATH"
# export PATH=$HOME/bin/command-line-tools/sdk/HarmonyOS-NEXT-DB1/openharmony/toolchains:$PATH

export LANG="en_US.UTF-8"
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"

export SHELL="zsh"
export LEFTHOOK=0

# zprof

# eval $(thefuck --alias)

eval "$(fnm env --use-on-cd)"

startEC() {
    nohup /Applications/EasyConnect.app/Contents/Resources/bin/EasyMonitor > /dev/null 2>&1 &
    nohup /Applications/EasyConnect.app/Contents/MacOS/EasyConnect > /dev/null 2>&1 &
}

fuckEC() {
    function killprocess()
    {
        processname=$1
        killall $processname >/dev/null 2>&1
        proxypids=$(ps aux | grep -v grep | grep $processname | awk '{print $2}')
        for proxypid in $proxypids
        do
            kill -9 $proxypid
        done
    }

    killprocess svpnservice
    killprocess CSClient
    killprocess ECAgentProxy
    killprocess /Applications/EasyConnect.app/Contents/MacOS/EasyConnect

    pkill ECAgent
    pkill EasyMonitor
}

# export NVM_DIR="$HOME/.nvm"
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
