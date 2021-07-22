all: brew init-env install-tools

all-upgrade: brew-upgrade nvim-upgrade cask-fonts-upgrade cask-upgrade mas-upgrade

TAGS := all

brew: brew-init brew-install brew-custom cask-install cask-fonts-install

brew-init:
	sudo -v
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install | /usr/bin/ruby
	brew update
	brew tap heroku/brew
	brew tap homebrew/bundle
	brew tap homebrew/cask
	brew tap homebrew/core
	brew tap homebrew/services
	brew tap homebrew/cask-drivers
	brew tap homebrew/cask-fonts
	brew tap homebrew/cask-versions

BREW_LIST= \
	neovim \
	git \
	httpie \
	bash \
	bash-completion2 \
	git \
	git-delta \
	git-extras \
	git-lfs \
	git-quick-stats \
	hub \
	tig \
	cloc \
	mas \
	tldr \
	wakeonlan \
	youtube-dl \
	z \
	ffmpeg \
	heroku \
	asdf \
	imagemagick \
	rbenv \
	poetry \
	ruby-build \
	hashicorp/tap/terraform-ls \
	terraformer \
	yarn \
	awscli \
	shellcheck \
	glances \
	htop \
	ncdu \
	docker-compose \
	docker-machine \
	lazydocker \
	nvim \
	python3 \

brew-install:
	-brew install $(BREW_LIST)

brew-custom:
	if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then \
		echo '/usr/local/bin/bash' | sudo tee -a /etc/shells; \
		chsh -s /usr/local/bin/bash; \
	fi;
	brew install --HEAD universal-ctags/universal-ctags/universal-ctags

brew-upgrade:
	-brew upgrade $(BREW_LIST)

init-env: folders-create item2-setup vim-setup nvim-setup xcode-setup aliases-create

folders-create:
	-mkdir "${HOME}/Applications"
	-mkdir "${HOME}/Archive"
	-mkdir "${HOME}/Work"
	-mkdir "${HOME}/projects"
	-mkdir "${HOME}/code"
	-mkdir "${HOME}/.tmp"
	-mkdir "${HOME}/.ssh"
	-mkdir "${HOME}/.ssh/control"
	-mkdir -p ~/.config/nvim
	chmod 700 "${HOME}/.ssh"
	-mkdir "${HOME}/.gnupg"
	chmod 700 "${HOME}/.gnupg"

# Install themes for Terminal and iTerm2
item2-setup:
	open "${PWD}/terminal/Solarized Dark Higher Contrast.itermcolors"
	open "${PWD}/terminal/Solarized Dark xterm-256color.terminal"
	open "${PWD}/terminal/Solarized Dark.itermcolors"

vim-setup:
	-mkdir "${HOME}/.vim"
	-mkdir "${HOME}/.vim/autoload"
	-mkdir "${HOME}/.vim/backups"
	-mkdir "${HOME}/.vim/colors"
	-mkdir "${HOME}/.vim/swaps"
	-mkdir "${HOME}/.vim/undo"
	curl -LSso "${HOME}/.vim/autoload/plug.vim" "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
	-ln -sf ${PWD}/vim/snapshot.vim "${HOME}/.vim/snapshot.vim"
	-ln -sf ${PWD}/.vimrc "${HOME}"

nvim-setup:
	mkdir -p ~/.config/nvim
	ln -sf $(PWD)/nvim/init.vim ~/.config/nvim/init.vim
	ln -sf $(PWD)/nvim/coc-settings.json ~/.config/nvim/coc-settings.json
	ln -snf $(PWD)/nvim/vim-ftplugins ~/.config/nvim/ftplugin

xcode-setup:
	xcode-select --install &> /dev/null
	# Wait until the XCode Command Line Tools are installed
	until xcode-select --print-path &> /dev/null; do sleep 5; done
	# Point the `xcode-select` developer directory to
	# the appropriate directory from within `Xcode.app`
	# https://github.com/alrra/dotfiles/issues/13
	sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
	# Prompt user to agree to the terms of the Xcode license
	# https://github.com/alrra/dotfiles/issues/10
	sudo xcodebuild -license

DOT_FILES_LIST= \
	.ackrc \
	.bash_profile \
	.bashrc \
	.ctags \
	.dircolors \
	.exports \
	.gemrc \
	.git-template-commit \
	.gitconfig \
	.gitignore \
	.inputrc \
	.irbrc \
	.mackup.cfg \
	.pryrc \
	.psqlrc \

aliases-create:
	for dot_file in $(DOT_FILES_LIST) ; do \
		ln -sf "${PWD}/$$dot_file" "${HOME}"; \
	done
	ln -sf "${PWD}/.bin" "${HOME}"

install-tools: install-npm gem npm pip3

install-npm:
	sudo mkdir "/usr/local/lib/node_modules"
	sudo chown -R $(whoami) "/usr/local/lib/node_modules"
	npm install npm -g

gem:
	gem install solargraph rubocop neovim
	gem install rubocop-rspec rubocop-rails rubocop-performance rubocop-rake
	gem install sorbet sorbet-runtime
	gem install brakeman reek

pip3:
	pip3 install --upgrade pynvim
	pip3 install --upgrade vim-vint
	pip3 install --upgrade autopep8 flake8 bandit pytype # black

npm:
	npm install -g neovim
	npm install -g prettier eslint babel-eslint eslint-plugin-import eslint-plugin-node
	# npx install-peerdeps -g eslint-config-airbnb
	npm install -g stylelint stylelint-config-recommended stylelint-config-standard
	npm install -g yaml-language-server markdownlint bash-language-server
	npm install -g dockerfile-language-server-nodejs

nvim-upgrade:
	nvim --headless +PlugUpdate +qall
	nvim --headless +CocUpdate +qall

CASK_FONTS_LIST= \
	font-domine \
	font-fira-code \
	font-fira-sans \
	font-fontawesome \
	font-inconsolata \
	font-lato \

cask-fonts-install:
	brew install --cask $(CASK_FONTS_LIST)

cask-fonts-upgrade:
	brew upgrade --cask $(CASK_FONTS_LIST)

CASK_LIST=\
	1password \
	amethyst \
	anki \
	appcleaner \
	arq-cloud-backup \
	beardedspice \
	blobsaver \
	caffeine \
	calibre \
	docker \
	dropbox \
	firefox \
	fork \
	google-chrome \
	grammarly \
	handbrake \
	imageoptim \
	iterm2 \
	karabiner-elements \
	keyboard-cleaner \
	keyboard-maestro \
	knockknock \
	libreoffice \
	marked \
	meetingbar \
	ngrok \
	oversight \
	aws-vault \
	postico \
	qlvideo \
	skype \
	slack \
	spotify \
	superduper \
	telegram \
	the-unarchiver \
	the_archive \
	timing \
	transmission \
	tunnelblick \
	ubiquiti-unifi-controller \
	viber \
	visual-studio-code \
	vlc \
	wordcounterapp \
	zoom \

cask-install:
	brew install --cask --no-quarantine $(CASK_LIST)

cask-upgrade:
	brew upgrade --cask --no-quarantine $(CASK_LIST)

# 1037126344 Apple Configurator 2
# 1320666476 Wipr
# 1384080005 Tweetbot
# 1449412482 Reeder
# 1460121080 ABBYY Lingvo English-Russian
# 1462114288 Grammarly for Safari
# 1513574319 Glance
# 1519867270 Refined GitHub
#  405399194 Kindle
#  407963104 Pixelmator
#  408981434 iMovie
#  409183694 Keynote
#  409201541 Pages
#  409203825 Numbers
#  411643860 DaisyDisk
#  413969927 AudioBookBinder
#  428271079 PDF Signer
#  497799835 Xcode
#  524373870 Due
#  586001240 SQLPro for SQLite
#  775737590 iA Writer
#  937984704 Amphetamine

MAS_LIST=\
	 1037126344 \
	 1320666476 \
	 1384080005 \
	 1449412482 \
	 1460121080 \
	 1462114288 \
	 1513574319 \
	 1519867270 \
	 405399194 \
	 407963104 \
	 408981434 \
	 409183694 \
	 409201541 \
	 409203825 \
	 411643860 \
	 413969927 \
	 428271079 \
	 497799835 \
	 524373870 \
	 586001240 \
	 775737590 \
	 937984704 \

mas-install:
	mas install $(MAS_LIST)

mas-upgrade:
	mas upgrade $(MAS_LIST)
