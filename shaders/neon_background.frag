// Slow neon smoke with drifting lights (SPEC 12): splash, login, onboarding.
// Uniform order matters (set by index in NeonBackdrop).
#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform vec2 uSize;
uniform float uTime;
uniform vec4 uBackground;
uniform vec4 uColorA; // violet
uniform vec4 uColorB; // magenta
uniform vec4 uColorC; // cyan

out vec4 fragColor;

float hash(vec2 p) {
  return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);
  return mix(
    mix(hash(i), hash(i + vec2(1.0, 0.0)), u.x),
    mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x),
    u.y
  );
}

float fbm(vec2 p) {
  float value = 0.0;
  float amplitude = 0.5;
  for (int i = 0; i < 4; i++) {
    value += amplitude * noise(p);
    p *= 2.0;
    amplitude *= 0.5;
  }
  return value;
}

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;
  float aspect = uSize.x / uSize.y;
  vec2 p = vec2(uv.x * aspect, uv.y);
  float t = uTime * 0.05;

  // Domain-warped smoke.
  vec2 q = vec2(fbm(p * 1.6 + vec2(0.0, t)), fbm(p * 1.6 + vec2(5.2, -t)));
  float smoke = fbm(p * 2.0 + 2.0 * q + vec2(t * 0.6, t * 0.3));

  // Lights drifting around the corners and the middle.
  vec2 lightA = vec2(0.15 * aspect + 0.10 * sin(uTime * 0.13), 0.12 + 0.08 * cos(uTime * 0.11));
  vec2 lightB = vec2(0.90 * aspect + 0.08 * cos(uTime * 0.09), 0.88 + 0.06 * sin(uTime * 0.12));
  vec2 lightC = vec2(0.50 * aspect + 0.30 * sin(uTime * 0.07), 0.50 + 0.30 * cos(uTime * 0.05));
  float a = exp(-4.0 * distance(p, lightA));
  float b = exp(-4.2 * distance(p, lightB));
  float c = exp(-6.0 * distance(p, lightC)) * 0.25;

  vec3 color = uBackground.rgb;
  // Kept dark (SPEC 12): lights glow through the smoke, no wash.
  color += uColorA.rgb * a * (0.25 + 0.75 * smoke) * 0.45;
  color += uColorB.rgb * b * (0.25 + 0.75 * smoke) * 0.35;
  color += uColorC.rgb * c * smoke;
  color += vec3(smoke * smoke) * 0.02;

  fragColor = vec4(color, 1.0);
}
