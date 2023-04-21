# ca-deployment

This repo runs scripts to deploy Comment Anywhere on kamatera.

# to use

First generate ssh keys named 'key'. EG

`ssh keygen key` 

Put them in the "ssh" folder

Restrict permissions on the .pub key

Use `ssh keygen-add` to add them to the server

# install submodules

run `git submodule init` to install all submodules

run `copy.backend.bat` to copy the backend to the server, if there have been updates

run `build.backend.bat` to rebuild the backend on the server


