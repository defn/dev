(() => {
  var er = Object.defineProperty,
    Nn = Object.defineProperties;
  var Sn = Object.getOwnPropertyDescriptors;
  var Ji = Object.getOwnPropertySymbols;
  var Dn = Object.prototype.hasOwnProperty,
    Ln = Object.prototype.propertyIsEnumerable;
  var tr = (i, t, e) =>
      t in i
        ? er(i, t, { enumerable: !0, configurable: !0, writable: !0, value: e })
        : (i[t] = e),
    H = (i, t) => {
      for (var e in t || (t = {})) Dn.call(t, e) && tr(i, e, t[e]);
      if (Ji) for (var e of Ji(t)) Ln.call(t, e) && tr(i, e, t[e]);
      return i;
    },
    Ie = (i, t) => Nn(i, Sn(t));
  var xn = (i, t) => {
    for (var e in t) er(i, e, { get: t[e], enumerable: !0 });
  };
  var Fe = {};
  xn(Fe, {
    afterMain: () => ar,
    afterRead: () => nr,
    afterWrite: () => ur,
    applyStyles: () => Yt,
    arrow: () => Me,
    auto: () => de,
    basePlacements: () => ot,
    beforeMain: () => sr,
    beforeRead: () => ir,
    beforeWrite: () => lr,
    bottom: () => L,
    clippingParents: () => ai,
    computeStyles: () => Gt,
    createPopper: () => Ae,
    createPopperBase: () => vr,
    createPopperLite: () => br,
    detectOverflow: () => j,
    end: () => pt,
    eventListeners: () => zt,
    flip: () => He,
    hide: () => We,
    left: () => C,
    main: () => or,
    modifierPhases: () => ci,
    offset: () => Be,
    placements: () => he,
    popper: () => Nt,
    popperGenerator: () => Mt,
    popperOffsets: () => Qt,
    preventOverflow: () => je,
    read: () => rr,
    reference: () => li,
    right: () => D,
    start: () => rt,
    top: () => w,
    variationPlacements: () => Pe,
    viewport: () => pe,
    write: () => cr,
  });
  var w = "top",
    L = "bottom",
    D = "right",
    C = "left",
    de = "auto",
    ot = [w, L, D, C],
    rt = "start",
    pt = "end",
    ai = "clippingParents",
    pe = "viewport",
    Nt = "popper",
    li = "reference",
    Pe = ot.reduce(function (i, t) {
      return i.concat([t + "-" + rt, t + "-" + pt]);
    }, []),
    he = [].concat(ot, [de]).reduce(function (i, t) {
      return i.concat([t, t + "-" + rt, t + "-" + pt]);
    }, []),
    ir = "beforeRead",
    rr = "read",
    nr = "afterRead",
    sr = "beforeMain",
    or = "main",
    ar = "afterMain",
    lr = "beforeWrite",
    cr = "write",
    ur = "afterWrite",
    ci = [ir, rr, nr, sr, or, ar, lr, cr, ur];
  function P(i) {
    return i ? (i.nodeName || "").toLowerCase() : null;
  }
  function y(i) {
    if (i == null) return window;
    if (i.toString() !== "[object Window]") {
      var t = i.ownerDocument;
      return (t && t.defaultView) || window;
    }
    return i;
  }
  function U(i) {
    var t = y(i).Element;
    return i instanceof t || i instanceof Element;
  }
  function $(i) {
    var t = y(i).HTMLElement;
    return i instanceof t || i instanceof HTMLElement;
  }
  function Kt(i) {
    if (typeof ShadowRoot == "undefined") return !1;
    var t = y(i).ShadowRoot;
    return i instanceof t || i instanceof ShadowRoot;
  }
  function $n(i) {
    var t = i.state;
    Object.keys(t.elements).forEach(function (e) {
      var r = t.styles[e] || {},
        n = t.attributes[e] || {},
        s = t.elements[e];
      !$(s) ||
        !P(s) ||
        (Object.assign(s.style, r),
        Object.keys(n).forEach(function (o) {
          var a = n[o];
          a === !1
            ? s.removeAttribute(o)
            : s.setAttribute(o, a === !0 ? "" : a);
        }));
    });
  }
  function In(i) {
    var t = i.state,
      e = {
        popper: {
          position: t.options.strategy,
          left: "0",
          top: "0",
          margin: "0",
        },
        arrow: { position: "absolute" },
        reference: {},
      };
    return (
      Object.assign(t.elements.popper.style, e.popper),
      (t.styles = e),
      t.elements.arrow && Object.assign(t.elements.arrow.style, e.arrow),
      function () {
        Object.keys(t.elements).forEach(function (r) {
          var n = t.elements[r],
            s = t.attributes[r] || {},
            o = Object.keys(t.styles.hasOwnProperty(r) ? t.styles[r] : e[r]),
            a = o.reduce(function (u, f) {
              return (u[f] = ""), u;
            }, {});
          !$(n) ||
            !P(n) ||
            (Object.assign(n.style, a),
            Object.keys(s).forEach(function (u) {
              n.removeAttribute(u);
            }));
        });
      }
    );
  }
  var Yt = {
    name: "applyStyles",
    enabled: !0,
    phase: "write",
    fn: $n,
    effect: In,
    requires: ["computeStyles"],
  };
  function M(i) {
    return i.split("-")[0];
  }
  var et = Math.max,
    St = Math.min,
    at = Math.round;
  function Ut() {
    var i = navigator.userAgentData;
    return i != null && i.brands && Array.isArray(i.brands)
      ? i.brands
          .map(function (t) {
            return t.brand + "/" + t.version;
          })
          .join(" ")
      : navigator.userAgent;
  }
  function me() {
    return !/^((?!chrome|android).)*safari/i.test(Ut());
  }
  function G(i, t, e) {
    t === void 0 && (t = !1), e === void 0 && (e = !1);
    var r = i.getBoundingClientRect(),
      n = 1,
      s = 1;
    t &&
      $(i) &&
      ((n = (i.offsetWidth > 0 && at(r.width) / i.offsetWidth) || 1),
      (s = (i.offsetHeight > 0 && at(r.height) / i.offsetHeight) || 1));
    var o = U(i) ? y(i) : window,
      a = o.visualViewport,
      u = !me() && e,
      f = (r.left + (u && a ? a.offsetLeft : 0)) / n,
      l = (r.top + (u && a ? a.offsetTop : 0)) / s,
      h = r.width / n,
      _ = r.height / s;
    return {
      width: h,
      height: _,
      top: l,
      right: f + h,
      bottom: l + _,
      left: f,
      x: f,
      y: l,
    };
  }
  function Dt(i) {
    var t = G(i),
      e = i.offsetWidth,
      r = i.offsetHeight;
    return (
      Math.abs(t.width - e) <= 1 && (e = t.width),
      Math.abs(t.height - r) <= 1 && (r = t.height),
      { x: i.offsetLeft, y: i.offsetTop, width: e, height: r }
    );
  }
  function _e(i, t) {
    var e = t.getRootNode && t.getRootNode();
    if (i.contains(t)) return !0;
    if (e && Kt(e)) {
      var r = t;
      do {
        if (r && i.isSameNode(r)) return !0;
        r = r.parentNode || r.host;
      } while (r);
    }
    return !1;
  }
  function B(i) {
    return y(i).getComputedStyle(i);
  }
  function ui(i) {
    return ["table", "td", "th"].indexOf(P(i)) >= 0;
  }
  function k(i) {
    return ((U(i) ? i.ownerDocument : i.document) || window.document)
      .documentElement;
  }
  function lt(i) {
    return P(i) === "html"
      ? i
      : i.assignedSlot || i.parentNode || (Kt(i) ? i.host : null) || k(i);
  }
  function fr(i) {
    return !$(i) || B(i).position === "fixed" ? null : i.offsetParent;
  }
  function Pn(i) {
    var t = /firefox/i.test(Ut()),
      e = /Trident/i.test(Ut());
    if (e && $(i)) {
      var r = B(i);
      if (r.position === "fixed") return null;
    }
    var n = lt(i);
    for (Kt(n) && (n = n.host); $(n) && ["html", "body"].indexOf(P(n)) < 0; ) {
      var s = B(n);
      if (
        s.transform !== "none" ||
        s.perspective !== "none" ||
        s.contain === "paint" ||
        ["transform", "perspective"].indexOf(s.willChange) !== -1 ||
        (t && s.willChange === "filter") ||
        (t && s.filter && s.filter !== "none")
      )
        return n;
      n = n.parentNode;
    }
    return null;
  }
  function it(i) {
    for (var t = y(i), e = fr(i); e && ui(e) && B(e).position === "static"; )
      e = fr(e);
    return e &&
      (P(e) === "html" || (P(e) === "body" && B(e).position === "static"))
      ? t
      : e || Pn(i) || t;
  }
  function Lt(i) {
    return ["top", "bottom"].indexOf(i) >= 0 ? "x" : "y";
  }
  function xt(i, t, e) {
    return et(i, St(t, e));
  }
  function dr(i, t, e) {
    var r = xt(i, t, e);
    return r > e ? e : r;
  }
  function ge() {
    return { top: 0, right: 0, bottom: 0, left: 0 };
  }
  function Ee(i) {
    return Object.assign({}, ge(), i);
  }
  function ve(i, t) {
    return t.reduce(function (e, r) {
      return (e[r] = i), e;
    }, {});
  }
  var Mn = function (t, e) {
    return (
      (t =
        typeof t == "function"
          ? t(Object.assign({}, e.rects, { placement: e.placement }))
          : t),
      Ee(typeof t != "number" ? t : ve(t, ot))
    );
  };
  function Rn(i) {
    var t,
      e = i.state,
      r = i.name,
      n = i.options,
      s = e.elements.arrow,
      o = e.modifiersData.popperOffsets,
      a = M(e.placement),
      u = Lt(a),
      f = [C, D].indexOf(a) >= 0,
      l = f ? "height" : "width";
    if (!(!s || !o)) {
      var h = Mn(n.padding, e),
        _ = Dt(s),
        d = u === "y" ? w : C,
        g = u === "y" ? L : D,
        m =
          e.rects.reference[l] +
          e.rects.reference[u] -
          o[u] -
          e.rects.popper[l],
        v = o[u] - e.rects.reference[u],
        T = it(s),
        N = T ? (u === "y" ? T.clientHeight || 0 : T.clientWidth || 0) : 0,
        S = m / 2 - v / 2,
        E = h[d],
        b = N - _[l] - h[g],
        A = N / 2 - _[l] / 2 + S,
        O = xt(E, A, b),
        R = u;
      e.modifiersData[r] = ((t = {}), (t[R] = O), (t.centerOffset = O - A), t);
    }
  }
  function kn(i) {
    var t = i.state,
      e = i.options,
      r = e.element,
      n = r === void 0 ? "[data-popper-arrow]" : r;
    n != null &&
      ((typeof n == "string" &&
        ((n = t.elements.popper.querySelector(n)), !n)) ||
        (_e(t.elements.popper, n) && (t.elements.arrow = n)));
  }
  var Me = {
    name: "arrow",
    enabled: !0,
    phase: "main",
    fn: Rn,
    effect: kn,
    requires: ["popperOffsets"],
    requiresIfExists: ["preventOverflow"],
  };
  function z(i) {
    return i.split("-")[1];
  }
  var Vn = { top: "auto", right: "auto", bottom: "auto", left: "auto" };
  function Hn(i, t) {
    var e = i.x,
      r = i.y,
      n = t.devicePixelRatio || 1;
    return { x: at(e * n) / n || 0, y: at(r * n) / n || 0 };
  }
  function pr(i) {
    var t,
      e = i.popper,
      r = i.popperRect,
      n = i.placement,
      s = i.variation,
      o = i.offsets,
      a = i.position,
      u = i.gpuAcceleration,
      f = i.adaptive,
      l = i.roundOffsets,
      h = i.isFixed,
      _ = o.x,
      d = _ === void 0 ? 0 : _,
      g = o.y,
      m = g === void 0 ? 0 : g,
      v = typeof l == "function" ? l({ x: d, y: m }) : { x: d, y: m };
    (d = v.x), (m = v.y);
    var T = o.hasOwnProperty("x"),
      N = o.hasOwnProperty("y"),
      S = C,
      E = w,
      b = window;
    if (f) {
      var A = it(e),
        O = "clientHeight",
        R = "clientWidth";
      if (
        (A === y(e) &&
          ((A = k(e)),
          B(A).position !== "static" &&
            a === "absolute" &&
            ((O = "scrollHeight"), (R = "scrollWidth"))),
        (A = A),
        n === w || ((n === C || n === D) && s === pt))
      ) {
        E = L;
        var I =
          h && A === b && b.visualViewport ? b.visualViewport.height : A[O];
        (m -= I - r.height), (m *= u ? 1 : -1);
      }
      if (n === C || ((n === w || n === L) && s === pt)) {
        S = D;
        var x =
          h && A === b && b.visualViewport ? b.visualViewport.width : A[R];
        (d -= x - r.width), (d *= u ? 1 : -1);
      }
    }
    var V = Object.assign({ position: a }, f && Vn),
      J = l === !0 ? Hn({ x: d, y: m }, y(e)) : { x: d, y: m };
    if (((d = J.x), (m = J.y), u)) {
      var W;
      return Object.assign(
        {},
        V,
        ((W = {}),
        (W[E] = N ? "0" : ""),
        (W[S] = T ? "0" : ""),
        (W.transform =
          (b.devicePixelRatio || 1) <= 1
            ? "translate(" + d + "px, " + m + "px)"
            : "translate3d(" + d + "px, " + m + "px, 0)"),
        W),
      );
    }
    return Object.assign(
      {},
      V,
      ((t = {}),
      (t[E] = N ? m + "px" : ""),
      (t[S] = T ? d + "px" : ""),
      (t.transform = ""),
      t),
    );
  }
  function Wn(i) {
    var t = i.state,
      e = i.options,
      r = e.gpuAcceleration,
      n = r === void 0 ? !0 : r,
      s = e.adaptive,
      o = s === void 0 ? !0 : s,
      a = e.roundOffsets,
      u = a === void 0 ? !0 : a,
      f = {
        placement: M(t.placement),
        variation: z(t.placement),
        popper: t.elements.popper,
        popperRect: t.rects.popper,
        gpuAcceleration: n,
        isFixed: t.options.strategy === "fixed",
      };
    t.modifiersData.popperOffsets != null &&
      (t.styles.popper = Object.assign(
        {},
        t.styles.popper,
        pr(
          Object.assign({}, f, {
            offsets: t.modifiersData.popperOffsets,
            position: t.options.strategy,
            adaptive: o,
            roundOffsets: u,
          }),
        ),
      )),
      t.modifiersData.arrow != null &&
        (t.styles.arrow = Object.assign(
          {},
          t.styles.arrow,
          pr(
            Object.assign({}, f, {
              offsets: t.modifiersData.arrow,
              position: "absolute",
              adaptive: !1,
              roundOffsets: u,
            }),
          ),
        )),
      (t.attributes.popper = Object.assign({}, t.attributes.popper, {
        "data-popper-placement": t.placement,
      }));
  }
  var Gt = {
    name: "computeStyles",
    enabled: !0,
    phase: "beforeWrite",
    fn: Wn,
    data: {},
  };
  var Re = { passive: !0 };
  function Bn(i) {
    var t = i.state,
      e = i.instance,
      r = i.options,
      n = r.scroll,
      s = n === void 0 ? !0 : n,
      o = r.resize,
      a = o === void 0 ? !0 : o,
      u = y(t.elements.popper),
      f = [].concat(t.scrollParents.reference, t.scrollParents.popper);
    return (
      s &&
        f.forEach(function (l) {
          l.addEventListener("scroll", e.update, Re);
        }),
      a && u.addEventListener("resize", e.update, Re),
      function () {
        s &&
          f.forEach(function (l) {
            l.removeEventListener("scroll", e.update, Re);
          }),
          a && u.removeEventListener("resize", e.update, Re);
      }
    );
  }
  var zt = {
    name: "eventListeners",
    enabled: !0,
    phase: "write",
    fn: function () {},
    effect: Bn,
    data: {},
  };
  var jn = { left: "right", right: "left", bottom: "top", top: "bottom" };
  function qt(i) {
    return i.replace(/left|right|bottom|top/g, function (t) {
      return jn[t];
    });
  }
  var Fn = { start: "end", end: "start" };
  function ke(i) {
    return i.replace(/start|end/g, function (t) {
      return Fn[t];
    });
  }
  function $t(i) {
    var t = y(i),
      e = t.pageXOffset,
      r = t.pageYOffset;
    return { scrollLeft: e, scrollTop: r };
  }
  function It(i) {
    return G(k(i)).left + $t(i).scrollLeft;
  }
  function fi(i, t) {
    var e = y(i),
      r = k(i),
      n = e.visualViewport,
      s = r.clientWidth,
      o = r.clientHeight,
      a = 0,
      u = 0;
    if (n) {
      (s = n.width), (o = n.height);
      var f = me();
      (f || (!f && t === "fixed")) && ((a = n.offsetLeft), (u = n.offsetTop));
    }
    return { width: s, height: o, x: a + It(i), y: u };
  }
  function di(i) {
    var t,
      e = k(i),
      r = $t(i),
      n = (t = i.ownerDocument) == null ? void 0 : t.body,
      s = et(
        e.scrollWidth,
        e.clientWidth,
        n ? n.scrollWidth : 0,
        n ? n.clientWidth : 0,
      ),
      o = et(
        e.scrollHeight,
        e.clientHeight,
        n ? n.scrollHeight : 0,
        n ? n.clientHeight : 0,
      ),
      a = -r.scrollLeft + It(i),
      u = -r.scrollTop;
    return (
      B(n || e).direction === "rtl" &&
        (a += et(e.clientWidth, n ? n.clientWidth : 0) - s),
      { width: s, height: o, x: a, y: u }
    );
  }
  function Pt(i) {
    var t = B(i),
      e = t.overflow,
      r = t.overflowX,
      n = t.overflowY;
    return /auto|scroll|overlay|hidden/.test(e + n + r);
  }
  function Ve(i) {
    return ["html", "body", "#document"].indexOf(P(i)) >= 0
      ? i.ownerDocument.body
      : $(i) && Pt(i)
        ? i
        : Ve(lt(i));
  }
  function ht(i, t) {
    var e;
    t === void 0 && (t = []);
    var r = Ve(i),
      n = r === ((e = i.ownerDocument) == null ? void 0 : e.body),
      s = y(r),
      o = n ? [s].concat(s.visualViewport || [], Pt(r) ? r : []) : r,
      a = t.concat(o);
    return n ? a : a.concat(ht(lt(o)));
  }
  function Xt(i) {
    return Object.assign({}, i, {
      left: i.x,
      top: i.y,
      right: i.x + i.width,
      bottom: i.y + i.height,
    });
  }
  function Kn(i, t) {
    var e = G(i, !1, t === "fixed");
    return (
      (e.top = e.top + i.clientTop),
      (e.left = e.left + i.clientLeft),
      (e.bottom = e.top + i.clientHeight),
      (e.right = e.left + i.clientWidth),
      (e.width = i.clientWidth),
      (e.height = i.clientHeight),
      (e.x = e.left),
      (e.y = e.top),
      e
    );
  }
  function hr(i, t, e) {
    return t === pe ? Xt(fi(i, e)) : U(t) ? Kn(t, e) : Xt(di(k(i)));
  }
  function Yn(i) {
    var t = ht(lt(i)),
      e = ["absolute", "fixed"].indexOf(B(i).position) >= 0,
      r = e && $(i) ? it(i) : i;
    return U(r)
      ? t.filter(function (n) {
          return U(n) && _e(n, r) && P(n) !== "body";
        })
      : [];
  }
  function pi(i, t, e, r) {
    var n = t === "clippingParents" ? Yn(i) : [].concat(t),
      s = [].concat(n, [e]),
      o = s[0],
      a = s.reduce(
        function (u, f) {
          var l = hr(i, f, r);
          return (
            (u.top = et(l.top, u.top)),
            (u.right = St(l.right, u.right)),
            (u.bottom = St(l.bottom, u.bottom)),
            (u.left = et(l.left, u.left)),
            u
          );
        },
        hr(i, o, r),
      );
    return (
      (a.width = a.right - a.left),
      (a.height = a.bottom - a.top),
      (a.x = a.left),
      (a.y = a.top),
      a
    );
  }
  function be(i) {
    var t = i.reference,
      e = i.element,
      r = i.placement,
      n = r ? M(r) : null,
      s = r ? z(r) : null,
      o = t.x + t.width / 2 - e.width / 2,
      a = t.y + t.height / 2 - e.height / 2,
      u;
    switch (n) {
      case w:
        u = { x: o, y: t.y - e.height };
        break;
      case L:
        u = { x: o, y: t.y + t.height };
        break;
      case D:
        u = { x: t.x + t.width, y: a };
        break;
      case C:
        u = { x: t.x - e.width, y: a };
        break;
      default:
        u = { x: t.x, y: t.y };
    }
    var f = n ? Lt(n) : null;
    if (f != null) {
      var l = f === "y" ? "height" : "width";
      switch (s) {
        case rt:
          u[f] = u[f] - (t[l] / 2 - e[l] / 2);
          break;
        case pt:
          u[f] = u[f] + (t[l] / 2 - e[l] / 2);
          break;
        default:
      }
    }
    return u;
  }
  function j(i, t) {
    t === void 0 && (t = {});
    var e = t,
      r = e.placement,
      n = r === void 0 ? i.placement : r,
      s = e.strategy,
      o = s === void 0 ? i.strategy : s,
      a = e.boundary,
      u = a === void 0 ? ai : a,
      f = e.rootBoundary,
      l = f === void 0 ? pe : f,
      h = e.elementContext,
      _ = h === void 0 ? Nt : h,
      d = e.altBoundary,
      g = d === void 0 ? !1 : d,
      m = e.padding,
      v = m === void 0 ? 0 : m,
      T = Ee(typeof v != "number" ? v : ve(v, ot)),
      N = _ === Nt ? li : Nt,
      S = i.rects.popper,
      E = i.elements[g ? N : _],
      b = pi(U(E) ? E : E.contextElement || k(i.elements.popper), u, l, o),
      A = G(i.elements.reference),
      O = be({ reference: A, element: S, strategy: "absolute", placement: n }),
      R = Xt(Object.assign({}, S, O)),
      I = _ === Nt ? R : A,
      x = {
        top: b.top - I.top + T.top,
        bottom: I.bottom - b.bottom + T.bottom,
        left: b.left - I.left + T.left,
        right: I.right - b.right + T.right,
      },
      V = i.modifiersData.offset;
    if (_ === Nt && V) {
      var J = V[n];
      Object.keys(x).forEach(function (W) {
        var Tt = [D, L].indexOf(W) >= 0 ? 1 : -1,
          yt = [w, L].indexOf(W) >= 0 ? "y" : "x";
        x[W] += J[yt] * Tt;
      });
    }
    return x;
  }
  function hi(i, t) {
    t === void 0 && (t = {});
    var e = t,
      r = e.placement,
      n = e.boundary,
      s = e.rootBoundary,
      o = e.padding,
      a = e.flipVariations,
      u = e.allowedAutoPlacements,
      f = u === void 0 ? he : u,
      l = z(r),
      h = l
        ? a
          ? Pe
          : Pe.filter(function (g) {
              return z(g) === l;
            })
        : ot,
      _ = h.filter(function (g) {
        return f.indexOf(g) >= 0;
      });
    _.length === 0 && (_ = h);
    var d = _.reduce(function (g, m) {
      return (
        (g[m] = j(i, {
          placement: m,
          boundary: n,
          rootBoundary: s,
          padding: o,
        })[M(m)]),
        g
      );
    }, {});
    return Object.keys(d).sort(function (g, m) {
      return d[g] - d[m];
    });
  }
  function Un(i) {
    if (M(i) === de) return [];
    var t = qt(i);
    return [ke(i), t, ke(t)];
  }
  function Gn(i) {
    var t = i.state,
      e = i.options,
      r = i.name;
    if (!t.modifiersData[r]._skip) {
      for (
        var n = e.mainAxis,
          s = n === void 0 ? !0 : n,
          o = e.altAxis,
          a = o === void 0 ? !0 : o,
          u = e.fallbackPlacements,
          f = e.padding,
          l = e.boundary,
          h = e.rootBoundary,
          _ = e.altBoundary,
          d = e.flipVariations,
          g = d === void 0 ? !0 : d,
          m = e.allowedAutoPlacements,
          v = t.options.placement,
          T = M(v),
          N = T === v,
          S = u || (N || !g ? [qt(v)] : Un(v)),
          E = [v].concat(S).reduce(function (Ft, dt) {
            return Ft.concat(
              M(dt) === de
                ? hi(t, {
                    placement: dt,
                    boundary: l,
                    rootBoundary: h,
                    padding: f,
                    flipVariations: g,
                    allowedAutoPlacements: m,
                  })
                : dt,
            );
          }, []),
          b = t.rects.reference,
          A = t.rects.popper,
          O = new Map(),
          R = !0,
          I = E[0],
          x = 0;
        x < E.length;
        x++
      ) {
        var V = E[x],
          J = M(V),
          W = z(V) === rt,
          Tt = [w, L].indexOf(J) >= 0,
          yt = Tt ? "width" : "height",
          K = j(t, {
            placement: V,
            boundary: l,
            rootBoundary: h,
            altBoundary: _,
            padding: f,
          }),
          tt = Tt ? (W ? D : C) : W ? L : w;
        b[yt] > A[yt] && (tt = qt(tt));
        var Se = qt(tt),
          wt = [];
        if (
          (s && wt.push(K[J] <= 0),
          a && wt.push(K[tt] <= 0, K[Se] <= 0),
          wt.every(function (Ft) {
            return Ft;
          }))
        ) {
          (I = V), (R = !1);
          break;
        }
        O.set(V, wt);
      }
      if (R)
        for (
          var De = g ? 3 : 1,
            ri = function (dt) {
              var fe = E.find(function (xe) {
                var Ot = O.get(xe);
                if (Ot)
                  return Ot.slice(0, dt).every(function (ni) {
                    return ni;
                  });
              });
              if (fe) return (I = fe), "break";
            },
            ue = De;
          ue > 0;
          ue--
        ) {
          var Le = ri(ue);
          if (Le === "break") break;
        }
      t.placement !== I &&
        ((t.modifiersData[r]._skip = !0), (t.placement = I), (t.reset = !0));
    }
  }
  var He = {
    name: "flip",
    enabled: !0,
    phase: "main",
    fn: Gn,
    requiresIfExists: ["offset"],
    data: { _skip: !1 },
  };
  function mr(i, t, e) {
    return (
      e === void 0 && (e = { x: 0, y: 0 }),
      {
        top: i.top - t.height - e.y,
        right: i.right - t.width + e.x,
        bottom: i.bottom - t.height + e.y,
        left: i.left - t.width - e.x,
      }
    );
  }
  function _r(i) {
    return [w, D, L, C].some(function (t) {
      return i[t] >= 0;
    });
  }
  function zn(i) {
    var t = i.state,
      e = i.name,
      r = t.rects.reference,
      n = t.rects.popper,
      s = t.modifiersData.preventOverflow,
      o = j(t, { elementContext: "reference" }),
      a = j(t, { altBoundary: !0 }),
      u = mr(o, r),
      f = mr(a, n, s),
      l = _r(u),
      h = _r(f);
    (t.modifiersData[e] = {
      referenceClippingOffsets: u,
      popperEscapeOffsets: f,
      isReferenceHidden: l,
      hasPopperEscaped: h,
    }),
      (t.attributes.popper = Object.assign({}, t.attributes.popper, {
        "data-popper-reference-hidden": l,
        "data-popper-escaped": h,
      }));
  }
  var We = {
    name: "hide",
    enabled: !0,
    phase: "main",
    requiresIfExists: ["preventOverflow"],
    fn: zn,
  };
  function qn(i, t, e) {
    var r = M(i),
      n = [C, w].indexOf(r) >= 0 ? -1 : 1,
      s =
        typeof e == "function" ? e(Object.assign({}, t, { placement: i })) : e,
      o = s[0],
      a = s[1];
    return (
      (o = o || 0),
      (a = (a || 0) * n),
      [C, D].indexOf(r) >= 0 ? { x: a, y: o } : { x: o, y: a }
    );
  }
  function Xn(i) {
    var t = i.state,
      e = i.options,
      r = i.name,
      n = e.offset,
      s = n === void 0 ? [0, 0] : n,
      o = he.reduce(function (l, h) {
        return (l[h] = qn(h, t.rects, s)), l;
      }, {}),
      a = o[t.placement],
      u = a.x,
      f = a.y;
    t.modifiersData.popperOffsets != null &&
      ((t.modifiersData.popperOffsets.x += u),
      (t.modifiersData.popperOffsets.y += f)),
      (t.modifiersData[r] = o);
  }
  var Be = {
    name: "offset",
    enabled: !0,
    phase: "main",
    requires: ["popperOffsets"],
    fn: Xn,
  };
  function Qn(i) {
    var t = i.state,
      e = i.name;
    t.modifiersData[e] = be({
      reference: t.rects.reference,
      element: t.rects.popper,
      strategy: "absolute",
      placement: t.placement,
    });
  }
  var Qt = {
    name: "popperOffsets",
    enabled: !0,
    phase: "read",
    fn: Qn,
    data: {},
  };
  function mi(i) {
    return i === "x" ? "y" : "x";
  }
  function Zn(i) {
    var t = i.state,
      e = i.options,
      r = i.name,
      n = e.mainAxis,
      s = n === void 0 ? !0 : n,
      o = e.altAxis,
      a = o === void 0 ? !1 : o,
      u = e.boundary,
      f = e.rootBoundary,
      l = e.altBoundary,
      h = e.padding,
      _ = e.tether,
      d = _ === void 0 ? !0 : _,
      g = e.tetherOffset,
      m = g === void 0 ? 0 : g,
      v = j(t, { boundary: u, rootBoundary: f, padding: h, altBoundary: l }),
      T = M(t.placement),
      N = z(t.placement),
      S = !N,
      E = Lt(T),
      b = mi(E),
      A = t.modifiersData.popperOffsets,
      O = t.rects.reference,
      R = t.rects.popper,
      I =
        typeof m == "function"
          ? m(Object.assign({}, t.rects, { placement: t.placement }))
          : m,
      x =
        typeof I == "number"
          ? { mainAxis: I, altAxis: I }
          : Object.assign({ mainAxis: 0, altAxis: 0 }, I),
      V = t.modifiersData.offset ? t.modifiersData.offset[t.placement] : null,
      J = { x: 0, y: 0 };
    if (A) {
      if (s) {
        var W,
          Tt = E === "y" ? w : C,
          yt = E === "y" ? L : D,
          K = E === "y" ? "height" : "width",
          tt = A[E],
          Se = tt + v[Tt],
          wt = tt - v[yt],
          De = d ? -R[K] / 2 : 0,
          ri = N === rt ? O[K] : R[K],
          ue = N === rt ? -R[K] : -O[K],
          Le = t.elements.arrow,
          Ft = d && Le ? Dt(Le) : { width: 0, height: 0 },
          dt = t.modifiersData["arrow#persistent"]
            ? t.modifiersData["arrow#persistent"].padding
            : ge(),
          fe = dt[Tt],
          xe = dt[yt],
          Ot = xt(0, O[K], Ft[K]),
          ni = S
            ? O[K] / 2 - De - Ot - fe - x.mainAxis
            : ri - Ot - fe - x.mainAxis,
          An = S
            ? -O[K] / 2 + De + Ot + xe + x.mainAxis
            : ue + Ot + xe + x.mainAxis,
          si = t.elements.arrow && it(t.elements.arrow),
          Tn = si ? (E === "y" ? si.clientTop || 0 : si.clientLeft || 0) : 0,
          Ki = (W = V == null ? void 0 : V[E]) != null ? W : 0,
          yn = tt + ni - Ki - Tn,
          wn = tt + An - Ki,
          Yi = xt(d ? St(Se, yn) : Se, tt, d ? et(wt, wn) : wt);
        (A[E] = Yi), (J[E] = Yi - tt);
      }
      if (a) {
        var Ui,
          On = E === "x" ? w : C,
          Cn = E === "x" ? L : D,
          Ct = A[b],
          $e = b === "y" ? "height" : "width",
          Gi = Ct + v[On],
          zi = Ct - v[Cn],
          oi = [w, C].indexOf(T) !== -1,
          qi = (Ui = V == null ? void 0 : V[b]) != null ? Ui : 0,
          Xi = oi ? Gi : Ct - O[$e] - R[$e] - qi + x.altAxis,
          Qi = oi ? Ct + O[$e] + R[$e] - qi - x.altAxis : zi,
          Zi = d && oi ? dr(Xi, Ct, Qi) : xt(d ? Xi : Gi, Ct, d ? Qi : zi);
        (A[b] = Zi), (J[b] = Zi - Ct);
      }
      t.modifiersData[r] = J;
    }
  }
  var je = {
    name: "preventOverflow",
    enabled: !0,
    phase: "main",
    fn: Zn,
    requiresIfExists: ["offset"],
  };
  function _i(i) {
    return { scrollLeft: i.scrollLeft, scrollTop: i.scrollTop };
  }
  function gi(i) {
    return i === y(i) || !$(i) ? $t(i) : _i(i);
  }
  function Jn(i) {
    var t = i.getBoundingClientRect(),
      e = at(t.width) / i.offsetWidth || 1,
      r = at(t.height) / i.offsetHeight || 1;
    return e !== 1 || r !== 1;
  }
  function Ei(i, t, e) {
    e === void 0 && (e = !1);
    var r = $(t),
      n = $(t) && Jn(t),
      s = k(t),
      o = G(i, n, e),
      a = { scrollLeft: 0, scrollTop: 0 },
      u = { x: 0, y: 0 };
    return (
      (r || (!r && !e)) &&
        ((P(t) !== "body" || Pt(s)) && (a = gi(t)),
        $(t)
          ? ((u = G(t, !0)), (u.x += t.clientLeft), (u.y += t.clientTop))
          : s && (u.x = It(s))),
      {
        x: o.left + a.scrollLeft - u.x,
        y: o.top + a.scrollTop - u.y,
        width: o.width,
        height: o.height,
      }
    );
  }
  function ts(i) {
    var t = new Map(),
      e = new Set(),
      r = [];
    i.forEach(function (s) {
      t.set(s.name, s);
    });
    function n(s) {
      e.add(s.name);
      var o = [].concat(s.requires || [], s.requiresIfExists || []);
      o.forEach(function (a) {
        if (!e.has(a)) {
          var u = t.get(a);
          u && n(u);
        }
      }),
        r.push(s);
    }
    return (
      i.forEach(function (s) {
        e.has(s.name) || n(s);
      }),
      r
    );
  }
  function vi(i) {
    var t = ts(i);
    return ci.reduce(function (e, r) {
      return e.concat(
        t.filter(function (n) {
          return n.phase === r;
        }),
      );
    }, []);
  }
  function bi(i) {
    var t;
    return function () {
      return (
        t ||
          (t = new Promise(function (e) {
            Promise.resolve().then(function () {
              (t = void 0), e(i());
            });
          })),
        t
      );
    };
  }
  function Ai(i) {
    var t = i.reduce(function (e, r) {
      var n = e[r.name];
      return (
        (e[r.name] = n
          ? Object.assign({}, n, r, {
              options: Object.assign({}, n.options, r.options),
              data: Object.assign({}, n.data, r.data),
            })
          : r),
        e
      );
    }, {});
    return Object.keys(t).map(function (e) {
      return t[e];
    });
  }
  var gr = { placement: "bottom", modifiers: [], strategy: "absolute" };
  function Er() {
    for (var i = arguments.length, t = new Array(i), e = 0; e < i; e++)
      t[e] = arguments[e];
    return !t.some(function (r) {
      return !(r && typeof r.getBoundingClientRect == "function");
    });
  }
  function Mt(i) {
    i === void 0 && (i = {});
    var t = i,
      e = t.defaultModifiers,
      r = e === void 0 ? [] : e,
      n = t.defaultOptions,
      s = n === void 0 ? gr : n;
    return function (a, u, f) {
      f === void 0 && (f = s);
      var l = {
          placement: "bottom",
          orderedModifiers: [],
          options: Object.assign({}, gr, s),
          modifiersData: {},
          elements: { reference: a, popper: u },
          attributes: {},
          styles: {},
        },
        h = [],
        _ = !1,
        d = {
          state: l,
          setOptions: function (T) {
            var N = typeof T == "function" ? T(l.options) : T;
            m(),
              (l.options = Object.assign({}, s, l.options, N)),
              (l.scrollParents = {
                reference: U(a)
                  ? ht(a)
                  : a.contextElement
                    ? ht(a.contextElement)
                    : [],
                popper: ht(u),
              });
            var S = vi(Ai([].concat(r, l.options.modifiers)));
            return (
              (l.orderedModifiers = S.filter(function (E) {
                return E.enabled;
              })),
              g(),
              d.update()
            );
          },
          forceUpdate: function () {
            if (!_) {
              var T = l.elements,
                N = T.reference,
                S = T.popper;
              if (Er(N, S)) {
                (l.rects = {
                  reference: Ei(N, it(S), l.options.strategy === "fixed"),
                  popper: Dt(S),
                }),
                  (l.reset = !1),
                  (l.placement = l.options.placement),
                  l.orderedModifiers.forEach(function (x) {
                    return (l.modifiersData[x.name] = Object.assign(
                      {},
                      x.data,
                    ));
                  });
                for (var E = 0; E < l.orderedModifiers.length; E++) {
                  if (l.reset === !0) {
                    (l.reset = !1), (E = -1);
                    continue;
                  }
                  var b = l.orderedModifiers[E],
                    A = b.fn,
                    O = b.options,
                    R = O === void 0 ? {} : O,
                    I = b.name;
                  typeof A == "function" &&
                    (l =
                      A({ state: l, options: R, name: I, instance: d }) || l);
                }
              }
            }
          },
          update: bi(function () {
            return new Promise(function (v) {
              d.forceUpdate(), v(l);
            });
          }),
          destroy: function () {
            m(), (_ = !0);
          },
        };
      if (!Er(a, u)) return d;
      d.setOptions(f).then(function (v) {
        !_ && f.onFirstUpdate && f.onFirstUpdate(v);
      });
      function g() {
        l.orderedModifiers.forEach(function (v) {
          var T = v.name,
            N = v.options,
            S = N === void 0 ? {} : N,
            E = v.effect;
          if (typeof E == "function") {
            var b = E({ state: l, name: T, instance: d, options: S }),
              A = function () {};
            h.push(b || A);
          }
        });
      }
      function m() {
        h.forEach(function (v) {
          return v();
        }),
          (h = []);
      }
      return d;
    };
  }
  var vr = Mt();
  var es = [zt, Qt, Gt, Yt],
    br = Mt({ defaultModifiers: es });
  var is = [zt, Qt, Gt, Yt, Be, He, je, Me, We],
    Ae = Mt({ defaultModifiers: is });
  var mt = new Map(),
    Ti = {
      set(i, t, e) {
        mt.has(i) || mt.set(i, new Map());
        let r = mt.get(i);
        if (!r.has(t) && r.size !== 0) {
          console.error(
            `Bootstrap doesn't allow more than one instance per element. Bound instance: ${
              Array.from(r.keys())[0]
            }.`,
          );
          return;
        }
        r.set(t, e);
      },
      get(i, t) {
        return (mt.has(i) && mt.get(i).get(t)) || null;
      },
      remove(i, t) {
        if (!mt.has(i)) return;
        let e = mt.get(i);
        e.delete(t), e.size === 0 && mt.delete(i);
      },
    },
    rs = 1e6,
    ns = 1e3,
    Ri = "transitionend",
    zr = (i) => (
      i &&
        window.CSS &&
        window.CSS.escape &&
        (i = i.replace(/#([^\s"#']+)/g, (t, e) => `#${CSS.escape(e)}`)),
      i
    ),
    ss = (i) =>
      i == null
        ? `${i}`
        : Object.prototype.toString
            .call(i)
            .match(/\s([a-z]+)/i)[1]
            .toLowerCase(),
    os = (i) => {
      do i += Math.floor(Math.random() * rs);
      while (document.getElementById(i));
      return i;
    },
    as = (i) => {
      if (!i) return 0;
      let { transitionDuration: t, transitionDelay: e } =
          window.getComputedStyle(i),
        r = Number.parseFloat(t),
        n = Number.parseFloat(e);
      return !r && !n
        ? 0
        : ((t = t.split(",")[0]),
          (e = e.split(",")[0]),
          (Number.parseFloat(t) + Number.parseFloat(e)) * ns);
    },
    qr = (i) => {
      i.dispatchEvent(new Event(Ri));
    },
    ct = (i) =>
      !i || typeof i != "object"
        ? !1
        : (typeof i.jquery != "undefined" && (i = i[0]),
          typeof i.nodeType != "undefined"),
    _t = (i) =>
      ct(i)
        ? i.jquery
          ? i[0]
          : i
        : typeof i == "string" && i.length > 0
          ? document.querySelector(zr(i))
          : null,
    le = (i) => {
      if (!ct(i) || i.getClientRects().length === 0) return !1;
      let t = getComputedStyle(i).getPropertyValue("visibility") === "visible",
        e = i.closest("details:not([open])");
      if (!e) return t;
      if (e !== i) {
        let r = i.closest("summary");
        if ((r && r.parentNode !== e) || r === null) return !1;
      }
      return t;
    },
    gt = (i) =>
      !i || i.nodeType !== Node.ELEMENT_NODE || i.classList.contains("disabled")
        ? !0
        : typeof i.disabled != "undefined"
          ? i.disabled
          : i.hasAttribute("disabled") &&
            i.getAttribute("disabled") !== "false",
    Xr = (i) => {
      if (!document.documentElement.attachShadow) return null;
      if (typeof i.getRootNode == "function") {
        let t = i.getRootNode();
        return t instanceof ShadowRoot ? t : null;
      }
      return i instanceof ShadowRoot
        ? i
        : i.parentNode
          ? Xr(i.parentNode)
          : null;
    },
    Ze = () => {},
    Ce = (i) => {
      i.offsetHeight;
    },
    Qr = () =>
      window.jQuery && !document.body.hasAttribute("data-bs-no-jquery")
        ? window.jQuery
        : null,
    yi = [],
    ls = (i) => {
      document.readyState === "loading"
        ? (yi.length ||
            document.addEventListener("DOMContentLoaded", () => {
              for (let t of yi) t();
            }),
          yi.push(i))
        : i();
    },
    X = () => document.documentElement.dir === "rtl",
    Z = (i) => {
      ls(() => {
        let t = Qr();
        if (t) {
          let e = i.NAME,
            r = t.fn[e];
          (t.fn[e] = i.jQueryInterface),
            (t.fn[e].Constructor = i),
            (t.fn[e].noConflict = () => ((t.fn[e] = r), i.jQueryInterface));
        }
      });
    },
    F = (i, t = [], e = i) => (typeof i == "function" ? i(...t) : e),
    Zr = (i, t, e = !0) => {
      if (!e) {
        F(i);
        return;
      }
      let r = 5,
        n = as(t) + r,
        s = !1,
        o = ({ target: a }) => {
          a === t && ((s = !0), t.removeEventListener(Ri, o), F(i));
        };
      t.addEventListener(Ri, o),
        setTimeout(() => {
          s || qr(t);
        }, n);
    },
    Wi = (i, t, e, r) => {
      let n = i.length,
        s = i.indexOf(t);
      return s === -1
        ? !e && r
          ? i[n - 1]
          : i[0]
        : ((s += e ? 1 : -1),
          r && (s = (s + n) % n),
          i[Math.max(0, Math.min(s, n - 1))]);
    },
    cs = /[^.]*(?=\..*)\.|.*/,
    us = /\..*/,
    fs = /::\d+$/,
    wi = {},
    Ar = 1,
    Jr = { mouseenter: "mouseover", mouseleave: "mouseout" },
    ds = new Set([
      "click",
      "dblclick",
      "mouseup",
      "mousedown",
      "contextmenu",
      "mousewheel",
      "DOMMouseScroll",
      "mouseover",
      "mouseout",
      "mousemove",
      "selectstart",
      "selectend",
      "keydown",
      "keypress",
      "keyup",
      "orientationchange",
      "touchstart",
      "touchmove",
      "touchend",
      "touchcancel",
      "pointerdown",
      "pointermove",
      "pointerup",
      "pointerleave",
      "pointercancel",
      "gesturestart",
      "gesturechange",
      "gestureend",
      "focus",
      "blur",
      "change",
      "reset",
      "select",
      "submit",
      "focusin",
      "focusout",
      "load",
      "unload",
      "beforeunload",
      "resize",
      "move",
      "DOMContentLoaded",
      "readystatechange",
      "error",
      "abort",
      "scroll",
    ]);
  function tn(i, t) {
    return (t && `${t}::${Ar++}`) || i.uidEvent || Ar++;
  }
  function en(i) {
    let t = tn(i);
    return (i.uidEvent = t), (wi[t] = wi[t] || {}), wi[t];
  }
  function ps(i, t) {
    return function e(r) {
      return (
        Bi(r, { delegateTarget: i }),
        e.oneOff && c.off(i, r.type, t),
        t.apply(i, [r])
      );
    };
  }
  function hs(i, t, e) {
    return function r(n) {
      let s = i.querySelectorAll(t);
      for (let { target: o } = n; o && o !== this; o = o.parentNode)
        for (let a of s)
          if (a === o)
            return (
              Bi(n, { delegateTarget: o }),
              r.oneOff && c.off(i, n.type, t, e),
              e.apply(o, [n])
            );
    };
  }
  function rn(i, t, e = null) {
    return Object.values(i).find(
      (r) => r.callable === t && r.delegationSelector === e,
    );
  }
  function nn(i, t, e) {
    let r = typeof t == "string",
      n = r ? e : t || e,
      s = sn(i);
    return ds.has(s) || (s = i), [r, n, s];
  }
  function Tr(i, t, e, r, n) {
    if (typeof t != "string" || !i) return;
    let [s, o, a] = nn(t, e, r);
    t in Jr &&
      (o = ((g) =>
        function (m) {
          if (
            !m.relatedTarget ||
            (m.relatedTarget !== m.delegateTarget &&
              !m.delegateTarget.contains(m.relatedTarget))
          )
            return g.call(this, m);
        })(o));
    let u = en(i),
      f = u[a] || (u[a] = {}),
      l = rn(f, o, s ? e : null);
    if (l) {
      l.oneOff = l.oneOff && n;
      return;
    }
    let h = tn(o, t.replace(cs, "")),
      _ = s ? hs(i, e, o) : ps(i, o);
    (_.delegationSelector = s ? e : null),
      (_.callable = o),
      (_.oneOff = n),
      (_.uidEvent = h),
      (f[h] = _),
      i.addEventListener(a, _, s);
  }
  function ki(i, t, e, r, n) {
    let s = rn(t[e], r, n);
    s && (i.removeEventListener(e, s, Boolean(n)), delete t[e][s.uidEvent]);
  }
  function ms(i, t, e, r) {
    let n = t[e] || {};
    for (let [s, o] of Object.entries(n))
      s.includes(r) && ki(i, t, e, o.callable, o.delegationSelector);
  }
  function sn(i) {
    return (i = i.replace(us, "")), Jr[i] || i;
  }
  var c = {
    on(i, t, e, r) {
      Tr(i, t, e, r, !1);
    },
    one(i, t, e, r) {
      Tr(i, t, e, r, !0);
    },
    off(i, t, e, r) {
      if (typeof t != "string" || !i) return;
      let [n, s, o] = nn(t, e, r),
        a = o !== t,
        u = en(i),
        f = u[o] || {},
        l = t.startsWith(".");
      if (typeof s != "undefined") {
        if (!Object.keys(f).length) return;
        ki(i, u, o, s, n ? e : null);
        return;
      }
      if (l) for (let h of Object.keys(u)) ms(i, u, h, t.slice(1));
      for (let [h, _] of Object.entries(f)) {
        let d = h.replace(fs, "");
        (!a || t.includes(d)) && ki(i, u, o, _.callable, _.delegationSelector);
      }
    },
    trigger(i, t, e) {
      if (typeof t != "string" || !i) return null;
      let r = Qr(),
        n = sn(t),
        s = t !== n,
        o = null,
        a = !0,
        u = !0,
        f = !1;
      s &&
        r &&
        ((o = r.Event(t, e)),
        r(i).trigger(o),
        (a = !o.isPropagationStopped()),
        (u = !o.isImmediatePropagationStopped()),
        (f = o.isDefaultPrevented()));
      let l = Bi(new Event(t, { bubbles: a, cancelable: !0 }), e);
      return (
        f && l.preventDefault(),
        u && i.dispatchEvent(l),
        l.defaultPrevented && o && o.preventDefault(),
        l
      );
    },
  };
  function Bi(i, t = {}) {
    for (let [e, r] of Object.entries(t))
      try {
        i[e] = r;
      } catch (n) {
        Object.defineProperty(i, e, {
          configurable: !0,
          get() {
            return r;
          },
        });
      }
    return i;
  }
  function yr(i) {
    if (i === "true") return !0;
    if (i === "false") return !1;
    if (i === Number(i).toString()) return Number(i);
    if (i === "" || i === "null") return null;
    if (typeof i != "string") return i;
    try {
      return JSON.parse(decodeURIComponent(i));
    } catch (t) {
      return i;
    }
  }
  function Oi(i) {
    return i.replace(/[A-Z]/g, (t) => `-${t.toLowerCase()}`);
  }
  var ut = {
      setDataAttribute(i, t, e) {
        i.setAttribute(`data-bs-${Oi(t)}`, e);
      },
      removeDataAttribute(i, t) {
        i.removeAttribute(`data-bs-${Oi(t)}`);
      },
      getDataAttributes(i) {
        if (!i) return {};
        let t = {},
          e = Object.keys(i.dataset).filter(
            (r) => r.startsWith("bs") && !r.startsWith("bsConfig"),
          );
        for (let r of e) {
          let n = r.replace(/^bs/, "");
          (n = n.charAt(0).toLowerCase() + n.slice(1, n.length)),
            (t[n] = yr(i.dataset[r]));
        }
        return t;
      },
      getDataAttribute(i, t) {
        return yr(i.getAttribute(`data-bs-${Oi(t)}`));
      },
    },
    Vt = class {
      static get Default() {
        return {};
      }
      static get DefaultType() {
        return {};
      }
      static get NAME() {
        throw new Error(
          'You have to implement the static method "NAME", for each component!',
        );
      }
      _getConfig(t) {
        return (
          (t = this._mergeConfigObj(t)),
          (t = this._configAfterMerge(t)),
          this._typeCheckConfig(t),
          t
        );
      }
      _configAfterMerge(t) {
        return t;
      }
      _mergeConfigObj(t, e) {
        let r = ct(e) ? ut.getDataAttribute(e, "config") : {};
        return H(
          H(
            H(H({}, this.constructor.Default), typeof r == "object" ? r : {}),
            ct(e) ? ut.getDataAttributes(e) : {},
          ),
          typeof t == "object" ? t : {},
        );
      }
      _typeCheckConfig(t, e = this.constructor.DefaultType) {
        for (let [r, n] of Object.entries(e)) {
          let s = t[r],
            o = ct(s) ? "element" : ss(s);
          if (!new RegExp(n).test(o))
            throw new TypeError(
              `${this.constructor.NAME.toUpperCase()}: Option "${r}" provided type "${o}" but expected type "${n}".`,
            );
        }
      }
    },
    _s = "5.3.0",
    Y = class extends Vt {
      constructor(t, e) {
        super(),
          (t = _t(t)),
          t &&
            ((this._element = t),
            (this._config = this._getConfig(e)),
            Ti.set(this._element, this.constructor.DATA_KEY, this));
      }
      dispose() {
        Ti.remove(this._element, this.constructor.DATA_KEY),
          c.off(this._element, this.constructor.EVENT_KEY);
        for (let t of Object.getOwnPropertyNames(this)) this[t] = null;
      }
      _queueCallback(t, e, r = !0) {
        Zr(t, e, r);
      }
      _getConfig(t) {
        return (
          (t = this._mergeConfigObj(t, this._element)),
          (t = this._configAfterMerge(t)),
          this._typeCheckConfig(t),
          t
        );
      }
      static getInstance(t) {
        return Ti.get(_t(t), this.DATA_KEY);
      }
      static getOrCreateInstance(t, e = {}) {
        return (
          this.getInstance(t) || new this(t, typeof e == "object" ? e : null)
        );
      }
      static get VERSION() {
        return _s;
      }
      static get DATA_KEY() {
        return `bs.${this.NAME}`;
      }
      static get EVENT_KEY() {
        return `.${this.DATA_KEY}`;
      }
      static eventName(t) {
        return `${t}${this.EVENT_KEY}`;
      }
    },
    Ci = (i) => {
      let t = i.getAttribute("data-bs-target");
      if (!t || t === "#") {
        let e = i.getAttribute("href");
        if (!e || (!e.includes("#") && !e.startsWith("."))) return null;
        e.includes("#") && !e.startsWith("#") && (e = `#${e.split("#")[1]}`),
          (t = e && e !== "#" ? e.trim() : null);
      }
      return zr(t);
    },
    p = {
      find(i, t = document.documentElement) {
        return [].concat(...Element.prototype.querySelectorAll.call(t, i));
      },
      findOne(i, t = document.documentElement) {
        return Element.prototype.querySelector.call(t, i);
      },
      children(i, t) {
        return [].concat(...i.children).filter((e) => e.matches(t));
      },
      parents(i, t) {
        let e = [],
          r = i.parentNode.closest(t);
        for (; r; ) e.push(r), (r = r.parentNode.closest(t));
        return e;
      },
      prev(i, t) {
        let e = i.previousElementSibling;
        for (; e; ) {
          if (e.matches(t)) return [e];
          e = e.previousElementSibling;
        }
        return [];
      },
      next(i, t) {
        let e = i.nextElementSibling;
        for (; e; ) {
          if (e.matches(t)) return [e];
          e = e.nextElementSibling;
        }
        return [];
      },
      focusableChildren(i) {
        let t = [
          "a",
          "button",
          "input",
          "textarea",
          "select",
          "details",
          "[tabindex]",
          '[contenteditable="true"]',
        ]
          .map((e) => `${e}:not([tabindex^="-"])`)
          .join(",");
        return this.find(t, i).filter((e) => !gt(e) && le(e));
      },
      getSelectorFromElement(i) {
        let t = Ci(i);
        return t && p.findOne(t) ? t : null;
      },
      getElementFromSelector(i) {
        let t = Ci(i);
        return t ? p.findOne(t) : null;
      },
      getMultipleElementsFromSelector(i) {
        let t = Ci(i);
        return t ? p.find(t) : [];
      },
    },
    ii = (i, t = "hide") => {
      let e = `click.dismiss${i.EVENT_KEY}`,
        r = i.NAME;
      c.on(document, e, `[data-bs-dismiss="${r}"]`, function (n) {
        if (
          (["A", "AREA"].includes(this.tagName) && n.preventDefault(), gt(this))
        )
          return;
        let s = p.getElementFromSelector(this) || this.closest(`.${r}`);
        i.getOrCreateInstance(s)[t]();
      });
    },
    gs = "alert",
    Es = "bs.alert",
    on = `.${Es}`,
    vs = `close${on}`,
    bs = `closed${on}`,
    As = "fade",
    Ts = "show",
    re = class extends Y {
      static get NAME() {
        return gs;
      }
      close() {
        if (c.trigger(this._element, vs).defaultPrevented) return;
        this._element.classList.remove(Ts);
        let e = this._element.classList.contains(As);
        this._queueCallback(() => this._destroyElement(), this._element, e);
      }
      _destroyElement() {
        this._element.remove(), c.trigger(this._element, bs), this.dispose();
      }
      static jQueryInterface(t) {
        return this.each(function () {
          let e = re.getOrCreateInstance(this);
          if (typeof t == "string") {
            if (e[t] === void 0 || t.startsWith("_") || t === "constructor")
              throw new TypeError(`No method named "${t}"`);
            e[t](this);
          }
        });
      }
    };
  ii(re, "close");
  Z(re);
  var ys = "button",
    ws = "bs.button",
    Os = `.${ws}`,
    Cs = ".data-api",
    Ns = "active",
    wr = '[data-bs-toggle="button"]',
    Ss = `click${Os}${Cs}`,
    ne = class extends Y {
      static get NAME() {
        return ys;
      }
      toggle() {
        this._element.setAttribute(
          "aria-pressed",
          this._element.classList.toggle(Ns),
        );
      }
      static jQueryInterface(t) {
        return this.each(function () {
          let e = ne.getOrCreateInstance(this);
          t === "toggle" && e[t]();
        });
      }
    };
  c.on(document, Ss, wr, (i) => {
    i.preventDefault();
    let t = i.target.closest(wr);
    ne.getOrCreateInstance(t).toggle();
  });
  Z(ne);
  var Ds = "swipe",
    ce = ".bs.swipe",
    Ls = `touchstart${ce}`,
    xs = `touchmove${ce}`,
    $s = `touchend${ce}`,
    Is = `pointerdown${ce}`,
    Ps = `pointerup${ce}`,
    Ms = "touch",
    Rs = "pen",
    ks = "pointer-event",
    Vs = 40,
    Hs = { endCallback: null, leftCallback: null, rightCallback: null },
    Ws = {
      endCallback: "(function|null)",
      leftCallback: "(function|null)",
      rightCallback: "(function|null)",
    },
    se = class extends Vt {
      constructor(t, e) {
        super(),
          (this._element = t),
          !(!t || !se.isSupported()) &&
            ((this._config = this._getConfig(e)),
            (this._deltaX = 0),
            (this._supportPointerEvents = Boolean(window.PointerEvent)),
            this._initEvents());
      }
      static get Default() {
        return Hs;
      }
      static get DefaultType() {
        return Ws;
      }
      static get NAME() {
        return Ds;
      }
      dispose() {
        c.off(this._element, ce);
      }
      _start(t) {
        if (!this._supportPointerEvents) {
          this._deltaX = t.touches[0].clientX;
          return;
        }
        this._eventIsPointerPenTouch(t) && (this._deltaX = t.clientX);
      }
      _end(t) {
        this._eventIsPointerPenTouch(t) &&
          (this._deltaX = t.clientX - this._deltaX),
          this._handleSwipe(),
          F(this._config.endCallback);
      }
      _move(t) {
        this._deltaX =
          t.touches && t.touches.length > 1
            ? 0
            : t.touches[0].clientX - this._deltaX;
      }
      _handleSwipe() {
        let t = Math.abs(this._deltaX);
        if (t <= Vs) return;
        let e = t / this._deltaX;
        (this._deltaX = 0),
          e &&
            F(e > 0 ? this._config.rightCallback : this._config.leftCallback);
      }
      _initEvents() {
        this._supportPointerEvents
          ? (c.on(this._element, Is, (t) => this._start(t)),
            c.on(this._element, Ps, (t) => this._end(t)),
            this._element.classList.add(ks))
          : (c.on(this._element, Ls, (t) => this._start(t)),
            c.on(this._element, xs, (t) => this._move(t)),
            c.on(this._element, $s, (t) => this._end(t)));
      }
      _eventIsPointerPenTouch(t) {
        return (
          this._supportPointerEvents &&
          (t.pointerType === Rs || t.pointerType === Ms)
        );
      }
      static isSupported() {
        return (
          "ontouchstart" in document.documentElement ||
          navigator.maxTouchPoints > 0
        );
      }
    },
    Bs = "carousel",
    js = "bs.carousel",
    bt = `.${js}`,
    an = ".data-api",
    Fs = "ArrowLeft",
    Ks = "ArrowRight",
    Ys = 500,
    Te = "next",
    Zt = "prev",
    te = "left",
    Xe = "right",
    Us = `slide${bt}`,
    Ni = `slid${bt}`,
    Gs = `keydown${bt}`,
    zs = `mouseenter${bt}`,
    qs = `mouseleave${bt}`,
    Xs = `dragstart${bt}`,
    Qs = `load${bt}${an}`,
    Zs = `click${bt}${an}`,
    ln = "carousel",
    Ke = "active",
    Js = "slide",
    to = "carousel-item-end",
    eo = "carousel-item-start",
    io = "carousel-item-next",
    ro = "carousel-item-prev",
    cn = ".active",
    un = ".carousel-item",
    no = cn + un,
    so = ".carousel-item img",
    oo = ".carousel-indicators",
    ao = "[data-bs-slide], [data-bs-slide-to]",
    lo = '[data-bs-ride="carousel"]',
    co = { [Fs]: Xe, [Ks]: te },
    uo = {
      interval: 5e3,
      keyboard: !0,
      pause: "hover",
      ride: !1,
      touch: !0,
      wrap: !0,
    },
    fo = {
      interval: "(number|boolean)",
      keyboard: "boolean",
      pause: "(string|boolean)",
      ride: "(boolean|string)",
      touch: "boolean",
      wrap: "boolean",
    },
    Ht = class extends Y {
      constructor(t, e) {
        super(t, e),
          (this._interval = null),
          (this._activeElement = null),
          (this._isSliding = !1),
          (this.touchTimeout = null),
          (this._swipeHelper = null),
          (this._indicatorsElement = p.findOne(oo, this._element)),
          this._addEventListeners(),
          this._config.ride === ln && this.cycle();
      }
      static get Default() {
        return uo;
      }
      static get DefaultType() {
        return fo;
      }
      static get NAME() {
        return Bs;
      }
      next() {
        this._slide(Te);
      }
      nextWhenVisible() {
        !document.hidden && le(this._element) && this.next();
      }
      prev() {
        this._slide(Zt);
      }
      pause() {
        this._isSliding && qr(this._element), this._clearInterval();
      }
      cycle() {
        this._clearInterval(),
          this._updateInterval(),
          (this._interval = setInterval(
            () => this.nextWhenVisible(),
            this._config.interval,
          ));
      }
      _maybeEnableCycle() {
        if (this._config.ride) {
          if (this._isSliding) {
            c.one(this._element, Ni, () => this.cycle());
            return;
          }
          this.cycle();
        }
      }
      to(t) {
        let e = this._getItems();
        if (t > e.length - 1 || t < 0) return;
        if (this._isSliding) {
          c.one(this._element, Ni, () => this.to(t));
          return;
        }
        let r = this._getItemIndex(this._getActive());
        if (r === t) return;
        let n = t > r ? Te : Zt;
        this._slide(n, e[t]);
      }
      dispose() {
        this._swipeHelper && this._swipeHelper.dispose(), super.dispose();
      }
      _configAfterMerge(t) {
        return (t.defaultInterval = t.interval), t;
      }
      _addEventListeners() {
        this._config.keyboard &&
          c.on(this._element, Gs, (t) => this._keydown(t)),
          this._config.pause === "hover" &&
            (c.on(this._element, zs, () => this.pause()),
            c.on(this._element, qs, () => this._maybeEnableCycle())),
          this._config.touch &&
            se.isSupported() &&
            this._addTouchEventListeners();
      }
      _addTouchEventListeners() {
        for (let r of p.find(so, this._element))
          c.on(r, Xs, (n) => n.preventDefault());
        let e = {
          leftCallback: () => this._slide(this._directionToOrder(te)),
          rightCallback: () => this._slide(this._directionToOrder(Xe)),
          endCallback: () => {
            this._config.pause === "hover" &&
              (this.pause(),
              this.touchTimeout && clearTimeout(this.touchTimeout),
              (this.touchTimeout = setTimeout(
                () => this._maybeEnableCycle(),
                Ys + this._config.interval,
              )));
          },
        };
        this._swipeHelper = new se(this._element, e);
      }
      _keydown(t) {
        if (/input|textarea/i.test(t.target.tagName)) return;
        let e = co[t.key];
        e && (t.preventDefault(), this._slide(this._directionToOrder(e)));
      }
      _getItemIndex(t) {
        return this._getItems().indexOf(t);
      }
      _setActiveIndicatorElement(t) {
        if (!this._indicatorsElement) return;
        let e = p.findOne(cn, this._indicatorsElement);
        e.classList.remove(Ke), e.removeAttribute("aria-current");
        let r = p.findOne(`[data-bs-slide-to="${t}"]`, this._indicatorsElement);
        r && (r.classList.add(Ke), r.setAttribute("aria-current", "true"));
      }
      _updateInterval() {
        let t = this._activeElement || this._getActive();
        if (!t) return;
        let e = Number.parseInt(t.getAttribute("data-bs-interval"), 10);
        this._config.interval = e || this._config.defaultInterval;
      }
      _slide(t, e = null) {
        if (this._isSliding) return;
        let r = this._getActive(),
          n = t === Te,
          s = e || Wi(this._getItems(), r, n, this._config.wrap);
        if (s === r) return;
        let o = this._getItemIndex(s),
          a = (d) =>
            c.trigger(this._element, d, {
              relatedTarget: s,
              direction: this._orderToDirection(t),
              from: this._getItemIndex(r),
              to: o,
            });
        if (a(Us).defaultPrevented || !r || !s) return;
        let f = Boolean(this._interval);
        this.pause(),
          (this._isSliding = !0),
          this._setActiveIndicatorElement(o),
          (this._activeElement = s);
        let l = n ? eo : to,
          h = n ? io : ro;
        s.classList.add(h), Ce(s), r.classList.add(l), s.classList.add(l);
        let _ = () => {
          s.classList.remove(l, h),
            s.classList.add(Ke),
            r.classList.remove(Ke, h, l),
            (this._isSliding = !1),
            a(Ni);
        };
        this._queueCallback(_, r, this._isAnimated()), f && this.cycle();
      }
      _isAnimated() {
        return this._element.classList.contains(Js);
      }
      _getActive() {
        return p.findOne(no, this._element);
      }
      _getItems() {
        return p.find(un, this._element);
      }
      _clearInterval() {
        this._interval &&
          (clearInterval(this._interval), (this._interval = null));
      }
      _directionToOrder(t) {
        return X() ? (t === te ? Zt : Te) : t === te ? Te : Zt;
      }
      _orderToDirection(t) {
        return X() ? (t === Zt ? te : Xe) : t === Zt ? Xe : te;
      }
      static jQueryInterface(t) {
        return this.each(function () {
          let e = Ht.getOrCreateInstance(this, t);
          if (typeof t == "number") {
            e.to(t);
            return;
          }
          if (typeof t == "string") {
            if (e[t] === void 0 || t.startsWith("_") || t === "constructor")
              throw new TypeError(`No method named "${t}"`);
            e[t]();
          }
        });
      }
    };
  c.on(document, Zs, ao, function (i) {
    let t = p.getElementFromSelector(this);
    if (!t || !t.classList.contains(ln)) return;
    i.preventDefault();
    let e = Ht.getOrCreateInstance(t),
      r = this.getAttribute("data-bs-slide-to");
    if (r) {
      e.to(r), e._maybeEnableCycle();
      return;
    }
    if (ut.getDataAttribute(this, "slide") === "next") {
      e.next(), e._maybeEnableCycle();
      return;
    }
    e.prev(), e._maybeEnableCycle();
  });
  c.on(window, Qs, () => {
    let i = p.find(lo);
    for (let t of i) Ht.getOrCreateInstance(t);
  });
  Z(Ht);
  var po = "collapse",
    ho = "bs.collapse",
    Ne = `.${ho}`,
    mo = ".data-api",
    _o = `show${Ne}`,
    go = `shown${Ne}`,
    Eo = `hide${Ne}`,
    vo = `hidden${Ne}`,
    bo = `click${Ne}${mo}`,
    Si = "show",
    ie = "collapse",
    Ye = "collapsing",
    Ao = "collapsed",
    To = `:scope .${ie} .${ie}`,
    yo = "collapse-horizontal",
    wo = "width",
    Oo = "height",
    Co = ".collapse.show, .collapse.collapsing",
    Vi = '[data-bs-toggle="collapse"]',
    No = { parent: null, toggle: !0 },
    So = { parent: "(null|element)", toggle: "boolean" },
    Wt = class extends Y {
      constructor(t, e) {
        super(t, e), (this._isTransitioning = !1), (this._triggerArray = []);
        let r = p.find(Vi);
        for (let n of r) {
          let s = p.getSelectorFromElement(n),
            o = p.find(s).filter((a) => a === this._element);
          s !== null && o.length && this._triggerArray.push(n);
        }
        this._initializeChildren(),
          this._config.parent ||
            this._addAriaAndCollapsedClass(this._triggerArray, this._isShown()),
          this._config.toggle && this.toggle();
      }
      static get Default() {
        return No;
      }
      static get DefaultType() {
        return So;
      }
      static get NAME() {
        return po;
      }
      toggle() {
        this._isShown() ? this.hide() : this.show();
      }
      show() {
        if (this._isTransitioning || this._isShown()) return;
        let t = [];
        if (
          (this._config.parent &&
            (t = this._getFirstLevelChildren(Co)
              .filter((a) => a !== this._element)
              .map((a) => Wt.getOrCreateInstance(a, { toggle: !1 }))),
          (t.length && t[0]._isTransitioning) ||
            c.trigger(this._element, _o).defaultPrevented)
        )
          return;
        for (let a of t) a.hide();
        let r = this._getDimension();
        this._element.classList.remove(ie),
          this._element.classList.add(Ye),
          (this._element.style[r] = 0),
          this._addAriaAndCollapsedClass(this._triggerArray, !0),
          (this._isTransitioning = !0);
        let n = () => {
            (this._isTransitioning = !1),
              this._element.classList.remove(Ye),
              this._element.classList.add(ie, Si),
              (this._element.style[r] = ""),
              c.trigger(this._element, go);
          },
          o = `scroll${r[0].toUpperCase() + r.slice(1)}`;
        this._queueCallback(n, this._element, !0),
          (this._element.style[r] = `${this._element[o]}px`);
      }
      hide() {
        if (
          this._isTransitioning ||
          !this._isShown() ||
          c.trigger(this._element, Eo).defaultPrevented
        )
          return;
        let e = this._getDimension();
        (this._element.style[e] = `${
          this._element.getBoundingClientRect()[e]
        }px`),
          Ce(this._element),
          this._element.classList.add(Ye),
          this._element.classList.remove(ie, Si);
        for (let n of this._triggerArray) {
          let s = p.getElementFromSelector(n);
          s && !this._isShown(s) && this._addAriaAndCollapsedClass([n], !1);
        }
        this._isTransitioning = !0;
        let r = () => {
          (this._isTransitioning = !1),
            this._element.classList.remove(Ye),
            this._element.classList.add(ie),
            c.trigger(this._element, vo);
        };
        (this._element.style[e] = ""),
          this._queueCallback(r, this._element, !0);
      }
      _isShown(t = this._element) {
        return t.classList.contains(Si);
      }
      _configAfterMerge(t) {
        return (t.toggle = Boolean(t.toggle)), (t.parent = _t(t.parent)), t;
      }
      _getDimension() {
        return this._element.classList.contains(yo) ? wo : Oo;
      }
      _initializeChildren() {
        if (!this._config.parent) return;
        let t = this._getFirstLevelChildren(Vi);
        for (let e of t) {
          let r = p.getElementFromSelector(e);
          r && this._addAriaAndCollapsedClass([e], this._isShown(r));
        }
      }
      _getFirstLevelChildren(t) {
        let e = p.find(To, this._config.parent);
        return p.find(t, this._config.parent).filter((r) => !e.includes(r));
      }
      _addAriaAndCollapsedClass(t, e) {
        if (t.length)
          for (let r of t)
            r.classList.toggle(Ao, !e), r.setAttribute("aria-expanded", e);
      }
      static jQueryInterface(t) {
        let e = {};
        return (
          typeof t == "string" && /show|hide/.test(t) && (e.toggle = !1),
          this.each(function () {
            let r = Wt.getOrCreateInstance(this, e);
            if (typeof t == "string") {
              if (typeof r[t] == "undefined")
                throw new TypeError(`No method named "${t}"`);
              r[t]();
            }
          })
        );
      }
    };
  c.on(document, bo, Vi, function (i) {
    (i.target.tagName === "A" ||
      (i.delegateTarget && i.delegateTarget.tagName === "A")) &&
      i.preventDefault();
    for (let t of p.getMultipleElementsFromSelector(this))
      Wt.getOrCreateInstance(t, { toggle: !1 }).toggle();
  });
  Z(Wt);
  var Or = "dropdown",
    Do = "bs.dropdown",
    Bt = `.${Do}`,
    ji = ".data-api",
    Lo = "Escape",
    Cr = "Tab",
    xo = "ArrowUp",
    Nr = "ArrowDown",
    $o = 2,
    Io = `hide${Bt}`,
    Po = `hidden${Bt}`,
    Mo = `show${Bt}`,
    Ro = `shown${Bt}`,
    fn = `click${Bt}${ji}`,
    dn = `keydown${Bt}${ji}`,
    ko = `keyup${Bt}${ji}`,
    ee = "show",
    Vo = "dropup",
    Ho = "dropend",
    Wo = "dropstart",
    Bo = "dropup-center",
    jo = "dropdown-center",
    Rt = '[data-bs-toggle="dropdown"]:not(.disabled):not(:disabled)',
    Fo = `${Rt}.${ee}`,
    Qe = ".dropdown-menu",
    Ko = ".navbar",
    Yo = ".navbar-nav",
    Uo = ".dropdown-menu .dropdown-item:not(.disabled):not(:disabled)",
    Go = X() ? "top-end" : "top-start",
    zo = X() ? "top-start" : "top-end",
    qo = X() ? "bottom-end" : "bottom-start",
    Xo = X() ? "bottom-start" : "bottom-end",
    Qo = X() ? "left-start" : "right-start",
    Zo = X() ? "right-start" : "left-start",
    Jo = "top",
    ta = "bottom",
    ea = {
      autoClose: !0,
      boundary: "clippingParents",
      display: "dynamic",
      offset: [0, 2],
      popperConfig: null,
      reference: "toggle",
    },
    ia = {
      autoClose: "(boolean|string)",
      boundary: "(string|element)",
      display: "string",
      offset: "(array|string|function)",
      popperConfig: "(null|object|function)",
      reference: "(string|element|object)",
    },
    q = class extends Y {
      constructor(t, e) {
        super(t, e),
          (this._popper = null),
          (this._parent = this._element.parentNode),
          (this._menu =
            p.next(this._element, Qe)[0] ||
            p.prev(this._element, Qe)[0] ||
            p.findOne(Qe, this._parent)),
          (this._inNavbar = this._detectNavbar());
      }
      static get Default() {
        return ea;
      }
      static get DefaultType() {
        return ia;
      }
      static get NAME() {
        return Or;
      }
      toggle() {
        return this._isShown() ? this.hide() : this.show();
      }
      show() {
        if (gt(this._element) || this._isShown()) return;
        let t = { relatedTarget: this._element };
        if (!c.trigger(this._element, Mo, t).defaultPrevented) {
          if (
            (this._createPopper(),
            "ontouchstart" in document.documentElement &&
              !this._parent.closest(Yo))
          )
            for (let r of [].concat(...document.body.children))
              c.on(r, "mouseover", Ze);
          this._element.focus(),
            this._element.setAttribute("aria-expanded", !0),
            this._menu.classList.add(ee),
            this._element.classList.add(ee),
            c.trigger(this._element, Ro, t);
        }
      }
      hide() {
        if (gt(this._element) || !this._isShown()) return;
        let t = { relatedTarget: this._element };
        this._completeHide(t);
      }
      dispose() {
        this._popper && this._popper.destroy(), super.dispose();
      }
      update() {
        (this._inNavbar = this._detectNavbar()),
          this._popper && this._popper.update();
      }
      _completeHide(t) {
        if (!c.trigger(this._element, Io, t).defaultPrevented) {
          if ("ontouchstart" in document.documentElement)
            for (let r of [].concat(...document.body.children))
              c.off(r, "mouseover", Ze);
          this._popper && this._popper.destroy(),
            this._menu.classList.remove(ee),
            this._element.classList.remove(ee),
            this._element.setAttribute("aria-expanded", "false"),
            ut.removeDataAttribute(this._menu, "popper"),
            c.trigger(this._element, Po, t);
        }
      }
      _getConfig(t) {
        if (
          ((t = super._getConfig(t)),
          typeof t.reference == "object" &&
            !ct(t.reference) &&
            typeof t.reference.getBoundingClientRect != "function")
        )
          throw new TypeError(
            `${Or.toUpperCase()}: Option "reference" provided type "object" without a required "getBoundingClientRect" method.`,
          );
        return t;
      }
      _createPopper() {
        if (typeof Fe == "undefined")
          throw new TypeError(
            "Bootstrap's dropdowns require Popper (https://popper.js.org)",
          );
        let t = this._element;
        this._config.reference === "parent"
          ? (t = this._parent)
          : ct(this._config.reference)
            ? (t = _t(this._config.reference))
            : typeof this._config.reference == "object" &&
              (t = this._config.reference);
        let e = this._getPopperConfig();
        this._popper = Ae(t, this._menu, e);
      }
      _isShown() {
        return this._menu.classList.contains(ee);
      }
      _getPlacement() {
        let t = this._parent;
        if (t.classList.contains(Ho)) return Qo;
        if (t.classList.contains(Wo)) return Zo;
        if (t.classList.contains(Bo)) return Jo;
        if (t.classList.contains(jo)) return ta;
        let e =
          getComputedStyle(this._menu)
            .getPropertyValue("--bs-position")
            .trim() === "end";
        return t.classList.contains(Vo) ? (e ? zo : Go) : e ? Xo : qo;
      }
      _detectNavbar() {
        return this._element.closest(Ko) !== null;
      }
      _getOffset() {
        let { offset: t } = this._config;
        return typeof t == "string"
          ? t.split(",").map((e) => Number.parseInt(e, 10))
          : typeof t == "function"
            ? (e) => t(e, this._element)
            : t;
      }
      _getPopperConfig() {
        let t = {
          placement: this._getPlacement(),
          modifiers: [
            {
              name: "preventOverflow",
              options: { boundary: this._config.boundary },
            },
            { name: "offset", options: { offset: this._getOffset() } },
          ],
        };
        return (
          (this._inNavbar || this._config.display === "static") &&
            (ut.setDataAttribute(this._menu, "popper", "static"),
            (t.modifiers = [{ name: "applyStyles", enabled: !1 }])),
          H(H({}, t), F(this._config.popperConfig, [t]))
        );
      }
      _selectMenuItem({ key: t, target: e }) {
        let r = p.find(Uo, this._menu).filter((n) => le(n));
        r.length && Wi(r, e, t === Nr, !r.includes(e)).focus();
      }
      static jQueryInterface(t) {
        return this.each(function () {
          let e = q.getOrCreateInstance(this, t);
          if (typeof t == "string") {
            if (typeof e[t] == "undefined")
              throw new TypeError(`No method named "${t}"`);
            e[t]();
          }
        });
      }
      static clearMenus(t) {
        if (t.button === $o || (t.type === "keyup" && t.key !== Cr)) return;
        let e = p.find(Fo);
        for (let r of e) {
          let n = q.getInstance(r);
          if (!n || n._config.autoClose === !1) continue;
          let s = t.composedPath(),
            o = s.includes(n._menu);
          if (
            s.includes(n._element) ||
            (n._config.autoClose === "inside" && !o) ||
            (n._config.autoClose === "outside" && o) ||
            (n._menu.contains(t.target) &&
              ((t.type === "keyup" && t.key === Cr) ||
                /input|select|option|textarea|form/i.test(t.target.tagName)))
          )
            continue;
          let a = { relatedTarget: n._element };
          t.type === "click" && (a.clickEvent = t), n._completeHide(a);
        }
      }
      static dataApiKeydownHandler(t) {
        let e = /input|textarea/i.test(t.target.tagName),
          r = t.key === Lo,
          n = [xo, Nr].includes(t.key);
        if ((!n && !r) || (e && !r)) return;
        t.preventDefault();
        let s = this.matches(Rt)
            ? this
            : p.prev(this, Rt)[0] ||
              p.next(this, Rt)[0] ||
              p.findOne(Rt, t.delegateTarget.parentNode),
          o = q.getOrCreateInstance(s);
        if (n) {
          t.stopPropagation(), o.show(), o._selectMenuItem(t);
          return;
        }
        o._isShown() && (t.stopPropagation(), o.hide(), s.focus());
      }
    };
  c.on(document, dn, Rt, q.dataApiKeydownHandler);
  c.on(document, dn, Qe, q.dataApiKeydownHandler);
  c.on(document, fn, q.clearMenus);
  c.on(document, ko, q.clearMenus);
  c.on(document, fn, Rt, function (i) {
    i.preventDefault(), q.getOrCreateInstance(this).toggle();
  });
  Z(q);
  var pn = "backdrop",
    ra = "fade",
    Sr = "show",
    Dr = `mousedown.bs.${pn}`,
    na = {
      className: "modal-backdrop",
      clickCallback: null,
      isAnimated: !1,
      isVisible: !0,
      rootElement: "body",
    },
    sa = {
      className: "string",
      clickCallback: "(function|null)",
      isAnimated: "boolean",
      isVisible: "boolean",
      rootElement: "(element|string)",
    },
    Je = class extends Vt {
      constructor(t) {
        super(),
          (this._config = this._getConfig(t)),
          (this._isAppended = !1),
          (this._element = null);
      }
      static get Default() {
        return na;
      }
      static get DefaultType() {
        return sa;
      }
      static get NAME() {
        return pn;
      }
      show(t) {
        if (!this._config.isVisible) {
          F(t);
          return;
        }
        this._append();
        let e = this._getElement();
        this._config.isAnimated && Ce(e),
          e.classList.add(Sr),
          this._emulateAnimation(() => {
            F(t);
          });
      }
      hide(t) {
        if (!this._config.isVisible) {
          F(t);
          return;
        }
        this._getElement().classList.remove(Sr),
          this._emulateAnimation(() => {
            this.dispose(), F(t);
          });
      }
      dispose() {
        this._isAppended &&
          (c.off(this._element, Dr),
          this._element.remove(),
          (this._isAppended = !1));
      }
      _getElement() {
        if (!this._element) {
          let t = document.createElement("div");
          (t.className = this._config.className),
            this._config.isAnimated && t.classList.add(ra),
            (this._element = t);
        }
        return this._element;
      }
      _configAfterMerge(t) {
        return (t.rootElement = _t(t.rootElement)), t;
      }
      _append() {
        if (this._isAppended) return;
        let t = this._getElement();
        this._config.rootElement.append(t),
          c.on(t, Dr, () => {
            F(this._config.clickCallback);
          }),
          (this._isAppended = !0);
      }
      _emulateAnimation(t) {
        Zr(t, this._getElement(), this._config.isAnimated);
      }
    },
    oa = "focustrap",
    aa = "bs.focustrap",
    ti = `.${aa}`,
    la = `focusin${ti}`,
    ca = `keydown.tab${ti}`,
    ua = "Tab",
    fa = "forward",
    Lr = "backward",
    da = { autofocus: !0, trapElement: null },
    pa = { autofocus: "boolean", trapElement: "element" },
    ei = class extends Vt {
      constructor(t) {
        super(),
          (this._config = this._getConfig(t)),
          (this._isActive = !1),
          (this._lastTabNavDirection = null);
      }
      static get Default() {
        return da;
      }
      static get DefaultType() {
        return pa;
      }
      static get NAME() {
        return oa;
      }
      activate() {
        this._isActive ||
          (this._config.autofocus && this._config.trapElement.focus(),
          c.off(document, ti),
          c.on(document, la, (t) => this._handleFocusin(t)),
          c.on(document, ca, (t) => this._handleKeydown(t)),
          (this._isActive = !0));
      }
      deactivate() {
        this._isActive && ((this._isActive = !1), c.off(document, ti));
      }
      _handleFocusin(t) {
        let { trapElement: e } = this._config;
        if (t.target === document || t.target === e || e.contains(t.target))
          return;
        let r = p.focusableChildren(e);
        r.length === 0
          ? e.focus()
          : this._lastTabNavDirection === Lr
            ? r[r.length - 1].focus()
            : r[0].focus();
      }
      _handleKeydown(t) {
        t.key === ua && (this._lastTabNavDirection = t.shiftKey ? Lr : fa);
      }
    },
    xr = ".fixed-top, .fixed-bottom, .is-fixed, .sticky-top",
    $r = ".sticky-top",
    Ue = "padding-right",
    Ir = "margin-right",
    we = class {
      constructor() {
        this._element = document.body;
      }
      getWidth() {
        let t = document.documentElement.clientWidth;
        return Math.abs(window.innerWidth - t);
      }
      hide() {
        let t = this.getWidth();
        this._disableOverFlow(),
          this._setElementAttributes(this._element, Ue, (e) => e + t),
          this._setElementAttributes(xr, Ue, (e) => e + t),
          this._setElementAttributes($r, Ir, (e) => e - t);
      }
      reset() {
        this._resetElementAttributes(this._element, "overflow"),
          this._resetElementAttributes(this._element, Ue),
          this._resetElementAttributes(xr, Ue),
          this._resetElementAttributes($r, Ir);
      }
      isOverflowing() {
        return this.getWidth() > 0;
      }
      _disableOverFlow() {
        this._saveInitialAttribute(this._element, "overflow"),
          (this._element.style.overflow = "hidden");
      }
      _setElementAttributes(t, e, r) {
        let n = this.getWidth(),
          s = (o) => {
            if (o !== this._element && window.innerWidth > o.clientWidth + n)
              return;
            this._saveInitialAttribute(o, e);
            let a = window.getComputedStyle(o).getPropertyValue(e);
            o.style.setProperty(e, `${r(Number.parseFloat(a))}px`);
          };
        this._applyManipulationCallback(t, s);
      }
      _saveInitialAttribute(t, e) {
        let r = t.style.getPropertyValue(e);
        r && ut.setDataAttribute(t, e, r);
      }
      _resetElementAttributes(t, e) {
        let r = (n) => {
          let s = ut.getDataAttribute(n, e);
          if (s === null) {
            n.style.removeProperty(e);
            return;
          }
          ut.removeDataAttribute(n, e), n.style.setProperty(e, s);
        };
        this._applyManipulationCallback(t, r);
      }
      _applyManipulationCallback(t, e) {
        if (ct(t)) {
          e(t);
          return;
        }
        for (let r of p.find(t, this._element)) e(r);
      }
    },
    ha = "modal",
    ma = "bs.modal",
    Q = `.${ma}`,
    _a = ".data-api",
    ga = "Escape",
    Ea = `hide${Q}`,
    va = `hidePrevented${Q}`,
    hn = `hidden${Q}`,
    mn = `show${Q}`,
    ba = `shown${Q}`,
    Aa = `resize${Q}`,
    Ta = `click.dismiss${Q}`,
    ya = `mousedown.dismiss${Q}`,
    wa = `keydown.dismiss${Q}`,
    Oa = `click${Q}${_a}`,
    Pr = "modal-open",
    Ca = "fade",
    Mr = "show",
    Di = "modal-static",
    Na = ".modal.show",
    Sa = ".modal-dialog",
    Da = ".modal-body",
    La = '[data-bs-toggle="modal"]',
    xa = { backdrop: !0, focus: !0, keyboard: !0 },
    $a = {
      backdrop: "(boolean|string)",
      focus: "boolean",
      keyboard: "boolean",
    },
    nt = class extends Y {
      constructor(t, e) {
        super(t, e),
          (this._dialog = p.findOne(Sa, this._element)),
          (this._backdrop = this._initializeBackDrop()),
          (this._focustrap = this._initializeFocusTrap()),
          (this._isShown = !1),
          (this._isTransitioning = !1),
          (this._scrollBar = new we()),
          this._addEventListeners();
      }
      static get Default() {
        return xa;
      }
      static get DefaultType() {
        return $a;
      }
      static get NAME() {
        return ha;
      }
      toggle(t) {
        return this._isShown ? this.hide() : this.show(t);
      }
      show(t) {
        this._isShown ||
          this._isTransitioning ||
          c.trigger(this._element, mn, { relatedTarget: t }).defaultPrevented ||
          ((this._isShown = !0),
          (this._isTransitioning = !0),
          this._scrollBar.hide(),
          document.body.classList.add(Pr),
          this._adjustDialog(),
          this._backdrop.show(() => this._showElement(t)));
      }
      hide() {
        !this._isShown ||
          this._isTransitioning ||
          c.trigger(this._element, Ea).defaultPrevented ||
          ((this._isShown = !1),
          (this._isTransitioning = !0),
          this._focustrap.deactivate(),
          this._element.classList.remove(Mr),
          this._queueCallback(
            () => this._hideModal(),
            this._element,
            this._isAnimated(),
          ));
      }
      dispose() {
        c.off(window, Q),
          c.off(this._dialog, Q),
          this._backdrop.dispose(),
          this._focustrap.deactivate(),
          super.dispose();
      }
      handleUpdate() {
        this._adjustDialog();
      }
      _initializeBackDrop() {
        return new Je({
          isVisible: Boolean(this._config.backdrop),
          isAnimated: this._isAnimated(),
        });
      }
      _initializeFocusTrap() {
        return new ei({ trapElement: this._element });
      }
      _showElement(t) {
        document.body.contains(this._element) ||
          document.body.append(this._element),
          (this._element.style.display = "block"),
          this._element.removeAttribute("aria-hidden"),
          this._element.setAttribute("aria-modal", !0),
          this._element.setAttribute("role", "dialog"),
          (this._element.scrollTop = 0);
        let e = p.findOne(Da, this._dialog);
        e && (e.scrollTop = 0),
          Ce(this._element),
          this._element.classList.add(Mr);
        let r = () => {
          this._config.focus && this._focustrap.activate(),
            (this._isTransitioning = !1),
            c.trigger(this._element, ba, { relatedTarget: t });
        };
        this._queueCallback(r, this._dialog, this._isAnimated());
      }
      _addEventListeners() {
        c.on(this._element, wa, (t) => {
          if (t.key === ga) {
            if (this._config.keyboard) {
              this.hide();
              return;
            }
            this._triggerBackdropTransition();
          }
        }),
          c.on(window, Aa, () => {
            this._isShown && !this._isTransitioning && this._adjustDialog();
          }),
          c.on(this._element, ya, (t) => {
            c.one(this._element, Ta, (e) => {
              if (!(this._element !== t.target || this._element !== e.target)) {
                if (this._config.backdrop === "static") {
                  this._triggerBackdropTransition();
                  return;
                }
                this._config.backdrop && this.hide();
              }
            });
          });
      }
      _hideModal() {
        (this._element.style.display = "none"),
          this._element.setAttribute("aria-hidden", !0),
          this._element.removeAttribute("aria-modal"),
          this._element.removeAttribute("role"),
          (this._isTransitioning = !1),
          this._backdrop.hide(() => {
            document.body.classList.remove(Pr),
              this._resetAdjustments(),
              this._scrollBar.reset(),
              c.trigger(this._element, hn);
          });
      }
      _isAnimated() {
        return this._element.classList.contains(Ca);
      }
      _triggerBackdropTransition() {
        if (c.trigger(this._element, va).defaultPrevented) return;
        let e =
            this._element.scrollHeight > document.documentElement.clientHeight,
          r = this._element.style.overflowY;
        r === "hidden" ||
          this._element.classList.contains(Di) ||
          (e || (this._element.style.overflowY = "hidden"),
          this._element.classList.add(Di),
          this._queueCallback(() => {
            this._element.classList.remove(Di),
              this._queueCallback(() => {
                this._element.style.overflowY = r;
              }, this._dialog);
          }, this._dialog),
          this._element.focus());
      }
      _adjustDialog() {
        let t =
            this._element.scrollHeight > document.documentElement.clientHeight,
          e = this._scrollBar.getWidth(),
          r = e > 0;
        if (r && !t) {
          let n = X() ? "paddingLeft" : "paddingRight";
          this._element.style[n] = `${e}px`;
        }
        if (!r && t) {
          let n = X() ? "paddingRight" : "paddingLeft";
          this._element.style[n] = `${e}px`;
        }
      }
      _resetAdjustments() {
        (this._element.style.paddingLeft = ""),
          (this._element.style.paddingRight = "");
      }
      static jQueryInterface(t, e) {
        return this.each(function () {
          let r = nt.getOrCreateInstance(this, t);
          if (typeof t == "string") {
            if (typeof r[t] == "undefined")
              throw new TypeError(`No method named "${t}"`);
            r[t](e);
          }
        });
      }
    };
  c.on(document, Oa, La, function (i) {
    let t = p.getElementFromSelector(this);
    ["A", "AREA"].includes(this.tagName) && i.preventDefault(),
      c.one(t, mn, (n) => {
        n.defaultPrevented ||
          c.one(t, hn, () => {
            le(this) && this.focus();
          });
      });
    let e = p.findOne(Na);
    e && nt.getInstance(e).hide(), nt.getOrCreateInstance(t).toggle(this);
  });
  ii(nt);
  Z(nt);
  var Ia = "offcanvas",
    Pa = "bs.offcanvas",
    ft = `.${Pa}`,
    _n = ".data-api",
    Ma = `load${ft}${_n}`,
    Ra = "Escape",
    Rr = "show",
    kr = "showing",
    Vr = "hiding",
    ka = "offcanvas-backdrop",
    gn = ".offcanvas.show",
    Va = `show${ft}`,
    Ha = `shown${ft}`,
    Wa = `hide${ft}`,
    Hr = `hidePrevented${ft}`,
    En = `hidden${ft}`,
    Ba = `resize${ft}`,
    ja = `click${ft}${_n}`,
    Fa = `keydown.dismiss${ft}`,
    Ka = '[data-bs-toggle="offcanvas"]',
    Ya = { backdrop: !0, keyboard: !0, scroll: !1 },
    Ua = {
      backdrop: "(boolean|string)",
      keyboard: "boolean",
      scroll: "boolean",
    },
    st = class extends Y {
      constructor(t, e) {
        super(t, e),
          (this._isShown = !1),
          (this._backdrop = this._initializeBackDrop()),
          (this._focustrap = this._initializeFocusTrap()),
          this._addEventListeners();
      }
      static get Default() {
        return Ya;
      }
      static get DefaultType() {
        return Ua;
      }
      static get NAME() {
        return Ia;
      }
      toggle(t) {
        return this._isShown ? this.hide() : this.show(t);
      }
      show(t) {
        if (
          this._isShown ||
          c.trigger(this._element, Va, { relatedTarget: t }).defaultPrevented
        )
          return;
        (this._isShown = !0),
          this._backdrop.show(),
          this._config.scroll || new we().hide(),
          this._element.setAttribute("aria-modal", !0),
          this._element.setAttribute("role", "dialog"),
          this._element.classList.add(kr);
        let r = () => {
          (!this._config.scroll || this._config.backdrop) &&
            this._focustrap.activate(),
            this._element.classList.add(Rr),
            this._element.classList.remove(kr),
            c.trigger(this._element, Ha, { relatedTarget: t });
        };
        this._queueCallback(r, this._element, !0);
      }
      hide() {
        if (!this._isShown || c.trigger(this._element, Wa).defaultPrevented)
          return;
        this._focustrap.deactivate(),
          this._element.blur(),
          (this._isShown = !1),
          this._element.classList.add(Vr),
          this._backdrop.hide();
        let e = () => {
          this._element.classList.remove(Rr, Vr),
            this._element.removeAttribute("aria-modal"),
            this._element.removeAttribute("role"),
            this._config.scroll || new we().reset(),
            c.trigger(this._element, En);
        };
        this._queueCallback(e, this._element, !0);
      }
      dispose() {
        this._backdrop.dispose(), this._focustrap.deactivate(), super.dispose();
      }
      _initializeBackDrop() {
        let t = () => {
            if (this._config.backdrop === "static") {
              c.trigger(this._element, Hr);
              return;
            }
            this.hide();
          },
          e = Boolean(this._config.backdrop);
        return new Je({
          className: ka,
          isVisible: e,
          isAnimated: !0,
          rootElement: this._element.parentNode,
          clickCallback: e ? t : null,
        });
      }
      _initializeFocusTrap() {
        return new ei({ trapElement: this._element });
      }
      _addEventListeners() {
        c.on(this._element, Fa, (t) => {
          if (t.key === Ra) {
            if (this._config.keyboard) {
              this.hide();
              return;
            }
            c.trigger(this._element, Hr);
          }
        });
      }
      static jQueryInterface(t) {
        return this.each(function () {
          let e = st.getOrCreateInstance(this, t);
          if (typeof t == "string") {
            if (e[t] === void 0 || t.startsWith("_") || t === "constructor")
              throw new TypeError(`No method named "${t}"`);
            e[t](this);
          }
        });
      }
    };
  c.on(document, ja, Ka, function (i) {
    let t = p.getElementFromSelector(this);
    if ((["A", "AREA"].includes(this.tagName) && i.preventDefault(), gt(this)))
      return;
    c.one(t, En, () => {
      le(this) && this.focus();
    });
    let e = p.findOne(gn);
    e && e !== t && st.getInstance(e).hide(),
      st.getOrCreateInstance(t).toggle(this);
  });
  c.on(window, Ma, () => {
    for (let i of p.find(gn)) st.getOrCreateInstance(i).show();
  });
  c.on(window, Ba, () => {
    for (let i of p.find("[aria-modal][class*=show][class*=offcanvas-]"))
      getComputedStyle(i).position !== "fixed" &&
        st.getOrCreateInstance(i).hide();
  });
  ii(st);
  Z(st);
  var Ga = /^aria-[\w-]*$/i,
    vn = {
      "*": ["class", "dir", "id", "lang", "role", Ga],
      a: ["target", "href", "title", "rel"],
      area: [],
      b: [],
      br: [],
      col: [],
      code: [],
      div: [],
      em: [],
      hr: [],
      h1: [],
      h2: [],
      h3: [],
      h4: [],
      h5: [],
      h6: [],
      i: [],
      img: ["src", "srcset", "alt", "title", "width", "height"],
      li: [],
      ol: [],
      p: [],
      pre: [],
      s: [],
      small: [],
      span: [],
      sub: [],
      sup: [],
      strong: [],
      u: [],
      ul: [],
    },
    za = new Set([
      "background",
      "cite",
      "href",
      "itemtype",
      "longdesc",
      "poster",
      "src",
      "xlink:href",
    ]),
    qa = /^(?!javascript:)(?:[a-z0-9+.-]+:|[^&:/?#]*(?:[/?#]|$))/i,
    Xa = (i, t) => {
      let e = i.nodeName.toLowerCase();
      return t.includes(e)
        ? za.has(e)
          ? Boolean(qa.test(i.nodeValue))
          : !0
        : t.filter((r) => r instanceof RegExp).some((r) => r.test(e));
    };
  function Qa(i, t, e) {
    if (!i.length) return i;
    if (e && typeof e == "function") return e(i);
    let n = new window.DOMParser().parseFromString(i, "text/html"),
      s = [].concat(...n.body.querySelectorAll("*"));
    for (let o of s) {
      let a = o.nodeName.toLowerCase();
      if (!Object.keys(t).includes(a)) {
        o.remove();
        continue;
      }
      let u = [].concat(...o.attributes),
        f = [].concat(t["*"] || [], t[a] || []);
      for (let l of u) Xa(l, f) || o.removeAttribute(l.nodeName);
    }
    return n.body.innerHTML;
  }
  var Za = "TemplateFactory",
    Ja = {
      allowList: vn,
      content: {},
      extraClass: "",
      html: !1,
      sanitize: !0,
      sanitizeFn: null,
      template: "<div></div>",
    },
    tl = {
      allowList: "object",
      content: "object",
      extraClass: "(string|function)",
      html: "boolean",
      sanitize: "boolean",
      sanitizeFn: "(null|function)",
      template: "string",
    },
    el = {
      entry: "(string|element|function|null)",
      selector: "(string|element)",
    },
    Hi = class extends Vt {
      constructor(t) {
        super(), (this._config = this._getConfig(t));
      }
      static get Default() {
        return Ja;
      }
      static get DefaultType() {
        return tl;
      }
      static get NAME() {
        return Za;
      }
      getContent() {
        return Object.values(this._config.content)
          .map((t) => this._resolvePossibleFunction(t))
          .filter(Boolean);
      }
      hasContent() {
        return this.getContent().length > 0;
      }
      changeContent(t) {
        return (
          this._checkContent(t),
          (this._config.content = H(H({}, this._config.content), t)),
          this
        );
      }
      toHtml() {
        let t = document.createElement("div");
        t.innerHTML = this._maybeSanitize(this._config.template);
        for (let [n, s] of Object.entries(this._config.content))
          this._setContent(t, s, n);
        let e = t.children[0],
          r = this._resolvePossibleFunction(this._config.extraClass);
        return r && e.classList.add(...r.split(" ")), e;
      }
      _typeCheckConfig(t) {
        super._typeCheckConfig(t), this._checkContent(t.content);
      }
      _checkContent(t) {
        for (let [e, r] of Object.entries(t))
          super._typeCheckConfig({ selector: e, entry: r }, el);
      }
      _setContent(t, e, r) {
        let n = p.findOne(r, t);
        if (n) {
          if (((e = this._resolvePossibleFunction(e)), !e)) {
            n.remove();
            return;
          }
          if (ct(e)) {
            this._putElementInTemplate(_t(e), n);
            return;
          }
          if (this._config.html) {
            n.innerHTML = this._maybeSanitize(e);
            return;
          }
          n.textContent = e;
        }
      }
      _maybeSanitize(t) {
        return this._config.sanitize
          ? Qa(t, this._config.allowList, this._config.sanitizeFn)
          : t;
      }
      _resolvePossibleFunction(t) {
        return F(t, [this]);
      }
      _putElementInTemplate(t, e) {
        if (this._config.html) {
          (e.innerHTML = ""), e.append(t);
          return;
        }
        e.textContent = t.textContent;
      }
    },
    il = "tooltip",
    rl = new Set(["sanitize", "allowList", "sanitizeFn"]),
    Li = "fade",
    nl = "modal",
    Ge = "show",
    sl = ".tooltip-inner",
    Wr = `.${nl}`,
    Br = "hide.bs.modal",
    ye = "hover",
    xi = "focus",
    ol = "click",
    al = "manual",
    ll = "hide",
    cl = "hidden",
    ul = "show",
    fl = "shown",
    dl = "inserted",
    pl = "click",
    hl = "focusin",
    ml = "focusout",
    _l = "mouseenter",
    gl = "mouseleave",
    El = {
      AUTO: "auto",
      TOP: "top",
      RIGHT: X() ? "left" : "right",
      BOTTOM: "bottom",
      LEFT: X() ? "right" : "left",
    },
    vl = {
      allowList: vn,
      animation: !0,
      boundary: "clippingParents",
      container: !1,
      customClass: "",
      delay: 0,
      fallbackPlacements: ["top", "right", "bottom", "left"],
      html: !1,
      offset: [0, 6],
      placement: "top",
      popperConfig: null,
      sanitize: !0,
      sanitizeFn: null,
      selector: !1,
      template:
        '<div class="tooltip" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>',
      title: "",
      trigger: "hover focus",
    },
    bl = {
      allowList: "object",
      animation: "boolean",
      boundary: "(string|element)",
      container: "(string|element|boolean)",
      customClass: "(string|function)",
      delay: "(number|object)",
      fallbackPlacements: "array",
      html: "boolean",
      offset: "(array|string|function)",
      placement: "(string|function)",
      popperConfig: "(null|object|function)",
      sanitize: "boolean",
      sanitizeFn: "(null|function)",
      selector: "(string|boolean)",
      template: "string",
      title: "(string|element|function)",
      trigger: "string",
    },
    Et = class extends Y {
      constructor(t, e) {
        if (typeof Fe == "undefined")
          throw new TypeError(
            "Bootstrap's tooltips require Popper (https://popper.js.org)",
          );
        super(t, e),
          (this._isEnabled = !0),
          (this._timeout = 0),
          (this._isHovered = null),
          (this._activeTrigger = {}),
          (this._popper = null),
          (this._templateFactory = null),
          (this._newContent = null),
          (this.tip = null),
          this._setListeners(),
          this._config.selector || this._fixTitle();
      }
      static get Default() {
        return vl;
      }
      static get DefaultType() {
        return bl;
      }
      static get NAME() {
        return il;
      }
      enable() {
        this._isEnabled = !0;
      }
      disable() {
        this._isEnabled = !1;
      }
      toggleEnabled() {
        this._isEnabled = !this._isEnabled;
      }
      toggle() {
        if (this._isEnabled) {
          if (
            ((this._activeTrigger.click = !this._activeTrigger.click),
            this._isShown())
          ) {
            this._leave();
            return;
          }
          this._enter();
        }
      }
      dispose() {
        clearTimeout(this._timeout),
          c.off(this._element.closest(Wr), Br, this._hideModalHandler),
          this._element.getAttribute("data-bs-original-title") &&
            this._element.setAttribute(
              "title",
              this._element.getAttribute("data-bs-original-title"),
            ),
          this._disposePopper(),
          super.dispose();
      }
      show() {
        if (this._element.style.display === "none")
          throw new Error("Please use show on visible elements");
        if (!(this._isWithContent() && this._isEnabled)) return;
        let t = c.trigger(this._element, this.constructor.eventName(ul)),
          r = (
            Xr(this._element) || this._element.ownerDocument.documentElement
          ).contains(this._element);
        if (t.defaultPrevented || !r) return;
        this._disposePopper();
        let n = this._getTipElement();
        this._element.setAttribute("aria-describedby", n.getAttribute("id"));
        let { container: s } = this._config;
        if (
          (this._element.ownerDocument.documentElement.contains(this.tip) ||
            (s.append(n),
            c.trigger(this._element, this.constructor.eventName(dl))),
          (this._popper = this._createPopper(n)),
          n.classList.add(Ge),
          "ontouchstart" in document.documentElement)
        )
          for (let a of [].concat(...document.body.children))
            c.on(a, "mouseover", Ze);
        let o = () => {
          c.trigger(this._element, this.constructor.eventName(fl)),
            this._isHovered === !1 && this._leave(),
            (this._isHovered = !1);
        };
        this._queueCallback(o, this.tip, this._isAnimated());
      }
      hide() {
        if (
          !this._isShown() ||
          c.trigger(this._element, this.constructor.eventName(ll))
            .defaultPrevented
        )
          return;
        if (
          (this._getTipElement().classList.remove(Ge),
          "ontouchstart" in document.documentElement)
        )
          for (let n of [].concat(...document.body.children))
            c.off(n, "mouseover", Ze);
        (this._activeTrigger[ol] = !1),
          (this._activeTrigger[xi] = !1),
          (this._activeTrigger[ye] = !1),
          (this._isHovered = null);
        let r = () => {
          this._isWithActiveTrigger() ||
            (this._isHovered || this._disposePopper(),
            this._element.removeAttribute("aria-describedby"),
            c.trigger(this._element, this.constructor.eventName(cl)));
        };
        this._queueCallback(r, this.tip, this._isAnimated());
      }
      update() {
        this._popper && this._popper.update();
      }
      _isWithContent() {
        return Boolean(this._getTitle());
      }
      _getTipElement() {
        return (
          this.tip ||
            (this.tip = this._createTipElement(
              this._newContent || this._getContentForTemplate(),
            )),
          this.tip
        );
      }
      _createTipElement(t) {
        let e = this._getTemplateFactory(t).toHtml();
        if (!e) return null;
        e.classList.remove(Li, Ge),
          e.classList.add(`bs-${this.constructor.NAME}-auto`);
        let r = os(this.constructor.NAME).toString();
        return (
          e.setAttribute("id", r), this._isAnimated() && e.classList.add(Li), e
        );
      }
      setContent(t) {
        (this._newContent = t),
          this._isShown() && (this._disposePopper(), this.show());
      }
      _getTemplateFactory(t) {
        return (
          this._templateFactory
            ? this._templateFactory.changeContent(t)
            : (this._templateFactory = new Hi(
                Ie(H({}, this._config), {
                  content: t,
                  extraClass: this._resolvePossibleFunction(
                    this._config.customClass,
                  ),
                }),
              )),
          this._templateFactory
        );
      }
      _getContentForTemplate() {
        return { [sl]: this._getTitle() };
      }
      _getTitle() {
        return (
          this._resolvePossibleFunction(this._config.title) ||
          this._element.getAttribute("data-bs-original-title")
        );
      }
      _initializeOnDelegatedTarget(t) {
        return this.constructor.getOrCreateInstance(
          t.delegateTarget,
          this._getDelegateConfig(),
        );
      }
      _isAnimated() {
        return (
          this._config.animation ||
          (this.tip && this.tip.classList.contains(Li))
        );
      }
      _isShown() {
        return this.tip && this.tip.classList.contains(Ge);
      }
      _createPopper(t) {
        let e = F(this._config.placement, [this, t, this._element]),
          r = El[e.toUpperCase()];
        return Ae(this._element, t, this._getPopperConfig(r));
      }
      _getOffset() {
        let { offset: t } = this._config;
        return typeof t == "string"
          ? t.split(",").map((e) => Number.parseInt(e, 10))
          : typeof t == "function"
            ? (e) => t(e, this._element)
            : t;
      }
      _resolvePossibleFunction(t) {
        return F(t, [this._element]);
      }
      _getPopperConfig(t) {
        let e = {
          placement: t,
          modifiers: [
            {
              name: "flip",
              options: { fallbackPlacements: this._config.fallbackPlacements },
            },
            { name: "offset", options: { offset: this._getOffset() } },
            {
              name: "preventOverflow",
              options: { boundary: this._config.boundary },
            },
            {
              name: "arrow",
              options: { element: `.${this.constructor.NAME}-arrow` },
            },
            {
              name: "preSetPlacement",
              enabled: !0,
              phase: "beforeMain",
              fn: (r) => {
                this._getTipElement().setAttribute(
                  "data-popper-placement",
                  r.state.placement,
                );
              },
            },
          ],
        };
        return H(H({}, e), F(this._config.popperConfig, [e]));
      }
      _setListeners() {
        let t = this._config.trigger.split(" ");
        for (let e of t)
          if (e === "click")
            c.on(
              this._element,
              this.constructor.eventName(pl),
              this._config.selector,
              (r) => {
                this._initializeOnDelegatedTarget(r).toggle();
              },
            );
          else if (e !== al) {
            let r =
                e === ye
                  ? this.constructor.eventName(_l)
                  : this.constructor.eventName(hl),
              n =
                e === ye
                  ? this.constructor.eventName(gl)
                  : this.constructor.eventName(ml);
            c.on(this._element, r, this._config.selector, (s) => {
              let o = this._initializeOnDelegatedTarget(s);
              (o._activeTrigger[s.type === "focusin" ? xi : ye] = !0),
                o._enter();
            }),
              c.on(this._element, n, this._config.selector, (s) => {
                let o = this._initializeOnDelegatedTarget(s);
                (o._activeTrigger[s.type === "focusout" ? xi : ye] =
                  o._element.contains(s.relatedTarget)),
                  o._leave();
              });
          }
        (this._hideModalHandler = () => {
          this._element && this.hide();
        }),
          c.on(this._element.closest(Wr), Br, this._hideModalHandler);
      }
      _fixTitle() {
        let t = this._element.getAttribute("title");
        t &&
          (!this._element.getAttribute("aria-label") &&
            !this._element.textContent.trim() &&
            this._element.setAttribute("aria-label", t),
          this._element.setAttribute("data-bs-original-title", t),
          this._element.removeAttribute("title"));
      }
      _enter() {
        if (this._isShown() || this._isHovered) {
          this._isHovered = !0;
          return;
        }
        (this._isHovered = !0),
          this._setTimeout(() => {
            this._isHovered && this.show();
          }, this._config.delay.show);
      }
      _leave() {
        this._isWithActiveTrigger() ||
          ((this._isHovered = !1),
          this._setTimeout(() => {
            this._isHovered || this.hide();
          }, this._config.delay.hide));
      }
      _setTimeout(t, e) {
        clearTimeout(this._timeout), (this._timeout = setTimeout(t, e));
      }
      _isWithActiveTrigger() {
        return Object.values(this._activeTrigger).includes(!0);
      }
      _getConfig(t) {
        let e = ut.getDataAttributes(this._element);
        for (let r of Object.keys(e)) rl.has(r) && delete e[r];
        return (
          (t = H(H({}, e), typeof t == "object" && t ? t : {})),
          (t = this._mergeConfigObj(t)),
          (t = this._configAfterMerge(t)),
          this._typeCheckConfig(t),
          t
        );
      }
      _configAfterMerge(t) {
        return (
          (t.container = t.container === !1 ? document.body : _t(t.container)),
          typeof t.delay == "number" &&
            (t.delay = { show: t.delay, hide: t.delay }),
          typeof t.title == "number" && (t.title = t.title.toString()),
          typeof t.content == "number" && (t.content = t.content.toString()),
          t
        );
      }
      _getDelegateConfig() {
        let t = {};
        for (let [e, r] of Object.entries(this._config))
          this.constructor.Default[e] !== r && (t[e] = r);
        return (t.selector = !1), (t.trigger = "manual"), t;
      }
      _disposePopper() {
        this._popper && (this._popper.destroy(), (this._popper = null)),
          this.tip && (this.tip.remove(), (this.tip = null));
      }
      static jQueryInterface(t) {
        return this.each(function () {
          let e = Et.getOrCreateInstance(this, t);
          if (typeof t == "string") {
            if (typeof e[t] == "undefined")
              throw new TypeError(`No method named "${t}"`);
            e[t]();
          }
        });
      }
    };
  Z(Et);
  var Al = "popover",
    Tl = ".popover-header",
    yl = ".popover-body",
    wl = Ie(H({}, Et.Default), {
      content: "",
      offset: [0, 8],
      placement: "right",
      template:
        '<div class="popover" role="tooltip"><div class="popover-arrow"></div><h3 class="popover-header"></h3><div class="popover-body"></div></div>',
      trigger: "click",
    }),
    Ol = Ie(H({}, Et.DefaultType), {
      content: "(null|string|element|function)",
    }),
    Oe = class extends Et {
      static get Default() {
        return wl;
      }
      static get DefaultType() {
        return Ol;
      }
      static get NAME() {
        return Al;
      }
      _isWithContent() {
        return this._getTitle() || this._getContent();
      }
      _getContentForTemplate() {
        return { [Tl]: this._getTitle(), [yl]: this._getContent() };
      }
      _getContent() {
        return this._resolvePossibleFunction(this._config.content);
      }
      static jQueryInterface(t) {
        return this.each(function () {
          let e = Oe.getOrCreateInstance(this, t);
          if (typeof t == "string") {
            if (typeof e[t] == "undefined")
              throw new TypeError(`No method named "${t}"`);
            e[t]();
          }
        });
      }
    };
  Z(Oe);
  var Cl = "scrollspy",
    Nl = "bs.scrollspy",
    Fi = `.${Nl}`,
    Sl = ".data-api",
    Dl = `activate${Fi}`,
    jr = `click${Fi}`,
    Ll = `load${Fi}${Sl}`,
    xl = "dropdown-item",
    Jt = "active",
    $l = '[data-bs-spy="scroll"]',
    $i = "[href]",
    Il = ".nav, .list-group",
    Fr = ".nav-link",
    Pl = ".nav-item",
    Ml = ".list-group-item",
    Rl = `${Fr}, ${Pl} > ${Fr}, ${Ml}`,
    kl = ".dropdown",
    Vl = ".dropdown-toggle",
    Hl = {
      offset: null,
      rootMargin: "0px 0px -25%",
      smoothScroll: !1,
      target: null,
      threshold: [0.1, 0.5, 1],
    },
    Wl = {
      offset: "(number|null)",
      rootMargin: "string",
      smoothScroll: "boolean",
      target: "element",
      threshold: "array",
    },
    oe = class extends Y {
      constructor(t, e) {
        super(t, e),
          (this._targetLinks = new Map()),
          (this._observableSections = new Map()),
          (this._rootElement =
            getComputedStyle(this._element).overflowY === "visible"
              ? null
              : this._element),
          (this._activeTarget = null),
          (this._observer = null),
          (this._previousScrollData = {
            visibleEntryTop: 0,
            parentScrollTop: 0,
          }),
          this.refresh();
      }
      static get Default() {
        return Hl;
      }
      static get DefaultType() {
        return Wl;
      }
      static get NAME() {
        return Cl;
      }
      refresh() {
        this._initializeTargetsAndObservables(),
          this._maybeEnableSmoothScroll(),
          this._observer
            ? this._observer.disconnect()
            : (this._observer = this._getNewObserver());
        for (let t of this._observableSections.values())
          this._observer.observe(t);
      }
      dispose() {
        this._observer.disconnect(), super.dispose();
      }
      _configAfterMerge(t) {
        return (
          (t.target = _t(t.target) || document.body),
          (t.rootMargin = t.offset ? `${t.offset}px 0px -30%` : t.rootMargin),
          typeof t.threshold == "string" &&
            (t.threshold = t.threshold
              .split(",")
              .map((e) => Number.parseFloat(e))),
          t
        );
      }
      _maybeEnableSmoothScroll() {
        this._config.smoothScroll &&
          (c.off(this._config.target, jr),
          c.on(this._config.target, jr, $i, (t) => {
            let e = this._observableSections.get(t.target.hash);
            if (e) {
              t.preventDefault();
              let r = this._rootElement || window,
                n = e.offsetTop - this._element.offsetTop;
              if (r.scrollTo) {
                r.scrollTo({ top: n, behavior: "smooth" });
                return;
              }
              r.scrollTop = n;
            }
          }));
      }
      _getNewObserver() {
        let t = {
          root: this._rootElement,
          threshold: this._config.threshold,
          rootMargin: this._config.rootMargin,
        };
        return new IntersectionObserver((e) => this._observerCallback(e), t);
      }
      _observerCallback(t) {
        let e = (o) => this._targetLinks.get(`#${o.target.id}`),
          r = (o) => {
            (this._previousScrollData.visibleEntryTop = o.target.offsetTop),
              this._process(e(o));
          },
          n = (this._rootElement || document.documentElement).scrollTop,
          s = n >= this._previousScrollData.parentScrollTop;
        this._previousScrollData.parentScrollTop = n;
        for (let o of t) {
          if (!o.isIntersecting) {
            (this._activeTarget = null), this._clearActiveClass(e(o));
            continue;
          }
          let a =
            o.target.offsetTop >= this._previousScrollData.visibleEntryTop;
          if (s && a) {
            if ((r(o), !n)) return;
            continue;
          }
          !s && !a && r(o);
        }
      }
      _initializeTargetsAndObservables() {
        (this._targetLinks = new Map()), (this._observableSections = new Map());
        let t = p.find($i, this._config.target);
        for (let e of t) {
          if (!e.hash || gt(e)) continue;
          let r = p.findOne(decodeURI(e.hash), this._element);
          le(r) &&
            (this._targetLinks.set(decodeURI(e.hash), e),
            this._observableSections.set(e.hash, r));
        }
      }
      _process(t) {
        this._activeTarget !== t &&
          (this._clearActiveClass(this._config.target),
          (this._activeTarget = t),
          t.classList.add(Jt),
          this._activateParents(t),
          c.trigger(this._element, Dl, { relatedTarget: t }));
      }
      _activateParents(t) {
        if (t.classList.contains(xl)) {
          p.findOne(Vl, t.closest(kl)).classList.add(Jt);
          return;
        }
        for (let e of p.parents(t, Il))
          for (let r of p.prev(e, Rl)) r.classList.add(Jt);
      }
      _clearActiveClass(t) {
        t.classList.remove(Jt);
        let e = p.find(`${$i}.${Jt}`, t);
        for (let r of e) r.classList.remove(Jt);
      }
      static jQueryInterface(t) {
        return this.each(function () {
          let e = oe.getOrCreateInstance(this, t);
          if (typeof t == "string") {
            if (e[t] === void 0 || t.startsWith("_") || t === "constructor")
              throw new TypeError(`No method named "${t}"`);
            e[t]();
          }
        });
      }
    };
  c.on(window, Ll, () => {
    for (let i of p.find($l)) oe.getOrCreateInstance(i);
  });
  Z(oe);
  var Bl = "tab",
    jl = "bs.tab",
    jt = `.${jl}`,
    Fl = `hide${jt}`,
    Kl = `hidden${jt}`,
    Yl = `show${jt}`,
    Ul = `shown${jt}`,
    Gl = `click${jt}`,
    zl = `keydown${jt}`,
    ql = `load${jt}`,
    Xl = "ArrowLeft",
    Kr = "ArrowRight",
    Ql = "ArrowUp",
    Yr = "ArrowDown",
    kt = "active",
    Ur = "fade",
    Ii = "show",
    Zl = "dropdown",
    Jl = ".dropdown-toggle",
    tc = ".dropdown-menu",
    Pi = ":not(.dropdown-toggle)",
    ec = '.list-group, .nav, [role="tablist"]',
    ic = ".nav-item, .list-group-item",
    rc = `.nav-link${Pi}, .list-group-item${Pi}, [role="tab"]${Pi}`,
    bn =
      '[data-bs-toggle="tab"], [data-bs-toggle="pill"], [data-bs-toggle="list"]',
    Mi = `${rc}, ${bn}`,
    nc = `.${kt}[data-bs-toggle="tab"], .${kt}[data-bs-toggle="pill"], .${kt}[data-bs-toggle="list"]`,
    vt = class extends Y {
      constructor(t) {
        super(t),
          (this._parent = this._element.closest(ec)),
          this._parent &&
            (this._setInitialAttributes(this._parent, this._getChildren()),
            c.on(this._element, zl, (e) => this._keydown(e)));
      }
      static get NAME() {
        return Bl;
      }
      show() {
        let t = this._element;
        if (this._elemIsActive(t)) return;
        let e = this._getActiveElem(),
          r = e ? c.trigger(e, Fl, { relatedTarget: t }) : null;
        c.trigger(t, Yl, { relatedTarget: e }).defaultPrevented ||
          (r && r.defaultPrevented) ||
          (this._deactivate(e, t), this._activate(t, e));
      }
      _activate(t, e) {
        if (!t) return;
        t.classList.add(kt), this._activate(p.getElementFromSelector(t));
        let r = () => {
          if (t.getAttribute("role") !== "tab") {
            t.classList.add(Ii);
            return;
          }
          t.removeAttribute("tabindex"),
            t.setAttribute("aria-selected", !0),
            this._toggleDropDown(t, !0),
            c.trigger(t, Ul, { relatedTarget: e });
        };
        this._queueCallback(r, t, t.classList.contains(Ur));
      }
      _deactivate(t, e) {
        if (!t) return;
        t.classList.remove(kt),
          t.blur(),
          this._deactivate(p.getElementFromSelector(t));
        let r = () => {
          if (t.getAttribute("role") !== "tab") {
            t.classList.remove(Ii);
            return;
          }
          t.setAttribute("aria-selected", !1),
            t.setAttribute("tabindex", "-1"),
            this._toggleDropDown(t, !1),
            c.trigger(t, Kl, { relatedTarget: e });
        };
        this._queueCallback(r, t, t.classList.contains(Ur));
      }
      _keydown(t) {
        if (![Xl, Kr, Ql, Yr].includes(t.key)) return;
        t.stopPropagation(), t.preventDefault();
        let e = [Kr, Yr].includes(t.key),
          r = Wi(
            this._getChildren().filter((n) => !gt(n)),
            t.target,
            e,
            !0,
          );
        r && (r.focus({ preventScroll: !0 }), vt.getOrCreateInstance(r).show());
      }
      _getChildren() {
        return p.find(Mi, this._parent);
      }
      _getActiveElem() {
        return this._getChildren().find((t) => this._elemIsActive(t)) || null;
      }
      _setInitialAttributes(t, e) {
        this._setAttributeIfNotExists(t, "role", "tablist");
        for (let r of e) this._setInitialAttributesOnChild(r);
      }
      _setInitialAttributesOnChild(t) {
        t = this._getInnerElement(t);
        let e = this._elemIsActive(t),
          r = this._getOuterElement(t);
        t.setAttribute("aria-selected", e),
          r !== t && this._setAttributeIfNotExists(r, "role", "presentation"),
          e || t.setAttribute("tabindex", "-1"),
          this._setAttributeIfNotExists(t, "role", "tab"),
          this._setInitialAttributesOnTargetPanel(t);
      }
      _setInitialAttributesOnTargetPanel(t) {
        let e = p.getElementFromSelector(t);
        e &&
          (this._setAttributeIfNotExists(e, "role", "tabpanel"),
          t.id &&
            this._setAttributeIfNotExists(e, "aria-labelledby", `${t.id}`));
      }
      _toggleDropDown(t, e) {
        let r = this._getOuterElement(t);
        if (!r.classList.contains(Zl)) return;
        let n = (s, o) => {
          let a = p.findOne(s, r);
          a && a.classList.toggle(o, e);
        };
        n(Jl, kt), n(tc, Ii), r.setAttribute("aria-expanded", e);
      }
      _setAttributeIfNotExists(t, e, r) {
        t.hasAttribute(e) || t.setAttribute(e, r);
      }
      _elemIsActive(t) {
        return t.classList.contains(kt);
      }
      _getInnerElement(t) {
        return t.matches(Mi) ? t : p.findOne(Mi, t);
      }
      _getOuterElement(t) {
        return t.closest(ic) || t;
      }
      static jQueryInterface(t) {
        return this.each(function () {
          let e = vt.getOrCreateInstance(this);
          if (typeof t == "string") {
            if (e[t] === void 0 || t.startsWith("_") || t === "constructor")
              throw new TypeError(`No method named "${t}"`);
            e[t]();
          }
        });
      }
    };
  c.on(document, Gl, bn, function (i) {
    ["A", "AREA"].includes(this.tagName) && i.preventDefault(),
      !gt(this) && vt.getOrCreateInstance(this).show();
  });
  c.on(window, ql, () => {
    for (let i of p.find(nc)) vt.getOrCreateInstance(i);
  });
  Z(vt);
  var sc = "toast",
    oc = "bs.toast",
    At = `.${oc}`,
    ac = `mouseover${At}`,
    lc = `mouseout${At}`,
    cc = `focusin${At}`,
    uc = `focusout${At}`,
    fc = `hide${At}`,
    dc = `hidden${At}`,
    pc = `show${At}`,
    hc = `shown${At}`,
    mc = "fade",
    Gr = "hide",
    ze = "show",
    qe = "showing",
    _c = { animation: "boolean", autohide: "boolean", delay: "number" },
    gc = { animation: !0, autohide: !0, delay: 5e3 },
    ae = class extends Y {
      constructor(t, e) {
        super(t, e),
          (this._timeout = null),
          (this._hasMouseInteraction = !1),
          (this._hasKeyboardInteraction = !1),
          this._setListeners();
      }
      static get Default() {
        return gc;
      }
      static get DefaultType() {
        return _c;
      }
      static get NAME() {
        return sc;
      }
      show() {
        if (c.trigger(this._element, pc).defaultPrevented) return;
        this._clearTimeout(),
          this._config.animation && this._element.classList.add(mc);
        let e = () => {
          this._element.classList.remove(qe),
            c.trigger(this._element, hc),
            this._maybeScheduleHide();
        };
        this._element.classList.remove(Gr),
          Ce(this._element),
          this._element.classList.add(ze, qe),
          this._queueCallback(e, this._element, this._config.animation);
      }
      hide() {
        if (!this.isShown() || c.trigger(this._element, fc).defaultPrevented)
          return;
        let e = () => {
          this._element.classList.add(Gr),
            this._element.classList.remove(qe, ze),
            c.trigger(this._element, dc);
        };
        this._element.classList.add(qe),
          this._queueCallback(e, this._element, this._config.animation);
      }
      dispose() {
        this._clearTimeout(),
          this.isShown() && this._element.classList.remove(ze),
          super.dispose();
      }
      isShown() {
        return this._element.classList.contains(ze);
      }
      _maybeScheduleHide() {
        this._config.autohide &&
          (this._hasMouseInteraction ||
            this._hasKeyboardInteraction ||
            (this._timeout = setTimeout(() => {
              this.hide();
            }, this._config.delay)));
      }
      _onInteraction(t, e) {
        switch (t.type) {
          case "mouseover":
          case "mouseout": {
            this._hasMouseInteraction = e;
            break;
          }
          case "focusin":
          case "focusout": {
            this._hasKeyboardInteraction = e;
            break;
          }
        }
        if (e) {
          this._clearTimeout();
          return;
        }
        let r = t.relatedTarget;
        this._element === r ||
          this._element.contains(r) ||
          this._maybeScheduleHide();
      }
      _setListeners() {
        c.on(this._element, ac, (t) => this._onInteraction(t, !0)),
          c.on(this._element, lc, (t) => this._onInteraction(t, !1)),
          c.on(this._element, cc, (t) => this._onInteraction(t, !0)),
          c.on(this._element, uc, (t) => this._onInteraction(t, !1));
      }
      _clearTimeout() {
        clearTimeout(this._timeout), (this._timeout = null);
      }
      static jQueryInterface(t) {
        return this.each(function () {
          let e = ae.getOrCreateInstance(this, t);
          if (typeof t == "string") {
            if (typeof e[t] == "undefined")
              throw new TypeError(`No method named "${t}"`);
            e[t](this);
          }
        });
      }
    };
  ii(ae);
  Z(ae);
  (() => {
    "use strict";
    let i = document.getElementById("searchToggleMobile"),
      t = document.getElementById("searchToggleDesktop"),
      e = document.getElementById("searchModal"),
      r = document.getElementById("search-form"),
      n = document.getElementById("query"),
      s = document.getElementById("searchResults"),
      o = new nt(e, { focus: !0 });
    i.addEventListener("click", a), t.addEventListener("click", a);
    function a() {
      o.toggle(),
        document.querySelector(".search-no-recent").classList.remove("d-none");
    }
    document.addEventListener("keydown", u);
    function u(d) {
      d.ctrlKey &&
        d.key === "k" &&
        (d.preventDefault(),
        o.show(),
        r.reset(),
        (s.textContent = ""),
        document.querySelector(".search-no-recent").classList.remove("d-none")),
        d.key === "Escape" &&
          (r.reset(),
          (s.textContent = ""),
          f && (h(f, "selected"), (l = -1)),
          document.querySelector(".search-no-results").classList.add("d-none"));
    }
    document.addEventListener("click", function (d) {
      var g = e.contains(d.target);
      g ||
        (r.reset(),
        (s.textContent = ""),
        document.querySelector(".search-no-results").classList.add("d-none")),
        f && (h(f, "selected"), (l = -1));
    }),
      e.addEventListener("shown.bs.modal", () => {
        n.focus();
      });
    var f,
      l = -1;
    document.addEventListener(
      "keydown",
      function (d) {
        var g = s.getElementsByTagName("article").length - 1;
        if (d.key === "ArrowDown")
          if ((l++, f)) {
            h(f, "selected");
            let m = s.getElementsByTagName("article")[l];
            typeof m != "undefined" && l <= g
              ? (f = m)
              : ((l = 0), (f = s.getElementsByTagName("article")[0])),
              _(f, "selected");
          } else
            (l = 0),
              (f = s.getElementsByTagName("article")[0]),
              _(f, "selected");
        else if (d.key === "ArrowUp")
          if (f) {
            h(f, "selected"), l--;
            let m = s.getElementsByTagName("article")[l];
            typeof m != "undefined" && l >= 0
              ? (f = m)
              : ((l = g), (f = s.getElementsByTagName("article")[g])),
              _(f, "selected");
          } else
            (l = 0),
              (f = s.getElementsByTagName("article")[g]),
              _(f, "selected");
      },
      !1,
    );
    function h(d, g) {
      d.classList
        ? d.classList.remove(g)
        : (d.className = d.className.replace(
            new RegExp("(^|\\b)" + g.split(" ").join("|") + "(\\b|$)", "gi"),
            " ",
          )),
        f.querySelector("a").blur();
    }
    function _(d, g) {
      d.classList ? d.classList.add(g) : (d.className += " " + g),
        f.querySelector("a").focus();
    }
    s.addEventListener(
      "mouseover",
      () => {
        f && h(f, "selected");
      },
      !1,
    );
  })();
})();
/*!
 * Search modal for Bootstrap based Hyas sites
 * Copyright 2021-2023 Hyas
 * Licensed under the MIT License
 */
/*! Bundled license information:

bootstrap/dist/js/bootstrap.esm.js:
  (*!
    * Bootstrap v5.3.0 (https://getbootstrap.com/)
    * Copyright 2011-2023 The Bootstrap Authors (https://github.com/twbs/bootstrap/graphs/contributors)
    * Licensed under MIT (https://github.com/twbs/bootstrap/blob/main/LICENSE)
    *)
*/
