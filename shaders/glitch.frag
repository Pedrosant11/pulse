// Quick glitch over a widget during a transition (SPEC 12, e.g. switching
// Date/Crew): shifted neon bands, scanlines and grain that fade with
// uIntensity (1 → 0). Premultiplied alpha overlay; it doesn't sample the
// child, so it works on every renderer.
#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform vec2 uSize;
uniform float uTime;
uniform float uIntensity;
uniform vec4 uColorA;
uniform vec4 uColorB;

out vec4 fragColor;

float hash(vec2 p) {
  return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
  vec2 frag = FlutterFragCoord().xy;
  vec2 uv = frag / uSize;
  float frame = floor(uTime * 30.0);
  float band = floor(uv.y * 24.0);

  float h = hash(vec2(band, frame));
  float on = step(1.0 - 0.35 * uIntensity, h);
  float shift = (hash(vec2(band, frame + 1.0)) - 0.5) * 0.3 * uIntensity;
  float stripes = step(0.5, fract((uv.x + shift) * 3.0 + h));
  float scan = 0.5 + 0.5 * sin(frag.y * 1.5);

  vec3 color = mix(uColorA.rgb, uColorB.rgb, step(0.5, hash(vec2(frame, band * 1.7))));
  float alpha = on * (0.25 + 0.35 * stripes) * uIntensity * scan;
  alpha += (hash(frag + frame) - 0.5) * 0.08 * uIntensity;
  alpha = clamp(alpha, 0.0, 1.0);

  fragColor = vec4(color * alpha, alpha);
}
