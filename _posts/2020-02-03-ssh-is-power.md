---
layout: post
title: ssh is power
slug: ssh-is-power
tags: linux cli server
author: Trrbl
excerpt: ssh can do far more than just connect you to a remote shell. far. more.
permalink: /usr/bin/:slug.html
image: https://cdn.her.st/images/00976e4a-27cc-4a29-8f1d-5053ac22d054.webp
thumbnail: https://cdn.her.st/images/d89b3334-0f01-4ee5-90d7-48358c28e325.webp
image-credits: image from @ https://linuxize.com/
size: 6.74k

---
let's just jump right in.

## port forwarding
*Did you know, you can fuckin port forward with fuckin ssh?!*
You might want to host a gameserver so you can play with your friend, or show a client your progress by giving him 
access to your local webserver - but you are behind a firewall and don't want to or simply can't forward the ports?
SSH can do it. All you need is a cheap server, [like the cheapest of my Micro plans]({% link /hosting.md %}) and you can use it to forward ports in a single line. 

### remote forwarding

For said scenarios above, where you run a server locally and want to expose it to the internet, like a webserver or gameserver
running on port 8080

```
ssh -R 8080:127.0.0.1:8080 user@hostname.her.st
```
now you can give `hostname.her.st:8080` (or the server IP) to your friend or client, and ssh will tunnel everything to your local machine.

### local forwarding

now let's say you want to access a mysql server that's running on your server. You can't connect to it over the internet
MySQL will only listen on 3306 locally, and be firewalled off. Still want to connect your dev environment to it? SSH can do it.

```
ssh -L 3306:127.0.0.1:3306 user@hostname.her.st
```

if you now connect your mysql client to 127.0.0.1:3306, you will actually connect to hostname.her.st:3306 (and you get encryption for free)

### appendix

The format is defined like that:

`8080:127.0.0.1:8080`

RemotePort (on the server):Destination (your computer):LocalPort(on your computer)

## disconnected - no problem

if you have access to `screen` on the server, use `ssh -t user@hostname.her.st screen -RR` and you will create a screen immediately 
upon login, or reattach to the last one if it exists. Similar behavior can be achieved with `tmux`. if your internet connection
goes down or indeed even if you close the terminal, your stuff will keep running.

## mount remote filesystem locally

tired of `scp` yet? try `sshfs` 

### run a speedtest

```
yes | pv | ssh remote_host "cat >/dev/null"
```

and it it's good enough (internet: >= 5mb/s, local: 35mb/s)

### mount it

```sh
sshfs	-o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,idmap=user user@hostname.her.st:/	/mnt/server-root
```

now you can just `cp` and `mv` to `/mnt/server-root` to upload files. you can treat it like any folder.


## oh and visual studio code
You can literally let vscode ssh into your server, install itself there, copy all your local settings and extensions over and have vsc run on your server instead
so your development environment is always the same, no matter what device you use. All your files will be stored on the server too, so no more forgetting your files either. I've been using it for months and love it.
https://code.visualstudio.com/docs/remote/ssh