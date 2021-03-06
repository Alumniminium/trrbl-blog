workbox.core.setCacheNameDetails({
    prefix: "trbl",
    suffix: "v2",
    precache: "precache",
    runtime: "runtime-cache"
}), workbox.clientsClaim(), workbox.precaching.precacheAndRoute(self.__precacheManifest), workbox.routing.registerRoute(/\.html$/, new workbox.strategies.StaleWhileRevalidate), workbox.routing.registerRoute(/\.js$/, new workbox.strategies.StaleWhileRevalidate), workbox.routing.registerRoute(/\.css$/, new workbox.strategies.StaleWhileRevalidate), workbox.routing.registerRoute(/\.webp$/, new workbox.strategies.StaleWhileRevalidate), workbox.routing.registerRoute(/\.png$/, new workbox.strategies.StaleWhileRevalidate), workbox.routing.registerRoute(/\.jpg$/, new workbox.strategies.StaleWhileRevalidate), workbox.routing.registerRoute(/assets\/(img|icons)/, new workbox.strategies.StaleWhileRevalidate), workbox.routing.registerRoute(/^https?:\/\/cdn.her.st/, new workbox.strategies.StaleWhileRevalidate), self.addEventListener("fetch", function (e) {
    e.respondWith(caches.match(e.request).then(function (t) {
        return t || fetch(e.request)
    }))
});