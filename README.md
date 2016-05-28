# docker-nginx-nodejs-lets-encrypt

Container with Nginx 1.8, Node.js 4 and support for Let's Encrypt, based on [passenger-docker](https://github.com/phusion/passenger-docker).

This container only hosts a single app behind https.

## Usage

```
docker create \
    --name=nginx-nodejs \
    -p 80:80 -p 443:443 \
    -e PGID=<gid> -e PUID=<uid> \
    -e DOMAIN=your.domain.com \
    -v <path/to/acme/>:/var/lib/acme \
    -v <path/to/your/project/>:/home/app/webapp \
    cpoppema/docker-nginx-nodejs-lets-encrypt
```

This container is based on phusion/passenger-customizable with ssh removed. For shell access whilst the container is running do `docker exec -it nginx-nodejs bash`.

**Let's encrypt**

This container includes [acmetool](https://github.com/hlandau/acme) to get your own Let's Encrypt certificate and a cronjob to renew them automatically. After creating and starting your own container, make sure to run `acmetool quickstart --export` and complete this small wizard. Be sure to:

* Select `RSA` as the type of keys you want for your certificates.
* Use `4096` as the RSA key size
* Select `WEBROOT` as the Challenge Conveyance Method.
* Put `/var/run/acme/acme-challenge/` as the Webroot Path.

After completing the wizard, run `acmetool want your.domain.com` to install certificates in `/var/lib/acme/live/your.domain.com/`.

**Parameters**

* `-p 80` - This port is only used for Let's Encrypt certificate creation and auto-renewal.
* `-p 443` - This port exposes your app.
* `-v /var/lib/acme` - This folder is where [acmetool](https://github.com/hlandau/acme) stashes its data including the certificates.
* `-v /home/app/webapp` - This is your node.js project's root, where your server.js exists.
* `-e DOMAIN` - This is the domain for the Nginx configuration file, it is only used to set the full path to your SSL certificate.
* `-e PGID` for GroupID - See below for explanation.
* `-e PUID` for UserID - See below for explanation.

**Environment**

By default Nginx clears all environment variables (except TZ) for its child processes. To pass variables to your app, you need to tell Nginx about them specifically. How ? Like so:

```
# my-variables.conf:
env POSTGRES_PORT;
```

Add `-v <path/to/my-variables.conf>:/etc/nginx/main.d/my-variables.conf` along with `-e POSTGRES_PORT=5432` to the docker-create command to let Nginx pass your variables to the app. Any file in the main.d-directory will be read by Nginx.

**What about my own nginx configuration ?**

This container uses [webapp.conf](./sites-enabled/webapp.conf). If you want to make adjustments or use something else entirely, simply add `-v <path/to/your/conf>:/etc/nginx/sites-enabled/webapp.conf>` to the docker-create command to overwrite the default one.

### User / Group Identifiers

**TL;DR** - The `PGID` and `PUID` values set the user / group you'd like your container to 'run as' to the host OS. This can be a user you've created or even root (not recommended).

Part of what makes this container work so well is by allowing you to specify your own `PUID` and `PGID`. This avoids nasty permissions errors with relation to data volumes (`-v` flags). When an application is installed on the host OS it is normally added to the common group called users, Docker apps due to the nature of the technology can't be added to this group. So this feature was added to let you easily choose when running your containers.

## Updates / Monitoring

* Upgrading to the latest version of OpenSSL or Node.js is easy, connect with the running container and run `apt-get update -q && apt-get install -qy openssl nodejs`.
* Monitor the logs of the container in realtime with `docker logs -f nginx-nodejs`.
* Monitor stdout/stderr of your application by looking at `/var/logs/nginx/error.log`, once you have shell access.


**Credits**
* [linuxserver.io](https://github.com/linuxserver) for their insights to use whatever user:group you want.
* [phusion](https://github.com/phusion/passenger-docker) to be able to create this docker with minimal effort.
