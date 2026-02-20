'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "70242f28bead588f6e10d547451c97de",
"assets/AssetManifest.bin.json": "a77c5e071e75d84b7223ba0b73899a89",
"assets/AssetManifest.json": "e7731cbfee875fe32b04e57e216c4305",
"assets/assets/image/aboutus.png": "f8d9c37f10e94cd959d718b72d08d5da",
"assets/assets/image/basement.jpg": "4704f6b2f1b752ce3f98cb09cd587d7a",
"assets/assets/image/Buzzer.jpg": "631e41a9f8cc0590980bf9e62713d87e",
"assets/assets/image/city.jpg": "6b7014730ff14a231c8ecd26280de4c5",
"assets/assets/image/clamp.jpg": "eb6cbff5539123c29bba7e22e44716b6",
"assets/assets/image/client.png": "1e2d8f75cc6d91c132f7f39cb2754460",
"assets/assets/image/crime.jpg": "143053e20567cb2ea4b638fc000de262",
"assets/assets/image/DCMotor.jpg": "102a56c95955b3d6d2d2cb1fdfdb17e6",
"assets/assets/image/dontknow.jpg": "3e475980f86f3fd771d7e745bbbdc069",
"assets/assets/image/dorm.jpg": "80cc6e4a376deef9ee6c2d455c70afcc",
"assets/assets/image/esp32.jpg": "d32d10e4815dbefac144dbdc19a67e4d",
"assets/assets/image/explode.jpg": "9d0675d8da65ed6b474ef2f235282629",
"assets/assets/image/fiberstrap.jpg": "00a695b9b17a7907304fa7d9b93edde3",
"assets/assets/image/google-play-icon.svg": "4b9aa68e69116da6172d135b253143b8",
"assets/assets/image/holder.jpg": "66dda184a1c1877a626bcb1cad1e9ef3",
"assets/assets/image/home.jpg": "e6e1ff34cd9ecd625364013794536cac",
"assets/assets/image/hotel.jpg": "06ae396062a07d521cb9e1e59968abc8",
"assets/assets/image/human.jpg": "577e64b79caa867a91b2d88651208d39",
"assets/assets/image/instagram.svg": "abfe70361d37471fb39f7967cc33ed16",
"assets/assets/image/perfboard.jpg": "4d09a56cde59caa127dafd683d4925e2",
"assets/assets/image/pushbutton.jpg": "23a1c2da5e9e933e2266f9c4967abebe",
"assets/assets/image/rental.jpg": "101cf53dca70d400f4a4d1400b0b535e",
"assets/assets/image/rfp602.png": "68257add463fad50f7cdb9c03ddead8a",
"assets/assets/image/slanted.png": "029db303d7340df2b10e57b4119af1f1",
"assets/assets/image/social.jpg": "b3d2e30924059979d94b465706160a98",
"assets/assets/image/statistic.png": "6cc5a77ab55db486eaa1d5b1e7b9fccc",
"assets/assets/image/windows.jpg": "57203b4ea734d0b8445e60ca04769d7f",
"assets/assets/image/youtube.svg": "ca2c58d1a15661bc9e1b67dcc69bbff0",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "a608eab16fa8202aa9c3bdb2a84aac43",
"assets/NOTICES": "f56489a39de10bade5c3eac09958e737",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "b681e0c27dee9bb47a4e5dd02f1d6494",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "12e5e9ef4f039754e2bc8583839d46ed",
"/": "12e5e9ef4f039754e2bc8583839d46ed",
"main.dart.js": "824f3737f70b6bf3eb43e8bf6ff0efc4",
"manifest.json": "83691e480d2627751b5fd01528b6e093",
"version.json": "d6d5a8ef3288d7784d9396c3b7b2047e"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
