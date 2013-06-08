# mytheme.zsh-theme
# vim:set ft=zsh:

# Detect and print edit mode (for Vim keybind)
function zle-line-init zle-keymap-select {
    if [ -z "${ORIG_RPROMPT}" ]; then
	    ORIG_RPROMPT=$RPROMPT
    fi
    #RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"${ORIG_RPROMPT}
    if [ "${KEYMAP}" = "vicmd" ];then
	    RPS1="%{${fg[red]}%}-- COMMAND -- %{${reset_color}%}${ORIG_RPROMPT}"
    else
	    RPS1=${ORIG_RPROMPT}
    fi
    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# print git branch on RPROMPT
# http://d.hatena.ne.jp/uasi/20091017/1255712789
# TODO: http://d.hatena.ne.jp/mollifier/20100906/p1
function rprompt-git-current-branch {
    local name st color

    if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
        return
    fi
    name=$(basename "`git symbolic-ref HEAD 2>/dev/null`")
    if [[ -z $name ]]; then
        return
    fi
    st=`git status 2>/dev/null`
    if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
        color=${fg[green]}
    elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
        color=${fg[yellow]}
    elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
        color=${fg_bold[red]}
    else
        color=${fg[red]}
    fi
    desc=$(git describe --abbrev=1 2>&/dev/null)

    echo "%{$color%}$name($desc)%{$reset_color%} "
}

autoload colors
colors
case ${UID} in
    0)
        PCOLOR=${fg_bold[yellow]}
        ;;
    *)
        PCOLOR=${fg[blue]}
        ;;
esac
setopt prompt_subst
PROMPT="%{${PCOLOR}%}%#%{${reset_color}%} "
PROMPT2="%{${PCOLOR}%}%_>%{${reset_color}%} "
RPROMPT=["%(?.%{${fg[green]}%}%?.%{${fg[red]}%}%?)%{${reset_color}%};%n;\`rprompt-git-current-branch\`%{${PCOLOR}%}%~%{${reset_color}%}]"
SPROMPT="%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && PROMPT="%{${fg[black]}${bg[yellow]}%}${HOST%%.*}%{${reset_color}%} ${PROMPT}"
#ZSH_THEME_GIT_PROMPT_PREFIX=''
#ZSH_THEME_GIT_PROMPT_SUFFIX="%{${reset_color}%}"
#ZSH_THEME_GIT_PROMPT_CLEAN="%{${fg[green]}%}-"
#ZSH_THEME_GIT_PROMPT_DIRTY="%{${fg[red]}%}*"
