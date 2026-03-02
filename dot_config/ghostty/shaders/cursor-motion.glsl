// Neovide-like cursor warp trail for Ghostty
// Tuned to be softer in motion, but with a slightly flashier neon trail.

const float DURATION_SHORT = 0.12;
const float DURATION_LONG = 0.20;
const float TRAIL_SIZE_HORIZONTAL = 0.32;
const float TRAIL_SIZE_VERTICAL = 0.70;
const float MIN_DISTANCE_RATIO = 0.14;
const float BLUR_PX = 1.65;
const float TRAIL_THICKNESS_Y = 1.0;
const float TRAIL_THICKNESS_X = 0.94;
const float MAX_ALPHA = 0.72;
const float GLOW_ALPHA = 0.24;
const float GLOW_WHITEN = 0.20;

float easeOutCubic(float x) {
    return 1.0 - pow(1.0 - x, 3.0);
}

vec2 nPos(vec2 p) {
    return (p * 2.0 - iResolution.xy) / iResolution.y;
}

vec2 nSize(vec2 s) {
    return (s * 2.0) / iResolution.y;
}

float sdRect(vec2 p, vec2 c, vec2 b) {
    vec2 d = abs(p - c) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float segDist2(vec2 p, vec2 a, vec2 b, inout float winding, float d2) {
    vec2 e = b - a;
    vec2 w = p - a;
    float t = clamp(dot(w, e) / max(dot(e, e), 1e-8), 0.0, 1.0);
    vec2 proj = a + e * t;

    float curD2 = dot(p - proj, p - proj);
    d2 = min(d2, curD2);

    float c0 = step(0.0, p.y - a.y);
    float c1 = 1.0 - step(0.0, p.y - b.y);
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
    float allCond = c0 * c1 * c2;
    float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
    winding *= flip;

    return d2;
}

float sdConvexQuad(vec2 p, vec2 v1, vec2 v2, vec2 v3, vec2 v4) {
    float winding = 1.0;
    float d2 = dot(p - v1, p - v1);

    d2 = segDist2(p, v1, v2, winding, d2);
    d2 = segDist2(p, v2, v3, winding, d2);
    d2 = segDist2(p, v3, v4, winding, d2);
    d2 = segDist2(p, v4, v1, winding, d2);

    return winding * sqrt(d2);
}

float aa(float dist, float blurPx) {
    float blur = nSize(vec2(blurPx)).x;
    return 1.0 - smoothstep(0.0, blur, dist);
}

void cursorCorners(vec4 c, out vec2 tl, out vec2 tr, out vec2 br, out vec2 bl) {
    // iCurrentCursor.xy is top-left corner in Ghostty.
    float cx = c.x + c.z * 0.5;
    float cy = c.y - c.w * 0.5;

    float hw = c.z * 0.5 * TRAIL_THICKNESS_X;
    float hh = c.w * 0.5 * TRAIL_THICKNESS_Y;

    tl = vec2(cx - hw, cy + hh);
    tr = vec2(cx + hw, cy + hh);
    br = vec2(cx + hw, cy - hh);
    bl = vec2(cx - hw, cy - hh);
}

float cornerDuration(float dotVal, float dLead, float dSide, float dTrail) {
    float isLead = step(0.5, dotVal);
    float isSide = step(-0.5, dotVal) * (1.0 - isLead);
    float d = mix(dTrail, dSide, isSide);
    return mix(d, dLead, isLead);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 base = texture(iChannel0, fragCoord.xy / iResolution.xy);
    vec4 outColor = base;

    vec2 p = nPos(fragCoord);

    vec4 cc = vec4(nPos(iCurrentCursor.xy), nSize(iCurrentCursor.zw));
    vec4 cp = vec4(nPos(iPreviousCursor.xy), nSize(iPreviousCursor.zw));

    vec2 centerCC = vec2(cc.x + cc.z * 0.5, cc.y - cc.w * 0.5);
    vec2 centerCP = vec2(cp.x + cp.z * 0.5, cp.y - cp.w * 0.5);

    vec2 move = centerCC - centerCP;
    float ax = abs(move.x);
    float ay = abs(move.y);
    float axisVertical = ay / (ax + ay + 1e-6);

    float lineLength = length(move);
    float distCellsX = lineLength / max(cc.z, 1e-4);

    float duration = mix(DURATION_SHORT, DURATION_LONG, clamp(distCellsX / 2.8, 0.0, 1.0));
    float trailSize = mix(TRAIL_SIZE_HORIZONTAL, TRAIL_SIZE_VERTICAL, axisVertical);

    float dt = iTime - iTimeCursorChange;
    float minDist = max(min(cc.z, cc.w) * MIN_DISTANCE_RATIO, nSize(vec2(0.5)).x);

    if (lineLength > minDist && dt >= 0.0 && dt < duration - 0.001) {
        vec2 cc_tl, cc_tr, cc_br, cc_bl;
        vec2 cp_tl, cp_tr, cp_br, cp_bl;
        cursorCorners(cc, cc_tl, cc_tr, cc_br, cc_bl);
        cursorCorners(cp, cp_tl, cp_tr, cp_br, cp_bl);

        vec2 s = sign(move);

        float dTrail = duration;
        float dLead = duration * (1.0 - trailSize);
        float dSide = (dLead + dTrail) * 0.5;

        float d_tl = cornerDuration(dot(vec2(-1.0,  1.0), s), dLead, dSide, dTrail);
        float d_tr = cornerDuration(dot(vec2( 1.0,  1.0), s), dLead, dSide, dTrail);
        float d_br = cornerDuration(dot(vec2( 1.0, -1.0), s), dLead, dSide, dTrail);
        float d_bl = cornerDuration(dot(vec2(-1.0, -1.0), s), dLead, dSide, dTrail);

        vec2 v_tl = mix(cp_tl, cc_tl, easeOutCubic(clamp(dt / max(d_tl, 1e-4), 0.0, 1.0)));
        vec2 v_tr = mix(cp_tr, cc_tr, easeOutCubic(clamp(dt / max(d_tr, 1e-4), 0.0, 1.0)));
        vec2 v_br = mix(cp_br, cc_br, easeOutCubic(clamp(dt / max(d_br, 1e-4), 0.0, 1.0)));
        vec2 v_bl = mix(cp_bl, cc_bl, easeOutCubic(clamp(dt / max(d_bl, 1e-4), 0.0, 1.0)));

        float trailSdf = sdConvexQuad(p, v_tl, v_tr, v_br, v_bl);
        float trailMask = aa(trailSdf, BLUR_PX);

        float fadeTail = pow(clamp(1.0 - dt / duration, 0.0, 1.0), 0.62);
        float shortHopBoost = (1.0 - axisVertical) * (1.0 - clamp(distCellsX / 2.2, 0.0, 1.0));

        vec4 trailColor = iCurrentCursorColor;
        float alpha = trailMask * trailColor.a * MAX_ALPHA * fadeTail * mix(1.0, 1.10, shortHopBoost);
        alpha = clamp(alpha, 0.0, 1.0);

        outColor = mix(outColor, vec4(trailColor.rgb, outColor.a), alpha);

        // Slight neon highlight: flashy but still controlled.
        vec3 glowColor = mix(trailColor.rgb, vec3(1.0), GLOW_WHITEN);
        float glowMask = trailMask * trailMask;
        float glowAlpha = glowMask * GLOW_ALPHA * trailColor.a * fadeTail;
        outColor.rgb = mix(outColor.rgb, glowColor, clamp(glowAlpha, 0.0, 1.0));

        // Keep the real cursor body clean above the trail.
        float currentSdf = sdRect(p, centerCC, cc.zw * 0.5);
        outColor = mix(outColor, base, step(currentSdf, 0.0));
    }

    fragColor = outColor;
}
