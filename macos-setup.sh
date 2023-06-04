# Check if running on macOS:
unamestr=$(uname)
if [[ "$unamestr" != 'Darwin' ]]; then
  read -p "This script has only been tested with macOS. Do you want to run it anyway? (y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
fi

# Check if Xcode is installed, install if not:
if [ -d "$(xcode-select -p)" ]; then
  echo "Xcode already installed"
else
  echo "Installing Xcode..."
  xcode-select --install
  read -n 1 -s -r -p "Press any key to continue, when Xcode is installed"
  echo
  if [ -d "$(xcode-select -p)" ]; then
    echo "Xcode installed"
  else
    echo "Xcode not installed, aborting..."
    exit 1
  fi
fi

# Config variables:
generateSShKey=false
generateGpgKey=false
loggedInGithub=false

# Ask if we should set up SSH key:
read -p "Generate SSH key? (Y/n): "
if [[ ! $REPLY =~ ^[Nn]$ && ! $REPLY =~ ^[Nn][Oo]$ ]]; then
  generateSShKey=true
fi

# Ask if we should set up GPG key:
read -p "Generate GPG key? (Y/n): "
if [[ ! $REPLY =~ ^[Nn]$ && ! $REPLY =~ ^[Nn][Oo]$ ]]; then
  generateGpgKey=true
fi

# Install Brew:
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
export HOMEBREW_CASK_OPTS="--appdir=$HOME/Applications"

# Install Java:
brew tap sdkman/tap
brew install sdkman-cli
SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec
export SDKMAN_DIR
echo \
"export SDKMAN_DIR=$(brew --prefix sdkman-cli)/libexec\n\
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"" >>$HOME/.zshrc
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
source "$SDKMAN_DIR/bin/sdkman-init.sh"
chmod -x $SDKMAN_DIR/bin/sdkman-init.sh
zsh $SDKMAN_DIR/bin/sdkman-init.sh
sed 's:sdkman_auto_answer=.*:sdkman_auto_answer=true:g' $SDKMAN_DIR/etc/config | tee $SDKMAN_DIR/etc/config
sdk install java 20.0.1-open
sdk use java 20.0.1-open
sdk default java 20.0.1-open
sed 's:sdkman_auto_answer=.*:sdkman_auto_answer=false:g' $SDKMAN_DIR/etc/config | tee $SDKMAN_DIR/etc/config

# Install common cli tools:
brew install gh k6 awscli kubernetes-cli maven git node@16 vault yarn gnupg pinentry-mac zsh

# Install common applications:
brew install --cask slack docker lens alt-tab insomnia visual-studio-code aws-vpn-client jetbrains-toolbox okta zoom

# Install extensions for vscode:
code --install-extension k--kato.intellij-idea-keybindings && code --install-extension GitHub.github-vscode-theme && code --install-extension oderwat.indent-rainbow && code --install-extension tejasvi.rainbow-brackets-2 && code --install-extension eamodio.gitlens && code --install-extension GitHub.copilot

# Install Oh My ZSH:
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k:
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed 's:ZSH_THEME=.*:ZSH_THEME="powerlevel10k/powerlevel10k":g' $HOME/.zshrc | tee $HOME/.zshrc

# Install Oh My ZSH plugins and font:
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sed 's:plugins=.*:plugins=(git gh brew aws vault vscode docker docker-compose kubectl mvn sdk zsh-syntax-highlighting zsh-autosuggestions):g' $HOME/.zshrc | tee $HOME/.zshrc
curl -fsSL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf >$HOME"/Library/Fonts/MesloLGS NF Regular.ttf"
osascript -e "tell application \"Terminal\" to set the font name of window 1 to \"MesloLGS NF Regular\""

# Add SSH config:
if [[ $generateSShKey == true ]]; then
  echo \
    "Host github.com\n \
    UseKeychain yes\n \
    AddKeysToAgent yes\n \
    Hostname github.com\n \
    IdentityFile $HOME/.ssh/github_trackunit\n \
    User git" >>$HOME/.ssh/config

  ssh-keygen -f $HOME/.ssh/github_trackunit -t rsa -b 4096 -C "github_trackunit" -O user@git
  echo Adding SSH key to keychain...
  ssh-add --apple-use-keychain $HOME/.ssh/github_trackunit
  gh auth login -h github.com -p ssh -s "read:gpg_key","write:gpg_key","read:public_key" -w
  loggedInGithub=true
fi

# Add GPG config:
if [[ $generateGpgKey == true ]]; then
  # Generate GPG key:
  pkill gpg-agent
  echo "pinentry-program $(which pinentry-mac)" >>$HOME/.gnupg/gpg-agent.conf
  gpg-agent --daemon
  gpg --default-new-key-algo rsa4096 --gen-key
  gpgProgram=$(which gpg)
  gpgKeyId=$(gpg --list-secret-keys --with-colons | awk -F: '$1 == "sec" {print $5}')
  pgpPublicKey=$(gpg --armor --export $gpgKeyId)
  git config --global --unset gpg.format
  git config --global user.signingkey $gpgKeyId
  git config --global commit.gpgsign true
  git config --global gpg.program $gpgProgram
  git config --global credential.helper osxkeychain
  echo 'export GPG_TTY=$(tty)' >>$HOME/.zshrc
  pkill gpg-agent
  gpg-agent --daemon
  if [[ $loggedInGithub == false ]]; then
    gh auth login -h github.com -p ssh -s "read:gpg_key","write:gpg_key","read:public_key" -w
    loggedInGithub=true
  fi
  echo $pgpPublicKey | gh gpg-key add
fi
