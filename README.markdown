My Compilitions Dotfiles
========================

Clone repository

    git clone https://github.com/suaron/dotfiles

Initialize and update git submodules

    git submodule init
    git submodule update

Install vim plug-ins

    cd vim && rake && cd ..

Create symlinks for all dotfiles to $HOME dir

    cd etc && rake && cd ..
