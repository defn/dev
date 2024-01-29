"use strict";
(() => {
  var Ge = Object.create;
  var Me = Object.defineProperty;
  var Qe = Object.getOwnPropertyDescriptor;
  var Ze = Object.getOwnPropertyNames;
  var Ke = Object.getPrototypeOf,
    et = Object.prototype.hasOwnProperty;
  var me = (r, f) => () => (
    f || r((f = { exports: {} }).exports, f), f.exports
  );
  var tt = (r, f, u, o) => {
    if ((f && typeof f == "object") || typeof f == "function")
      for (let a of Ze(f))
        !et.call(r, a) &&
          a !== u &&
          Me(r, a, {
            get: () => f[a],
            enumerable: !(o = Qe(f, a)) || o.enumerable,
          });
    return r;
  };
  var be = (r, f, u) => (
    (u = r != null ? Ge(Ke(r)) : {}),
    tt(
      f || !r || !r.__esModule
        ? Me(u, "default", { value: r, enumerable: !0 })
        : u,
      r,
    )
  );
  var Le = me((lt, pe) => {
    (function (r, f) {
      var u = f(r, r.document, Date);
      (r.lazySizes = u),
        typeof pe == "object" && pe.exports && (pe.exports = u);
    })(typeof window != "undefined" ? window : {}, function (f, u, o) {
      "use strict";
      var a, e;
      if (
        ((function () {
          var p,
            v = {
              lazyClass: "lazyload",
              loadedClass: "lazyloaded",
              loadingClass: "lazyloading",
              preloadClass: "lazypreload",
              errorClass: "lazyerror",
              autosizesClass: "lazyautosizes",
              fastLoadedClass: "ls-is-cached",
              iframeLoadMode: 0,
              srcAttr: "data-src",
              srcsetAttr: "data-srcset",
              sizesAttr: "data-sizes",
              minSize: 40,
              customMedia: {},
              init: !0,
              expFactor: 1.5,
              hFac: 0.8,
              loadMode: 2,
              loadHidden: !0,
              ricTimeout: 0,
              throttleDelay: 125,
            };
          e = f.lazySizesConfig || f.lazysizesConfig || {};
          for (p in v) p in e || (e[p] = v[p]);
        })(),
        !u || !u.getElementsByClassName)
      )
        return { init: function () {}, cfg: e, noSupport: !0 };
      var y = u.documentElement,
        h = f.HTMLPictureElement,
        b = "addEventListener",
        L = "getAttribute",
        z = f[b].bind(f),
        A = f.setTimeout,
        m = f.requestAnimationFrame || A,
        S = f.requestIdleCallback,
        g = /^picture$/i,
        T = ["load", "error", "lazyincluded", "_lazyloaded"],
        w = {},
        j = Array.prototype.forEach,
        W = function (p, v) {
          return (
            w[v] || (w[v] = new RegExp("(\\s|^)" + v + "(\\s|$)")),
            w[v].test(p[L]("class") || "") && w[v]
          );
        },
        H = function (p, v) {
          W(p, v) ||
            p.setAttribute("class", (p[L]("class") || "").trim() + " " + v);
        },
        K = function (p, v) {
          var C;
          (C = W(p, v)) &&
            p.setAttribute("class", (p[L]("class") || "").replace(C, " "));
        },
        ee = function (p, v, C) {
          var l = C ? b : "removeEventListener";
          C && ee(p, v),
            T.forEach(function (n) {
              p[l](n, v);
            });
        },
        F = function (p, v, C, l, n) {
          var t = u.createEvent("Event");
          return (
            C || (C = {}),
            (C.instance = a),
            t.initEvent(v, !l, !n),
            (t.detail = C),
            p.dispatchEvent(t),
            t
          );
        },
        te = function (p, v) {
          var C;
          !h && (C = f.picturefill || e.pf)
            ? (v && v.src && !p[L]("srcset") && p.setAttribute("srcset", v.src),
              C({ reevaluate: !0, elements: [p] }))
            : v && v.src && (p.src = v.src);
        },
        $ = function (p, v) {
          return (getComputedStyle(p, null) || {})[v];
        },
        ue = function (p, v, C) {
          for (
            C = C || p.offsetWidth;
            C < e.minSize && v && !p._lazysizesWidth;

          )
            (C = v.offsetWidth), (v = v.parentNode);
          return C;
        },
        X = (function () {
          var p,
            v,
            C = [],
            l = [],
            n = C,
            t = function () {
              var s = n;
              for (n = C.length ? l : C, p = !0, v = !1; s.length; )
                s.shift()();
              p = !1;
            },
            c = function (s, d) {
              p && !d
                ? s.apply(this, arguments)
                : (n.push(s), v || ((v = !0), (u.hidden ? A : m)(t)));
            };
          return (c._lsFlush = t), c;
        })(),
        V = function (p, v) {
          return v
            ? function () {
                X(p);
              }
            : function () {
                var C = this,
                  l = arguments;
                X(function () {
                  p.apply(C, l);
                });
              };
        },
        he = function (p) {
          var v,
            C = 0,
            l = e.throttleDelay,
            n = e.ricTimeout,
            t = function () {
              (v = !1), (C = o.now()), p();
            },
            c =
              S && n > 49
                ? function () {
                    S(t, { timeout: n }),
                      n !== e.ricTimeout && (n = e.ricTimeout);
                  }
                : V(function () {
                    A(t);
                  }, !0);
          return function (s) {
            var d;
            (s = s === !0) && (n = 33),
              !v &&
                ((v = !0),
                (d = l - (o.now() - C)),
                d < 0 && (d = 0),
                s || d < 9 ? c() : A(c, d));
          };
        },
        ce = function (p) {
          var v,
            C,
            l = 99,
            n = function () {
              (v = null), p();
            },
            t = function () {
              var c = o.now() - C;
              c < l ? A(t, l - c) : (S || n)(n);
            };
          return function () {
            (C = o.now()), v || (v = A(t, l));
          };
        },
        le = (function () {
          var p,
            v,
            C,
            l,
            n,
            t,
            c,
            s,
            d,
            x,
            k,
            Y,
            We = /^img$/i,
            De = /^iframe$/i,
            Be = "onscroll" in f && !/(gle|ing)bot/.test(navigator.userAgent),
            Ue = 0,
            ne = 0,
            I = 0,
            Q = -1,
            ze = function (i) {
              I--, (!i || I < 0 || !i.target) && (I = 0);
            },
            Ae = function (i) {
              return (
                Y == null && (Y = $(u.body, "visibility") == "hidden"),
                Y ||
                  !(
                    $(i.parentNode, "visibility") == "hidden" &&
                    $(i, "visibility") == "hidden"
                  )
              );
            },
            qe = function (i, E) {
              var _,
                M = i,
                P = Ae(i);
              for (
                s -= E, k += E, d -= E, x += E;
                P && (M = M.offsetParent) && M != u.body && M != y;

              )
                (P = ($(M, "opacity") || 1) > 0),
                  P &&
                    $(M, "overflow") != "visible" &&
                    ((_ = M.getBoundingClientRect()),
                    (P =
                      x > _.left &&
                      d < _.right &&
                      k > _.top - 1 &&
                      s < _.bottom + 1));
              return P;
            },
            Te = function () {
              var i,
                E,
                _,
                M,
                P,
                O,
                B,
                U,
                J,
                q,
                G,
                Z,
                R = a.elements;
              if ((l = e.loadMode) && I < 8 && (i = R.length)) {
                for (E = 0, Q++; E < i; E++)
                  if (!(!R[E] || R[E]._lazyRace)) {
                    if (!Be || (a.prematureUnveil && a.prematureUnveil(R[E]))) {
                      ie(R[E]);
                      continue;
                    }
                    if (
                      ((!(U = R[E][L]("data-expand")) || !(O = U * 1)) &&
                        (O = ne),
                      q ||
                        ((q =
                          !e.expand || e.expand < 1
                            ? y.clientHeight > 500 && y.clientWidth > 500
                              ? 500
                              : 370
                            : e.expand),
                        (a._defEx = q),
                        (G = q * e.expFactor),
                        (Z = e.hFac),
                        (Y = null),
                        ne < G && I < 1 && Q > 2 && l > 2 && !u.hidden
                          ? ((ne = G), (Q = 0))
                          : l > 1 && Q > 1 && I < 6
                            ? (ne = q)
                            : (ne = Ue)),
                      J !== O &&
                        ((t = innerWidth + O * Z),
                        (c = innerHeight + O),
                        (B = O * -1),
                        (J = O)),
                      (_ = R[E].getBoundingClientRect()),
                      (k = _.bottom) >= B &&
                        (s = _.top) <= c &&
                        (x = _.right) >= B * Z &&
                        (d = _.left) <= t &&
                        (k || x || d || s) &&
                        (e.loadHidden || Ae(R[E])) &&
                        ((v && I < 3 && !U && (l < 3 || Q < 4)) || qe(R[E], O)))
                    ) {
                      if ((ie(R[E]), (P = !0), I > 9)) break;
                    } else
                      !P &&
                        v &&
                        !M &&
                        I < 4 &&
                        Q < 4 &&
                        l > 2 &&
                        (p[0] || e.preloadAfterLoad) &&
                        (p[0] ||
                          (!U &&
                            (k ||
                              x ||
                              d ||
                              s ||
                              R[E][L](e.sizesAttr) != "auto"))) &&
                        (M = p[0] || R[E]);
                  }
                M && !P && ie(M);
              }
            },
            N = he(Te),
            _e = function (i) {
              var E = i.target;
              if (E._lazyCache) {
                delete E._lazyCache;
                return;
              }
              ze(i),
                H(E, e.loadedClass),
                K(E, e.loadingClass),
                ee(E, xe),
                F(E, "lazyloaded");
            },
            $e = V(_e),
            xe = function (i) {
              $e({ target: i.target });
            },
            Ve = function (i, E) {
              var _ = i.getAttribute("data-load-mode") || e.iframeLoadMode;
              _ == 0
                ? i.contentWindow.location.replace(E)
                : _ == 1 && (i.src = E);
            },
            Ye = function (i) {
              var E,
                _ = i[L](e.srcsetAttr);
              (E = e.customMedia[i[L]("data-media") || i[L]("media")]) &&
                i.setAttribute("media", E),
                _ && i.setAttribute("srcset", _);
            },
            Je = V(function (i, E, _, M, P) {
              var O, B, U, J, q, G;
              (q = F(i, "lazybeforeunveil", E)).defaultPrevented ||
                (M && (_ ? H(i, e.autosizesClass) : i.setAttribute("sizes", M)),
                (B = i[L](e.srcsetAttr)),
                (O = i[L](e.srcAttr)),
                P && ((U = i.parentNode), (J = U && g.test(U.nodeName || ""))),
                (G = E.firesLoad || ("src" in i && (B || O || J))),
                (q = { target: i }),
                H(i, e.loadingClass),
                G && (clearTimeout(C), (C = A(ze, 2500)), ee(i, xe, !0)),
                J && j.call(U.getElementsByTagName("source"), Ye),
                B
                  ? i.setAttribute("srcset", B)
                  : O && !J && (De.test(i.nodeName) ? Ve(i, O) : (i.src = O)),
                P && (B || J) && te(i, { src: O })),
                i._lazyRace && delete i._lazyRace,
                K(i, e.lazyClass),
                X(function () {
                  var Z = i.complete && i.naturalWidth > 1;
                  (!G || Z) &&
                    (Z && H(i, e.fastLoadedClass),
                    _e(q),
                    (i._lazyCache = !0),
                    A(function () {
                      "_lazyCache" in i && delete i._lazyCache;
                    }, 9)),
                    i.loading == "lazy" && I--;
                }, !0);
            }),
            ie = function (i) {
              if (!i._lazyRace) {
                var E,
                  _ = We.test(i.nodeName),
                  M = _ && (i[L](e.sizesAttr) || i[L]("sizes")),
                  P = M == "auto";
                ((P || !v) &&
                  _ &&
                  (i[L]("src") || i.srcset) &&
                  !i.complete &&
                  !W(i, e.errorClass) &&
                  W(i, e.lazyClass)) ||
                  ((E = F(i, "lazyunveilread").detail),
                  P && re.updateElem(i, !0, i.offsetWidth),
                  (i._lazyRace = !0),
                  I++,
                  Je(i, E, P, M, _));
              }
            },
            Xe = ce(function () {
              (e.loadMode = 3), N();
            }),
            we = function () {
              e.loadMode == 3 && (e.loadMode = 2), Xe();
            },
            fe = function () {
              if (!v) {
                if (o.now() - n < 999) {
                  A(fe, 999);
                  return;
                }
                (v = !0), (e.loadMode = 3), N(), z("scroll", we, !0);
              }
            };
          return {
            _: function () {
              (n = o.now()),
                (a.elements = u.getElementsByClassName(e.lazyClass)),
                (p = u.getElementsByClassName(
                  e.lazyClass + " " + e.preloadClass,
                )),
                z("scroll", N, !0),
                z("resize", N, !0),
                z("pageshow", function (i) {
                  if (i.persisted) {
                    var E = u.querySelectorAll("." + e.loadingClass);
                    E.length &&
                      E.forEach &&
                      m(function () {
                        E.forEach(function (_) {
                          _.complete && ie(_);
                        });
                      });
                  }
                }),
                f.MutationObserver
                  ? new MutationObserver(N).observe(y, {
                      childList: !0,
                      subtree: !0,
                      attributes: !0,
                    })
                  : (y[b]("DOMNodeInserted", N, !0),
                    y[b]("DOMAttrModified", N, !0),
                    setInterval(N, 999)),
                z("hashchange", N, !0),
                [
                  "focus",
                  "mouseover",
                  "click",
                  "load",
                  "transitionend",
                  "animationend",
                ].forEach(function (i) {
                  u[b](i, N, !0);
                }),
                /d$|^c/.test(u.readyState)
                  ? fe()
                  : (z("load", fe), u[b]("DOMContentLoaded", N), A(fe, 2e4)),
                a.elements.length ? (Te(), X._lsFlush()) : N();
            },
            checkElems: N,
            unveil: ie,
            _aLSL: we,
          };
        })(),
        re = (function () {
          var p,
            v = V(function (t, c, s, d) {
              var x, k, Y;
              if (
                ((t._lazysizesWidth = d),
                (d += "px"),
                t.setAttribute("sizes", d),
                g.test(c.nodeName || ""))
              )
                for (
                  x = c.getElementsByTagName("source"), k = 0, Y = x.length;
                  k < Y;
                  k++
                )
                  x[k].setAttribute("sizes", d);
              s.detail.dataAttr || te(t, s.detail);
            }),
            C = function (t, c, s) {
              var d,
                x = t.parentNode;
              x &&
                ((s = ue(t, x, s)),
                (d = F(t, "lazybeforesizes", { width: s, dataAttr: !!c })),
                d.defaultPrevented ||
                  ((s = d.detail.width),
                  s && s !== t._lazysizesWidth && v(t, x, d, s)));
            },
            l = function () {
              var t,
                c = p.length;
              if (c) for (t = 0; t < c; t++) C(p[t]);
            },
            n = ce(l);
          return {
            _: function () {
              (p = u.getElementsByClassName(e.autosizesClass)), z("resize", n);
            },
            checkElems: n,
            updateElem: C,
          };
        })(),
        D = function () {
          !D.i && u.getElementsByClassName && ((D.i = !0), re._(), le._());
        };
      return (
        A(function () {
          e.init && D();
        }),
        (a = {
          cfg: e,
          autoSizer: re,
          loader: le,
          init: D,
          uP: te,
          aC: H,
          rC: K,
          hC: W,
          fire: F,
          gW: ue,
          rAF: X,
        }),
        a
      );
    });
  });
  var Re = me((ft, Ce) => {
    (function (r, f) {
      var u = function () {
        f(r.lazySizes), r.removeEventListener("lazyunveilread", u, !0);
      };
      (f = f.bind(null, r, r.document)),
        typeof Ce == "object" && Ce.exports
          ? f(Le())
          : typeof define == "function" && define.amd
            ? define(["lazysizes"], f)
            : r.lazySizes
              ? u()
              : r.addEventListener("lazyunveilread", u, !0);
    })(window, function (r, f, u) {
      "use strict";
      var o = "loading" in HTMLImageElement.prototype,
        a = "loading" in HTMLIFrameElement.prototype,
        e = !1,
        y = u.prematureUnveil,
        h = u.cfg,
        b = {
          focus: 1,
          mouseover: 1,
          click: 1,
          load: 1,
          transitionend: 1,
          animationend: 1,
          scroll: 1,
          resize: 1,
        };
      if (
        (h.nativeLoading || (h.nativeLoading = {}),
        !r.addEventListener || !r.MutationObserver || (!o && !a))
      )
        return;
      function L() {
        var A = u.loader,
          m = A.checkElems,
          S = function () {
            setTimeout(function () {
              r.removeEventListener("scroll", A._aLSL, !0);
            }, 1e3);
          },
          g =
            typeof h.nativeLoading.disableListeners == "object"
              ? h.nativeLoading.disableListeners
              : b;
        g.scroll &&
          (r.addEventListener("load", S),
          S(),
          r.removeEventListener("scroll", m, !0)),
          g.resize && r.removeEventListener("resize", m, !0),
          Object.keys(g).forEach(function (T) {
            g[T] && f.removeEventListener(T, m, !0);
          });
      }
      function z() {
        e ||
          ((e = !0),
          o &&
            a &&
            h.nativeLoading.disableListeners &&
            (h.nativeLoading.disableListeners === !0 &&
              (h.nativeLoading.setLoadingAttribute = !0),
            L()),
          h.nativeLoading.setLoadingAttribute &&
            r.addEventListener(
              "lazybeforeunveil",
              function (A) {
                var m = A.target;
                "loading" in m &&
                  !m.getAttribute("loading") &&
                  m.setAttribute("loading", "lazy");
              },
              !0,
            ));
      }
      u.prematureUnveil = function (m) {
        if (
          (e || z(),
          "loading" in m &&
            (h.nativeLoading.setLoadingAttribute ||
              m.getAttribute("loading")) &&
            (m.getAttribute("data-sizes") != "auto" || m.offsetWidth))
        )
          return !0;
        if (y) return y(m);
      };
    });
  });
  var Ie = me((ae, Se) => {
    (function (f, u) {
      typeof ae == "object" && typeof Se == "object"
        ? (Se.exports = u())
        : typeof define == "function" && define.amd
          ? define([], u)
          : typeof ae == "object"
            ? (ae.ClipboardJS = u())
            : (f.ClipboardJS = u());
    })(ae, function () {
      return (function () {
        var r = {
            686: function (o, a, e) {
              "use strict";
              e.d(a, {
                default: function () {
                  return C;
                },
              });
              var y = e(279),
                h = e.n(y),
                b = e(370),
                L = e.n(b),
                z = e(817),
                A = e.n(z);
              function m(l) {
                try {
                  return document.execCommand(l);
                } catch (n) {
                  return !1;
                }
              }
              var S = function (n) {
                  var t = A()(n);
                  return m("cut"), t;
                },
                g = S;
              function T(l) {
                var n = document.documentElement.getAttribute("dir") === "rtl",
                  t = document.createElement("textarea");
                (t.style.fontSize = "12pt"),
                  (t.style.border = "0"),
                  (t.style.padding = "0"),
                  (t.style.margin = "0"),
                  (t.style.position = "absolute"),
                  (t.style[n ? "right" : "left"] = "-9999px");
                var c =
                  window.pageYOffset || document.documentElement.scrollTop;
                return (
                  (t.style.top = "".concat(c, "px")),
                  t.setAttribute("readonly", ""),
                  (t.value = l),
                  t
                );
              }
              var w = function (n, t) {
                  var c = T(n);
                  t.container.appendChild(c);
                  var s = A()(c);
                  return m("copy"), c.remove(), s;
                },
                j = function (n) {
                  var t =
                      arguments.length > 1 && arguments[1] !== void 0
                        ? arguments[1]
                        : { container: document.body },
                    c = "";
                  return (
                    typeof n == "string"
                      ? (c = w(n, t))
                      : n instanceof HTMLInputElement &&
                          ![
                            "text",
                            "search",
                            "url",
                            "tel",
                            "password",
                          ].includes(n == null ? void 0 : n.type)
                        ? (c = w(n.value, t))
                        : ((c = A()(n)), m("copy")),
                    c
                  );
                },
                W = j;
              function H(l) {
                return (
                  typeof Symbol == "function" &&
                  typeof Symbol.iterator == "symbol"
                    ? (H = function (t) {
                        return typeof t;
                      })
                    : (H = function (t) {
                        return t &&
                          typeof Symbol == "function" &&
                          t.constructor === Symbol &&
                          t !== Symbol.prototype
                          ? "symbol"
                          : typeof t;
                      }),
                  H(l)
                );
              }
              var K = function () {
                  var n =
                      arguments.length > 0 && arguments[0] !== void 0
                        ? arguments[0]
                        : {},
                    t = n.action,
                    c = t === void 0 ? "copy" : t,
                    s = n.container,
                    d = n.target,
                    x = n.text;
                  if (c !== "copy" && c !== "cut")
                    throw new Error(
                      'Invalid "action" value, use either "copy" or "cut"',
                    );
                  if (d !== void 0)
                    if (d && H(d) === "object" && d.nodeType === 1) {
                      if (c === "copy" && d.hasAttribute("disabled"))
                        throw new Error(
                          'Invalid "target" attribute. Please use "readonly" instead of "disabled" attribute',
                        );
                      if (
                        c === "cut" &&
                        (d.hasAttribute("readonly") ||
                          d.hasAttribute("disabled"))
                      )
                        throw new Error(
                          `Invalid "target" attribute. You can't cut text from elements with "readonly" or "disabled" attributes`,
                        );
                    } else
                      throw new Error(
                        'Invalid "target" value, use a valid Element',
                      );
                  if (x) return W(x, { container: s });
                  if (d) return c === "cut" ? g(d) : W(d, { container: s });
                },
                ee = K;
              function F(l) {
                return (
                  typeof Symbol == "function" &&
                  typeof Symbol.iterator == "symbol"
                    ? (F = function (t) {
                        return typeof t;
                      })
                    : (F = function (t) {
                        return t &&
                          typeof Symbol == "function" &&
                          t.constructor === Symbol &&
                          t !== Symbol.prototype
                          ? "symbol"
                          : typeof t;
                      }),
                  F(l)
                );
              }
              function te(l, n) {
                if (!(l instanceof n))
                  throw new TypeError("Cannot call a class as a function");
              }
              function $(l, n) {
                for (var t = 0; t < n.length; t++) {
                  var c = n[t];
                  (c.enumerable = c.enumerable || !1),
                    (c.configurable = !0),
                    "value" in c && (c.writable = !0),
                    Object.defineProperty(l, c.key, c);
                }
              }
              function ue(l, n, t) {
                return n && $(l.prototype, n), t && $(l, t), l;
              }
              function X(l, n) {
                if (typeof n != "function" && n !== null)
                  throw new TypeError(
                    "Super expression must either be null or a function",
                  );
                (l.prototype = Object.create(n && n.prototype, {
                  constructor: { value: l, writable: !0, configurable: !0 },
                })),
                  n && V(l, n);
              }
              function V(l, n) {
                return (
                  (V =
                    Object.setPrototypeOf ||
                    function (c, s) {
                      return (c.__proto__ = s), c;
                    }),
                  V(l, n)
                );
              }
              function he(l) {
                var n = re();
                return function () {
                  var c = D(l),
                    s;
                  if (n) {
                    var d = D(this).constructor;
                    s = Reflect.construct(c, arguments, d);
                  } else s = c.apply(this, arguments);
                  return ce(this, s);
                };
              }
              function ce(l, n) {
                return n && (F(n) === "object" || typeof n == "function")
                  ? n
                  : le(l);
              }
              function le(l) {
                if (l === void 0)
                  throw new ReferenceError(
                    "this hasn't been initialised - super() hasn't been called",
                  );
                return l;
              }
              function re() {
                if (
                  typeof Reflect == "undefined" ||
                  !Reflect.construct ||
                  Reflect.construct.sham
                )
                  return !1;
                if (typeof Proxy == "function") return !0;
                try {
                  return (
                    Date.prototype.toString.call(
                      Reflect.construct(Date, [], function () {}),
                    ),
                    !0
                  );
                } catch (l) {
                  return !1;
                }
              }
              function D(l) {
                return (
                  (D = Object.setPrototypeOf
                    ? Object.getPrototypeOf
                    : function (t) {
                        return t.__proto__ || Object.getPrototypeOf(t);
                      }),
                  D(l)
                );
              }
              function p(l, n) {
                var t = "data-clipboard-".concat(l);
                if (n.hasAttribute(t)) return n.getAttribute(t);
              }
              var v = (function (l) {
                  X(t, l);
                  var n = he(t);
                  function t(c, s) {
                    var d;
                    return (
                      te(this, t),
                      (d = n.call(this)),
                      d.resolveOptions(s),
                      d.listenClick(c),
                      d
                    );
                  }
                  return (
                    ue(
                      t,
                      [
                        {
                          key: "resolveOptions",
                          value: function () {
                            var s =
                              arguments.length > 0 && arguments[0] !== void 0
                                ? arguments[0]
                                : {};
                            (this.action =
                              typeof s.action == "function"
                                ? s.action
                                : this.defaultAction),
                              (this.target =
                                typeof s.target == "function"
                                  ? s.target
                                  : this.defaultTarget),
                              (this.text =
                                typeof s.text == "function"
                                  ? s.text
                                  : this.defaultText),
                              (this.container =
                                F(s.container) === "object"
                                  ? s.container
                                  : document.body);
                          },
                        },
                        {
                          key: "listenClick",
                          value: function (s) {
                            var d = this;
                            this.listener = L()(s, "click", function (x) {
                              return d.onClick(x);
                            });
                          },
                        },
                        {
                          key: "onClick",
                          value: function (s) {
                            var d = s.delegateTarget || s.currentTarget,
                              x = this.action(d) || "copy",
                              k = ee({
                                action: x,
                                container: this.container,
                                target: this.target(d),
                                text: this.text(d),
                              });
                            this.emit(k ? "success" : "error", {
                              action: x,
                              text: k,
                              trigger: d,
                              clearSelection: function () {
                                d && d.focus(),
                                  window.getSelection().removeAllRanges();
                              },
                            });
                          },
                        },
                        {
                          key: "defaultAction",
                          value: function (s) {
                            return p("action", s);
                          },
                        },
                        {
                          key: "defaultTarget",
                          value: function (s) {
                            var d = p("target", s);
                            if (d) return document.querySelector(d);
                          },
                        },
                        {
                          key: "defaultText",
                          value: function (s) {
                            return p("text", s);
                          },
                        },
                        {
                          key: "destroy",
                          value: function () {
                            this.listener.destroy();
                          },
                        },
                      ],
                      [
                        {
                          key: "copy",
                          value: function (s) {
                            var d =
                              arguments.length > 1 && arguments[1] !== void 0
                                ? arguments[1]
                                : { container: document.body };
                            return W(s, d);
                          },
                        },
                        {
                          key: "cut",
                          value: function (s) {
                            return g(s);
                          },
                        },
                        {
                          key: "isSupported",
                          value: function () {
                            var s =
                                arguments.length > 0 && arguments[0] !== void 0
                                  ? arguments[0]
                                  : ["copy", "cut"],
                              d = typeof s == "string" ? [s] : s,
                              x = !!document.queryCommandSupported;
                            return (
                              d.forEach(function (k) {
                                x = x && !!document.queryCommandSupported(k);
                              }),
                              x
                            );
                          },
                        },
                      ],
                    ),
                    t
                  );
                })(h()),
                C = v;
            },
            828: function (o) {
              var a = 9;
              if (typeof Element != "undefined" && !Element.prototype.matches) {
                var e = Element.prototype;
                e.matches =
                  e.matchesSelector ||
                  e.mozMatchesSelector ||
                  e.msMatchesSelector ||
                  e.oMatchesSelector ||
                  e.webkitMatchesSelector;
              }
              function y(h, b) {
                for (; h && h.nodeType !== a; ) {
                  if (typeof h.matches == "function" && h.matches(b)) return h;
                  h = h.parentNode;
                }
              }
              o.exports = y;
            },
            438: function (o, a, e) {
              var y = e(828);
              function h(z, A, m, S, g) {
                var T = L.apply(this, arguments);
                return (
                  z.addEventListener(m, T, g),
                  {
                    destroy: function () {
                      z.removeEventListener(m, T, g);
                    },
                  }
                );
              }
              function b(z, A, m, S, g) {
                return typeof z.addEventListener == "function"
                  ? h.apply(null, arguments)
                  : typeof m == "function"
                    ? h.bind(null, document).apply(null, arguments)
                    : (typeof z == "string" &&
                        (z = document.querySelectorAll(z)),
                      Array.prototype.map.call(z, function (T) {
                        return h(T, A, m, S, g);
                      }));
              }
              function L(z, A, m, S) {
                return function (g) {
                  (g.delegateTarget = y(g.target, A)),
                    g.delegateTarget && S.call(z, g);
                };
              }
              o.exports = b;
            },
            879: function (o, a) {
              (a.node = function (e) {
                return (
                  e !== void 0 && e instanceof HTMLElement && e.nodeType === 1
                );
              }),
                (a.nodeList = function (e) {
                  var y = Object.prototype.toString.call(e);
                  return (
                    e !== void 0 &&
                    (y === "[object NodeList]" ||
                      y === "[object HTMLCollection]") &&
                    "length" in e &&
                    (e.length === 0 || a.node(e[0]))
                  );
                }),
                (a.string = function (e) {
                  return typeof e == "string" || e instanceof String;
                }),
                (a.fn = function (e) {
                  var y = Object.prototype.toString.call(e);
                  return y === "[object Function]";
                });
            },
            370: function (o, a, e) {
              var y = e(879),
                h = e(438);
              function b(m, S, g) {
                if (!m && !S && !g)
                  throw new Error("Missing required arguments");
                if (!y.string(S))
                  throw new TypeError("Second argument must be a String");
                if (!y.fn(g))
                  throw new TypeError("Third argument must be a Function");
                if (y.node(m)) return L(m, S, g);
                if (y.nodeList(m)) return z(m, S, g);
                if (y.string(m)) return A(m, S, g);
                throw new TypeError(
                  "First argument must be a String, HTMLElement, HTMLCollection, or NodeList",
                );
              }
              function L(m, S, g) {
                return (
                  m.addEventListener(S, g),
                  {
                    destroy: function () {
                      m.removeEventListener(S, g);
                    },
                  }
                );
              }
              function z(m, S, g) {
                return (
                  Array.prototype.forEach.call(m, function (T) {
                    T.addEventListener(S, g);
                  }),
                  {
                    destroy: function () {
                      Array.prototype.forEach.call(m, function (T) {
                        T.removeEventListener(S, g);
                      });
                    },
                  }
                );
              }
              function A(m, S, g) {
                return h(document.body, m, S, g);
              }
              o.exports = b;
            },
            817: function (o) {
              function a(e) {
                var y;
                if (e.nodeName === "SELECT") e.focus(), (y = e.value);
                else if (e.nodeName === "INPUT" || e.nodeName === "TEXTAREA") {
                  var h = e.hasAttribute("readonly");
                  h || e.setAttribute("readonly", ""),
                    e.select(),
                    e.setSelectionRange(0, e.value.length),
                    h || e.removeAttribute("readonly"),
                    (y = e.value);
                } else {
                  e.hasAttribute("contenteditable") && e.focus();
                  var b = window.getSelection(),
                    L = document.createRange();
                  L.selectNodeContents(e),
                    b.removeAllRanges(),
                    b.addRange(L),
                    (y = b.toString());
                }
                return y;
              }
              o.exports = a;
            },
            279: function (o) {
              function a() {}
              (a.prototype = {
                on: function (e, y, h) {
                  var b = this.e || (this.e = {});
                  return (b[e] || (b[e] = [])).push({ fn: y, ctx: h }), this;
                },
                once: function (e, y, h) {
                  var b = this;
                  function L() {
                    b.off(e, L), y.apply(h, arguments);
                  }
                  return (L._ = y), this.on(e, L, h);
                },
                emit: function (e) {
                  var y = [].slice.call(arguments, 1),
                    h = ((this.e || (this.e = {}))[e] || []).slice(),
                    b = 0,
                    L = h.length;
                  for (b; b < L; b++) h[b].fn.apply(h[b].ctx, y);
                  return this;
                },
                off: function (e, y) {
                  var h = this.e || (this.e = {}),
                    b = h[e],
                    L = [];
                  if (b && y)
                    for (var z = 0, A = b.length; z < A; z++)
                      b[z].fn !== y && b[z].fn._ !== y && L.push(b[z]);
                  return L.length ? (h[e] = L) : delete h[e], this;
                },
              }),
                (o.exports = a),
                (o.exports.TinyEmitter = a);
            },
          },
          f = {};
        function u(o) {
          if (f[o]) return f[o].exports;
          var a = (f[o] = { exports: {} });
          return r[o](a, a.exports, u), a.exports;
        }
        return (
          (function () {
            u.n = function (o) {
              var a =
                o && o.__esModule
                  ? function () {
                      return o.default;
                    }
                  : function () {
                      return o;
                    };
              return u.d(a, { a }), a;
            };
          })(),
          (function () {
            u.d = function (o, a) {
              for (var e in a)
                u.o(a, e) &&
                  !u.o(o, e) &&
                  Object.defineProperty(o, e, { enumerable: !0, get: a[e] });
            };
          })(),
          (function () {
            u.o = function (o, a) {
              return Object.prototype.hasOwnProperty.call(o, a);
            };
          })(),
          u(686)
        );
      })().default;
    });
  });
  function Pe(r) {
    return new Promise(function (f, u, o) {
      (o = new XMLHttpRequest()).open("GET", r, (o.withCredentials = !0)),
        (o.onload = function () {
          o.status === 200 ? f() : u();
        }),
        o.send();
    });
  }
  var Ee,
    rt =
      (Ee = document.createElement("link")).relList &&
      Ee.relList.supports &&
      Ee.relList.supports("prefetch")
        ? function (r) {
            return new Promise(function (f, u, o) {
              ((o = document.createElement("link")).rel = "prefetch"),
                (o.href = r),
                (o.onload = f),
                (o.onerror = u),
                document.head.appendChild(o);
            });
          }
        : Pe,
    nt =
      window.requestIdleCallback ||
      function (r) {
        var f = Date.now();
        return setTimeout(function () {
          r({
            didTimeout: !1,
            timeRemaining: function () {
              return Math.max(0, 50 - (Date.now() - f));
            },
          });
        }, 1);
      },
    oe = new Set(),
    de = new Set(),
    ve = !1;
  function ke(r) {
    if (r) {
      if (r.saveData) return new Error("Save-Data is enabled");
      if (/2g/.test(r.effectiveType))
        return new Error("network conditions are poor");
    }
    return !0;
  }
  function Oe(r) {
    if ((r || (r = {}), window.IntersectionObserver)) {
      var f = (function (S) {
          S = S || 1;
          var g = [],
            T = 0;
          function w() {
            T < S && g.length > 0 && (g.shift()(), T++);
          }
          return [
            function (j) {
              g.push(j) > 1 || w();
            },
            function () {
              T--, w();
            },
          ];
        })(r.throttle || 1 / 0),
        u = f[0],
        o = f[1],
        a = r.limit || 1 / 0,
        e = r.origins || [location.hostname],
        y = r.ignores || [],
        h = r.delay || 0,
        b = [],
        L = r.timeoutFn || nt,
        z = typeof r.hrefFn == "function" && r.hrefFn,
        A = r.prerender || !1;
      ve = r.prerenderAndPrefetch || !1;
      var m = new IntersectionObserver(
        function (S) {
          S.forEach(function (g) {
            if (g.isIntersecting)
              b.push((g = g.target).href),
                (function (w, j) {
                  j ? setTimeout(w, j) : w();
                })(function () {
                  b.indexOf(g.href) !== -1 &&
                    (m.unobserve(g),
                    (ve || A) && de.size < 1
                      ? it(z ? z(g) : g.href).catch(function (w) {
                          if (!r.onError) throw w;
                          r.onError(w);
                        })
                      : oe.size < a &&
                        !A &&
                        u(function () {
                          Ne(z ? z(g) : g.href, r.priority)
                            .then(o)
                            .catch(function (w) {
                              o(), r.onError && r.onError(w);
                            });
                        }));
                }, h);
            else {
              var T = b.indexOf((g = g.target).href);
              T > -1 && b.splice(T);
            }
          });
        },
        { threshold: r.threshold || 0 },
      );
      return (
        L(
          function () {
            (r.el || document).querySelectorAll("a").forEach(function (S) {
              (e.length && !e.includes(S.hostname)) ||
                (function g(T, w) {
                  return Array.isArray(w)
                    ? w.some(function (j) {
                        return g(T, j);
                      })
                    : (w.test || w).call(w, T.href, T);
                })(S, y) ||
                m.observe(S);
            });
          },
          { timeout: r.timeout || 2e3 },
        ),
        function () {
          oe.clear(), m.disconnect();
        }
      );
    }
  }
  function Ne(r, f, u) {
    var o = ke(navigator.connection);
    return o instanceof Error
      ? Promise.reject(new Error("Cannot prefetch, " + o.message))
      : (de.size > 0 &&
          !ve &&
          console.warn(
            "[Warning] You are using both prefetching and prerendering on the same document",
          ),
        Promise.all(
          [].concat(r).map(function (a) {
            if (!oe.has(a))
              return (
                oe.add(a),
                (f
                  ? function (e) {
                      return window.fetch
                        ? fetch(e, { credentials: "include" })
                        : Pe(e);
                    }
                  : rt)(new URL(a, location.href).toString())
              );
          }),
        ));
  }
  function it(r, f) {
    var u = ke(navigator.connection);
    if (u instanceof Error)
      return Promise.reject(new Error("Cannot prerender, " + u.message));
    if (!HTMLScriptElement.supports("speculationrules"))
      return (
        Ne(r),
        Promise.reject(
          new Error(
            "This browser does not support the speculation rules API. Falling back to prefetch.",
          ),
        )
      );
    if (document.querySelector('script[type="speculationrules"]'))
      return Promise.reject(
        new Error(
          "Speculation Rules is already defined and cannot be altered.",
        ),
      );
    for (var o = 0, a = [].concat(r); o < a.length; o += 1) {
      var e = a[o];
      if (window.location.origin !== new URL(e, window.location.href).origin)
        return Promise.reject(
          new Error("Only same origin URLs are allowed: " + e),
        );
      de.add(e);
    }
    oe.size > 0 &&
      !ve &&
      console.warn(
        "[Warning] You are using both prefetching and prerendering on the same document",
      );
    var y = (function (h) {
      var b = document.createElement("script");
      (b.type = "speculationrules"),
        (b.text =
          '{"prerender":[{"source": "list","urls": ["' +
          Array.from(h).join('","') +
          '"]}]}');
      try {
        document.head.appendChild(b);
      } catch (L) {
        return L;
      }
      return !0;
    })(de);
    return y === !0 ? Promise.resolve() : Promise.reject(y);
  }
  var Fe = be(Le()),
    vt = be(Re());
  Oe();
  Fe.default.cfg.nativeLoading = {
    setLoadingAttribute: !0,
    disableListeners: { scroll: !0 },
  };
  var je = be(Ie());
  (() => {
    "use strict";
    for (
      var r = document.getElementsByClassName("highlight"), f = 0;
      f < r.length;
      ++f
    ) {
      var u = r[f];
      u.insertAdjacentHTML(
        "afterbegin",
        '<div class="clipboard"><button class="btn btn-clipboard" aria-label="Clipboard button"></button></div>',
      );
    }
    var o = new je.default(".btn-clipboard", {
      target: function (a) {
        return a.parentNode.nextElementSibling;
      },
    });
    o.on("success", function (a) {
      a.clearSelection();
    }),
      o.on("error", function (a) {
        console.error("Action:", a.action),
          console.error("Trigger:", a.trigger);
      });
  })();
  var se = document.getElementById("toTop");
  se !== null &&
    (se.classList.remove("fade"),
    (window.onscroll = function () {
      ot();
    }),
    se.addEventListener("click", at));
  function ot() {
    document.body.scrollTop > 270 || document.documentElement.scrollTop > 270
      ? se.classList.add("fade")
      : se.classList.remove("fade");
  }
  function at() {
    (document.body.scrollTop = 0), (document.documentElement.scrollTop = 0);
  }
  var ge,
    ye = document.querySelectorAll("[data-toggle-tab]"),
    st = document.querySelectorAll("[data-pane]");
  function He(r) {
    if (r.target) {
      r.preventDefault();
      var f = r.currentTarget,
        u = f.getAttribute("data-toggle-tab");
    } else var u = r;
    window.localStorage && window.localStorage.setItem("configLangPref", u);
    for (
      var o = document.querySelectorAll("[data-toggle-tab=" + u + "]"),
        a = document.querySelectorAll("[data-pane=" + u + "]"),
        e = 0;
      e < ye.length;
      e++
    )
      ye[e].classList.remove("active"), st[e].classList.remove("active");
    for (var e = 0; e < o.length; e++)
      o[e].classList.add("active"), a[e].classList.add("show", "active");
  }
  for (ge = 0; ge < ye.length; ge++) ye[ge].addEventListener("click", He);
  window.localStorage.getItem("configLangPref") &&
    He(window.localStorage.getItem("configLangPref"));
})();
/*! Bundled license information:

clipboard/dist/clipboard.js:
  (*!
   * clipboard.js v2.0.11
   * https://clipboardjs.com/
   *
   * Licensed MIT © Zeno Rocha
   *)

@hyas/doks-core/assets/js/clipboard.js:
  (*!
   * clipboard.js for Bootstrap based Hyas sites
   * Copyright 2021-2023 Hyas
   * Licensed under the MIT License
   *)
*/
