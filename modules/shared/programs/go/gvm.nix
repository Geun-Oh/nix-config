{ pkgs, ... }:

{
  programs.bash.initExtra = ''
    if [ ! -d "$HOME/.gvm" ]; then
      git clone https://github.com/moovweb/gvm.git $HOME/.gvm
      source $HOME/.gvm/scripts/gvm
    fi
    source $HOME/.gvm/scripts/gvm
  '';
}
