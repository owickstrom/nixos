#version 300 es
precision highp float;
in vec2 v_texcoord;
uniform sampler2D tex;
uniform int wl_output;  // id of the monitor being rendered, see `hyprctl monitors -j`
uniform vec2 fullSize;  // monitor size in pixels
layout(location = 0) out vec4 fragColor;

const int EINK_OUTPUT = 0;       // BenQ EW2880U (DP-2); the Mira on DP-3 is real e-ink

const float CONTRAST     = 1.7;   // steeper curve pushes mids toward ink, like a high-contrast e-ink setting
const float BRIGHTNESS   = -0.02;
const float BLACK        = 0.08;  // ink isn't pure black
const float WHITE        = 0.80;  // paper isn't pure white
const float LEVELS       = 8.0;   // gray levels; fewer levels = more visible dither
const float DITHER       = 0.8;   // 0 = plain quantization, 1 = full-step Bayer dither
const int   DITHER_SCALE = 2;     // physical pixels per dither cell; 2 matches the monitor's scale=2 logical pixel
const float SOFTEN       = 0.5;   // 0..1 blend with a 3x3 blur, mimics e-ink edge bleed
const float INK_BLEED    = 0.3;   // 0..1 blend toward the darkest neighbour; thickens and clumps strokes
const float DESATURATE   = 0.75;  // 0 = full colour, 1 = pure grayscale
const vec3  WARM         = vec3(1.0, 0.63, 0.28); // blackbody tint, 2500K. 2000K: vec3(1.0, 0.54, 0.07)
const float WARMTH       = 1.0;   // 0 = neutral gray, 1 = full WARM tint

const float B4[16] = float[16](0.,8.,2.,10., 12.,4.,14.,6., 3.,11.,1.,9., 15.,7.,13.,5.);

float luma(vec3 c) {
    return dot(c, vec3(0.2126, 0.7152, 0.0722));
}

void main() {
    vec3 c = texture(tex, v_texcoord).rgb;
    if (wl_output != EINK_OUTPUT) {
        fragColor = vec4(c, 1.0);
        return;
    }

    float y = luma(c);
    if (SOFTEN > 0.0 || INK_BLEED > 0.0) {
        vec2 px = 1.0 / fullSize;
        float sum = 0.0;
        float darkest = 1.0;
        for (int i = -1; i <= 1; i++)
            for (int j = -1; j <= 1; j++) {
                float n = luma(texture(tex, v_texcoord + vec2(float(i), float(j)) * px).rgb);
                sum += n;
                darkest = min(darkest, n);
            }
        y = mix(y, sum / 9.0, SOFTEN);
        y = mix(y, darkest, INK_BLEED);
    }

    y = clamp((y - 0.5) * CONTRAST + 0.5 + BRIGHTNESS, 0.0, 1.0);

    // Quantize to LEVELS grays with a centered ordered dither. Dither cells are
    // DITHER_SCALE pixels wide so the pattern reads as e-ink grain, not noise.
    ivec2 p = (ivec2(gl_FragCoord.xy) / DITHER_SCALE) & 3;
    float t = (B4[p.y * 4 + p.x] + 0.5) / 16.0 - 0.5;
    float q = floor(y * (LEVELS - 1.0) + 0.5 + t * DITHER) / (LEVELS - 1.0);

    float g = mix(BLACK, WHITE, q);
    // Re-apply the original hue at the quantized brightness, then desaturate.
    vec3 colored = clamp(c * (g / max(luma(c), 0.001)), 0.0, 1.0);
    vec3 outc = mix(colored, vec3(g), DESATURATE);

    vec3 tint = mix(vec3(1.0), WARM, WARMTH);
    fragColor = vec4(outc * tint, 1.0);
}
