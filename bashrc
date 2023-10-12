alias ll='ls -l'
alias la='ls -a'
alias vim='nvim'
alias rm='safe-rm'
alias typora='open -a typora'
alias todo='vim ~/prj/note/orgs/gtd.org'
# alias ssh="trzsz -d ssh"
alias ssh="TERM=xterm-256color ssh"
alias cr="code -r"

# 
# proxy
#
alias proxy='export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890'
alias noproxy='export https_proxy= http_proxy= all_proxy='
proxy

# 
# git
#
alias g='git'

alias ga='git add'
alias gaa='git add --all'

alias gb='git branch'
alias gba='git branch -a'

alias gc='git commit --verbose'
alias gco='git checkout'
alias gcz='npx git-cz'

alias gd='git diff'
alias gdc='git diff --cached'

alias greport='git_log.py ~/prj'
alias gzip="git archive HEAD -o"

alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'
alias glo="git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)' --all"

alias gl='git pull'
alias gp='git push'
alias gst='git status'

# Warn if the current branch is a WIP
function gwork_in_progress() {
  command git -c log.showSignature=false log -n 1 2>/dev/null | grep -q -- "--wip--" && echo "$(tput setaf 124)WIP$(tput sgr0)"
}

function gdnolock() {
  git diff "$@" ":(exclude)package-lock.json" ":(exclude)*.lock"
}

function grename() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $0 old_branch new_branch"
    return 1
  fi

  # Rename branch locally
  git branch -m "$1" "$2"
  # Rename branch in origin remote
  if git push origin :"$1"; then
    git push --set-upstream origin "$2"
  fi
}

# 
# adb
#
alias adb-input-menu='adb shell input keyevent 82'
alias adb-scrcpy='scrcpy -w -S -m 1080 >/dev/null 2>&1 &'
alias adb-noproxy="adb shell settings put global http_proxy :0"
function adb-proxy() {
  if [ -z "$1" ]; then
	echo "Usage: adb-proxy <proxy-port>"
	return 1
  fi
  ifconfig | grep -Eo '(172|192)[.0-9]+' | head -1 | xargs -I{} echo adb shell settings put global http_proxy {}:$1
  ifconfig | grep -Eo '(172|192)[.0-9]+' | head -1 | xargs -I{} adb shell settings put global http_proxy {}:$1
}
function adb-reverse-tcp() {
  adb reverse tcp:$1 tcp:$1
}

# 
# env
#
export EDITOR='nvim'
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_NDK=$HOME/Library/Android/sdk/ndk/21.4.7075529

export PATH=$PATH:$HOME/bin
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$HOME/Library/Python/3.9/bin
export PATH=$PATH:$HOME/bin/apache-maven-3.8.6/bin

export LANG="en_US.UTF-8"
# export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"

export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/brew.git" 
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"

if [ -f ~/bin/sensible.bash ]; then
   source ~/bin/sensible.bash
fi

if [ -f ~/bin/z.sh ]; then
   source ~/bin/z.sh
fi

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		printf "git:\e[36m${BRANCH}\e[31m${STAT}\e[m"
	else
		printf ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}


function parse_proxy_state() {
	if [ -n "${http_proxy}" ]
	then
		printf "(p)"
	else
		printf ""
	fi
}

export PS1="\n\[\e[94m\]# \w\[\e[m\] \$(parse_git_branch) \$(gwork_in_progress) [\t]\n\$(parse_proxy_state)\[\e[31m\]\\$\[\e[m\] "

# export NVM_DIR="$HOME/.nvm"
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


# eval "$(thefuck --alias)"
