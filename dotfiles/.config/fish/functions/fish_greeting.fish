function fish_greeting
    set -l desktop "$XDG_CURRENT_DESKTOP"
    if test -z "$desktop"
        set desktop '—'
    end
    set -l kernel (command uname -r)
    set -l memory (command free -h | command awk '/^Mem:/ { print $3 " / " $2 }')

    set -l logo \
        '       /\\' \
        '      /  \\' \
        '     /\   \\' \
        '    /      \\' \
        '   /   ,,   \\' \
        '  /   |  |  -\\' \
        " /_-'      '-_\\"

    set -l info '' 'Arch Linux' "$desktop" "$kernel" "$memory" '' ''
    set -l labels '' 'ОС' 'Рабочий стол' 'Ядро' 'Память' '' ''

    printf '\n'
    for row in (seq (count $logo))
        set_color magenta
        printf '  %-18s' "$logo[$row]"
        if test -n "$info[$row]"
            set_color brblack
            set -l padding (math 15 - (string length -- "$labels[$row]"))
            printf '%s%*s' "$labels[$row]" $padding ''
            set_color normal
            printf '%s' "$info[$row]"
        end
        printf '\n'
    end
    set_color normal
    printf '\n'
end
