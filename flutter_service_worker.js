'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"web.iml": "731a1a3080009db8d4572ef3fb1679c3",
"pubspec.lock": "448c78cb5d7dc56525f868e17b02d29c",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"build/web/icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"build/web/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"build/web/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"build/web/icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"build/web/assets/AssetManifest.bin.json": "69a99f98c8b1fb8111c5fb961769fcd8",
"build/web/assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"build/web/assets/AssetManifest.bin": "693635b5258fe5f1cda720cf224f158c",
"build/web/assets/fonts/MaterialIcons-Regular.otf": "deea0f5dba93813bade5621aec9b6b13",
"build/web/assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"build/web/assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"build/web/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"build/web/assets/NOTICES": "6bfd14c0110f89f35df407ff909db43b",
"build/web/index.html": "c7abd37f72f736b9a7f8a8e4b7fe4309",
"build/web/main.dart.js": "ec368bae622911c3f791ec502b188242",
"build/web/manifest.json": "901d86fb8842ec0d66225a542131d689",
"build/web/version.json": "b3b87f9153d4406c14bc11865bbe1089",
"build/web/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"build/web/flutter_bootstrap.js": "d7d1c0b4a7e31a924e5c3584ed3cda14",
"build/web/.git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
"build/web/.git/config": "5b603c2c0801a9ded3b79159fc38b404",
"build/web/.git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
"build/web/.git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
"build/web/.git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
"build/web/.git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
"build/web/.git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
"build/web/.git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
"build/web/.git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
"build/web/.git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
"build/web/.git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
"build/web/.git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
"build/web/.git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
"build/web/.git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
"build/web/.git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
"build/web/.git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
"build/web/.git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
"build/web/.git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
"build/web/canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"build/web/canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"build/web/canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"build/web/canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"build/web/canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"build/web/canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"build/web/canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"build/web/canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"build/web/canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"build/web/canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"build/web/canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"build/web/canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"build/web/flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"assets/AssetManifest.bin.json": "a1fee2517bf598633e2f67fcf3e26c94",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/AssetManifest.bin": "0b0a3415aad49b6e9bf965ff578614f9",
"assets/fonts/MaterialIcons-Regular.otf": "2ee11d859208a215cfa9ac98042efc13",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/NOTICES": "4829b84e10f6b480850662e658333174",
"web/icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"web/icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"web/icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"web/icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"web/index.html": "61be8381bac3a1c65b6e70d8909fff94",
"web/manifest.json": "901d86fb8842ec0d66225a542131d689",
"web/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"index.html": "77db6cfbefa6ae539891f77745157f6b",
"/": "77db6cfbefa6ae539891f77745157f6b",
"pubspec.yaml": "4952b8a60cf1759dd763a1f4ded31163",
"README.md": "ac18482fc28234fc361bcd7776f73e29",
"main.dart.js": "f68a02cecf26233e0984f2bde8ee448c",
"manifest.json": "9d144cd0055cf4d849659483f4c06a8e",
"version.json": "24257dbd8861a93b87c74bedb750db8f",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter_bootstrap.js": "2464b2bd4d8fa2e4790fbf78c3a617c0",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
".idea/modules.xml": "6e562bd2e74aaa79b0f10c5b25fab769",
".idea/runConfigurations/main_dart.xml": "2b82ac5d547e7256de51268edfd10dc3",
".idea/libraries/Dart_SDK.xml": "20f10eedd5cd149b5c80b60fa1cb78c2",
".idea/libraries/KotlinJavaRuntime.xml": "4b0df607078b06360237b0a81046129d",
".idea/workspace.xml": "cc5f609be0f96835c87839f62217d14b",
"test/widget_test.dart": "cb2dd7128b72a5807c36cba95bd6bbc4",
".dart_tool/package_config.json": "72ceb6c48fa3390ac0b54c4498597f36",
".dart_tool/dartpad/web_plugin_registrant.dart": "7ed35bc85b7658d113371ffc24d07117",
".dart_tool/package_graph.json": "ac23abdc3d4a3e53d2a58e7f4441b736",
".dart_tool/version": "e8896a46519236f2f706a0505f215c24",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/web_resources.d": "ec6b0f9853074dd1f6ea4b10d1b46475",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/outputs.json": "1c06995a0a70a70234b17425327fcf7d",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/app.dill": "de97db18053d8c647bd467105b882817",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/service_worker.d": "c2777c2d442524f8b3d9b5c0a31e0ef2",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/dart_build.d": "62ab9ed2f414b8c91d1f680a8242c32f",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/dart2js.d": "23a4db8ff4b30cd46c242cb7555f8893",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/web_release_bundle.stamp": "2df2a481e98fd79ed567500927536c45",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/dart_build_result.json": "c75c4831b1f9be40ddaf8f059988ce7d",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/app.dill.deps": "9499dbb1626207ee7e4278f24483e928",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/dart_build.stamp": "bf523e3cdd07f5fdb87d4b2790578950",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/web_plugin_registrant.dart": "7ed35bc85b7658d113371ffc24d07117",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/main.dart.js": "ec368bae622911c3f791ec502b188242",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/web_templated_files.stamp": "16d00f5bd77a92e6ebc11b5c0823a0be",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/web_static_assets.stamp": "ca3ce26ad53eacde0bf7b10a7f2e7a24",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/main.dart.js.deps": "1d7fe8b22b5899afe8bf6806e57b7e58",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/web_entrypoint.stamp": "dcbc7a646f509bde55ea25501596a4df",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/gen_localizations.stamp": "436d2f2faeb7041740ee3f49a985d62a",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/main.dart": "29f38f0f6de2ac2509b7bc77abef7401",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/dart2js.stamp": "3018feb151fa25d5bbf73ef6d9ea73d0",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/web_service_worker.stamp": "71fbe639bdecfc423e17b9727e4c72d6",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/dart2wasm.stamp": "8a86b75696edffda77e499061e8cf474",
".dart_tool/flutter_build/53ec7a27d3c0c9c4253d9577f10dc547/flutter_assets.d": "8daf7a88d2cb885b1d1f063e4bb3c9d5",
"analysis_options.yaml": "66d03d7647c8e438164feaf5b922d44a",
"lib/main.dart": "c8e149125151c1ebb31c65a53bc8270e"};
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
