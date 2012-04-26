_mco()
{
        local cur cmd agents

        COMPREPLY=()
        cur=${COMP_WORDS[COMP_CWORD]}
        prev=${COMP_WORDS[COMP_CWORD-1]}
        cmd=${COMP_WORDS[0]}

        if [ $COMP_CWORD -eq 1 ]; then
           agents=$($cmd | sed -n "s@Known commands: @@p")
           COMPREPLY=($(compgen -W "$agents" -- "$cur"))
        elif [ $COMP_CWORD -eq 2 ]; then
           options=$($cmd $prev --help | grep -o -- '-[^, ]\+') 
           COMPREPLY=($(compgen -W "$options" -- "$cur"))
        fi
}
[ -n "${have:-}" ] && complete -F _mco mco
