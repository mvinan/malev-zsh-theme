function real_time() {
    local color="%{$fg_no_bold[blue]%}";
    local color2="%{$fg_no_bold[yellow]%}";
    local time="[$(date +%H:%M)]";
    local color_reset="%{$reset_color%}";
    echo "${color}${time}${color_reset} 🧑‍💻  ${color}$(host_name)${color_reset}";
}

function host_name() {
    local color="%{$fg_no_bold[blue]%}";
    local color_reset="%{$reset_color%}";
    echo "${color}[%n]${color_reset}";
}

function directory() {
    local color="%{$fg_no_bold[magenta]%}";
    local directory="${PWD/#$HOME/~}";
    local color_reset="%{$reset_color%}";
    echo "🗂  ${color}${directory}${color_reset}";
}

function update_git_status() {
    GIT_STATUS=$(git_prompt_info);
}

function get_git_prompt_status() {
    local normal_color="%{$fg_bold[black]%}";
    local color_reset="%{$reset_color%}";
    local git_prompt=""
    if [ -n "$(git_prompt_status)" ];
    then
        git_prompt="${normal_color}[${color_reset}$(git_prompt_status)${normal_color}]${color_reset}"
    else
        git_prompt=""
    fi
    echo "${git_prompt}"
}

function git_status() {
    echo "$(get_git_prompt_status)${GIT_STATUS}"
}

function update_command_status() {
    local arrow="";
    local color_reset="%{$reset_color%}";
    local reset_font="%{$fg_no_bold[white]%}";
    if $1;
    then
        arrow="%{$fg_no_bold[blue]%}❱%{$fg_no_bold[blue]%}❱";
    else
        arrow="%{$fg_bold[red]%}❱❱";
    fi
    COMMAND_STATUS="${arrow}${reset_font}${color_reset}";
}

update_command_status true;

function command_status() {
    echo "${COMMAND_STATUS}"
}

output_command_execute_after() {
    if [ "$COMMAND_TIME_BEIGIN" = "-20200325" ] || [ "$COMMAND_TIME_BEIGIN" = "" ];
    then
        return 1;
    fi

    local cmd="${$(fc -l | tail -1)#*  }";
    local color_cmd="";
    if $1;
    then
        color_cmd="$fg_no_bold[green]";
    else
        color_cmd="$fg_bold[red]";
    fi
    local color_reset="$reset_color";
    cmd="${color_cmd}${cmd}${color_reset}"

    local time="[$(date +%H:%M:%S)]"
    local color_time="$fg_no_bold[cyan]";
    time="${color_time}${time}${color_reset}";
}


precmd() {
    local last_cmd_return_code=$?;
    local last_cmd_result=true;
    if [ "$last_cmd_return_code" = "0" ];
    then
        last_cmd_result=true;
    else
        last_cmd_result=false;
    fi

    update_git_status;

    update_command_status $last_cmd_result;

    output_command_execute_after $last_cmd_result;
}

setopt PROMPT_SUBST;

TMOUT=1;
TRAPALRM() {
    if [ "$WIDGET" = "" ] || [ "$WIDGET" = "accept-line" ] ; then
        zle reset-prompt;
    fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_no_bold[red]%}[%{$fg_no_bold[yellow]%}";
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}";
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_no_bold[red]%}] ○";
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_no_bold[red]%}]%{$reset_color%} %{$fg_bold[green]%}●";

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[blue]%}!"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}-"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[magenta]%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[yellow]%}#"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[cyan]%}?"

RPROMPT='$(git_status)';
PROMPT=$'┌─╼ $(real_time) $(directory)\
└╼ $(command_status) ';