# bash-libs
A repo of bash functions to source

## Usage
To use these functions you need to source the files from scripts like so
```
#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/microdc/bash-libs/master/common.sh)
```

## OSX
This procedure works on both OSX and Linux providing you use GNU bash.

## Make sure we are using GNU Bash on OSX
```
$ brew install bash
$ $ which -a bash
/usr/local/bin/bash # GNU Bash (Version 4)
/bin/bash           # MAC Bash (Version 3)
```

