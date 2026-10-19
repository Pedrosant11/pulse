// Pulse site background (three.js): the app's neon smoke shader plus, on the
// home page, a ring of particles shaped like a sound wave that pulses on a
// 124 BPM kick and follows the pointer. Paused when hidden; a static
// gradient stays behind it (reduced motion, no WebGL).
import * as THREE from './vendor/three.module.min.js';

const canvas = document.querySelector('canvas.scene');
const reduced = matchMedia('(prefers-reduced-motion: reduce)').matches;

// "?3d" forces the scene (testing on machines without a GPU).
const forced = new URLSearchParams(location.search).has('3d');

if (canvas && !reduced) {
  try {
    if (!start(canvas, canvas.dataset.mode === 'hero')) canvas.remove();
  } catch (error) {
    canvas.remove();
  }
}

/// Software rendering (no GPU: emulators, old phones) can't keep up with
/// full-screen shaders; the CSS gradient stays instead.
function softwareGl(gl) {
  const info = gl.getExtension('WEBGL_debug_renderer_info');
  const name = info ? gl.getParameter(info.UNMASKED_RENDERER_WEBGL) : '';
  return /swiftshader|llvmpipe|software|basic render/i.test(String(name));
}

function start(canvas, hero) {
  const renderer = new THREE.WebGLRenderer({
    canvas,
    antialias: false,
    alpha: false,
    powerPreference: 'low-power',
  });
  if (!forced && softwareGl(renderer.getContext())) {
    renderer.dispose();
    return false;
  }
  const mobile = matchMedia('(max-width: 700px)').matches;
  // Phones: lower resolution (the smoke is soft anyway) and 30 fps.
  renderer.setPixelRatio(mobile ? Math.min(devicePixelRatio, 2) * 0.75 : Math.min(devicePixelRatio, 1.5));
  renderer.setClearColor(0x0a0a0f, 1);
  // Phones draw every other frame (~30 fps).
  const skip = mobile ? 2 : 1;

  const scene = new THREE.Scene();
  const camera = new THREE.PerspectiveCamera(50, 1, 0.1, 100);
  camera.position.set(0, 0, 9);

  const palette = {
    background: new THREE.Color(0x0a0a0f),
    violet: new THREE.Color(0x7b2cff),
    magenta: new THREE.Color(0xff2bd6),
    cyan: new THREE.Color(0x00e5ff),
    lime: new THREE.Color(0xc6ff00),
  };

  // Neon smoke: the same domain-warped fbm as shaders/neon_background.frag.
  const smoke = new THREE.Mesh(
    new THREE.PlaneGeometry(2, 2),
    new THREE.ShaderMaterial({
      depthTest: false,
      depthWrite: false,
      uniforms: {
        uSize: { value: new THREE.Vector2(1, 1) },
        uTime: { value: 0 },
        uBackground: { value: palette.background },
        uColorA: { value: palette.violet },
        uColorB: { value: palette.magenta },
        uColorC: { value: palette.cyan },
      },
      vertexShader: /* glsl */ `
        void main() { gl_Position = vec4(position.xy, 0.0, 1.0); }
      `,
      fragmentShader: /* glsl */ `
        precision mediump float;
        uniform vec2 uSize;
        uniform float uTime;
        uniform vec3 uBackground, uColorA, uColorB, uColorC;
        float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }
        float noise(vec2 p) {
          vec2 i = floor(p), f = fract(p), u = f * f * (3.0 - 2.0 * f);
          return mix(mix(hash(i), hash(i + vec2(1, 0)), u.x),
                     mix(hash(i + vec2(0, 1)), hash(i + vec2(1, 1)), u.x), u.y);
        }
        float fbm(vec2 p) {
          float v = 0.0, a = 0.5;
          for (int i = 0; i < 4; i++) { v += a * noise(p); p *= 2.0; a *= 0.5; }
          return v;
        }
        void main() {
          vec2 uv = gl_FragCoord.xy / uSize;
          uv.y = 1.0 - uv.y;
          float aspect = uSize.x / uSize.y;
          vec2 p = vec2(uv.x * aspect, uv.y);
          float t = uTime * 0.05;
          vec2 q = vec2(fbm(p * 1.6 + vec2(0.0, t)), fbm(p * 1.6 + vec2(5.2, -t)));
          float s = fbm(p * 2.0 + 2.0 * q + vec2(t * 0.6, t * 0.3));
          vec2 la = vec2(0.15 * aspect + 0.10 * sin(uTime * 0.13), 0.12 + 0.08 * cos(uTime * 0.11));
          vec2 lb = vec2(0.90 * aspect + 0.08 * cos(uTime * 0.09), 0.88 + 0.06 * sin(uTime * 0.12));
          vec2 lc = vec2(0.50 * aspect + 0.30 * sin(uTime * 0.07), 0.50 + 0.30 * cos(uTime * 0.05));
          float a = exp(-4.0 * distance(p, la));
          float b = exp(-4.2 * distance(p, lb));
          float c = exp(-6.0 * distance(p, lc)) * 0.25;
          vec3 color = uBackground;
          color += uColorA * a * (0.25 + 0.75 * s) * 0.45;
          color += uColorB * b * (0.25 + 0.75 * s) * 0.35;
          color += uColorC * c * s;
          color += vec3(s * s) * 0.02;
          gl_FragColor = vec4(color, 1.0);
        }
      `,
    }),
  );
  smoke.frustumCulled = false;
  smoke.renderOrder = -1;
  scene.add(smoke);

  // Sound-wave ring (home page): rings of points whose radius follows a
  // waveform, kicked by the beat.
  const group = new THREE.Group();
  let ring = null;
  if (hero) {
    const rings = mobile ? 22 : 34;
    const perRing = mobile ? 140 : 220;
    const count = rings * perRing;
    const angle = new Float32Array(count);
    const layer = new Float32Array(count);
    const seed = new Float32Array(count);
    for (let r = 0; r < rings; r++) {
      for (let i = 0; i < perRing; i++) {
        const k = r * perRing + i;
        angle[k] = (i / perRing) * Math.PI * 2;
        layer[k] = r / (rings - 1);
        seed[k] = Math.random();
      }
    }
    const geometry = new THREE.BufferGeometry();
    geometry.setAttribute('position', new THREE.BufferAttribute(new Float32Array(count * 3), 3));
    geometry.setAttribute('aAngle', new THREE.BufferAttribute(angle, 1));
    geometry.setAttribute('aLayer', new THREE.BufferAttribute(layer, 1));
    geometry.setAttribute('aSeed', new THREE.BufferAttribute(seed, 1));

    ring = new THREE.Points(
      geometry,
      new THREE.ShaderMaterial({
        transparent: true,
        depthWrite: false,
        blending: THREE.AdditiveBlending,
        uniforms: {
          uTime: { value: 0 },
          uBeat: { value: 0 },
          uPixelRatio: { value: renderer.getPixelRatio() },
          uDepth: { value: 9 },
          uMagenta: { value: palette.magenta },
          uViolet: { value: palette.violet },
          uCyan: { value: palette.cyan },
        },
        vertexShader: /* glsl */ `
          attribute float aAngle;
          attribute float aLayer;
          attribute float aSeed;
          uniform float uTime, uBeat, uPixelRatio, uDepth;
          uniform vec3 uMagenta, uViolet, uCyan;
          varying vec3 vColor;
          varying float vAlpha;
          void main() {
            float a = aAngle;
            // Waveform around the ring, travelling slowly; the kick swells it.
            float wave = sin(a * 6.0 + uTime * 0.9) * 0.5
                       + sin(a * 13.0 - uTime * 1.7 + aLayer * 3.0) * 0.25
                       + sin(a * 3.0 + uTime * 0.4) * 0.25;
            float r = 2.2 + aLayer * 1.4 + wave * (0.18 + 0.55 * uBeat) * (0.4 + aLayer);
            float z = (aLayer - 0.5) * 1.6 + sin(a * 2.0 + uTime * 0.6) * 0.25;
            vec3 pos = vec3(cos(a) * r, sin(a) * r, z);
            pos += (aSeed - 0.5) * 0.06;
            vec4 mv = modelViewMatrix * vec4(pos, 1.0);
            gl_Position = projectionMatrix * mv;
            gl_PointSize = max(2.5, (3.0 + 4.0 * uBeat * (1.0 - aLayer)) * uPixelRatio * (uDepth / -mv.z));
            float side = 0.5 + 0.5 * sin(a + uTime * 0.2);
            vColor = mix(mix(uViolet, uMagenta, side), uCyan, aLayer * aLayer);
            vAlpha = 0.35 + 0.65 * (1.0 - aLayer) * (0.6 + 0.4 * uBeat);
          }
        `,
        fragmentShader: /* glsl */ `
          precision mediump float;
          varying vec3 vColor;
          varying float vAlpha;
          void main() {
            float d = length(gl_PointCoord - 0.5);
            float glow = smoothstep(0.5, 0.0, d);
            gl_FragColor = vec4(vColor * glow, glow * vAlpha);
          }
        `,
      }),
    );
    ring.frustumCulled = false;
    group.add(ring);
    group.rotation.x = -0.35;
    scene.add(group);
  }

  // Pointer parallax (desktop) — eased toward the target.
  const target = { x: 0, y: 0 };
  addEventListener('pointermove', (event) => {
    target.x = (event.clientX / innerWidth - 0.5) * 0.6;
    target.y = (event.clientY / innerHeight - 0.5) * 0.4;
  }, { passive: true });

  function resize() {
    const width = canvas.clientWidth;
    const height = canvas.clientHeight;
    renderer.setSize(width, height, false);
    camera.aspect = width / height;
    // Fit the ring (radius ~4) in the width on narrow screens.
    const halfFov = THREE.MathUtils.degToRad(camera.fov / 2);
    camera.position.z = Math.max(9, 4.4 / (Math.tan(halfFov) * camera.aspect));
    camera.updateProjectionMatrix();
    if (ring) ring.material.uniforms.uDepth.value = camera.position.z;
    renderer.getDrawingBufferSize(smoke.material.uniforms.uSize.value);
  }
  new ResizeObserver(resize).observe(canvas);
  resize();

  // Only animate while on screen and the tab is visible.
  let visible = true;
  new IntersectionObserver(([entry]) => { visible = entry.isIntersecting; })
    .observe(canvas);

  const bpm = 124;
  const clock = new THREE.Clock();
  let frame = 0;
  renderer.setAnimationLoop(() => {
    if (!visible || document.hidden) return;
    if (frame++ % skip !== 0) return;
    const t = clock.getElapsedTime();
    smoke.material.uniforms.uTime.value = t;
    if (ring) {
      // Kick: sharp attack, quick decay, every beat.
      const phase = (t * bpm / 60) % 1;
      const beat = Math.exp(-phase * 6.0);
      ring.material.uniforms.uTime.value = t;
      ring.material.uniforms.uBeat.value = beat;
      group.rotation.z = t * 0.05;
      group.rotation.y += (target.x - group.rotation.y) * 0.04;
      group.rotation.x += (-0.35 + target.y - group.rotation.x) * 0.04;
      const scale = 1 + beat * 0.03;
      group.scale.set(scale, scale, scale);
    }
    renderer.render(scene, camera);
  });
  return true;
}
