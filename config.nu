# config.nu
#
# Installed by:
# version = "0.102.0"
#

$env.config.buffer_editor = $env.HOME + "/.local/bin/nvimg"
$env.config.edit_mode = "vi"

$env.config.show_banner = false
$env.config.rm.always_trash = true

$env.config.footer_mode = "auto"

$env.ANDROID_HOME = $env.HOME + "/Library/Android/sdk"

# Setup PATH
$env.PATH = (
    (open /etc/paths | lines)
    | append [
        ~/.local/bin
        ~/.rvm/bin
        /opt/homebrew/bin
        ([$env.ANDROID_HOME "/platform-tools"] | str join)
        ([$env.ANDROID_HOME "/build-tools"] | str join)
        ([$env.ANDROID_HOME "/tools/bin"] | str join)
        ([$env.ANDROID_HOME "/emulator"] | str join)
        /Applications/Postgres.app/Contents/Versions/latest/bin
    ]
)

$env.HOMEBREW_NO_HINTS = 1
$env.JAVA_HOME = (/usr/libexec/java_home -v17)

$env.PATH = $env.PATH | uniq


#
# fnm setup
#
$env.PATH = ($env.PATH | prepend "~/.fnm")

load-env (fnm env --shell bash
    | lines
    | str replace 'export ' ''
    | str replace -a '"' ''
    | split column "="
    | rename name value
    | where name != "FNM_ARCH" and name != "PATH"
    | reduce -f {} {|it, acc| $acc | upsert $it.name $it.value }
)

$env.PATH = ($env.PATH
    | split row (char esep)
    | prepend $"($env.FNM_MULTISHELL_PATH)/bin)"
)

#
# Aliases
#
alias ll = ls -l
alias nvm = fnm
alias appopen = /usr/bin/open

