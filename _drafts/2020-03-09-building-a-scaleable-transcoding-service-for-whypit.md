---
layout: post
title: transcoding service for whyp.it
slug: is-your-transgender-running
tags: csharp linux cli netcore ffmpeg
author: trbl
excerpt: Hey, can you build a audio transcoder and waveform generator for this website idea I had? Sure, what could go wrong...
permalink: /usr/bin/:slug.html
image: https://cdn.her.st/images/06ac3787-a8f0-49fc-9dcd-67a857391c04.webp
thumbnail: https://cdn.her.st/images/e788d86e-f110-440c-8a9b-e03c714ea40a.webp
image-credits: Landing page https://whyp.it
size: 3.9k
---

# august 2019

[Braed](https://www.linkedin.com/in/bradleyvarol/) started talking about building a replacement for the then recently defunct audio sharing website called [Instaud.io (@WaybackMachine)](https://web.archive.org/web/20180901093124/https://instaud.io/). The plan was to build an anonymous one-click audio sharing website and eventually compete with Clyp.it. When he started showing me mock images of what he had in mind, I was impressed by how clean it looked.

A year earlier, he was working on the first prototype, it worked, but there was no transcoding, people could only upload mp3's and the player had to download the entire file before showing the waveform.
<center>
<img class="lazyload" data-src="https://cdn.her.st/images/1e7a63d1-36bd-47ed-8086-d9c919ac9e50.webp" alt="screenshot from old version">
</center>
My brain went off trying to work out how to solve the transcoding problem and I offered to build a transcoding service he could use right away. New problems are always fun, this sounded like a great project.

*and.. I could rent him some of my VM's for hosting/transcoding ( ͡° ͜ʖ ͡°)*

This time he'd build his own player while use a new tech stack ([VueJS/Nuxt](https://nuxtjs.org/)). He was serious and passionate about this project. He knew he couldn't transcode the files on the webserver using PHP or Node as that wouldn't scale, that much was obvious but the solution wasn't.
<center>
<img class="lazyload" data-src="https://cdn.her.st/images/647ced08-cf20-4db7-bbf6-24b47ea340b4.webp" alt="how it all begun discord chat screenshot">
</center>

## NAudio + TCP

My first idea was building a simple transcoder in using [NAudio](https://github.com/naudio/NAudio) and communicate with the backend using TCP sockets  to download the file to the transcoder, then upload the transcoded file back to the website backend. PHP can do raw TCP sockets after all. I started working on it right away, creating a simple binary protocol on top of tcp, setup the server code, hooked up the packets and told Braed that I should have a working prototype in a couple of hours using TCP and [NAudio](https://github.com/naudio/NAudio). He didn't work with sockets before, so when I explained how the protocol is going to work, he just told me he had no idea what any of that even meant. Great. I decided to make it work anyways.

Two hours later I've had uploads and downloads working, I built a producer / consumer pair so it could be easily threaded in the future. I was ready to implement [NAudio](https://github.com/naudio/NAudio) and do actual transcoding.

*[NAudio](https://github.com/naudio/NAudio) doesn't work with netcore* and even worse, there was nothing available to work with audio on netcore.

## back to the drawingboard

For a couple minutes I've even considered going with the full .net framework in order to make [NAudio](https://github.com/naudio/NAudio) work, but that'd have also meant that we would have to run the transcoders on Windows servers. Running Windows Servers is way more expensive not only due to higher resource requirements but also licensing fees. No, using Windows would be stupid, I had to find another solution.

## ffmpeg

After a couple of seconds, I realized that I'm playing audio and video just fine on my linux laptop, and that there was [ffmpeg](). Using ffmpeg to transcode the files would be perfect as it supports every format known to man and is designed in a way it can be automated easily. Architecture of the transcoder would now become a bit more complicated so I spent a couple of minutes on that problem. I decided to ask Braed about how to communicate with the backend first as he didn't seem too excited about TCP. We decided on a shared Queue, where he would submit work to and I'd dequeue, process and enqueue in another queue. We didn't know how to share that queue though, so I googled [mysql as a worker queue]() and got 

<center>
<img class="lazyload" data-src="https://cdn.her.st/images/2043b311-5c72-4be1-b3d6-32f346d6d3b3.webp" alt="screenshot of the UI (March 12th, 2020)">
</center>



<center>
<img class="lazyload" data-src="https://cdn.her.st/images/2043b311-5c72-4be1-b3d6-32f346d6d3b3.webp" alt="screenshot of the UI (March 12th, 2020)">
</center>


How it all began
<https://discordapp.com/channels/@me/409511488160530432/622527799357341706>
