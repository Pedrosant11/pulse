// Light burst behind the match celebration (SPEC 12): rays and a ring that
// grow with uProgress (0 → 1), then keep turning slowly with uTime.
// Output is premultiplied alpha, drawn over the backdrop.
#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform vec2 uSize;
uniform float uTime;
uniform float uProgress;
uniform vec4 uColorA; // mode accent
uniform vec4 uColorB; // violet

out vec4 fragColor;

void main() {
  vec2 uv = (FlutterFragCoord().xy - 0.5 * uSize) / min(uSize.x, uSize.y);
  float r = length(uv);
  float angle = atan(uv.y, uv.x);
  float grow = smoothstep(0.0, 1.0, uProgress);

  float rays = pow(0.5 + 0.5 * sin(angle * 14.0 + uTime * 0.8), 6.0)
    + 0.6 * pow(0.5 + 0.5 * sin(angle * 7.0 - uTime * 0.5), 8.0);
  float rayMask = rays * exp(-r * 2.2 / max(grow, 0.05)) * grow;

  float ring = exp(-pow((r - grow * 0.9) * 14.0, 2.0)) * (1.0 - 0.7 * grow);
  float core = exp(-r * 6.0) * (0.6 + 0.4 * sin(uTime * 2.0)) * grow;

  float alpha = clamp(rayMask * 0.8 + ring + core, 0.0, 1.0);
  vec3 color = mix(uColorA.rgb, uColorB.rgb, clamp(r * 1.5, 0.0, 1.0));
  fragColor = vec4(color * alpha, alpha);
}
