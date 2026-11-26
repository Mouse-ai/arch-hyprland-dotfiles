function y --description 'Open Yazi and return to its last directory'
    set -l cwd_file (mktemp -t yazi-cwd.XXXXXX); or return 1
    command yazi --cwd-file="$cwd_file" $argv
    set -l result $status

    set -l destination
    if test "$result" -eq 0; and read -z destination < "$cwd_file"; and test -d "$destination"
        builtin cd -- "$destination"; or set result $status
    end

    command rm -f -- "$cwd_file"
    return $result
end
