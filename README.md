# Minimal Vapor Project Template

Clone this repository to get started with a new Vapor project without boilerplate code.

## Documentation

View [Vapor](https://github.com/qutheory/vapor) for documentation.

## Requirements

Requires Swift development snapshot from 3rd May 2016 or newer.

## Building

Check out Kylef's [swiftenv](https://github.com/kylef/swiftenv) for ensuring you have the latest
version of Swift installed. This project contains a `.swift-version` file which will tell `swiftenv` which version of Swift to build with automatically.

If you dont want to use `swiftenv`, visit [Swift.org](http://swift.org) to learn more about installing development snapshots on your system.

### Compiling

Run `vapor build` and `vapor run`.

Otherwise, clone this repo and run `swift build` to compile your application, then run `.build/debug/App`.

### Xcode 7.3

Open the `VaporApp.xcodeproj` with Xcode 7.3 and make sure Xcode > Toolchains is set to `swift-DEVELOPMENT-SNAPSHOT-2016-05-03-a.xctoolchain` or later.

## Deploying

Check the [Vapor](https://github.com/qutheory/vapor) documentation for more in-depth deployment instructions.

### Upstart

To start your `Vapor` site automatically when the server is booted, add this file to your server.

`/etc/init/vapor-template.conf`

```conf
description "Vapor Template"

start on startup

exec /home/<user_name>/vapor-template/.build/release/App --workDir=/home/<user_name>/vapor-template
```

You additionally have access to the following commands for starting and stopping your server.

```shell
sudo stop vapor-template
sudo start vapor-template
```

The following script is useful for upgrading your website.

```shell
git pull
swift build --configuration release
sudo stop vapor-template
sudo start vapor-template
```

### Docker
You can run this demo application locally in a Linux environment using Docker.

1. Ensure [Docker](https://www.docker.com) is installed on your local machine.
2. Start the Docker terminal
3. cd into `vapor-template`
4. Build the container `docker build -t vapor .`
5. Run the container `docker run -it -p 8080:8080 vapor`
5. Configure VirtualBox to [forward ports 8080 to 8080](https://www.virtualbox.org/manual/ch06.html)
6. Visit http://0.0.0.0:8080

### Nginx / Supervisor

You can also run your Vapor app through Nginx.  It’s recommended you use [Supervisor](http://supervisord.org) to run the app instance to protect against crashes and ensure it’s always running.

#### Supervisor

To setup Vapor running through Supervisor, follow these steps:

`apt-get install -y supervisor`

Edit the config below to match your environment and place it in `/etc/supervisor/conf.d/your-app.conf`:

```shell
[program:your-app]
command=/path/to/app/.build/release/App serve --ip=127.0.0.1 --port=8080
directory=/path/to/app
user=www-data
stdout_logfile=/var/log/supervisor/%(program_name)-stdout.log
stderr_logfile=/var/log/supervisor/%(program_name)-stderr.log
```

Now register the app with Supervisor and start it up:
```shell
supervisorctl reread
supervisorctl add your-app
supervisorctl start your-app # `add` may have auto-started, so disregard an “already started” error here
```

#### Nginx

With the app now running via Supervisor, you can use this sample nginx config to proxy it through Nginx:

```nginx
server {
	server_name your.host;
	listen 80;

	root /path/to/app/Public;

	# Serve all public/static files via nginx and then fallback to Vapor for the rest
	try_files $uri @proxy;

	location @proxy {
		# Make sure the port here matches the port in your Supervisor config
		proxy_pass http://127.0.0.1:8080;
		proxy_set_header Host $host;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_connect_timeout 3s;
		proxy_read_timeout 10s;
	}
}
```
