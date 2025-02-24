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

alias vim='nvim'
alias vi='nvim'
alias gcz='cz'

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
ssh-vps() {
  env -i TERM=xterm-256color ssh vps
}
# 
# adb
#
alias adb-input-menu='adb shell input keyevent 82'
alias adb-scrcpy='scrcpy -S -m 1080 >/dev/null 2>&1 &'
alias adb-noproxy="adb shell settings put global http_proxy :0"
alias aider='all_proxy= aider'
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
export PATH="/Users/tanzheng/.local/bin:$PATH"
# export PATH=$HOME/bin/command-line-tools/sdk/HarmonyOS-NEXT-DB1/openharmony/toolchains:$PATH

export LANG="en_US.UTF-8"
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"

export SHELL="zsh"
export LEFTHOOK=0

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


export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

zinit snippet OMZP::git
zinit snippet OMZP::vscode
zinit snippet OMZP::brew
zinit snippet OMZP::rbenv
zinit snippet OMZP::fnm

zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=180'

export PATH="$(brew --prefix)/opt/python@3.10/libexec/bin:$PATH"

eval "$(fnm env --use-on-cd)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
