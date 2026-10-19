// Small touches shared by every page: cards fade in as they scroll into
// view, and the title glitches now and then (like the app's mode switch).
const reduced = matchMedia('(prefers-reduced-motion: reduce)').matches;

if (!reduced && 'IntersectionObserver' in window) {
  const io = new IntersectionObserver((entries) => {
    for (const entry of entries) {
      if (entry.isIntersecting) {
        entry.target.classList.add('in');
        io.unobserve(entry.target);
      }
    }
  }, { threshold: 0.15 });
  document.querySelectorAll('.reveal').forEach((el, i) => {
    el.style.transitionDelay = `${(i % 4) * 80}ms`;
    io.observe(el);
  });
} else {
  document.querySelectorAll('.reveal').forEach((el) => el.classList.add('in'));
}

const title = document.querySelector('.glitch');
if (title && !reduced) {
  setInterval(() => {
    title.classList.remove('kick');
    void title.offsetWidth; // restart the animation
    title.classList.add('kick');
  }, 4200);
}
