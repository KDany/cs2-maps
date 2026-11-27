"""Variant badges for Workshop cover images.

Small rounded icons in the top-right corner of a cover image that show which
variants of the map exist. One badge per map variant (a rainy night is one
badge, not "night" + "rain"). See docs/variant-badges.md.

Needs Python 3 and Pillow (pip install pillow).

Usage (from the repository root):
  python3 tools/variant_badges.py icons docs/images/badges          # write the badge PNGs (512 px)
  python3 tools/variant_badges.py stamp COVER OUT day,night_rain    # stamp badges onto a cover image
  python3 tools/variant_badges.py stamp COVER OUT day,night_rain --scale 0.09   # badge size as a share of the width
"""
import math, os, sys
from PIL import Image, ImageDraw, ImageFilter

SS = 4                      # supersampling for smooth edges
BG = (14, 19, 27, 215)      # badge background
WHITE = (240, 244, 248, 255)
VARIANTS = {
    #  name     accent colour       glyph
    'day':    ((242, 182, 50),  'sun'),
    'rain':   ((92, 160, 235),  'rain'),
    'winter': ((150, 215, 245), 'snow'),
    'night':  ((170, 150, 240), 'moon'),
    'night_rain': ((120, 140, 245), 'moon_rain'),   # a rainy night: one variant, one badge
    'xmas':   ((225, 70, 70),   'tree'),             # Christmas edition (decorations), not just snow
    'halloween': ((240, 130, 40), 'pumpkin'),        # Halloween edition
    'easter': ((130, 205, 120), 'egg'),               # Easter edition
    'night_xmas': ((225, 70, 70), 'tree_moon'),        # Christmas at night: the xmas badge with a moon
    'lunar_new_year': ((215, 170, 60), 'lantern'),   # Lunar New Year edition
    'day_rain': ((50, 180, 190), 'sun_rain'),         # a rainy day: the sun behind the rain cloud
}

def _sun(d, s):
    c = s / 2; r = s * 0.16
    d.ellipse([c-r, c-r, c+r, c+r], fill=WHITE)
    for i in range(8):
        a = math.radians(i * 45); w = s * 0.045
        r0, r1 = s * 0.24, s * 0.33
        x0, y0, x1, y1 = c + math.cos(a)*r0, c + math.sin(a)*r0, c + math.cos(a)*r1, c + math.sin(a)*r1
        d.line([(x0, y0), (x1, y1)], fill=WHITE, width=int(w))
        for x, y in ((x0, y0), (x1, y1)): d.ellipse([x-w/2, y-w/2, x+w/2, y+w/2], fill=WHITE)

def _cloud(d, s, cy):
    # three overlapping circles and a flat base
    for cx, cyo, r in ((0.36, 0.03, 0.13), (0.52, -0.04, 0.17), (0.66, 0.04, 0.12)):
        d.ellipse([s*(cx-r), s*(cy+cyo-r), s*(cx+r), s*(cy+cyo+r)], fill=WHITE)
    d.rounded_rectangle([s*0.23, s*(cy+0.02), s*0.78, s*(cy+0.16)], radius=s*0.07, fill=WHITE)

def _rain(d, s):
    _cloud(d, s, 0.40)
    w = s * 0.045
    for x in (0.36, 0.50, 0.64):
        x0, y0, x1, y1 = s*x, s*0.66, s*(x-0.05), s*0.80
        d.line([(x0, y0), (x1, y1)], fill=WHITE, width=int(w))
        for px, py in ((x0, y0), (x1, y1)): d.ellipse([px-w/2, py-w/2, px+w/2, py+w/2], fill=WHITE)

def _snow(d, s):
    c = s / 2; R = s * 0.30; w = s * 0.045
    for i in range(6):
        a = math.radians(i * 60 + 90)
        ex, ey = c + math.cos(a)*R, c - math.sin(a)*R
        d.line([(c, c), (ex, ey)], fill=WHITE, width=int(w))
        for t, l in ((0.55, 0.10), (0.80, 0.08)):           # side branches
            bx, by = c + math.cos(a)*R*t, c - math.sin(a)*R*t
            for da in (40, -40):
                b = a + math.radians(da)
                d.line([(bx, by), (bx + math.cos(b)*s*l, by - math.sin(b)*s*l)], fill=WHITE, width=int(w*0.85))
        d.ellipse([ex-w/2, ey-w/2, ex+w/2, ey+w/2], fill=WHITE)
    d.ellipse([c-w, c-w, c+w, c+w], fill=WHITE)

def _moon(d, s):
    c = s / 2; r = s * 0.27
    d.ellipse([c-r, c-r, c+r, c+r], fill=WHITE)
    o = s * 0.13
    d.ellipse([c-r+o, c-r-o*0.6, c+r+o, c+r-o*0.6], fill=(0, 0, 0, 0))

def _moon_rain(d, s):
    # crescent moon in the top right, the rain cloud in front of it, lower left
    cx, cy, r = s*0.66, s*0.30, s*0.17
    d.ellipse([cx-r, cy-r, cx+r, cy+r], fill=WHITE)
    o = s*0.085
    d.ellipse([cx-r+o, cy-r-o*0.7, cx+r+o, cy+r-o*0.7], fill=(0, 0, 0, 0))
    dx, cyc, g = -0.05, 0.50, s*0.03
    lobes = ((0.36, 0.03, 0.12), (0.51, -0.04, 0.15), (0.64, 0.04, 0.11))
    for cxx, cyo, rr in lobes:   # transparent gap around the cloud, so moon and cloud read as two shapes
        d.ellipse([s*(cxx+dx-rr)-g, s*(cyc+cyo-rr)-g, s*(cxx+dx+rr)+g, s*(cyc+cyo+rr)+g], fill=(0, 0, 0, 0))
    d.rounded_rectangle([s*(0.24+dx)-g, s*(cyc+0.02)-g, s*(0.75+dx)+g, s*(cyc+0.15)+g], radius=s*0.07, fill=(0, 0, 0, 0))
    for cxx, cyo, rr in lobes:
        d.ellipse([s*(cxx+dx-rr), s*(cyc+cyo-rr), s*(cxx+dx+rr), s*(cyc+cyo+rr)], fill=WHITE)
    d.rounded_rectangle([s*(0.24+dx), s*(cyc+0.02), s*(0.75+dx), s*(cyc+0.15)], radius=s*0.065, fill=WHITE)
    w = s * 0.045
    for x in (0.33, 0.46, 0.59):
        x0, y0, x1, y1 = s*x, s*0.72, s*(x-0.05), s*0.84
        d.line([(x0, y0), (x1, y1)], fill=WHITE, width=int(w))
        for px, py in ((x0, y0), (x1, y1)): d.ellipse([px-w/2, py-w/2, px+w/2, py+w/2], fill=WHITE)

def _tree(d, s):
    # three stacked tiers, a trunk and a star on top
    for top, bot, half in ((0.28, 0.46, 0.14), (0.39, 0.59, 0.19), (0.50, 0.72, 0.24)):
        d.polygon([(s*0.5, s*top), (s*(0.5+half), s*bot), (s*(0.5-half), s*bot)], fill=WHITE)
    d.rectangle([s*0.46, s*0.72, s*0.54, s*0.80], fill=WHITE)
    cx, cy, R, r = s*0.5, s*0.235, s*0.07, s*0.03
    pts = [(cx + (R if i % 2 == 0 else r)*math.sin(math.radians(i*36)), cy - (R if i % 2 == 0 else r)*math.cos(math.radians(i*36))) for i in range(10)]
    d.polygon(pts, fill=(242, 182, 50, 255))

def _pumpkin(d, s):
    # jack-o'-lantern: three overlapping lobes, a stem, and a carved face cut out of it
    T = (0, 0, 0, 0)
    for cx, rx in ((0.36, 0.17), (0.64, 0.17), (0.5, 0.19)):
        d.ellipse([s*(cx-rx), s*0.34, s*(cx+rx), s*0.80], fill=WHITE)
    d.polygon([(s*0.47, s*0.36), (s*0.53, s*0.36), (s*0.56, s*0.22), (s*0.50, s*0.20)], fill=WHITE)
    # lobe seams
    for x in (0.42, 0.58):   # short seams above the eyes and below the mouth only
        d.line([(s*x, s*0.37), (s*x, s*0.45)], fill=T, width=int(s*0.018))
        d.line([(s*x, s*0.755), (s*x, s*0.79)], fill=T, width=int(s*0.018))
    # eyes and nose
    d.polygon([(s*0.30, s*0.56), (s*0.42, s*0.56), (s*0.36, s*0.46)], fill=T)
    d.polygon([(s*0.58, s*0.56), (s*0.70, s*0.56), (s*0.64, s*0.46)], fill=T)
    d.polygon([(s*0.47, s*0.62), (s*0.53, s*0.62), (s*0.50, s*0.57)], fill=T)
    # zigzag mouth
    pts = [(0.28, 0.65), (0.35, 0.69), (0.40, 0.66), (0.45, 0.70), (0.50, 0.67), (0.55, 0.70), (0.60, 0.66),
           (0.65, 0.69), (0.72, 0.65), (0.66, 0.74), (0.58, 0.72), (0.50, 0.75), (0.42, 0.72), (0.34, 0.74)]
    d.polygon([(s*x, s*y) for x, y in pts], fill=T)

def _egg(d, s):
    # decorated Easter egg: egg outline (narrower at the top), a zigzag band and dots cut out of it
    T = (0, 0, 0, 0); cx, cy = 0.5, 0.53
    pts = []
    for i in range(120):
        t = 2*math.pi*i/120
        y = -math.cos(t)
        rx = 0.21 * (1 + 0.12*y)           # wider at the bottom (y grows downwards)
        pts.append((s*(cx + rx*math.sin(t)), s*(cy + 0.29*y)))
    d.polygon(pts, fill=WHITE)
    band = [(0.30, 0.52), (0.36, 0.47), (0.42, 0.52), (0.48, 0.47), (0.54, 0.52), (0.60, 0.47), (0.66, 0.52), (0.71, 0.48)]
    w = int(s*0.035)
    d.line([(s*x, s*y) for x, y in band], fill=T, width=w, joint='curve')
    d.line([(s*x, s*(y+0.12)) for x, y in band], fill=T, width=w, joint='curve')
    for x, y in ((0.42, 0.36), (0.58, 0.36), (0.50, 0.30), (0.39, 0.74), (0.50, 0.77), (0.61, 0.74)):
        r = s*0.025; d.ellipse([s*x-r, s*y-r, s*x+r, s*y+r], fill=T)

def _tree_moon(d, s):
    # the Christmas tree, shifted left, with a small crescent moon in the top right corner
    T = (0, 0, 0, 0); dx = -0.06
    for top, bot, half in ((0.28, 0.46, 0.14), (0.39, 0.59, 0.19), (0.50, 0.72, 0.24)):
        d.polygon([(s*(0.5+dx), s*top), (s*(0.5+dx+half), s*bot), (s*(0.5+dx-half), s*bot)], fill=WHITE)
    d.rectangle([s*(0.46+dx), s*0.72, s*(0.54+dx), s*0.80], fill=WHITE)
    cx, cy, R, r = s*(0.5+dx), s*0.235, s*0.07, s*0.03
    pts = [(cx + (R if i % 2 == 0 else r)*math.sin(math.radians(i*36)), cy - (R if i % 2 == 0 else r)*math.cos(math.radians(i*36))) for i in range(10)]
    d.polygon(pts, fill=(242, 182, 50, 255))
    mx, my, mr = s*0.73, s*0.27, s*0.10
    d.ellipse([mx-mr, my-mr, mx+mr, my+mr], fill=WHITE)
    o = s*0.05
    d.ellipse([mx-mr+o, my-mr-o*0.7, mx+mr+o, my+mr-o*0.7], fill=T)

def _lantern(d, s):
    # red paper lantern with gold caps, ribs cut out of it and a tassel
    T = (0, 0, 0, 0); RED = (220, 55, 55, 255); GOLD = (242, 182, 50, 255)
    d.line([(s*0.5, s*0.14), (s*0.5, s*0.24)], fill=WHITE, width=int(s*0.025))
    d.ellipse([s*0.26, s*0.27, s*0.74, s*0.71], fill=RED)
    for half in (0.12, 0.0):                           # vertical ribs: a narrow ellipse and the centre line
        if half: d.ellipse([s*(0.5-half), s*0.27, s*(0.5+half), s*0.71], outline=T, width=int(s*0.018))
        else: d.line([(s*0.5, s*0.27), (s*0.5, s*0.71)], fill=T, width=int(s*0.018))
    d.rounded_rectangle([s*0.36, s*0.23, s*0.64, s*0.30], radius=s*0.02, fill=GOLD)
    d.rounded_rectangle([s*0.36, s*0.68, s*0.64, s*0.75], radius=s*0.02, fill=GOLD)
    for x in (0.45, 0.50, 0.55):                       # tassel
        d.line([(s*0.5, s*0.75), (s*x, s*0.88)], fill=GOLD, width=int(s*0.022))

def _sun_rain(d, s):
    # the sun peeking out behind the top right of the rain cloud (the day version of _moon_rain)
    T = (0, 0, 0, 0)
    cx, cy, r = s*0.65, s*0.32, s*0.10
    d.ellipse([cx-r, cy-r, cx+r, cy+r], fill=WHITE)
    w = s*0.032
    for i in range(8):
        a = math.radians(i*45)
        x0, y0, x1, y1 = cx + math.cos(a)*s*0.14, cy + math.sin(a)*s*0.14, cx + math.cos(a)*s*0.185, cy + math.sin(a)*s*0.185
        d.line([(x0, y0), (x1, y1)], fill=WHITE, width=int(w))
        for x, y in ((x0, y0), (x1, y1)): d.ellipse([x-w/2, y-w/2, x+w/2, y+w/2], fill=WHITE)
    dx, cyc, g = -0.05, 0.50, s*0.03
    lobes = ((0.36, 0.03, 0.12), (0.51, -0.04, 0.15), (0.64, 0.04, 0.11))
    for cxx, cyo, rr in lobes:   # transparent gap around the cloud, so the sun and the cloud read as two shapes
        d.ellipse([s*(cxx+dx-rr)-g, s*(cyc+cyo-rr)-g, s*(cxx+dx+rr)+g, s*(cyc+cyo+rr)+g], fill=T)
    d.rounded_rectangle([s*(0.24+dx)-g, s*(cyc+0.02)-g, s*(0.75+dx)+g, s*(cyc+0.15)+g], radius=s*0.07, fill=T)
    for cxx, cyo, rr in lobes:
        d.ellipse([s*(cxx+dx-rr), s*(cyc+cyo-rr), s*(cxx+dx+rr), s*(cyc+cyo+rr)], fill=WHITE)
    d.rounded_rectangle([s*(0.24+dx), s*(cyc+0.02), s*(0.75+dx), s*(cyc+0.15)], radius=s*0.065, fill=WHITE)
    w = s * 0.045
    for x in (0.33, 0.46, 0.59):
        x0, y0, x1, y1 = s*x, s*0.72, s*(x-0.05), s*0.84
        d.line([(x0, y0), (x1, y1)], fill=WHITE, width=int(w))
        for px, py in ((x0, y0), (x1, y1)): d.ellipse([px-w/2, py-w/2, px+w/2, py+w/2], fill=WHITE)

GLYPHS = {'sun': _sun, 'rain': _rain, 'snow': _snow, 'moon': _moon, 'moon_rain': _moon_rain, 'tree': _tree, 'pumpkin': _pumpkin, 'egg': _egg, 'tree_moon': _tree_moon, 'lantern': _lantern, 'sun_rain': _sun_rain}

def badge(name, size=512):
    accent, glyph = VARIANTS[name]
    S = size * SS
    im = Image.new('RGBA', (S, S), (0, 0, 0, 0)); d = ImageDraw.Draw(im)
    pad = S * 0.04; rad = S * 0.22; bw = S * 0.035
    d.rounded_rectangle([pad, pad, S-pad, S-pad], radius=rad, fill=accent + (255,))
    d.rounded_rectangle([pad+bw, pad+bw, S-pad-bw, S-pad-bw], radius=rad-bw, fill=BG)
    g = Image.new('RGBA', (S, S), (0, 0, 0, 0)); GLYPHS[glyph](ImageDraw.Draw(g), S)
    im.alpha_composite(g)
    im = im.resize((size, size), Image.LANCZOS)
    # soft shadow so the badge reads on bright covers too
    sh = Image.new('RGBA', (size, size), (0, 0, 0, 0)); sh.putalpha(im.getchannel('A').point(lambda v: v*0.55))
    sh = sh.filter(ImageFilter.GaussianBlur(size*0.03))
    out = Image.new('RGBA', (size, size), (0, 0, 0, 0)); out.alpha_composite(sh, (int(size*0.01), int(size*0.02))); out.alpha_composite(im)
    return out

def stamp(cover_path, out_path, names, scale=0.075, margin=0.025, gap=0.012):
    cover = Image.open(cover_path).convert('RGBA'); W, H = cover.size
    b = round(W * scale)
    b = max(32, min(b, round(H * 0.28)))
    x = W - round(W * margin) - b; y = round(W * margin)
    for n in reversed(names):          # first variant ends up leftmost
        cover.alpha_composite(badge(n, b), (x, y)); x -= b + round(W * gap)
    cover.convert('RGB').save(out_path)

if __name__ == '__main__':
    if sys.argv[1] == 'icons':
        os.makedirs(sys.argv[2], exist_ok=True)
        for n in VARIANTS: badge(n).save(os.path.join(sys.argv[2], f'badge_{n}_512.png'))
    elif sys.argv[1] == 'stamp':
        scale = float(sys.argv[sys.argv.index('--scale') + 1]) if '--scale' in sys.argv else 0.075
        stamp(sys.argv[2], sys.argv[3], sys.argv[4].split(','), scale=scale)
