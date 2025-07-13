// Service Worker Template - Minimal offline caching for Rumble Loadouts
// Version will be automatically injected at build time

const CACHE_NAME = 'rumble-loadouts-{{VERSION}}';
const urlsToCache = [
  '/',
  '/index.html',
  '/elm.js'
];

// Install event: Cache the application files
self.addEventListener('install', event => {
  console.log('Service Worker installing with cache:', CACHE_NAME);
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        console.log('Caching app files');
        return cache.addAll(urlsToCache);
      })
  );
  // Immediately activate the new service worker
  self.skipWaiting();
});

// Activate event: Clean up old caches
self.addEventListener('activate', event => {
  console.log('Service Worker activating');
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheName !== CACHE_NAME) {
            console.log('Deleting old cache:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
  // Take control of all pages immediately
  self.clients.claim();
});

// Fetch event: Serve from cache when offline
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        // Return cached version if available
        if (response) {
          console.log('Serving from cache:', event.request.url);
          return response;
        }
        // Otherwise try to fetch from network
        return fetch(event.request).catch(() => {
          // If network fails, try to serve the main page for navigation requests
          if (event.request.mode === 'navigate') {
            return caches.match('/index.html');
          }
          console.log('Failed to serve:', event.request.url);
          throw new Error('Network error and no cache available');
        });
      })
  );
});