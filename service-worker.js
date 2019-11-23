workbox.core.setCacheNameDetails({
    prefix: 'trrbl',
    suffix: 'v2',
    precache: 'precache',
    runtime: 'runtime-cache'
});
workbox.skipWaiting();
workbox.clientsClaim();
workbox.precaching.precacheAndRoute(self.__precacheManifest);
workbox.routing.registerRoute(/\.html$/, workbox.strategies.StaleWhileRevalidate());
workbox.routing.registerRoute(/\.js$/, workbox.strategies.StaleWhileRevalidate());
workbox.routing.registerRoute(/\.css$/, workbox.strategies.StaleWhileRevalidate());
workbox.routing.registerRoute(/\.webp$/, workbox.strategies.StaleWhileRevalidate());
workbox.routing.registerRoute(/\.png$/, workbox.strategies.StaleWhileRevalidate());
workbox.routing.registerRoute(/\.jpg$/, workbox.strategies.StaleWhileRevalidate());
workbox.routing.registerRoute(/assets\/(img|icons)/, workbox.strategies.StaleWhileRevalidate());
workbox.routing.registerRoute(/^https?:\/\/h.img.alumni.re/, workbox.strategies.StaleWhileRevalidate());
self.addEventListener('fetch', function (event) {
    event.respondWith(caches.match(event.request).then(function (response) {
        return response || fetch(event.request)
    }))
})