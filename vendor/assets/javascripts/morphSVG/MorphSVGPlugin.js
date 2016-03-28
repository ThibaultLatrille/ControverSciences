/*!
 * VERSION: 0.8.4
 * DATE: 2016-02-16
 * UPDATES AND DOCS AT: http://greensock.com
 *
 * @author: Jack Doyle, jack@greensock.com
 */
var _gsScope = "undefined" != typeof module && module.exports && "undefined" != typeof global ? global : this || window;
(_gsScope._gsQueue || (_gsScope._gsQueue = [])).push(function () {
    "use strict";
    var a = Math.PI / 180,
        b = 180 / Math.PI,
        c = /[achlmqstvz]|(-?\d*\.?\d*(?:e[\-+]?\d+)?)[0-9]/gi,
        d = /(?:(-|-=|\+=)?\d*\.?\d*(?:e[\-+]?\d+)?)[0-9]/gi,
        e = /[achlmqstvz]/gi,
        f = /\d+e[\-\+]\d+/gi,
        g = _gsScope._gsDefine.globals.TweenLite,
        l = function (a) {
            return !0;
        },
        m = function (a) {
        window.console && console.log(a)
    },
        n = function (b, c) {
        var g, h, i, j, k, l, d = Math.ceil(Math.abs(c) / 90), e = 0, f = [];
        for (b *= a, c *= a, g = c / d, h = 4 / 3 * Math.sin(g / 2) / (1 + Math.cos(g / 2)), l = 0; d > l; l++)i = b + l * g, j = Math.cos(i), k = Math.sin(i), f[e++] = j - h * k, f[e++] = k + h * j, i += g, j = Math.cos(i), k = Math.sin(i), f[e++] = j + h * k, f[e++] = k - h * j, f[e++] = j, f[e++] = k;
        return f
    }, o = function (c, d, e, f, g, h, i, j, k) {
        if (c !== j || d !== k) {
            e = Math.abs(e), f = Math.abs(f);
            var l = g % 360 * a, m = Math.cos(l), o = Math.sin(l), p = (c - j) / 2, q = (d - k) / 2, r = m * p + o * q, s = -o * p + m * q, t = e * e, u = f * f, v = r * r, w = s * s, x = v / t + w / u;
            x > 1 && (e = Math.sqrt(x) * e, f = Math.sqrt(x) * f, t = e * e, u = f * f);
            var y = h === i ? -1 : 1, z = (t * u - t * w - u * v) / (t * w + u * v);
            0 > z && (z = 0);
            var A = y * Math.sqrt(z), B = A * (e * s / f), C = A * -(f * r / e), D = (c + j) / 2, E = (d + k) / 2, F = D + (m * B - o * C), G = E + (o * B + m * C), H = (r - B) / e, I = (s - C) / f, J = (-r - B) / e, K = (-s - C) / f, L = Math.sqrt(H * H + I * I), M = H;
            y = 0 > I ? -1 : 1;
            var N = y * Math.acos(M / L) * b;
            L = Math.sqrt((H * H + I * I) * (J * J + K * K)), M = H * J + I * K, y = 0 > H * K - I * J ? -1 : 1;
            var O = y * Math.acos(M / L) * b;
            !i && O > 0 ? O -= 360 : i && 0 > O && (O += 360), O %= 360, N %= 360;
            var V, W, X, P = n(N, O), Q = m * e, R = o * e, S = o * -f, T = m * f, U = P.length - 2;
            for (V = 0; U > V; V += 2)W = P[V], X = P[V + 1], P[V] = W * Q + X * S + F, P[V + 1] = W * R + X * T + G;
            return P[P.length - 2] = j, P[P.length - 1] = k, P
        }
    }, p = function (a) {
        var k, l, n, p, q, r, s, t, u, v, w, x, y, b = (a + "").replace(f, function (a) {
                var b = +a;
                return 1e-4 > b && b > -1e-4 ? 0 : a
            }).match(c) || [], d = [], e = 0, g = 0, h = b.length, i = 2, j = 0;
        if (!a || !isNaN(b[0]) || isNaN(b[1]))return m("ERROR: malformed path data: " + a), d;
        for (k = 0; h > k; k++)if (y = q, isNaN(b[k]) ? (q = b[k].toUpperCase(), r = q !== b[k]) : k--, n = +b[k + 1], p = +b[k + 2], r && (n += e, p += g), 0 === k && (t = n, u = p), "M" === q)s && s.length < 8 && (d.length -= 1, i = 0), e = t = n, g = u = p, s = [n, p], j += i, i = 2, d.push(s), k += 2, q = "L"; else if ("C" === q)s || (s = [0, 0]), s[i++] = n, s[i++] = p, r || (e = g = 0), s[i++] = e + 1 * b[k + 3], s[i++] = g + 1 * b[k + 4], s[i++] = e += 1 * b[k + 5], s[i++] = g += 1 * b[k + 6], k += 6; else if ("S" === q)"C" === y || "S" === y ? (v = e - s[i - 4], w = g - s[i - 3], s[i++] = e + v, s[i++] = g + w) : (s[i++] = e, s[i++] = g), s[i++] = n, s[i++] = p, r || (e = g = 0), s[i++] = e += 1 * b[k + 3], s[i++] = g += 1 * b[k + 4], k += 4; else if ("Q" === q)v = n - e, w = p - g, s[i++] = e + 2 * v / 3, s[i++] = g + 2 * w / 3, r || (e = g = 0), e += 1 * b[k + 3], g += 1 * b[k + 4], v = n - e, w = p - g, s[i++] = e + 2 * v / 3, s[i++] = g + 2 * w / 3, s[i++] = e, s[i++] = g, k += 4; else if ("T" === q)v = e - s[i - 4], w = g - s[i - 3], s[i++] = e + v, s[i++] = g + w, v = e + 1.5 * v - n, w = g + 1.5 * w - p, s[i++] = n + 2 * v / 3, s[i++] = p + 2 * w / 3, s[i++] = e = n, s[i++] = g = p, k += 2; else if ("H" === q)p = g, s[i++] = e + (n - e) / 3, s[i++] = g + (p - g) / 3, s[i++] = e + 2 * (n - e) / 3, s[i++] = g + 2 * (p - g) / 3, s[i++] = e = n, s[i++] = p, k += 1; else if ("V" === q)p = n, n = e, r && (p += g - e), s[i++] = n, s[i++] = g + (p - g) / 3, s[i++] = n, s[i++] = g + 2 * (p - g) / 3, s[i++] = n, s[i++] = g = p, k += 1; else if ("L" === q || "Z" === q)"Z" === q && (n = t, p = u, s.closed = !0), ("L" === q || Math.abs(e - n) > .5 || Math.abs(g - p) > .5) && (s[i++] = e + (n - e) / 3, s[i++] = g + (p - g) / 3, s[i++] = e + 2 * (n - e) / 3, s[i++] = g + 2 * (p - g) / 3, s[i++] = n, s[i++] = p, "L" === q && (k += 2)), e = n, g = p; else if ("A" === q) {
            for (x = o(e, g, 1 * b[k + 1], 1 * b[k + 2], 1 * b[k + 3], 1 * b[k + 4], 1 * b[k + 5], (r ? e : 0) + 1 * b[k + 6], (r ? g : 0) + 1 * b[k + 7]), l = 0; l < x.length; l++)s[i++] = x[l];
            e = s[i - 2], g = s[i - 1], k += 7
        } else m("Error: malformed path data: " + a);
        return d.totalPoints = j + i, d
    }, q = function (a, b) {
        var g, h, i, j, k, l, m, n, o, p, q, r, s, t, c = 0, d = .999999, e = a.length, f = b / ((e - 2) / 6);
        for (s = 2; e > s; s += 6)for (c += f; c > d;)g = a[s - 2], h = a[s - 1], i = a[s], j = a[s + 1], k = a[s + 2], l = a[s + 3], m = a[s + 4], n = a[s + 5], t = 1 / (Math.floor(c) + 1), o = g + (i - g) * t, q = i + (k - i) * t, o += (q - o) * t, q += (k + (m - k) * t - q) * t, p = h + (j - h) * t, r = j + (l - j) * t, p += (r - p) * t, r += (l + (n - l) * t - r) * t, a.splice(s, 4, g + (i - g) * t, h + (j - h) * t, o, p, o + (q - o) * t, p + (r - p) * t, q, r, k + (m - k) * t, l + (n - l) * t), s += 6, e += 6, c--;
        return a
    }, r = function (a) {
        var e, f, g, h, b = "", c = a.length, d = 100;
        for (f = 0; c > f; f++) {
            for (h = a[f], b += "M" + h[0] + "," + h[1] + " C", e = h.length, g = 2; e > g; g++)b += (h[g++] * d | 0) / d + "," + (h[g++] * d | 0) / d + " " + (h[g++] * d | 0) / d + "," + (h[g++] * d | 0) / d + " " + (h[g++] * d | 0) / d + "," + (h[g] * d | 0) / d + " ";
            h.closed && (b += "z")
        }
        return b
    }, s = function (a) {
        for (var b = [], c = a.length - 1, d = 0; --c > -1;)b[d++] = a[c], b[d++] = a[c + 1], c--;
        for (c = 0; d > c; c++)a[c] = b[c];
        a.reversed = a.reversed ? !1 : !0
    }, t = function (a) {
        var e, b = a.length, c = 0, d = 0;
        for (e = 0; b > e; e++)c += a[e++], d += a[e];
        return [c / (b / 2), d / (b / 2)]
    }, u = function (a) {
        var g, h, i, b = a.length, c = a[0], d = c, e = a[1], f = e;
        for (i = 6; b > i; i += 6)g = a[i], h = a[i + 1], g > c ? c = g : d > g && (d = g), h > e ? e = h : f > h && (f = h);
        return a.centerX = (c + d) / 2, a.centerY = (e + f) / 2, a.size = (c - d) * (e - f)
    }, v = function (a) {
        for (var g, h, i, j, k, b = a.length, c = a[0][0], d = c, e = a[0][1], f = e; --b > -1;)for (k = a[b], g = k.length, j = 6; g > j; j += 6)h = k[j], i = k[j + 1], h > c ? c = h : d > h && (d = h), i > e ? e = i : f > i && (f = i);
        return a.centerX = (c + d) / 2, a.centerY = (e + f) / 2, a.size = (c - d) * (e - f)
    }, w = function (a, b) {
        return b.length - a.length
    }, x = function (a, b) {
        var c = a.size || u(a), d = b.size || u(b);
        return Math.abs(d - c) < (c + d) / 20 ? b.centerX - a.centerX || b.centerY - a.centerY : d - c
    }, y = function (a, b) {
        var f, g, c = a.slice(0), d = a.length, e = d - 2;
        for (b = 0 | b, f = 0; d > f; f++)g = (f + b) % e, a[f++] = c[g], a[f] = c[g + 1]
    }, z = function (a, b, c, d, e) {
        var i, j, k, l, f = a.length, g = 0, h = f - 2;
        for (c *= 6, j = 0; f > j; j += 6)i = (j + c) % h, l = a[i] - (b[j] - d), k = a[i + 1] - (b[j + 1] - e), g += Math.sqrt(k * k + l * l);
        return g
    }, A = function (a, b, c) {
        var k, l, m, d = a.length, e = t(a), f = t(b), g = f[0] - e[0], h = f[1] - e[1], i = z(a, b, 0, g, h), j = 0;
        for (m = 6; d > m; m += 6)l = z(a, b, m / 6, g, h), i > l && (i = l, j = m);
        if (c)for (k = a.slice(0), s(k), m = 6; d > m; m += 6)l = z(k, b, m / 6, g, h), i > l && (i = l, j = -m);
        return j / 6
    }, B = function (a, b, c) {
        for (var h, i, j, k, l, m, d = a.length, e = 99999999999, f = 0, g = 0; --d > -1;)for (h = a[d], m = h.length, l = 0; m > l; l += 6)i = h[l] - b, j = h[l + 1] - c, k = Math.sqrt(i * i + j * j), e > k && (e = k, f = h[l], g = h[l + 1]);
        return [f, g]
    }, C = function (a, b, c, d, e, f) {
        var m, n, o, p, q, g = b.length, h = 0, i = Math.min(a.size || u(a), b[c].size || u(b[c])) * d, j = 999999999999, k = a.centerX + e, l = a.centerY + f;
        for (n = c; g > n && (m = b[n].size || u(b[n]), !(i > m)); n++)o = b[n].centerX - k, p = b[n].centerY - l, q = Math.sqrt(o * o + p * p), j > q && (h = n, j = q);
        return q = b[h], b.splice(h, 1), q
    }, D = function (a, b, c, d) {
        var p, r, t, z, D, E, F, e = b.length - a.length, f = e > 0 ? b : a, g = e > 0 ? a : b, h = 0, i = "complexity" === d ? w : x, j = "position" === d ? 0 : "number" == typeof d ? d : .8, k = g.length, l = "object" == typeof c && c.push ? c.slice(0) : [c], n = "reverse" === l[0] || l[0] < 0, o = "log" === c;
        if (g[0]) {
            if (f.length > 1 && (a.sort(i), b.sort(i), E = f.size || v(f), E = g.size || v(g), E = f.centerX - g.centerX, F = f.centerY - g.centerY, i === x))for (k = 0; k < g.length; k++)f.splice(k, 0, C(g[k], f, k, j, E, F));
            if (e)for (0 > e && (e = -e), f[0].length > g[0].length && q(g[0], (f[0].length - g[0].length) / 6 | 0), k = g.length; e > h;)z = f[k].size || u(f[k]), t = B(g, f[k].centerX, f[k].centerY), z = t[0], D = t[1], g[k++] = [z, D, z, D, z, D, z, D], g.totalPoints += 8, h++;
            for (k = 0; k < a.length; k++)p = b[k], r = a[k], e = p.length - r.length, 0 > e ? q(p, -e / 6 | 0) : e > 0 && q(r, e / 6 | 0), n && !r.reversed && s(r), c = l[k] || 0 === l[k] ? l[k] : "auto", c && (r.closed || Math.abs(r[0] - r[r.length - 2]) < .5 && Math.abs(r[1] - r[r.length - 1]) < .5 ? "auto" === c || "log" === c ? (l[k] = c = A(r, p, 0 === k), 0 > c && (n = !0, s(r), c = -c), y(r, 6 * c)) : "reverse" !== c && (k && 0 > c && s(r), y(r, 6 * (0 > c ? -c : c))) : !n && ("auto" === c && Math.abs(p[0] - r[0]) + Math.abs(p[1] - r[1]) + Math.abs(p[p.length - 2] - r[r.length - 2]) + Math.abs(p[p.length - 1] - r[r.length - 1]) > Math.abs(p[0] - r[r.length - 2]) + Math.abs(p[1] - r[r.length - 1]) + Math.abs(p[p.length - 2] - r[0]) + Math.abs(p[p.length - 1] - r[1]) || c % 2) ? (s(r), l[k] = -1, n = !0) : "auto" === c ? l[k] = 0 : "reverse" === c && (l[k] = -1), r.closed !== p.closed && (r.closed = p.closed = !1));
            return o && m("shapeIndex:[" + l.join(",") + "]"), l
        }
    }, E = function (a, b, c, d) {
        var e = p(a[0]), f = p(a[1]);
        D(e, f, b || 0 === b ? b : "auto", c) && (a[0] = r(e), a[1] = r(f), ("log" === d || d === !0) && m('precompile:["' + a[0] + '","' + a[1] + '"]'))
    }, F = function (a, b, c) {
        return b || c || a || 0 === a ? function (d) {
            E(d, a, b, c)
        } : E
    }, G = function (a, b) {
        if (!b)return a;
        var g, h, i, c = a.match(d) || [], e = c.length, f = "";
        for ("reverse" === b ? (h = e - 1, g = -2) : (h = (2 * (parseInt(b, 10) || 0) + 1 + 100 * e) % e, g = 2), i = 0; e > i; i += 2)f += c[h - 1] + "," + c[h] + " ", h = (h + g) % e;
        return f
    }, H = function (a, b) {
        var h, i, j, k, l, m, n, c = 0, d = parseFloat(a[0]), e = parseFloat(a[1]), f = d + "," + e + " ", g = .999999;
        for (j = a.length, h = .5 * b / (.5 * j - 1), i = 0; j - 2 > i; i += 2) {
            if (c += h, m = parseFloat(a[i + 2]), n = parseFloat(a[i + 3]), c > g)for (l = 1 / (Math.floor(c) + 1), k = 1; c > g;)f += (d + (m - d) * l * k).toFixed(2) + "," + (e + (n - e) * l * k).toFixed(2) + " ", c--, k++;
            f += m + "," + n + " ", d = m, e = n
        }
        return f
    }, I = function (a) {
        var b = a[0].match(d) || [], c = a[1].match(d) || [], e = c.length - b.length;
        e > 0 ? a[0] = H(b, e) : a[1] = H(c, -e)
    }, J = function (a) {
        return isNaN(a) ? I : function (b) {
            I(b), b[1] = G(b[1], parseInt(a, 10))
        }
    }, K = function (a, b) {
        var c = document.createElementNS("http://www.w3.org/2000/svg", "path"), d = Array.prototype.slice.call(a.attributes), e = d.length;
        for (b = "," + b + ","; --e > -1;)-1 === b.indexOf("," + d[e].nodeName + ",") && c.setAttributeNS(null, d[e].nodeName, d[e].nodeValue);
        return c
    }, L = function (a, b) {
        var f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, c = a.tagName.toLowerCase(), e = .552284749831;
        return "path" !== c && a.getBBox ? (k = K(a, "x,y,width,height,cx,cy,rx,ry,r,x1,x2,y1,y2,points"), "rect" === c ? (i = +a.getAttribute("rx") || 0, j = +a.getAttribute("ry") || 0, g = +a.getAttribute("x") || 0, h = +a.getAttribute("y") || 0, o = (+a.getAttribute("width") || 0) - 2 * i, p = (+a.getAttribute("height") || 0) - 2 * j, i || j ? (q = g + i * (1 - e), r = g + i, s = r + o, t = s + i * e, u = s + i, v = h + j * (1 - e), w = h + j, x = w + p, y = x + j * e, z = x + j, f = "M" + u + "," + w + " V" + x + " C" + [u, y, t, z, s, z, s - (s - r) / 3, z, r + (s - r) / 3, z, r, z, q, z, g, y, g, x, g, x - (x - w) / 3, g, w + (x - w) / 3, g, w, g, v, q, h, r, h, r + (s - r) / 3, h, s - (s - r) / 3, h, s, h, t, h, u, v, u, w].join(",") + "z") : f = "M" + (g + o) + "," + h + " v" + p + " h" + -o + " v" + -p + " h" + o + "z") : "circle" === c || "ellipse" === c ? ("circle" === c ? (i = j = +a.getAttribute("r") || 0, m = i * e) : (i = +a.getAttribute("rx") || 0, j = +a.getAttribute("ry") || 0, m = j * e), g = +a.getAttribute("cx") || 0, h = +a.getAttribute("cy") || 0, l = i * e, f = "M" + (g + i) + "," + h + " C" + [g + i, h + m, g + l, h + j, g, h + j, g - l, h + j, g - i, h + m, g - i, h, g - i, h - m, g - l, h - j, g, h - j, g + l, h - j, g + i, h - m, g + i, h].join(",") + "z") : "line" === c ? f = "M" + a.getAttribute("x1") + "," + a.getAttribute("y1") + " L" + a.getAttribute("x2") + "," + a.getAttribute("y2") : ("polyline" === c || "polygon" === c) && (n = (a.getAttribute("points") + "").match(d) || [], g = n.shift(), h = n.shift(), f = "M" + g + "," + h + " L" + n.join(","), "polygon" === c && (f += "," + g + "," + h + "z")), k.setAttribute("d", f), b && a.parentNode && (a.parentNode.insertBefore(k, a), a.parentNode.removeChild(a)), k) : a
    }, M = function (a, b, c) {
        var f, h, e = "string" == typeof a;
        return (!e || (a.match(d) || []).length < 3) && (f = e ? g.selector(a) : a && a[0] ? a : [a], f && f[0] ? (f = f[0], h = f.nodeName.toUpperCase(), b && "PATH" !== h && (f = L(f, !1), h = "PATH"), a = f.getAttribute("PATH" === h ? "d" : "points") || "", f === c && (a = f.getAttributeNS(null, "data-original") || a)) : (m("WARNING: invalid morph to: " + a), a = !1)), a
    }, N = "Use MorphSVGPlugin.convertToPath(elementOrSelectorText) to convert to a path before morphing.", O = _gsScope._gsDefine.plugin({
        propName: "morphSVG",
        API: 2,
        global: !0,
        version: "0.8.4",
        init: function (a, b, c) {
            var d, f, g, n, o;
            return "function" != typeof a.setAttribute ? !1 : l ? (d = a.nodeName.toUpperCase(), o = "POLYLINE" === d || "POLYGON" === d, "PATH" === d || o ? (f = "PATH" === d ? "d" : "points", ("string" == typeof b || b.getBBox || b[0]) && (b = {shape: b}), n = M(b.shape || b.d || b.points || "", "d" === f, a), o && e.test(n) ? (m("WARNING: a <" + d + "> cannot accept path data. " + N), !1) : (n && (this._target = a, a.getAttributeNS(null, "data-original") || a.setAttributeNS(null, "data-original", a.getAttribute(f)), g = this._addTween(a, "setAttribute", a.getAttribute(f) + "", n + "", "morphSVG", !1, f, "object" == typeof b.precompile ? function (a) {
                a[0] = b.precompile[0], a[1] = b.precompile[1]
            } : "d" === f ? F(b.shapeIndex, b.map || O.defaultMap, b.precompile) : J(b.shapeIndex)), g && (this._overwriteProps.push("morphSVG"), g.end = n, g.endProp = f)), l)) : (m("WARNING: cannot morph a <" + d + "> SVG element. " + N), !1)) : (window.location.href = "http://" + j + k + "?plugin=" + i + "&source=" + h, !1)
        },
        set: function (a) {
            var b;
            if (this._super.setRatio.call(this, a), 1 === a)for (b = this._firstPT; b;)b.end && this._target.setAttribute(b.endProp, b.end), b = b._next
        }
    });
    O.pathFilter = E, O.pointsFilter = I, O.subdivideRawBezier = q, O.defaultMap = "size", O.pathDataToRawBezier = function (a) {
        return p(M(a, !0))
    }, O.equalizeSegmentQuantity = D, O.convertToPath = function (a, b) {
        "string" == typeof a && (a = g.selector(a));
        for (var c = a && 0 !== a.length ? a.length && a[0] && a[0].nodeType ? Array.prototype.slice.call(a, 0) : [a] : [], d = c.length; --d > -1;)c[d] = L(c[d], b !== !1);
        return c
    }, O.pathDataToBezier = function (a, b) {
        var e, f, h, i, j, k, l, m, c = p(M(a, !0))[0] || [], d = 0;
        if (b = b || {}, m = b.align || b.relative, i = b.matrix || [1, 0, 0, 1, 0, 0], j = b.offsetX || 0, k = b.offsetY || 0, "relative" === m || m === !0 ? (j -= c[0] * i[0] + c[1] * i[2], k -= c[0] * i[1] + c[1] * i[3], d = "+=") : (j += i[4], k += i[5], m && (m = "string" == typeof m ? g.selector(m) : m && m[0] ? m : [m], m && m[0] && (l = m[0].getBBox() || {
                    x: 0,
                    y: 0
                }, j -= l.x, k -= l.y))), e = [], h = c.length, i)for (f = 0; h > f; f += 2)e.push({
            x: d + (c[f] * i[0] + c[f + 1] * i[2] + j),
            y: d + (c[f] * i[1] + c[f + 1] * i[3] + k)
        }); else for (f = 0; h > f; f += 2)e.push({x: d + (c[f] + j), y: d + (c[f + 1] + k)});
        return e
    }
}), _gsScope._gsDefine && _gsScope._gsQueue.pop()();