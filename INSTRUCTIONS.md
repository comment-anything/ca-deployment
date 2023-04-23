# Comment Anywhere Deployment Repository ("ca-deployment")

This directory contains build scripts for the remote deployment and the three components of comment anywhere; ca-back-end, ca-front-end, and ca-static.

You will not be able to use the deploy scripts (build.backend.bat, build.static.bat, etc) in this top-level folder unless you have access to the hosting and have an SSH key registered on the server. They are only presented here for reference.

## Warning

Our current configuration allows for abuse via email spam. Please do not request new passwords or verifications for emails you do not own, and please do not share our SMTP credentials. Thank you.

## Fastest testing of the extension

The fastest way to interact with comment anywhere is to skip all build steps and run the extension that is already built and distributed with this folder. To do so, execute the following steps:

1. Open Mozilla Firefox
2. Type `about:debugging` in the URL input area
3. Click on `This Firefox` on the left
4. Click on `Load Temporary Addon`
5. Navigate to `ca-front-end/dist/` and click on `manifest.json`
6. The Comment Anywhere guy will appear next to your URL input area. If it doesn't appear there, it's behind the drop-down puzzle piece button that shows more extensions.
7. Click the Comment Anywhere guy.
8. Interact with Comment Anywhere.

In this mode, the extension will be interacting with our server, located at commentanywhere.net. 

We recommend you register an account. No email will be sent automatically (You need to 'request verification' in settings if you want to receive a verification email and test that process.) Verification is tracked but not currently necessary to post comments.

If you wish to test the admin or moderator panels then logout, then login with the following user:

Username: Comadmin
Password: comadmin1

# Build the Front End from Source

## Required Dependencies for the Front End

For the front-end, `./ca-front-end`, you will need Node and Node Package Manager (NPM), available for windows [here](https://nodejs.org/en).

Node is a JavaScript environment that allows the compilation of binaries from JavaScript code and provides dependency management through NPM. We do not compile and binaries for this project, but we do use several dependencies managed through NPM to *transpile* our TypeScript source code into bundled JavaScript code for deployment.

After installing Node, cd into `ca-front-end` and type the following in the command line:

`npm i`

This will install all required dependencies to a subfolder called `node_modules`.

## Build the Front End 

You will have access to our NPM scripts defined in `ca-front-end/package.json`.

Run `npm run dist` to build the extension.

Open Mozilla Firefox.

Type `about:debugging` in the URL bar.

Click on `This Firefox`

Click on `Add Extensions`

Open `ca-front-end/dist/manifest.json` to test the front end.

## Build the Front End for Local Server Testing

Ensure you are CDed into `/ca-front-end/` and run `npm run dist-local`.

The extension will rebuild, but it will instead be configured to look for a server on localhost, at port 3000.

If you go to `about:debugging`->`This Firefox` and click `reload extension`, then interact with it, you will see that Comment Anywhere guy gives you a message like, "Error Fetching form Server". This is because the extension is now configured to look for a server on another port on your computer but isn't finding it.

# Build the Back End

## Required Dependencies for the Back End

The Back End requires that you have [docker](https://docs.docker.com/get-docker/) installed. Note, this installation can become involved, as you will need WSL and may need to enable virtualization in your BIOS. 

The Back End cannot be run without Docker as the server is configured to terminate if it cannot find the database, and the database runs in Docker.

You will also need to install `Go`, available [here](https://go.dev/).

If you are on windows, you will need to install `Make`. To get Make on Windows, you will need to install [Chocolatey](https://chocolatey.org/). Then, from an elevated powershell, type `choco install make`.

## Build the database

The database and database container are configured with .env variables. It is built with MakeFiles.

Port 5432 on your computer is used for the database. If this port is in use already, you can change the value of `DB_HOST_PORT` in `/ca-back-end/.env`

- CD into `/ca-back-end/`
- Run `make dependencies` to get the required dependencies for the back end.
- Run `make build_postgres` to build the database container.
- Run `make create_test_db` to create the database within the docker container.
- Run `make migrate_test_up` to load the schema into the database using [golang-migrate](https://github.com/golang-migrate/migrate)
- Run `docker ps` to confirm that a container named `postgres-ca-db-421` is running.

## Run the server as a local process

Port 3000 on your computer is used for the server. If this port is in use already, you can change the value of `SERVER_PORT` in `/ca-back-end/.env`. If you do so, you will also need to change the address in `ca-front-end/.env` so the extension looks for the right port.

- Run `go serve .` to run the server as a local process. Note that the CLI may not work properly on a Windows environment, but the server will run fine. Keep the server running as you rebuild the extension.

- Build the extension for local server testing if necessary, (`npm run dist-local`)
- Reload the extension in Mozilla (`about:debugging` -> `This Firefox` -> `Load Temporary Addon` -> `manifest.json`) if necessary.
- Interact with the extension

As you interact with the extension, you should be able to see the results of HTTP requests being printed to the server terminal.

## Build the extension in a docker container

Stop running the extension as a regular system process by closing the terminal or pressing ctrl-c.

In `ca-back-end`, execute the following make commands.

- Run `make build_server_image` to build the custom docker image.
- Run `make create_net` to create a docker network.
- Run `make net_con_db` to connect the database to the network.
- Run `make create_server` to create the server container.
- Run `make net_con_server` to connect the server to the docker network.
- Run `make start_server` to restart the server. (It would have stopped because of a failure at first to find the database)
- Run `docker ps` to verify that the server container, named "cany-http", is running.

You can test the extension again to verify that it is connecting to the container on port 3000.

If you type `docker logs cany-http` you should be able to see recent logs.

## Build and run the static website

If you want to ensure the static site provides the last version of the front end that was built and is in `ca-front-end/dist`, run `make zip.front.end` inside of this directory (`ca-deployment`)

To start the static site, do the following:

- CD into `ca-static`
- Run `make build.static.image`
- Run `create.static.container`
- Navigate to `localhost:80` in your browser to see the static site. 
















