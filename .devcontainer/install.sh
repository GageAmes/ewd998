#!/bin/bash

## Fix issues with gitpod's stock .bashrc
cp /etc/skel/.bashrc $HOME

## Shorthands for git
git config --global alias.slog 'log --pretty=oneline --abbrev-commit'
git config --global alias.co checkout
git config --global alias.lco '!f() { git checkout ":/$1:" ; }; f'

## Waste less screen estate on the prompt.
echo 'export PS1="$ "' >> $HOME/.bashrc

## Make it easy to go back and forth in the (linear) git history.
echo 'function sn() { git log --reverse --pretty=%H main | grep -A 1 $(git rev-parse HEAD) | tail -n1 | xargs git show --color; }' >> $HOME/.bashrc
echo 'function n() { git log --reverse --pretty=%H main | grep -A 1 $(git rev-parse HEAD) | tail -n1 | xargs git checkout; }' >> $HOME/.bashrc
echo 'function p() { git checkout HEAD^; }' >> $HOME/.bashrc

## Patches VSCode extensions for TLA+
wget https://github.com/lemmy/vscode-tlaplus/releases/download/v1.6.0-beta.202106014/vscode-tlaplus-1.6.0.vsix -P /tmp
wget https://github.com/alygin/better-comments/releases/download/v2.0.5_tla/better-comments-2.0.5.vsix -P /tmp

## The extensions below are not available from the non-Microsoft Open VSX marketplace
## and have to be installed manually in gitpod.
## see https://www.gitpod.io/docs/vscode-extensions/#where-do-i-find-extensions
wget https://marketplace.visualstudio.com/_apis/public/gallery/publishers/EFanZh/vsextensions/graphviz-preview/1.5.0/vspackage -O /tmp/efanzh.vsix.gz
gunzip /tmp/efanzh.vsix.gz
wget https://marketplace.visualstudio.com/_apis/public/gallery/publishers/tintinweb/vsextensions/graphviz-interactive-preview/0.0.11/vspackage -O /tmp/tintinweb.vsix.gz
gunzip /tmp/tintinweb.vsix.gz
wget https://marketplace.visualstudio.com/_apis/public/gallery/publishers/tomoki1207/vsextensions/pdf/1.1.0/vspackage -O /tmp/pdf.vsix.gz
gunzip /tmp/pdf.vsix.gz

## Place to install TLC, TLAPS, Apalache, ...
mkdir -p tools

## PATH below has two locations because of inconsistencies between Gitpod and Codespaces.
## Gitpod:     /workspace/...
## Codespaces: /workspaces/...

## Install TLA+ Tools
wget https://nightly.tlapl.us/dist/tla2tools.jar -P tools/
echo "alias tlcrepl='java -cp /workspace/ewd998/tools/tla2tools.jar:/workspaces/ewd998/tools/tla2tools.jar tlc2.REPL'" >> $HOME/.bashrc
echo "alias tlc='java -cp /workspace/ewd998/tools/tla2tools.jar:/workspaces/ewd998/tools/tla2tools.jar tlc2.TLC'" >> $HOME/.bashrc

## Install CommunityModules
wget https://github.com/tlaplus/CommunityModules/releases/latest/download/CommunityModules-deps.jar -P tools/

## Install TLAPS (proof system)
wget https://github.com/tlaplus/tlapm/releases/download/v1.4.5/tlaps-1.4.5-x86_64-linux-gnu-inst.bin -P /tmp
chmod +x /tmp/tlaps-1.4.5-x86_64-linux-gnu-inst.bin
/tmp/tlaps-1.4.5-x86_64-linux-gnu-inst.bin -d tools/tlaps
echo 'export PATH=$PATH:/workspace/ewd998/tools/tlaps/bin:/workspaces/ewd998/tools/tlaps/bin' >> $HOME/.bashrc

## Install Apalache
wget https://github.com/informalsystems/apalache/releases/latest/download/apalache.tgz -P /tmp
mkdir -p tools/apalache
tar xvfz /tmp/apalache.tgz --directory tools/apalache/
echo 'export PATH=$PATH:/workspace/ewd998/tools/apalache/bin:/workspaces/ewd998/tools/apalache/bin' >> $HOME/.bashrc
tools/apalache/bin/apalache-mc config --enable-stats=true

## Install the VSCode extensions (if this is moved up, it appears to be racy and cause Bad status code: 404: Not found.)
code --install-extension /tmp/vscode-tlaplus-1.6.0.vsix
code --install-extension /tmp/better-comments-2.0.5.vsix
code --install-extension /tmp/efanzh.vsix
code --install-extension /tmp/tintinweb.vsix
code --install-extension /tmp/pdf.vsix

## (Moved to the end to let it run in the background while we get started)
## - graphviz to visualize TLC's state graphs
## - htop to show system load
## - texlive-latex-recommended to generate pretty-printed specs
## - z3 for Apalache (comes with z3 turnkey) (TLAPS brings its own install)
## - r-base iff tutorial covers statistics (TODO)
sudo apt-get install -y graphviz htop
## No need because Apalache comes with z3 turnkey
#sudo apt-get install -y z3 libz3-java 
sudo apt-get install -y --no-install-recommends texlive-latex-recommended
#sudo apt-get install -y r-base

## Install TLA+ Toolbox
wget https://github.com/tlaplus/tlaplus/releases/download/v1.8.0/TLAToolbox-1.8.0.deb -P /tmp
sudo dpkg -i /tmp/TLAToolbox-1.8.0.deb

## Activate the aliases above
source ~/.bashrc

## switch to first commit of the tutorial
git co ':/v01:'
