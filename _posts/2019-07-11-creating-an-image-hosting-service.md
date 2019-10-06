---
layout: post
title:  "creating an image hosting web service"
slug: "creating image hosting web service in csharp"
tags: tutorial project csharp net core netcore web
author: Trrbl
excerpt: this blog needs images. let's build an image hosting service and an app to upload them.
permalink: /usr/bin/:slug.html
image: https://h.img.alumni.re/images/9d17f4a4-16cf-4815-b711-694f67b3e882.webp
thumbnail: https://h.img.alumni.re/images/8a6b499b-c703-4e31-8c9f-ac3d468966ca.webp
size: 13.78k
---

# hello entity,
We've got work to do.

## $ needs
Easy to use service that lets us host images and other static data and allows direct linking and embedding. 
Any webserver will do. 
I have a virtual server with apache2, so I'll use that.
Considering that box also runs a FTP server, we shall upload our files using FTP.
We also need an app that can take an image path as argument, 
upload it to our service and copies the direct link to it straight into the clipboard. 

The app should be a command line tool and do nothing without arguments.

## $ requirements

A tiny private server should be able to host everything we need.

* Web Server
* FTP Server 
* SSL
* UploaderApp
* Possibly a Browser / Management app in the future

## $ setting up the webserver

First we have to install a webserver. Usually I'd use Nginx, but since I have an apache server already up, I'll go with that.

I'll use a custom subdomain for this service.
<a href="https://h.img.alumni.re/">https://h.img.alumni.re/</a> 
Here's a visual representation why I chose this domain in case you are wondering:

| &nbsp;&nbsp;&nbsp;Server&nbsp;&nbsp;&nbsp; 	| &nbsp;&nbsp;&nbsp;Type&nbsp;&nbsp;&nbsp; 	| &nbsp;&nbsp;&nbsp;Domain&nbsp;&nbsp;&nbsp; 	| &nbsp;&nbsp;&nbsp;TLD&nbsp;&nbsp;&nbsp; 	|
|:------:	|:----:	|:------:	|:--------------:	|
|    h   	|  img 	| alumni 	|  re 	|

the `h` symbolizes my Homeserver.

#### install apache:

```sh
# Updating the repos and installing everything we need
> sudo apt update && sudo apt install apache2
```
Apache is installed and ready, you can verify that by going to <a href="http://0.0.0.0/" >http://0.0.0.0/</a>

#### setup VHOST

Now its time to configure the virtual host. To do that, we have to create a text file in

`/etc/apache2/sites-enabled/` 
called 
`h.img.alumni.re.conf` (replace the name with your domain)
and put some text inside of it.

```sh
> sudo nano /etc/apache2/sites-enabled/h.img.alumni.re.conf
```

```zsh
<VirtualHost *:80>
        # ServerName is supposed to be DOMAIN . TLD
        ServerName alumni.re
        # ServerAlias is supposed to be the entire (sub)domain
        ServerAlias h.img.alumni.re
        # Document root is where your files will be stored
        DocumentRoot /var/www/h.img.alumni.re/html

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
```

And for my final trick, let's create the directory structure for the webserver.

```sh
# We've set this path above as DocumentRoot
> mkdir /var/www/h.img.alumni.re
> mkdir /var/www/h.img.alumni.re/html
> mkdir /var/www/h.img.alumni.re/html/img
```

After setting the DNS records of your subdomain at your provider, your site should be ready, you can verify that by going to it in a browser: <a href="http://h.img.alumni.re/" >http://h.img.alumni.re/</a>


## $ setting up Certbot for free SSL

Pretty important to set up SSL nowdays as every browser will freak the fuck out if your images come from an 'insecure source' - basically over `http` instead of `https` ... There's no real benefit in encrypting static files, but if it makes the browsers happy..

```bash
# Updating the repos and installing everything we need
> sudo apt update && sudo apt install apache2 certbot python-certbot-apache
# let it do it's magic
> sudo certbot --apache
```

When you're asked how you want to enable SSL, chose "redirect", wait for certbot to finish writing new configs and pulling the certs, then run

```sh
> sudo certbot renew --dry-run
```

If that command fails, check <a href="https://certbot.eff.org/help/">Certbot Help</a> otherwise, let's automate the renewal process by adding 

```
0 1 * * * /usr/bin/certbot renew & > /dev/null
```

to your crontab (`> crontab -e`) - and dont forget the new line at the end or it will complain..

## $ setup FTP

I regret using FTP for this already, but let's get it installed and setup. In theory, you could skip this step and use http uploads, but I rather have something isolated from the webserver, as I plan on writing my own webserver for static content later, and I probably won't impement anything but GET. Enough rambling, let's punch in some commands to install it and enable it on boot.

```sh
> sudo apt-get install vsftpd -y
> sudo systemctl enable vsftpd
```

Now let's add our FTP user

```sh
#ftp boi gonna live in the webroot (and get jailed into it)
> useradd ftp -m -d /var/www/h.img.alumni.re/html
> sudo passwd ftp
```

Now we have to make sure our server is setup properly. We will need to configure write permissions, ports, directories and authentication. I've attached my configuration file which should work for you too.

```sh
> cat /etc/vsftpd.conf 
listen_ipv6=YES
anonymous_enable=NO
anon_upload_enable=NO
local_enable=YES
write_enable=YES
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=NO
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=ftp
rsa_cert_file=/etc/letsencrypt/live/h.img.alumni.re/cert.pem
rsa_private_key_file=/etc/letsencrypt/live/h.img.alumni.re/privkey.pem
ssl_enable=YES
require_ssl_reuse=NO
pasv_enable=YES
pasv_min_port=1024
pasv_max_port=1025
allow_writeable_chroot=YES
chroot_local_user=YES
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd.chroot_list
file_open_mode=0777
local_umask=022

```
`/etc/vsftpd.chroot_list` is an empty file. Just run 
```sh
> sudo touch /etc/vsftpd.chroot_list
``` 
to create it, also notice I'm re-using our SSL cert we got for our webserver earlier. I've taken the default path here, so when certbot renews it, vsftpd will always use the newest one.

Now let's start the ftp server.

```sh
> sudo systemctl start vsftpd
```

### bonus step: disallow ssh for ftp user

```sh
> sudo nano /etc/ssh/sshd_config
```
Add/edit the following line
```sh
DenyUsers ftp # ftp is my user
```
```sh
> sudo systemctl restart vsftpd
```

## $ bringing it all together with our c# netcore app


#### review

Let's quickly review what we got setup so far so we can start thinking about how we are going to implement that in code..


- Webserver w/ ssl & domain 
- FTP Server w/ ssl & domain
- FTP User w/ r+w access to domain's root folder

and here's what we still need

- App that let's me upload images quickly.

## c#

Let's start with the FTP Upload first. That should be the most difficult part here. Thankfully, the .net framework already has pre-made classes to deal with FTP, namely  `FtpWebRequest`. So let's design our first class, the one responsible for uploading images...

```cs
public static class Uploader
{
    // First we will set our root address for the following requests
    private const string FTP_IMG_ROOT = "ftp://h.img.alumni.re/images/";
    // Next we set our Id file's public HTTP url, we will download this and parse it to set the current Id.
    private const string HTTP_IMG_ID_FILE = "https://h.img.alumni.re/images/Id.txt";
    // We use the curId as something like a counter, so we don't overwrite old files. I decided to do this on the client since *I'm* the only client.
    // Don't be an idiot.
    private static int nextId;
    private static int curId;

    // Since this is a static class and its initialized only if arguments are passed, its ok to block in the constructor.
    // Don't do this is bigger applications. 
    static Uploader()
    {
        // as stated above, here we download and parse the Id file so we know what the last Id on the server is
        // (it gets worse)
        using (WebClient client = new WebClient())
            client.DownloadFile(HTTP_IMG_ID_FILE, "Id.txt");

        if (File.Exists("Id.txt") && int.TryParse(File.ReadAllText("Id.txt"), out curId))
            nextId = curId + 1;
    }
    
    // Saves a couple of lines of code :D
    private static FtpWebRequest CreateUploadRequest(string file)
    {
        var request = (FtpWebRequest)WebRequest.Create(FTP_IMG_ROOT + $"{file}");
        request.Credentials = new NetworkCredential("ftp", "root");
        request.EnableSsl = true; // this is the reason we can't use WebClient. It won't work with ssl.
        request.Method = WebRequestMethods.Ftp.UploadFile;
         return request;
    }
    
    // not sure why i ended up using tasks... i bet they just slow everything down tbh..
    // you test that and email me the results. blog@her.st ;D
    public static async Task<string> UploadAsync(string path)
    {
        // further attemt at creating a more unique path but still giving it some readability.
        // this would turn File.txt into File_3948.txt
        // I don't even check if a file with the same name exists and just assume so.
        // Asking the server for a file list, looking for it and THEN starting to upload
        // takse too much time. This is single user anyways, I won't run 20 instances of this shit.
        var request = CreateUploadRequest(Path.GetFileNameWithoutExtension(path) + "_" + curId + Path.GetExtension(path));
        using (var fileStream = File.OpenRead(path)) // doing streams like a good boi in case file is biiig
        using (var ftpStream = request.GetRequestStream())
            await fileStream.CopyToAsync(ftpStream); // but in the end I take the lazy route.
        await UpdateId(); // Told you it'd get worse.
        return request.RequestUri.AbsoluteUri.Replace("ftp", "https");
    }
    
    // did you think the server would keep track of the counter? 
    private static async Task UpdateId()
    {
        Interlocked.Increment(ref curId); // atomicly incrementing our counters because by now i have no idea where our methods execute
        Interlocked.Increment(ref nextId); // doing this seems to calm me down, no idea if its snakeoil
        await File.WriteAllTextAsync("Id.txt", $"{curId}"); // we write it so we can read it ...
        var request = CreateUploadRequest("Id.txt"); // another request
        using (var fileStream = File.OpenRead("Id.txt")) // this is a file with a fucking number in it. Number might get big, lets use a stream XDDDDDDD
        using (var ftpStream = request.GetRequestStream())
            await fileStream.CopyToAsync(ftpStream); // another lazy way out
    }
}
```


Couple of lines of code, nothing too fancy, kept it simple for the most part. I wish I went with HTTP uploads instead, having to deal with the FtpWebRequest directly made this class way bigger than it needed to be. Let's make our `Main()` smaller :D


```cs
public static async Task Main(string[] args)
{
    if (args.Length == 0) // no args? no bueno.
        return;// seppuku
    var builder = new StringBuilder();
    for (int i = 0; i < args.Length; i++)
    {
      // upload image, get direct link bacl
        var url = await Uploader.UploadAsync(args[i]);
        // if this is the last file, don't add a new line at the end.
        if (i == args.Length-1)
            builder.Append(url); // add to url list
        else
            builder.AppendLine(url); // add line to url list
        Console.WriteLine(url); // optional
    }
    // set clipboard to the url list 
    Clipboard.Set(builder.ToString());
}// another kind of seppuku
```


Not much to say about that.. I'm using a command line utility called xclip to set the clipboard on linux because I'm too lazy to figure out how to properly do that. Anyways, it works so I'm happy. 


```cs
public static class Clipboard
{
    public static void Set(string text)
    {
      // gotta write it into a temp file for xclip :D fuck you xclip :D
        var tmpFilePath = Path.GetTempFileName(); 
        File.WriteAllText(tmpFilePath, text);
        try
        {
          // now we cat it and pipe it into xclip..
            var arguments = $"-c \"cat {tmpFilePath} | xclip -i -selection clipboard\""; 
            var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "bash",
                    Arguments = arguments,
                    UseShellExecute = false,
                }
            };
            process.Start();
            // y u no exit u shit? setting the clipboard won't take 5sec on the slowest potato. 
            // Kill after 5 sec, sumting wong.
            process.WaitForExit(1000 * 5); 
        }
        finally
        {
            File.Delete(tmpFilePath); // its not you, its me
        }
    }
}
```

# F5


We did it. The minimal viable product is complete. We will iterate over the code and expand its functionality soon -
There's a couple of things we can put on our todo list now, as we have a working prototype.

* refactor and clean up the code
* Convert to WebP
* create multiple versions of the image
* * Raw image
* * Resized to Thumbnail Size
* Copy all the links into the clipboard with formatting for easy copy/paste into new Article.md 

First things first though, here's how I'll use this application:

```sh
Print + shift
        maim -s ~/upload.png; cwebp ~/upload.png -o ~/upload.webp; imgup ~/upload.webp && play ~/.config/.ding.wav && trash ~/upload.webp && ~/upload.png
```

`maim` is a screenshot utility and gives you a selection rectangle you can place with your mouse, then save it to my home directory as `upload.png`, run `cwebp` a command line webp converter, saving it as `upload.webp` next to the source file, invoking our app, I've called it `ImgUp`  passing it the `upload.webp` path, then after it finishes uploading, I play a ding sound and delete the files from my home directory. 

The URL to the image is now in my clipboard and I can CTRL+V it here 
<img src="https://h.img.alumni.re/images/b79eebcd-cdcf-410e-ac0b-067465831887.webp" width="100%" />

