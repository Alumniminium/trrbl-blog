workbox.core.setCacheNameDetails({
    prefix: 'trrbl',
    suffix: 'v2',
    precache: 'precache',
    runtime: 'runtime-cache'
});
workbox.skipWaiting();
workbox.clientsClaim();
workbox.precaching.precacheAndRoute(self.__precacheManifest);
workbox.routing.registerRoute(/\.html$/, new workbox.strategies.StaleWhileRevalidate());
workbox.routing.registerRoute(/\.js$/, new workbox.strategies.StaleWhileRevalidate());
workbox.routing.registerRoute(/\.css$/, new workbox.strategies.StaleWhileRevalidate());
workbox.routing.registerRoute(/\.webp$/, new workbox.strategies.StaleWhileRevalidate());
workbox.routing.registerRoute(/\.png$/, new workbox.strategies.StaleWhileRevalidate());
workbox.routing.registerRoute(/\.jpg$/, new workbox.strategies.StaleWhileRevalidate());
workbox.routing.registerRoute(/assets\/(img|icons)/, new workbox.strategies.StaleWhileRevalidate());
workbox.routing.registerRoute(/^https?:\/\/h.img.alumni.re/, new workbox.strategies.StaleWhileRevalidate());
self.addEventListener('fetch', function (event) {
    event.respondWith(caches.match(event.request).then(function (response) {
        return response || fetch(event.request)
    }))
})