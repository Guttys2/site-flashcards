self.addEventListener('install', (e) => {
  e.waitUntil(
    caches.open('flashcards-v2').then((cache) => { // Alterado de v1 para v2
      return cache.addAll(['./', './index.html', './manifest.json']);
    })
  );
});
