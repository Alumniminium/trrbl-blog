---
layout: post
title: unlimited free http proxies (Part 1)
slug: unlimited-free-http-proxies-part-1
tags: csharp netcore pastebin proxy proxies
author: Trrbl
excerpt: pastebin api + proxy tester = unlimited free proxies. Let's write everything we need and build a database of working proxies. Starting with a simple C# console app that checks if a proxy is working.
permalink: /usr/bin/:slug.html
image: https://h.img.alumni.re/images/proxy1.webp
thumbnail: https://h.img.alumni.re/images/proxy1.webp
image-credits: this isn't sketchy... we're just organizing unorganized public lists into a database...
size: 6.74k
---

## c# proxy checker

With the shit that's going down in Hong Kong, Iran and dozens of other places around the world, VPN's and Proxies are in high demand. Wouldn't it be great if we had a free unlimited supply of web proxies? Googling around for some free ones, I mostly found sketchy websites with sketchy paid plans, and a couple pastebin links with massive lists of IP's and ports... 

...massive lists with IP's and ports...
<center> <img class="lazyload" data-src="https://h.img.alumni.re/images/i.png" alt="hmm"> </center>

But before we even try to automatically search pastebin for new proxy lists, we have to make sure that we can test proxies in the first place; Thankfully, .net comes with [full proxy support](https://docs.microsoft.com/en-us/dotnet/framework/network-programming/how-to-enable-a-webrequest-to-use-a-proxy-to-communicate-with-the-internet) and you can use it in a single line!

I've made one and put it on github, I call it [SockPuppet](https://github.com/Alumniminium/SockPuppet) because it tests SOCKS web proxies.
<center><img class="lazyload" data-src="https://h.img.alumni.re/images/badum.webp" alt="badum tss"></center>

## arch
My version is a simple Producer-Consumer setup that only keeps twice as many proxies in memory as it has worker threads, in case the lists get really big after running the scraper for a few weeks or months. I've annotated the code and encourage you to quickly read over it. The `LoadBlock` is a simple `AutoResetEvent` I use to signal the producer to read more proxies into the queue.

#### BlockingCollection<T> 
`Proxies` here is a `BlockingCollection<Proxy>`. If you never heard about `BlockingCollection<T>`, it's kinda like a threadsafe `List<T>` that behaves like a `ConcurrentQueue<T>`. You `foreach` it just like a List and every iteration the current item is removed from the collection. That being said, a foreach loop on a BlockingCollection will *never return*. The *Collection* is going to start *Blocking* when it's  empty. Which is perfect for the consumer workloop of our Producer/Consumer setup.

```csharp
private static void WorkLoop()
{
    // threads will be blocked at Proxies.GetConsumingEnumerable()
    // as long as everything INSIDE the foreach loop is threadsafe
    // we can throw as many threads on it as our network can handle
    foreach (var proxy in Proxies.GetConsumingEnumerable())
    {
        if (Proxies.Count < ThreadCount * 2)// allow more proxies to be
            LoadBlock.Set();          // loaded from proxy list
        proxy.Test();                 // connect to proxy, download website
        if (proxy.Alive && proxy.Safe)// Safe = Identical response as without proxy
            Writer?.WriteLine(proxy); // write to output file
        // write to stdout, IP starts at position 8
        Console.WriteLine($"{(proxy.Alive ? "[ Up! ]" : "[Down!]")}{proxy}");
        Trace(proxy);
    }
}
```
Please note that `Writer` is a `StreamWriter` and is *not* threadsafe. Also `Console`'s threadsafety will break if you start changing colors.

```csharp
private static void StartThreads(int threadCount)
{
    Threads = new Thread[threadCount];
    for (int i = 0; i < threadCount; i++)
    {
        Threads[i] = new Thread(WorkLoop); // Target the method above

        // IsBackground = true
        // if the main thread exits kill this thread,
        // don't wait for it to exit and keep a zombie process running
        Threads[i].IsBackground = true; 
        Threads[i].Start();
    }
}
```

## parsing
We're having an easy time again. The parser will be a breeze!

The go-to format you find on pastebin is '`IP:PORT`' like so
```
222.252.25.168:8080
178.200.170.41:80
50.197.38.230:60724
...
```
let's write a parser that will only read a sane amount of lines while checking them in the `WorkLoop` on `N` threads. Great performance, great resource utilization. We don't waste RAM or sacrifice startup time by reading everything and instead do everything on demand with a healthy buffer.
```csharp
while (!Reader.EndOfStream) // while there is shit to read
{
    //always trim your lines!
    var line = Reader.ReadLine().Trim();
    var parts = line.Split(':');//naive implementation
    var ip = parts[0]; // expecting only valid data
    var port = ushort.Parse(parts[1]); // (╯°□°）╯︵ ┻━┻ 

    var proxy = new Proxy(ip, port, timeout);
    Proxies.Add(proxy); // BlockingCollection<Proxy>

    if (Proxies.Count > threadCount * 2)
        LoadBlock.WaitOne(); // Enough in the Queue, wait till we get signaled.
}
```

## testing
Now, testing the Proxy is super easy. `WebProxy` is a built-in class, just like `HttpWebRequest`. Both together and we're virtually done.

```csharp
public void Test()
{
    try
    {
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create("https://her.st");

        var proxy = new WebProxy(IP, Port);
        proxy.BypassProxyOnLocal = false;
        
        request.Proxy = proxy;
        request.UserAgent = "ProxyTester Version: 1";
        request.Timeout = Timeout;

        WebResponse webResponse = request.GetResponse();
        var reader = new StreamReader(webResponse.GetResponseStream());
        _response = reader.ReadToEnd().Trim();

        Alive = true; // proxy is working
    }
    catch
    {
        Alive = false; // proxy is not working
    }
}
```

## sorting

It would make sense to do multiple rounds of sorting, by latency, by throughput, by country,... we will focus at sorting by country first. There's 100's of 'free' APIs for 'Geo-IP' lookups, but there's always one catch: after a certain amount of queries, they ask for your credit card.

How do those services do it? I've done some googling and it turns out, there's free databases available, most notably the [IP2Location Db's](https://www.ip2location.com/database) - we will use LITE-DB5 which has a C# parser by the taiwanese [Sky Land Universal Coorporation](https://github.com/SkyLandTW) licensed under the Unlicense. Perfect. Let's legally steal their code and hook it up.

*I will dive deeper into how this db was created in my next networking article*
```csharp
private static void Trace(Proxy proxy)
{
    var location = Locator.Locate(IPAddress.Par(proxy.IP));

    if (!OrderedProxies.ContainsKe(location.Country))
        OrderedProxies.Add(location.Country,new List<Proxy>());
    OrderedProxies[location.Country].Add(proxy);
}
```
*OrderedProxies?*

as you can see in the code above, I created a `Dictionary<string Country, List<Proxy>>` namely `OrderedProxies` which lets me group the proxies by country very easily. In the next part, I hope to have had time to refactor and rename most of the worst variable and class names. I've been facepalming too much while writing this article.

## what's next?

There's still alot to be added to this little service. Off the top of my head:

* Ping proxies to find the best latency
* run speedtest to find the best throughput
* automate pastebin harvesting
* database
* web api with json responses - REST like.

see you soon
