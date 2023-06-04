# Java dev

This repository is meant as a starting point for Java app development.

The macOS setup script will install the tools required for development on a (new) mac.

- [Installation](#installation)
- [What's included](#whats-included)
    - [Tools](#tools)
    - [Applications](#applications)
    - [Plugins and misc](#plugins-and-misc)
- [Additional functionality](#additional-functionality)

## Installation

Clone the repository and run the setup script:

```bash
git clone git@github.com:MarkHjorth/java-dev.git
cd java-dev
./setup-mac.sh
```

## What's included

The setup script will install the following tools, applications and plugins:

### Tools

| Tool                                                          | Description               |
| ------------------------------------------------------------- | ------------------------- |
| [Homebrew](https://brew.sh/)                                  | Package manager for macOS |
| [sdkman](https://sdkman.io/)                                  | SDK manager for Java      |
| [Github CLI](https://cli.github.com/)                         | CLI for Github            |
| [K6](https://k6.io/)                                          | Load testing tool         |
| [Aws CLI](https://aws.amazon.com/cli/)                        | CLI for AWS               |
| [Kubectl](https://kubernetes.io/docs/tasks/tools/)            | CLI for Kubernetes        |
| [Maven](https://maven.apache.org/)                            | Build tool for Java       |
| [Git](https://git-scm.com/)                                   | Version control system    |
| [Node](https://nodejs.org/en/)                                | JavaScript runtime        |
| [Vault](https://www.vaultproject.io/)                         | Secrets management        |
| [Yarn](https://yarnpkg.com/)                                  | Package manager for Node  |
| [GnuPG](https://gnupg.org/)                                   | Encryption tool for GPG   |
| [Pinentry mac](https://formulae.brew.sh/formula/pinentry-mac) | Pinentry for GPG          |
| [Zsh](https://zsh.org/)                                       | Shell                     |
| [Oh my zsh](https://ohmyz.sh/)                                | Zsh plugin manager        |

### Applications
| Application                                                 | Description         |
| ----------------------------------------------------------- | ------------------- |
| [Slack](https://slack.com/)                                 | Chat                |
| [Docker](https://www.docker.com/)                           | Container runtime   |
| [Lens](https://k8slens.dev/)                                | Kubernetes GUI      |
| [Alt-tab](https://alt-tab-macos.netlify.app/)               | Alt-tab replacement |
| [Insomnia](https://insomnia.rest/)                          | REST client         |
| [Visual Studio Code](https://code.visualstudio.com/)        | Code editor         |
| [AWS VPN client](https://aws.amazon.com/vpn/)               | VPN client          |
| [Jetbrains Toolbox](https://www.jetbrains.com/toolbox-app/) | IDE manager         |
| [Okta cli](https://cli.okta.com)                            | Okta CLI            |
| [Zoom](https://zoom.us/)                                    | Video conferencing  |

### Plugins and misc
| Plugin                                                                                                                    | Description                     |
| ------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| [Powerlevel10k](https://github.com/romkatv/powerlevel10k)                                                                 | Zsh theme                       |
| [Zsh autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)                                                   | Autosuggestions for Zsh         |
| [Zsh syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)                                           | Syntax highlighting for Zsh     |
| [Meslo Nerd Font](https://github.com/romkatv/powerlevel10k-media/blob/master/MesloLGS%20NF%20Regular.ttf)                 | Font for Powerlevel10k          |
| [VSCode IntelliJ IDEA Keybindings](https://marketplace.visualstudio.com/items?itemName=k--kato.intellij-idea-keybindings) | IntelliJ keybindings for VSCode |
| [VSCode Github theme](https://marketplace.visualstudio.com/items?itemName=GitHub.github-vscode-theme)                     | Github theme for VSCode         |
| [VSCode Indent rainbow](https://marketplace.visualstudio.com/items?itemName=oderwat.indent-rainbow)                       | Indent rainbow for VSCode       |
| [VSCode Rainbow brackets](https://marketplace.visualstudio.com/items?itemName=tejasvi.rainbow-brackets-2)                 | Rainbow brackets for VSCode     |
| [VSCode Gitlens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)                                     | Gitlens for VSCode              |
| [VSCode Github Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)                               | Github Copilot for VSCode       |

## Additional functionality
The setup script will ask you if you want to generate an SSH key and GPG key. If you do, it will prompt you for your email address and name. The keys will be generated and added to the ssh-agent and gpg-agent respectively.
