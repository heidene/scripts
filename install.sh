#!/bin/bash

cd $HOME
if xcode-select --install; then
  echo XCode-select installed
else
  printf 'xcode-select installation failed, do you wish to continue? (y/n)'
  read answer < /dev/tty
  
  if [ "$answer" != "${answer#[Yy]}" ]; then
    echo Continue with the installation...
  else
    echo Failed installing xcode-select
    exit 1
  fi
fi

installHomebrew="curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
if bash -c "$($installHomebrew)"  < /dev/tty; then
  brew bundle install
else
  echo Failed installing Homebrew
  exit 1
fi

remote_install()
{
  CURL=$1
  FAIL_MESSAGE=$2
  SHOULD_EXIT="${$3:-FALSE}"
  if bash -c "$($CURL)"  < /dev/tty; then
    echo Done executing script
  else
    echo $FAIL_MESSAGE
    if $SHOULD_EXIT == true; then 
      exit 1
    fi
  fi
}

installSpacevim="curl -sLf https://spacevim.org/install.sh"
remote_install $installSpacevim "Failled installing SpaceVim"

exit 0