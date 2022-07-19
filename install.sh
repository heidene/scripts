#!/bin/bash

cd $HOME
git clone https://github.com/heidene/scripts.git scripts
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
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
  brew bundle install --file=scripts/Brewfile
else
  echo Failed installing Homebrew
  exit 1
fi

remote_install()
{
  CMD="$1 $2 $3"
  FAIL_MESSAGE=$4
  SHOULD_EXIT=$5
  echo $CMD $FAIL_MESSAGE $SHOULD_EXIT
  if bash -c "$($CMD)"  < /dev/tty; then
    echo Done executing script
  else
    echo $FAIL_MESSAGE
    if ${SHOULD_EXIT:-false} == true; then 
      exit 1
    fi
  fi
}

installSpacevim="curl -sLf https://spacevim.org/install.sh"
if remote_install $installSpacevim "Failled installing SpaceVim"; then
  vim  < /dev/tty
fi

git clone --bare https://github.com/heidene/dotfiles.git
fish
dotfilesNoTrack

exit 0