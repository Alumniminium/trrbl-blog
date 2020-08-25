---
layout: post
title:  "simplifying our image hosting service"
slug: "simplifying our image hosting service without csharp"
tags: bash netcore web linux ssh
author: trbl
excerpt: C# is great and all, but not required if you learn how to use the tools linux comes with. Let's remove all of that shit.
permalink: /usr/bin/:slug.html
image: https://cdn.her.st/images/simplifyingimagehostservice.jpg
thumbnail: https://cdn.her.st/images/simplifyingimagehostservice-small.jpg
size: 13.78k
---

# Let's cut out the middle-man

## $ fuck FTP
Last time we've setup vsftp to handle our image uploads. This foolishness ends now. We've already got our SSH Server up and we can easily transfer files through it.
Let's do that, shall we?

```sh
apt remove vsftp -y
```

## $ fuck Apache
Apache configs suck.
Hello nginx.
```sh
apt remove apache2 -y && apt install nginx -y
```

## $ setting up nginx

Let's also change the domain from *h.img.alumni.re* to *cdn.her.st* as I'm not going to be using my homeserver anymore.

We're going to use *threaded async IO* and *sendfile* for maximum throughput on potentially big files like binary data, audio and video but not for small things like images and assets (which are mostly css and js text files). There's some added latency involved when using threaded async IO so its only worth paying that overhead if the file tansfer will usually take more than a couple seconds. We really don't want to add any additional latency to image requests as that would unnecessarily slow down page loading speed.

*/etc/nginx/sites-enabled/default*
```json
server {
	listen 80;
	root /srv/http/cdn.her.st;
	index index.html;
	server_name cdn.her.st;

    location / {
    	try_files	$uri $uri/ =404;	
    } 
    location /bin {
    	sendfile	on;
    	aio		threads;
    	try_files	$uri $uri/ =404;	
    }
    location /videos {
    	sendfile	on;
    	aio		threads;
    	try_files	$uri $uri/ =404;	
    }
    location /audio {
    	sendfile	on;
    	aio		threads;
    	try_files	$uri $uri/ =404;	
    }
    location /assets {
    	sendfile	on;
    	try_files	$uri $uri/ =404;	
    }
}
```
Now let's spin up the service and we're done!

```sh
systemctl enable nginx --now
```

## $ porting ImgUp to bash

```bash
#!/bin/bash
path=$1
filename=$2
if [ -z $filename ]; then 
    filename=$(basename $path)
fi

scp -q $path trbl@cdn.her.st:/srv/http/cdn.her.st/images/$filename
echo "https://cdn.her.st/images/$filename" | xclip -sel clip
echo "https://cdn.her.st/images/$filename (added to clipboard)"
```
usage:
```
imgup /path/to/image.jpg [Optional remote filename]
```

Much better than the C# clusterfuck with multiple classes.

# we did it again! :D

The first iteration brought down complexity and increased performance! Can't ask for a better outcome considering how little effort this took. 

## whats left

* imgup argument parsing
* make universal script that can upload any kind of file
* create multiple versions of the image (server sided?)
* * Raw image
* * Resized to Thumbnail Size