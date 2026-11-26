if not contains -- "$HOME/.local/bin" $PATH
    set -gx PATH "$HOME/.local/bin" $PATH
end
if test -z "$DOTNET_ROOT"; and test -x "$HOME/.local/opt/dotnet/dotnet"
    set -gx DOTNET_ROOT "$HOME/.local/opt/dotnet"
end

if status is-interactive
    alias ls 'ls --color=auto'
    alias grep 'grep --color=auto'
    set -g fish_autosuggestion_enabled 1
    set -g fish_color_autosuggestion brblack
    set -g fish_color_command magenta
    set -g fish_color_param normal
    set -g fish_color_quote green
    set -g fish_color_error red
    set -g fish_color_comment brblack
    set -g fish_color_valid_path --underline
end
