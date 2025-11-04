const Et = {},
  E = Symbol(),
  Qt = !1;
var Ce = Array.isArray,
  Ie = Array.prototype.indexOf,
  Pe = Array.from,
  Me = Object.defineProperty,
  lt = Object.getOwnPropertyDescriptor,
  Ye = Object.prototype,
  Le = Array.prototype,
  $e = Object.getPrototypeOf,
  Ut = Object.isExtensible;
function He(t) {
  for (var e = 0; e < t.length; e++) t[e]();
}
function je() {
  var t,
    e,
    n = new Promise((r, s) => {
      ((t = r), (e = s));
    });
  return { promise: n, resolve: t, reject: e };
}
const m = 2,
  Xt = 4,
  te = 8,
  L = 16,
  J = 32,
  Q = 64,
  kt = 128,
  y = 1024,
  k = 2048,
  $ = 4096,
  U = 8192,
  G = 16384,
  ee = 32768,
  mt = 65536,
  Bt = 1 << 17,
  ne = 1 << 18,
  St = 1 << 19,
  qe = 1 << 20,
  P = 256,
  bt = 512,
  Tt = 32768,
  Ct = 1 << 21,
  re = 1 << 22,
  ot = 1 << 23,
  Dt = Symbol("$state"),
  se = new (class extends Error {
    name = "StaleReactionError";
    message =
      "The reaction that called `getAbortSignal()` was re-run or destroyed";
  })(),
  Nt = 8;
function Ue() {
  throw new Error("https://svelte.dev/e/effect_update_depth_exceeded");
}
function Be() {
  throw new Error("https://svelte.dev/e/hydration_failed");
}
function Ve() {
  throw new Error("https://svelte.dev/e/state_descriptors_fixed");
}
function Ke() {
  throw new Error("https://svelte.dev/e/state_prototype_fixed");
}
function We() {
  throw new Error("https://svelte.dev/e/state_unsafe_mutation");
}
function ze() {
  throw new Error("https://svelte.dev/e/svelte_boundary_reset_onerror");
}
function ie(t) {
  console.warn("https://svelte.dev/e/hydration_mismatch");
}
function Ge() {
  console.warn("https://svelte.dev/e/svelte_boundary_reset_noop");
}
let O = !1;
function dt(t) {
  O = t;
}
let T;
function at(t) {
  if (t === null) throw (ie(), Et);
  return (T = t);
}
function fe() {
  return at(it(T));
}
function Ze(t = 1) {
  if (O) {
    for (var e = t, n = T; e--; ) n = it(n);
    T = n;
  }
}
function Je(t = !0) {
  for (var e = 0, n = T; ; ) {
    if (n.nodeType === Nt) {
      var r = n.data;
      if (r === "]") {
        if (e === 0) return n;
        e -= 1;
      } else (r === "[" || r === "[!") && (e += 1);
    }
    var s = it(n);
    (t && n.remove(), (n = s));
  }
}
function Qe(t) {
  return t === this.v;
}
let Xe = !1,
  Y = null;
function Rt(t) {
  Y = t;
}
function tn(t, e = !1, n) {
  Y = { p: Y, i: !1, c: null, e: null, s: t, x: null, l: null };
}
function en(t) {
  var e = Y,
    n = e.e;
  if (n !== null) {
    e.e = null;
    for (var r of n) pn(r);
  }
  return ((e.i = !0), (Y = e.p), {});
}
function le() {
  return !0;
}
let tt = [];
function nn() {
  var t = tt;
  ((tt = []), He(t));
}
function Lt(t) {
  if (tt.length === 0) {
    var e = tt;
    queueMicrotask(() => {
      e === tt && nn();
    });
  }
  tt.push(t);
}
function ue(t) {
  var e = p;
  if (e === null) return ((d.f |= ot), t);
  if ((e.f & ee) === 0) {
    if ((e.f & kt) === 0) throw t;
    e.b.error(t);
  } else xt(t, e);
}
function xt(t, e) {
  for (; e !== null; ) {
    if ((e.f & kt) !== 0)
      try {
        e.b.error(t);
        return;
      } catch (n) {
        t = n;
      }
    e = e.parent;
  }
  throw t;
}
const pt = new Set();
let R = null,
  S = null,
  j = [],
  $t = null,
  It = !1;
class D {
  committed = !1;
  current = new Map();
  previous = new Map();
  #r = new Set();
  #t = new Set();
  #u = 0;
  #i = 0;
  #o = null;
  #f = [];
  #s = [];
  skipped_effects = new Set();
  is_fork = !1;
  process(e) {
    ((j = []), this.apply());
    var n = {
      parent: null,
      effect: null,
      effects: [],
      render_effects: [],
      block_effects: [],
    };
    for (const r of e) this.#e(r, n);
    (this.is_fork || this.#l(),
      this.#i > 0 || this.is_fork
        ? (this.#n(n.effects),
          this.#n(n.render_effects),
          this.#n(n.block_effects))
        : ((R = null), Vt(n.render_effects), Vt(n.effects), this.#o?.resolve()),
      (S = null));
  }
  #e(e, n) {
    e.f ^= y;
    for (var r = e.first; r !== null; ) {
      var s = r.f,
        i = (s & (J | Q)) !== 0,
        f = i && (s & y) !== 0,
        u = f || (s & U) !== 0 || this.skipped_effects.has(r);
      if (
        ((r.f & kt) !== 0 &&
          r.b?.is_pending() &&
          (n = {
            parent: n,
            effect: r,
            effects: [],
            render_effects: [],
            block_effects: [],
          }),
        !u && r.fn !== null)
      ) {
        i
          ? (r.f ^= y)
          : (s & Xt) !== 0
            ? n.effects.push(r)
            : vt(r) && ((r.f & L) !== 0 && n.block_effects.push(r), _t(r));
        var l = r.first;
        if (l !== null) {
          r = l;
          continue;
        }
      }
      var o = r.parent;
      for (r = r.next; r === null && o !== null; )
        (o === n.effect &&
          (this.#n(n.effects),
          this.#n(n.render_effects),
          this.#n(n.block_effects),
          (n = n.parent)),
          (r = o.next),
          (o = o.parent));
    }
  }
  #n(e) {
    for (const n of e) (((n.f & k) !== 0 ? this.#f : this.#s).push(n), g(n, y));
  }
  capture(e, n) {
    (this.previous.has(e) || this.previous.set(e, n),
      (e.f & ot) === 0 && (this.current.set(e, e.v), S?.set(e, e.v)));
  }
  activate() {
    ((R = this), this.apply());
  }
  deactivate() {
    ((R = null), (S = null));
  }
  flush() {
    if ((this.activate(), j.length > 0)) {
      if ((rn(), R !== null && R !== this)) return;
    } else this.#u === 0 && this.process([]);
    this.deactivate();
  }
  discard() {
    for (const e of this.#t) e(this);
    this.#t.clear();
  }
  #l() {
    if (this.#i === 0) {
      for (const e of this.#r) e();
      this.#r.clear();
    }
    this.#u === 0 && this.#a();
  }
  #a() {
    if (pt.size > 1) {
      this.previous.clear();
      var e = S,
        n = !0,
        r = {
          parent: null,
          effect: null,
          effects: [],
          render_effects: [],
          block_effects: [],
        };
      for (const s of pt) {
        if (s === this) {
          n = !1;
          continue;
        }
        const i = [];
        for (const [u, l] of this.current) {
          if (s.current.has(u))
            if (n && l !== s.current.get(u)) s.current.set(u, l);
            else continue;
          i.push(u);
        }
        if (i.length === 0) continue;
        const f = [...s.current.keys()].filter((u) => !this.current.has(u));
        if (f.length > 0) {
          const u = new Set(),
            l = new Map();
          for (const o of i) oe(o, f, u, l);
          if (j.length > 0) {
            ((R = s), s.apply());
            for (const o of j) s.#e(o, r);
            ((j = []), s.deactivate());
          }
        }
      }
      ((R = null), (S = e));
    }
    ((this.committed = !0), pt.delete(this));
  }
  increment(e) {
    ((this.#u += 1), e && (this.#i += 1));
  }
  decrement(e) {
    ((this.#u -= 1), e && (this.#i -= 1), this.revive());
  }
  revive() {
    for (const e of this.#f) (g(e, k), st(e));
    for (const e of this.#s) (g(e, $), st(e));
    ((this.#f = []), (this.#s = []), this.flush());
  }
  oncommit(e) {
    this.#r.add(e);
  }
  ondiscard(e) {
    this.#t.add(e);
  }
  settled() {
    return (this.#o ??= je()).promise;
  }
  static ensure() {
    if (R === null) {
      const e = (R = new D());
      (pt.add(R),
        D.enqueue(() => {
          R === e && e.flush();
        }));
    }
    return R;
  }
  static enqueue(e) {
    Lt(e);
  }
  apply() {}
}
function rn() {
  var t = rt;
  It = !0;
  try {
    var e = 0;
    for (Wt(!0); j.length > 0; ) {
      var n = D.ensure();
      if (e++ > 1e3) {
        var r, s;
        sn();
      }
      (n.process(j), B.clear());
    }
  } finally {
    ((It = !1), Wt(t), ($t = null));
  }
}
function sn() {
  try {
    Ue();
  } catch (t) {
    xt(t, $t);
  }
}
let I = null;
function Vt(t) {
  var e = t.length;
  if (e !== 0) {
    for (var n = 0; n < e; ) {
      var r = t[n++];
      if (
        (r.f & (G | U)) === 0 &&
        vt(r) &&
        ((I = new Set()),
        _t(r),
        r.deps === null &&
          r.first === null &&
          r.nodes_start === null &&
          (r.teardown === null && r.ac === null ? Te(r) : (r.fn = null)),
        I?.size > 0)
      ) {
        B.clear();
        for (const s of I) {
          if ((s.f & (G | U)) !== 0) continue;
          const i = [s];
          let f = s.parent;
          for (; f !== null; )
            (I.has(f) && (I.delete(f), i.push(f)), (f = f.parent));
          for (let u = i.length - 1; u >= 0; u--) {
            const l = i[u];
            (l.f & (G | U)) === 0 && _t(l);
          }
        }
        I.clear();
      }
    }
    I = null;
  }
}
function oe(t, e, n, r) {
  if (!n.has(t) && (n.add(t), t.reactions !== null))
    for (const s of t.reactions) {
      const i = s.f;
      (i & m) !== 0
        ? oe(s, e, n, r)
        : (i & (re | L)) !== 0 &&
          (i & k) === 0 &&
          ae(s, e, r) &&
          (g(s, k), st(s));
    }
}
function ae(t, e, n) {
  const r = n.get(t);
  if (r !== void 0) return r;
  if (t.deps !== null)
    for (const s of t.deps) {
      if (e.includes(s)) return !0;
      if ((s.f & m) !== 0 && ae(s, e, n)) return (n.set(s, !0), !0);
    }
  return (n.set(t, !1), !1);
}
function st(t) {
  for (var e = ($t = t); e.parent !== null; ) {
    e = e.parent;
    var n = e.f;
    if (It && e === p && (n & L) !== 0 && (n & ne) === 0) return;
    if ((n & (Q | J)) !== 0) {
      if ((n & y) === 0) return;
      e.f ^= y;
    }
  }
  j.push(e);
}
function fn(t) {
  let e = 0,
    n = jt(0),
    r;
  return () => {
    vn() &&
      (nt(n),
      yn(
        () => (
          e === 0 && (r = kn(() => t(() => ut(n)))),
          (e += 1),
          () => {
            Lt(() => {
              ((e -= 1), e === 0 && (r?.(), (r = void 0), ut(n)));
            });
          }
        ),
      ));
  };
}
var ln = mt | St | kt;
function un(t, e, n) {
  new on(t, e, n);
}
class on {
  parent;
  #r = !1;
  #t;
  #u = O ? T : null;
  #i;
  #o;
  #f;
  #s = null;
  #e = null;
  #n = null;
  #l = null;
  #a = null;
  #h = 0;
  #c = 0;
  #v = !1;
  #_ = null;
  #g = fn(
    () => (
      (this.#_ = jt(this.#h)),
      () => {
        this.#_ = null;
      }
    ),
  );
  constructor(e, n, r) {
    ((this.#t = e),
      (this.#i = n),
      (this.#o = r),
      (this.parent = p.b),
      (this.#r = !!this.#i.pending),
      (this.#f = gn(() => {
        if (((p.b = this), O)) {
          const i = this.#u;
          (fe(), i.nodeType === Nt && i.data === "[!" ? this.#m() : this.#E());
        } else {
          var s = this.#w();
          try {
            this.#s = W(() => r(s));
          } catch (i) {
            this.error(i);
          }
          this.#c > 0 ? this.#p() : (this.#r = !1);
        }
        return () => {
          this.#a?.remove();
        };
      }, ln)),
      O && (this.#t = T));
  }
  #E() {
    try {
      this.#s = W(() => this.#o(this.#t));
    } catch (e) {
      this.error(e);
    }
    this.#r = !1;
  }
  #m() {
    const e = this.#i.pending;
    e &&
      ((this.#e = W(() => e(this.#t))),
      D.enqueue(() => {
        var n = this.#w();
        ((this.#s = this.#d(() => (D.ensure(), W(() => this.#o(n))))),
          this.#c > 0
            ? this.#p()
            : (gt(this.#e, () => {
                this.#e = null;
              }),
              (this.#r = !1)));
      }));
  }
  #w() {
    var e = this.#t;
    return (
      this.#r && ((this.#a = ye()), this.#t.before(this.#a), (e = this.#a)),
      e
    );
  }
  is_pending() {
    return this.#r || (!!this.parent && this.parent.is_pending());
  }
  has_pending_snippet() {
    return !!this.#i.pending;
  }
  #d(e) {
    var n = p,
      r = d,
      s = Y;
    (V(this.#f), A(this.#f), Rt(this.#f.ctx));
    try {
      return e();
    } catch (i) {
      return (ue(i), null);
    } finally {
      (V(n), A(r), Rt(s));
    }
  }
  #p() {
    const e = this.#i.pending;
    (this.#s !== null &&
      ((this.#l = document.createDocumentFragment()),
      this.#l.append(this.#a),
      Tn(this.#s, this.#l)),
      this.#e === null && (this.#e = W(() => e(this.#t))));
  }
  #y(e) {
    if (!this.has_pending_snippet()) {
      this.parent && this.parent.#y(e);
      return;
    }
    ((this.#c += e),
      this.#c === 0 &&
        ((this.#r = !1),
        this.#e &&
          gt(this.#e, () => {
            this.#e = null;
          }),
        this.#l && (this.#t.before(this.#l), (this.#l = null))));
  }
  update_pending_count(e) {
    (this.#y(e), (this.#h += e), this.#_ && ve(this.#_, this.#h));
  }
  get_effect_pending() {
    return (this.#g(), nt(this.#_));
  }
  error(e) {
    var n = this.#i.onerror;
    let r = this.#i.failed;
    if (this.#v || (!n && !r)) throw e;
    (this.#s && (F(this.#s), (this.#s = null)),
      this.#e && (F(this.#e), (this.#e = null)),
      this.#n && (F(this.#n), (this.#n = null)),
      O && (at(this.#u), Ze(), at(Je())));
    var s = !1,
      i = !1;
    const f = () => {
      if (s) {
        Ge();
        return;
      }
      ((s = !0),
        i && ze(),
        D.ensure(),
        (this.#h = 0),
        this.#n !== null &&
          gt(this.#n, () => {
            this.#n = null;
          }),
        (this.#r = this.has_pending_snippet()),
        (this.#s = this.#d(() => ((this.#v = !1), W(() => this.#o(this.#t))))),
        this.#c > 0 ? this.#p() : (this.#r = !1));
    };
    var u = d;
    try {
      (A(null), (i = !0), n?.(e, f), (i = !1));
    } catch (l) {
      xt(l, this.#f && this.#f.parent);
    } finally {
      A(u);
    }
    r &&
      Lt(() => {
        this.#n = this.#d(() => {
          (D.ensure(), (this.#v = !0));
          try {
            return W(() => {
              r(
                this.#t,
                () => e,
                () => f,
              );
            });
          } catch (l) {
            return (xt(l, this.#f.parent), null);
          } finally {
            this.#v = !1;
          }
        });
      });
  }
}
function ce(t) {
  var e = t.effects;
  if (e !== null) {
    t.effects = null;
    for (var n = 0; n < e.length; n += 1) F(e[n]);
  }
}
function an(t) {
  for (var e = t.parent; e !== null; ) {
    if ((e.f & m) === 0) return e;
    e = e.parent;
  }
  return null;
}
function Ht(t) {
  var e,
    n = p;
  V(an(t));
  try {
    ((t.f &= ~Tt), ce(t), (e = Se(t)));
  } finally {
    V(n);
  }
  return e;
}
function _e(t) {
  var e = Ht(t);
  if ((t.equals(e) || ((t.v = e), (t.wv = Ae())), !ht))
    if (S !== null) S.set(t, t.v);
    else {
      var n = (q || (t.f & P) !== 0) && t.deps !== null ? $ : y;
      g(t, n);
    }
}
let Pt = new Set();
const B = new Map();
let he = !1;
function jt(t, e) {
  var n = { f: 0, v: t, reactions: null, equals: Qe, rv: 0, wv: 0 };
  return n;
}
function H(t, e) {
  const n = jt(t);
  return (Rn(n), n);
}
function z(t, e, n = !1) {
  d !== null &&
    (!N || (d.f & Bt) !== 0) &&
    le() &&
    (d.f & (m | L | re | Bt)) !== 0 &&
    !M?.includes(t) &&
    We();
  let r = n ? et(e) : e;
  return ve(t, r);
}
function ve(t, e) {
  if (!t.equals(e)) {
    var n = t.v;
    (ht ? B.set(t, e) : B.set(t, n), (t.v = e));
    var r = D.ensure();
    (r.capture(t, n),
      (t.f & m) !== 0 &&
        ((t.f & k) !== 0 && Ht(t), g(t, (t.f & P) === 0 ? y : $)),
      (t.wv = Ae()),
      de(t, k),
      p !== null &&
        (p.f & y) !== 0 &&
        (p.f & (J | Q)) === 0 &&
        (x === null ? xn([t]) : x.push(t)),
      !r.is_fork && Pt.size > 0 && !he && cn());
  }
  return e;
}
function cn() {
  he = !1;
  const t = Array.from(Pt);
  for (const e of t) ((e.f & y) !== 0 && g(e, $), vt(e) && _t(e));
  Pt.clear();
}
function ut(t) {
  z(t, t.v + 1);
}
function de(t, e) {
  var n = t.reactions;
  if (n !== null)
    for (var r = n.length, s = 0; s < r; s++) {
      var i = n[s],
        f = i.f,
        u = (f & k) === 0;
      (u && g(i, e),
        (f & m) !== 0
          ? (f & Tt) === 0 && ((i.f |= Tt), de(i, $))
          : u && ((f & L) !== 0 && I !== null && I.add(i), st(i)));
    }
}
function et(t) {
  if (typeof t != "object" || t === null || Dt in t) return t;
  const e = $e(t);
  if (e !== Ye && e !== Le) return t;
  var n = new Map(),
    r = Ce(t),
    s = H(0),
    i = Z,
    f = (u) => {
      if (Z === i) return u();
      var l = d,
        o = Z;
      (A(null), Gt(i));
      var a = u();
      return (A(l), Gt(o), a);
    };
  return (
    r && n.set("length", H(t.length)),
    new Proxy(t, {
      defineProperty(u, l, o) {
        (!("value" in o) ||
          o.configurable === !1 ||
          o.enumerable === !1 ||
          o.writable === !1) &&
          Ve();
        var a = n.get(l);
        return (
          a === void 0
            ? (a = f(() => {
                var h = H(o.value);
                return (n.set(l, h), h);
              }))
            : z(a, o.value, !0),
          !0
        );
      },
      deleteProperty(u, l) {
        var o = n.get(l);
        if (o === void 0) {
          if (l in u) {
            const a = f(() => H(E));
            (n.set(l, a), ut(s));
          }
        } else (z(o, E), ut(s));
        return !0;
      },
      get(u, l, o) {
        if (l === Dt) return t;
        var a = n.get(l),
          h = l in u;
        if (
          (a === void 0 &&
            (!h || lt(u, l)?.writable) &&
            ((a = f(() => {
              var c = et(h ? u[l] : E),
                v = H(c);
              return v;
            })),
            n.set(l, a)),
          a !== void 0)
        ) {
          var _ = nt(a);
          return _ === E ? void 0 : _;
        }
        return Reflect.get(u, l, o);
      },
      getOwnPropertyDescriptor(u, l) {
        var o = Reflect.getOwnPropertyDescriptor(u, l);
        if (o && "value" in o) {
          var a = n.get(l);
          a && (o.value = nt(a));
        } else if (o === void 0) {
          var h = n.get(l),
            _ = h?.v;
          if (h !== void 0 && _ !== E)
            return { enumerable: !0, configurable: !0, value: _, writable: !0 };
        }
        return o;
      },
      has(u, l) {
        if (l === Dt) return !0;
        var o = n.get(l),
          a = (o !== void 0 && o.v !== E) || Reflect.has(u, l);
        if (o !== void 0 || (p !== null && (!a || lt(u, l)?.writable))) {
          o === void 0 &&
            ((o = f(() => {
              var _ = a ? et(u[l]) : E,
                c = H(_);
              return c;
            })),
            n.set(l, o));
          var h = nt(o);
          if (h === E) return !1;
        }
        return a;
      },
      set(u, l, o, a) {
        var h = n.get(l),
          _ = l in u;
        if (r && l === "length")
          for (var c = o; c < h.v; c += 1) {
            var v = n.get(c + "");
            v !== void 0
              ? z(v, E)
              : c in u && ((v = f(() => H(E))), n.set(c + "", v));
          }
        if (h === void 0)
          (!_ || lt(u, l)?.writable) &&
            ((h = f(() => H(void 0))), z(h, et(o)), n.set(l, h));
        else {
          _ = h.v !== E;
          var C = f(() => et(o));
          z(h, C);
        }
        var K = Reflect.getOwnPropertyDescriptor(u, l);
        if ((K?.set && K.set.call(a, o), !_)) {
          if (r && typeof l == "string") {
            var qt = n.get("length"),
              Ot = Number(l);
            Number.isInteger(Ot) && Ot >= qt.v && z(qt, Ot + 1);
          }
          ut(s);
        }
        return !0;
      },
      ownKeys(u) {
        nt(s);
        var l = Reflect.ownKeys(u).filter((h) => {
          var _ = n.get(h);
          return _ === void 0 || _.v !== E;
        });
        for (var [o, a] of n) a.v !== E && !(o in u) && l.push(o);
        return l;
      },
      setPrototypeOf() {
        Ke();
      },
    })
  );
}
var Kt, pe, we;
function Mt() {
  if (Kt === void 0) {
    Kt = window;
    var t = Element.prototype,
      e = Node.prototype,
      n = Text.prototype;
    ((pe = lt(e, "firstChild").get),
      (we = lt(e, "nextSibling").get),
      Ut(t) &&
        ((t.__click = void 0),
        (t.__className = void 0),
        (t.__attributes = null),
        (t.__style = void 0),
        (t.__e = void 0)),
      Ut(n) && (n.__t = void 0));
  }
}
function ye(t = "") {
  return document.createTextNode(t);
}
function ge(t) {
  return pe.call(t);
}
function it(t) {
  return we.call(t);
}
function _n(t) {
  t.textContent = "";
}
function Ee(t) {
  var e = d,
    n = p;
  (A(null), V(null));
  try {
    return t();
  } finally {
    (A(e), V(n));
  }
}
function hn(t, e) {
  var n = e.last;
  n === null
    ? (e.last = e.first = t)
    : ((n.next = t), (t.prev = n), (e.last = t));
}
function ft(t, e, n, r = !0) {
  var s = p;
  s !== null && (s.f & U) !== 0 && (t |= U);
  var i = {
    ctx: Y,
    deps: null,
    nodes_start: null,
    nodes_end: null,
    f: t | k,
    first: null,
    fn: e,
    last: null,
    next: null,
    parent: s,
    b: s && s.b,
    prev: null,
    teardown: null,
    transitions: null,
    wv: 0,
    ac: null,
  };
  if (n)
    try {
      (_t(i), (i.f |= ee));
    } catch (l) {
      throw (F(i), l);
    }
  else e !== null && st(i);
  if (r) {
    var f = i;
    if (
      (n &&
        f.deps === null &&
        f.teardown === null &&
        f.nodes_start === null &&
        f.first === f.last &&
        (f.f & St) === 0 &&
        ((f = f.first),
        (t & L) !== 0 && (t & mt) !== 0 && f !== null && (f.f |= mt)),
      f !== null &&
        ((f.parent = s),
        s !== null && hn(f, s),
        d !== null && (d.f & m) !== 0 && (t & Q) === 0))
    ) {
      var u = d;
      (u.effects ??= []).push(f);
    }
  }
  return i;
}
function vn() {
  return d !== null && !N;
}
function dn(t) {
  const e = ft(te, null, !1);
  return (g(e, y), (e.teardown = t), e);
}
function pn(t) {
  return ft(Xt | qe, t, !1);
}
function wn(t) {
  D.ensure();
  const e = ft(Q | St, t, !0);
  return (n = {}) =>
    new Promise((r) => {
      n.outro
        ? gt(e, () => {
            (F(e), r(void 0));
          })
        : (F(e), r(void 0));
    });
}
function yn(t, e = 0) {
  return ft(te | e, t, !0);
}
function gn(t, e = 0) {
  var n = ft(L | e, t, !0);
  return n;
}
function W(t, e = !0) {
  return ft(J | St, t, !0, e);
}
function me(t) {
  var e = t.teardown;
  if (e !== null) {
    const n = ht,
      r = d;
    (zt(!0), A(null));
    try {
      e.call(null);
    } finally {
      (zt(n), A(r));
    }
  }
}
function be(t, e = !1) {
  var n = t.first;
  for (t.first = t.last = null; n !== null; ) {
    const s = n.ac;
    s !== null &&
      Ee(() => {
        s.abort(se);
      });
    var r = n.next;
    ((n.f & Q) !== 0 ? (n.parent = null) : F(n, e), (n = r));
  }
}
function En(t) {
  for (var e = t.first; e !== null; ) {
    var n = e.next;
    ((e.f & J) === 0 && F(e), (e = n));
  }
}
function F(t, e = !0) {
  var n = !1;
  ((e || (t.f & ne) !== 0) &&
    t.nodes_start !== null &&
    t.nodes_end !== null &&
    (mn(t.nodes_start, t.nodes_end), (n = !0)),
    be(t, e && !n),
    At(t, 0),
    g(t, G));
  var r = t.transitions;
  if (r !== null) for (const i of r) i.stop();
  me(t);
  var s = t.parent;
  (s !== null && s.first !== null && Te(t),
    (t.next =
      t.prev =
      t.teardown =
      t.ctx =
      t.deps =
      t.fn =
      t.nodes_start =
      t.nodes_end =
      t.ac =
        null));
}
function mn(t, e) {
  for (; t !== null; ) {
    var n = t === e ? null : it(t);
    (t.remove(), (t = n));
  }
}
function Te(t) {
  var e = t.parent,
    n = t.prev,
    r = t.next;
  (n !== null && (n.next = r),
    r !== null && (r.prev = n),
    e !== null &&
      (e.first === t && (e.first = r), e.last === t && (e.last = n)));
}
function gt(t, e, n = !0) {
  var r = [];
  (Re(t, r, !0),
    bn(r, () => {
      (n && F(t), e && e());
    }));
}
function bn(t, e) {
  var n = t.length;
  if (n > 0) {
    var r = () => --n || e();
    for (var s of t) s.out(r);
  } else e();
}
function Re(t, e, n) {
  if ((t.f & U) === 0) {
    if (((t.f ^= U), t.transitions !== null))
      for (const f of t.transitions) (f.is_global || n) && e.push(f);
    for (var r = t.first; r !== null; ) {
      var s = r.next,
        i = (r.f & mt) !== 0 || ((r.f & J) !== 0 && (t.f & L) !== 0);
      (Re(r, e, i ? n : !1), (r = s));
    }
  }
}
function Tn(t, e) {
  for (var n = t.nodes_start, r = t.nodes_end; n !== null; ) {
    var s = n === r ? null : it(n);
    (e.append(n), (n = s));
  }
}
let rt = !1;
function Wt(t) {
  rt = t;
}
let ht = !1;
function zt(t) {
  ht = t;
}
let d = null,
  N = !1;
function A(t) {
  d = t;
}
let p = null;
function V(t) {
  p = t;
}
let M = null;
function Rn(t) {
  d !== null && (M === null ? (M = [t]) : M.push(t));
}
let w = null,
  b = 0,
  x = null;
function xn(t) {
  x = t;
}
let xe = 1,
  ct = 0,
  Z = ct;
function Gt(t) {
  Z = t;
}
let q = !1;
function Ae() {
  return ++xe;
}
function vt(t) {
  var e = t.f;
  if ((e & k) !== 0) return !0;
  if ((e & $) !== 0) {
    var n = t.deps,
      r = (e & P) !== 0;
    if ((e & m && (t.f &= ~Tt), n !== null)) {
      var s,
        i,
        f = (e & bt) !== 0,
        u = r && p !== null && !q,
        l = n.length;
      if ((f || u) && (p === null || (p.f & G) === 0)) {
        var o = t,
          a = o.parent;
        for (s = 0; s < l; s++)
          ((i = n[s]),
            (f || !i?.reactions?.includes(o)) && (i.reactions ??= []).push(o));
        (f && (o.f ^= bt), u && a !== null && (a.f & P) === 0 && (o.f ^= P));
      }
      for (s = 0; s < l; s++)
        if (((i = n[s]), vt(i) && _e(i), i.wv > t.wv)) return !0;
    }
    (!r || (p !== null && !q)) && g(t, y);
  }
  return !1;
}
function ke(t, e, n = !0) {
  var r = t.reactions;
  if (r !== null && !M?.includes(t))
    for (var s = 0; s < r.length; s++) {
      var i = r[s];
      (i.f & m) !== 0
        ? ke(i, e, !1)
        : e === i && (n ? g(i, k) : (i.f & y) !== 0 && g(i, $), st(i));
    }
}
function Se(t) {
  var e = w,
    n = b,
    r = x,
    s = d,
    i = q,
    f = M,
    u = Y,
    l = N,
    o = Z,
    a = t.f;
  ((w = null),
    (b = 0),
    (x = null),
    (q = (a & P) !== 0 && (N || !rt || d === null)),
    (d = (a & (J | Q)) === 0 ? t : null),
    (M = null),
    Rt(t.ctx),
    (N = !1),
    (Z = ++ct),
    t.ac !== null &&
      (Ee(() => {
        t.ac.abort(se);
      }),
      (t.ac = null)));
  try {
    t.f |= Ct;
    var h = t.fn,
      _ = h(),
      c = t.deps;
    if (w !== null) {
      var v;
      if ((At(t, b), c !== null && b > 0))
        for (c.length = b + w.length, v = 0; v < w.length; v++) c[b + v] = w[v];
      else t.deps = c = w;
      if (!q || ((a & m) !== 0 && t.reactions !== null))
        for (v = b; v < c.length; v++) (c[v].reactions ??= []).push(t);
    } else c !== null && b < c.length && (At(t, b), (c.length = b));
    if (le() && x !== null && !N && c !== null && (t.f & (m | $ | k)) === 0)
      for (v = 0; v < x.length; v++) ke(x[v], t);
    return (
      s !== null &&
        s !== t &&
        (ct++, x !== null && (r === null ? (r = x) : r.push(...x))),
      (t.f & ot) !== 0 && (t.f ^= ot),
      _
    );
  } catch (C) {
    return ue(C);
  } finally {
    ((t.f ^= Ct),
      (w = e),
      (b = n),
      (x = r),
      (d = s),
      (q = i),
      (M = f),
      Rt(u),
      (N = l),
      (Z = o));
  }
}
function An(t, e) {
  let n = e.reactions;
  if (n !== null) {
    var r = Ie.call(n, t);
    if (r !== -1) {
      var s = n.length - 1;
      s === 0 ? (n = e.reactions = null) : ((n[r] = n[s]), n.pop());
    }
  }
  n === null &&
    (e.f & m) !== 0 &&
    (w === null || !w.includes(e)) &&
    (g(e, $), (e.f & (P | bt)) === 0 && (e.f ^= bt), ce(e), At(e, 0));
}
function At(t, e) {
  var n = t.deps;
  if (n !== null) for (var r = e; r < n.length; r++) An(t, n[r]);
}
function _t(t) {
  var e = t.f;
  if ((e & G) === 0) {
    g(t, y);
    var n = p,
      r = rt;
    ((p = t), (rt = !0));
    try {
      ((e & L) !== 0 ? En(t) : be(t), me(t));
      var s = Se(t);
      ((t.teardown = typeof s == "function" ? s : null), (t.wv = xe));
      var i;
      Qt && Xe && (t.f & k) !== 0 && t.deps;
    } finally {
      ((rt = r), (p = n));
    }
  }
}
function nt(t) {
  var e = t.f,
    n = (e & m) !== 0;
  if (d !== null && !N) {
    var r = p !== null && (p.f & G) !== 0;
    if (!r && !M?.includes(t)) {
      var s = d.deps;
      if ((d.f & Ct) !== 0)
        t.rv < ct &&
          ((t.rv = ct),
          w === null && s !== null && s[b] === t
            ? b++
            : w === null
              ? (w = [t])
              : (!q || !w.includes(t)) && w.push(t));
      else {
        (d.deps ??= []).push(t);
        var i = t.reactions;
        i === null ? (t.reactions = [d]) : i.includes(d) || i.push(d);
      }
    }
  } else if (n && t.deps === null && t.effects === null) {
    var f = t,
      u = f.parent;
    u !== null && (u.f & P) === 0 && (f.f ^= P);
  }
  if (ht) {
    if (B.has(t)) return B.get(t);
    if (n) {
      f = t;
      var l = f.v;
      return (
        (((f.f & y) === 0 && f.reactions !== null) || Ne(f)) && (l = Ht(f)),
        B.set(f, l),
        l
      );
    }
  } else if (n) {
    if (((f = t), S?.has(f))) return S.get(f);
    vt(f) && _e(f);
  }
  if (S?.has(t)) return S.get(t);
  if ((t.f & ot) !== 0) throw t.v;
  return t.v;
}
function Ne(t) {
  if (t.v === E) return !0;
  if (t.deps === null) return !1;
  for (const e of t.deps) if (B.has(e) || ((e.f & m) !== 0 && Ne(e))) return !0;
  return !1;
}
function kn(t) {
  var e = N;
  try {
    return ((N = !0), t());
  } finally {
    N = e;
  }
}
const Sn = -7169;
function g(t, e) {
  t.f = (t.f & Sn) | e;
}
const Nn = new Set(),
  Zt = new Set();
let Jt = null;
function wt(t) {
  var e = this,
    n = e.ownerDocument,
    r = t.type,
    s = t.composedPath?.() || [],
    i = s[0] || t.target;
  Jt = t;
  var f = 0,
    u = Jt === t && t.__root;
  if (u) {
    var l = s.indexOf(u);
    if (l !== -1 && (e === document || e === window)) {
      t.__root = e;
      return;
    }
    var o = s.indexOf(e);
    if (o === -1) return;
    l <= o && (f = l);
  }
  if (((i = s[f] || t.target), i !== e)) {
    Me(t, "currentTarget", {
      configurable: !0,
      get() {
        return i || n;
      },
    });
    var a = d,
      h = p;
    (A(null), V(null));
    try {
      for (var _, c = []; i !== null; ) {
        var v = i.assignedSlot || i.parentNode || i.host || null;
        try {
          var C = i["__" + r];
          C != null && (!i.disabled || t.target === i) && C.call(i, t);
        } catch (K) {
          _ ? c.push(K) : (_ = K);
        }
        if (t.cancelBubble || v === e || v === null) break;
        i = v;
      }
      if (_) {
        for (let K of c)
          queueMicrotask(() => {
            throw K;
          });
        throw _;
      }
    } finally {
      ((t.__root = e), delete t.currentTarget, A(a), V(h));
    }
  }
}
function On(t) {
  var e = document.createElement("template");
  return ((e.innerHTML = t.replaceAll("<!>", "<!---->")), e.content);
}
function Oe(t, e) {
  var n = p;
  n.nodes_start === null && ((n.nodes_start = t), (n.nodes_end = e));
}
const Dn = ["touchstart", "touchmove"];
function Fn(t) {
  return Dn.includes(t);
}
function De(t, e) {
  return Fe(t, e);
}
function Cn(t, e) {
  (Mt(), (e.intro = e.intro ?? !1));
  const n = e.target,
    r = O,
    s = T;
  try {
    for (var i = ge(n); i && (i.nodeType !== Nt || i.data !== "["); ) i = it(i);
    if (!i) throw Et;
    (dt(!0), at(i));
    const f = Fe(t, { ...e, anchor: i });
    return (dt(!1), f);
  } catch (f) {
    if (
      f instanceof Error &&
      f.message
        .split(
          `
`,
        )
        .some((u) => u.startsWith("https://svelte.dev/e/"))
    )
      throw f;
    return (
      f !== Et && console.warn("Failed to hydrate: ", f),
      e.recover === !1 && Be(),
      Mt(),
      _n(n),
      dt(!1),
      De(t, e)
    );
  } finally {
    (dt(r), at(s));
  }
}
const X = new Map();
function Fe(
  t,
  { target: e, anchor: n, props: r = {}, events: s, context: i, intro: f = !0 },
) {
  Mt();
  var u = new Set(),
    l = (h) => {
      for (var _ = 0; _ < h.length; _++) {
        var c = h[_];
        if (!u.has(c)) {
          u.add(c);
          var v = Fn(c);
          e.addEventListener(c, wt, { passive: v });
          var C = X.get(c);
          C === void 0
            ? (document.addEventListener(c, wt, { passive: v }), X.set(c, 1))
            : X.set(c, C + 1);
        }
      }
    };
  (l(Pe(Nn)), Zt.add(l));
  var o = void 0,
    a = wn(() => {
      var h = n ?? e.appendChild(ye());
      return (
        un(h, { pending: () => {} }, (_) => {
          if (i) {
            tn({});
            var c = Y;
            c.c = i;
          }
          if (
            (s && (r.$$events = s),
            O && Oe(_, null),
            (o = t(_, r) || {}),
            O &&
              ((p.nodes_end = T),
              T === null || T.nodeType !== Nt || T.data !== "]"))
          )
            throw (ie(), Et);
          i && en();
        }),
        () => {
          for (var _ of u) {
            e.removeEventListener(_, wt);
            var c = X.get(_);
            --c === 0
              ? (document.removeEventListener(_, wt), X.delete(_))
              : X.set(_, c);
          }
          (Zt.delete(l), h !== n && h.parentNode?.removeChild(h));
        }
      );
    });
  return (Yt.set(o, a), o);
}
let Yt = new WeakMap();
function In(t, e) {
  const n = Yt.get(t);
  return n ? (Yt.delete(t), n(e)) : Promise.resolve();
}
function yt(t) {
  return (e, ...n) => {
    var r = t(...n),
      s;
    if (O) ((s = T), fe());
    else {
      var i = r.render().trim(),
        f = On(i);
      ((s = ge(f)), e.before(s));
    }
    const u = r.setup?.(s);
    (Oe(s, s), typeof u == "function" && dn(u));
  };
}
const Ft = new WeakMap();
var Yn =
  (t) =>
  async (e, n, r, { client: s }) => {
    if (!t.hasAttribute("ssr")) return;
    let i,
      f,
      u = {};
    for (const [o, a] of Object.entries(r))
      ((f ??= {}),
        o === "default"
          ? ((f.default = !0),
            (i = yt(() => ({ render: () => `<astro-slot>${a}</astro-slot>` }))))
          : (f[o] = yt(() => ({
              render: () => `<astro-slot name="${o}">${a}</astro-slot>`,
            }))),
        o === "default"
          ? (u.children = yt(() => ({
              render: () => `<astro-slot>${a}</astro-slot>`,
            })))
          : (u[o] = yt(() => ({
              render: () => `<astro-slot name="${o}">${a}</astro-slot>`,
            }))));
    const l = { ...n, children: i, $$slots: f, ...u };
    if (Ft.has(t)) Ft.get(t).setProps(l);
    else {
      const o = Pn(e, t, l, s !== "only");
      (Ft.set(t, o),
        t.addEventListener("astro:unmount", () => o.destroy(), { once: !0 }));
    }
  };
function Pn(t, e, n, r) {
  let s = et(n);
  const i = r ? Cn : De;
  r || (e.innerHTML = "");
  const f = i(t, { target: e, props: s });
  return {
    setProps(u) {
      Object.assign(s, u);
      for (const l in s) l in u || delete s[l];
    },
    destroy() {
      In(f);
    },
  };
}
export { Yn as default };
