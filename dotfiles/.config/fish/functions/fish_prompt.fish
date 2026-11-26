function fish_prompt
    set -l last_status $status

    set_color bfa0f5
    printf '%s' (prompt_pwd)

    set -l repo_root (command git rev-parse --show-toplevel 2>/dev/null)
    if test -n "$repo_root"
        set -l repo_name (path basename -- "$repo_root")
        set -l revision (command git symbolic-ref --quiet --short HEAD 2>/dev/null)
        if test -z "$revision"
            set revision (command git rev-parse --short HEAD 2>/dev/null)
        end
        set_color a6cedc
        printf '  %s' "$repo_name"
        if test -n "$revision"
            set_color 9686a5
            printf ' · %s' "$revision"
        end
    end

    if test "$last_status" -eq 0
        set_color bfa0f5
    else
        set_color ec8899
        printf '  [%s]' "$last_status"
    end

    printf '\n❯ '
    set_color normal
end
