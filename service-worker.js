workbox.core.setCacheNameDetails({
    prefix: 'trrbl',
    suffix: 'v1',
    precache: 'precache',
    runtime: 'runtime-cache'
});
workbox.skipWaiting();
workbox.clientsClaim();
workbox.precaching.precacheAndRoute(self.__precacheManifest);
workbox.routing.registerRoute(/\.html$/, workbox.strategies.precacheAndRoute());
workbox.routing.registerRoute(/\.ttf$/, workbox.strategies.precacheAndRoute());
workbox.routing.registerRoute(/\.woff$/, workbox.strategies.precacheAndRoute());
workbox.routing.registerRoute(/\.js$/, workbox.strategies.precacheAndRoute());
workbox.routing.registerRoute(/\.css$/, workbox.strategies.precacheAndRoute());
workbox.routing.registerRoute(/\.webp$/, workbox.strategies.precacheAndRoute());
workbox.routing.registerRoute(/\.png$/, workbox.strategies.precacheAndRoute());
workbox.routing.registerRoute(/assets\/(img|icons)/, workbox.strategies.precacheAndRoute());
workbox.routing.registerRoute(/^https?:\/\/h.img.alumni.re/, workbox.strategies.staleWhileRevalidate());
self.addEventListener('fetch', function (event) {
    event.respondWith(caches.match(event.request).then(function (response) {
        return response || fetch(event.request)
    }))
})