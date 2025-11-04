const me = {},
  y = Symbol(),
  lt = !1;
var Vt = Array.isArray,
  Bt = Array.prototype.indexOf,
  Kt = Array.from,
  Wt = Object.defineProperty,
  pe = Object.getOwnPropertyDescriptor,
  $t = Object.prototype,
  zt = Array.prototype,
  Gt = Object.getPrototypeOf,
  Qe = Object.isExtensible;
const Bn = () => {};
function Xt(e) {
  for (var t = 0; t < e.length; t++) e[t]();
}
function ut() {
  var e,
    t,
    n = new Promise((r, i) => {
      ((e = r), (t = i));
    });
  return { promise: n, resolve: e, reject: t };
}
const T = 2,
  Be = 4,
  Ke = 8,
  U = 16,
  Z = 32,
  se = 64,
  Fe = 128,
  b = 1024,
  A = 2048,
  V = 4096,
  M = 8192,
  z = 16384,
  at = 32768,
  oe = 65536,
  et = 1 << 17,
  ot = 1 << 18,
  ve = 1 << 19,
  Zt = 1 << 20,
  F = 256,
  xe = 512,
  Se = 32768,
  je = 1 << 21,
  We = 1 << 22,
  G = 1 << 23,
  Ye = Symbol("$state"),
  le = new (class extends Error {
    name = "StaleReactionError";
    message =
      "The reaction that called `getAbortSignal()` was re-run or destroyed";
  })(),
  ct = 3,
  Ie = 8;
function Jt() {
  throw new Error("https://svelte.dev/e/async_derived_orphan");
}
function Qt() {
  throw new Error("https://svelte.dev/e/effect_update_depth_exceeded");
}
function en() {
  throw new Error("https://svelte.dev/e/hydration_failed");
}
function tn() {
  throw new Error("https://svelte.dev/e/state_descriptors_fixed");
}
function nn() {
  throw new Error("https://svelte.dev/e/state_prototype_fixed");
}
function rn() {
  throw new Error("https://svelte.dev/e/state_unsafe_mutation");
}
function sn() {
  throw new Error("https://svelte.dev/e/svelte_boundary_reset_onerror");
}
function $e(e) {
  console.warn("https://svelte.dev/e/hydration_mismatch");
}
function fn() {
  console.warn("https://svelte.dev/e/svelte_boundary_reset_noop");
}
let m = !1;
function Re(e) {
  m = e;
}
let g;
function q(e) {
  if (e === null) throw ($e(), me);
  return (g = e);
}
function ze() {
  return q(B(g));
}
function Wn(e) {
  if (m) {
    if (B(g) !== null) throw ($e(), me);
    g = e;
  }
}
function ln(e = 1) {
  if (m) {
    for (var t = e, n = g; t--; ) n = B(n);
    g = n;
  }
}
function un(e = !0) {
  for (var t = 0, n = g; ; ) {
    if (n.nodeType === Ie) {
      var r = n.data;
      if (r === "]") {
        if (t === 0) return n;
        t -= 1;
      } else (r === "[" || r === "[!") && (t += 1);
    }
    var i = B(n);
    (e && n.remove(), (n = i));
  }
}
function ht(e) {
  return e === this.v;
}
let an = !1,
  I = null;
function ce(e) {
  I = e;
}
function on(e, t = !1, n) {
  I = { p: I, i: !1, c: null, e: null, s: e, x: null, l: null };
}
function cn(e) {
  var t = I,
    n = t.e;
  if (n !== null) {
    t.e = null;
    for (var r of n) Sn(r);
  }
  return ((t.i = !0), (I = t.p), {});
}
function _t() {
  return !0;
}
let ue = [];
function hn() {
  var e = ue;
  ((ue = []), Xt(e));
}
function Ge(e) {
  if (ue.length === 0) {
    var t = ue;
    queueMicrotask(() => {
      t === ue && hn();
    });
  }
  ue.push(e);
}
function vt(e) {
  var t = d;
  if (t === null) return ((v.f |= G), e);
  if ((t.f & at) === 0) {
    if ((t.f & Fe) === 0) throw e;
    t.b.error(e);
  } else he(e, t);
}
function he(e, t) {
  for (; t !== null; ) {
    if ((t.f & Fe) !== 0)
      try {
        t.b.error(e);
        return;
      } catch (n) {
        e = n;
      }
    t = t.parent;
  }
  throw e;
}
const ke = new Set();
let w = null,
  D = null,
  W = [],
  Xe = null,
  Le = !1;
class P {
  committed = !1;
  current = new Map();
  previous = new Map();
  #e = new Set();
  #t = new Set();
  #n = 0;
  #r = 0;
  #u = null;
  #f = [];
  #l = [];
  skipped_effects = new Set();
  is_fork = !1;
  process(t) {
    ((W = []), this.apply());
    var n = {
      parent: null,
      effect: null,
      effects: [],
      render_effects: [],
      block_effects: [],
    };
    for (const r of t) this.#i(r, n);
    (this.is_fork || this.#a(),
      this.#r > 0 || this.is_fork
        ? (this.#s(n.effects),
          this.#s(n.render_effects),
          this.#s(n.block_effects))
        : ((w = null), tt(n.render_effects), tt(n.effects), this.#u?.resolve()),
      (D = null));
  }
  #i(t, n) {
    t.f ^= b;
    for (var r = t.first; r !== null; ) {
      var i = r.f,
        s = (i & (Z | se)) !== 0,
        f = s && (i & b) !== 0,
        u = f || (i & M) !== 0 || this.skipped_effects.has(r);
      if (
        ((r.f & Fe) !== 0 &&
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
        s
          ? (r.f ^= b)
          : (i & Be) !== 0
            ? n.effects.push(r)
            : Te(r) && ((r.f & U) !== 0 && n.block_effects.push(r), be(r));
        var l = r.first;
        if (l !== null) {
          r = l;
          continue;
        }
      }
      var a = r.parent;
      for (r = r.next; r === null && a !== null; )
        (a === n.effect &&
          (this.#s(n.effects),
          this.#s(n.render_effects),
          this.#s(n.block_effects),
          (n = n.parent)),
          (r = a.next),
          (a = a.parent));
    }
  }
  #s(t) {
    for (const n of t) (((n.f & A) !== 0 ? this.#f : this.#l).push(n), E(n, b));
  }
  capture(t, n) {
    (this.previous.has(t) || this.previous.set(t, n),
      (t.f & G) === 0 && (this.current.set(t, t.v), D?.set(t, t.v)));
  }
  activate() {
    ((w = this), this.apply());
  }
  deactivate() {
    ((w = null), (D = null));
  }
  flush() {
    if ((this.activate(), W.length > 0)) {
      if ((_n(), w !== null && w !== this)) return;
    } else this.#n === 0 && this.process([]);
    this.deactivate();
  }
  discard() {
    for (const t of this.#t) t(this);
    this.#t.clear();
  }
  #a() {
    if (this.#r === 0) {
      for (const t of this.#e) t();
      this.#e.clear();
    }
    this.#n === 0 && this.#o();
  }
  #o() {
    if (ke.size > 1) {
      this.previous.clear();
      var t = D,
        n = !0,
        r = {
          parent: null,
          effect: null,
          effects: [],
          render_effects: [],
          block_effects: [],
        };
      for (const i of ke) {
        if (i === this) {
          n = !1;
          continue;
        }
        const s = [];
        for (const [u, l] of this.current) {
          if (i.current.has(u))
            if (n && l !== i.current.get(u)) i.current.set(u, l);
            else continue;
          s.push(u);
        }
        if (s.length === 0) continue;
        const f = [...i.current.keys()].filter((u) => !this.current.has(u));
        if (f.length > 0) {
          const u = new Set(),
            l = new Map();
          for (const a of s) dt(a, f, u, l);
          if (W.length > 0) {
            ((w = i), i.apply());
            for (const a of W) i.#i(a, r);
            ((W = []), i.deactivate());
          }
        }
      }
      ((w = null), (D = t));
    }
    ((this.committed = !0), ke.delete(this));
  }
  increment(t) {
    ((this.#n += 1), t && (this.#r += 1));
  }
  decrement(t) {
    ((this.#n -= 1), t && (this.#r -= 1), this.revive());
  }
  revive() {
    for (const t of this.#f) (E(t, A), re(t));
    for (const t of this.#l) (E(t, V), re(t));
    ((this.#f = []), (this.#l = []), this.flush());
  }
  oncommit(t) {
    this.#e.add(t);
  }
  ondiscard(t) {
    this.#t.add(t);
  }
  settled() {
    return (this.#u ??= ut()).promise;
  }
  static ensure() {
    if (w === null) {
      const t = (w = new P());
      (ke.add(w),
        P.enqueue(() => {
          w === t && t.flush();
        }));
    }
    return w;
  }
  static enqueue(t) {
    Ge(t);
  }
  apply() {}
}
function _n() {
  var e = ae;
  Le = !0;
  try {
    var t = 0;
    for (rt(!0); W.length > 0; ) {
      var n = P.ensure();
      if (t++ > 1e3) {
        var r, i;
        vn();
      }
      (n.process(W), X.clear());
    }
  } finally {
    ((Le = !1), rt(e), (Xe = null));
  }
}
function vn() {
  try {
    Qt();
  } catch (e) {
    he(e, Xe);
  }
}
let j = null;
function tt(e) {
  var t = e.length;
  if (t !== 0) {
    for (var n = 0; n < t; ) {
      var r = e[n++];
      if (
        (r.f & (z | M)) === 0 &&
        Te(r) &&
        ((j = new Set()),
        be(r),
        r.deps === null &&
          r.first === null &&
          r.nodes_start === null &&
          (r.teardown === null && r.ac === null ? Ot(r) : (r.fn = null)),
        j?.size > 0)
      ) {
        X.clear();
        for (const i of j) {
          if ((i.f & (z | M)) !== 0) continue;
          const s = [i];
          let f = i.parent;
          for (; f !== null; )
            (j.has(f) && (j.delete(f), s.push(f)), (f = f.parent));
          for (let u = s.length - 1; u >= 0; u--) {
            const l = s[u];
            (l.f & (z | M)) === 0 && be(l);
          }
        }
        j.clear();
      }
    }
    j = null;
  }
}
function dt(e, t, n, r) {
  if (!n.has(e) && (n.add(e), e.reactions !== null))
    for (const i of e.reactions) {
      const s = i.f;
      (s & T) !== 0
        ? dt(i, t, n, r)
        : (s & (We | U)) !== 0 &&
          (s & A) === 0 &&
          pt(i, t, r) &&
          (E(i, A), re(i));
    }
}
function pt(e, t, n) {
  const r = n.get(e);
  if (r !== void 0) return r;
  if (e.deps !== null)
    for (const i of e.deps) {
      if (t.includes(i)) return !0;
      if ((i.f & T) !== 0 && pt(i, t, n)) return (n.set(i, !0), !0);
    }
  return (n.set(e, !1), !1);
}
function re(e) {
  for (var t = (Xe = e); t.parent !== null; ) {
    t = t.parent;
    var n = t.f;
    if (Le && t === d && (n & U) !== 0 && (n & ot) === 0) return;
    if ((n & (se | Z)) !== 0) {
      if ((n & b) === 0) return;
      t.f ^= b;
    }
  }
  W.push(t);
}
function dn(e) {
  let t = 0,
    n = Pe(0),
    r;
  return () => {
    xn() &&
      (te(n),
      Dn(
        () => (
          t === 0 && (r = jn(() => e(() => ge(n)))),
          (t += 1),
          () => {
            Ge(() => {
              ((t -= 1), t === 0 && (r?.(), (r = void 0), ge(n)));
            });
          }
        ),
      ));
  };
}
var pn = oe | ve | Fe;
function gn(e, t, n) {
  new wn(e, t, n);
}
class wn {
  parent;
  #e = !1;
  #t;
  #n = m ? g : null;
  #r;
  #u;
  #f;
  #l = null;
  #i = null;
  #s = null;
  #a = null;
  #o = null;
  #_ = 0;
  #c = 0;
  #v = !1;
  #h = null;
  #m = dn(
    () => (
      (this.#h = Pe(this.#_)),
      () => {
        this.#h = null;
      }
    ),
  );
  constructor(t, n, r) {
    ((this.#t = t),
      (this.#r = n),
      (this.#u = r),
      (this.parent = d.b),
      (this.#e = !!this.#r.pending),
      (this.#f = xt(() => {
        if (((d.b = this), m)) {
          const s = this.#n;
          (ze(), s.nodeType === Ie && s.data === "[!" ? this.#b() : this.#y());
        } else {
          var i = this.#g();
          try {
            this.#l = L(() => r(i));
          } catch (s) {
            this.error(s);
          }
          this.#c > 0 ? this.#p() : (this.#e = !1);
        }
        return () => {
          this.#o?.remove();
        };
      }, pn)),
      m && (this.#t = g));
  }
  #y() {
    try {
      this.#l = L(() => this.#u(this.#t));
    } catch (t) {
      this.error(t);
    }
    this.#e = !1;
  }
  #b() {
    const t = this.#r.pending;
    t &&
      ((this.#i = L(() => t(this.#t))),
      P.enqueue(() => {
        var n = this.#g();
        ((this.#l = this.#d(() => (P.ensure(), L(() => this.#u(n))))),
          this.#c > 0
            ? this.#p()
            : (we(this.#i, () => {
                this.#i = null;
              }),
              (this.#e = !1)));
      }));
  }
  #g() {
    var t = this.#t;
    return (
      this.#e && ((this.#o = ie()), this.#t.before(this.#o), (t = this.#o)),
      t
    );
  }
  is_pending() {
    return this.#e || (!!this.parent && this.parent.is_pending());
  }
  has_pending_snippet() {
    return !!this.#r.pending;
  }
  #d(t) {
    var n = d,
      r = v,
      i = I;
    (Y(this.#f), k(this.#f), ce(this.#f.ctx));
    try {
      return t();
    } catch (s) {
      return (vt(s), null);
    } finally {
      (Y(n), k(r), ce(i));
    }
  }
  #p() {
    const t = this.#r.pending;
    (this.#l !== null &&
      ((this.#a = document.createDocumentFragment()),
      this.#a.append(this.#o),
      Ft(this.#l, this.#a)),
      this.#i === null && (this.#i = L(() => t(this.#t))));
  }
  #w(t) {
    if (!this.has_pending_snippet()) {
      this.parent && this.parent.#w(t);
      return;
    }
    ((this.#c += t),
      this.#c === 0 &&
        ((this.#e = !1),
        this.#i &&
          we(this.#i, () => {
            this.#i = null;
          }),
        this.#a && (this.#t.before(this.#a), (this.#a = null))));
  }
  update_pending_count(t) {
    (this.#w(t), (this.#_ += t), this.#h && Oe(this.#h, this.#_));
  }
  get_effect_pending() {
    return (this.#m(), te(this.#h));
  }
  error(t) {
    var n = this.#r.onerror;
    let r = this.#r.failed;
    if (this.#v || (!n && !r)) throw t;
    (this.#l && (S(this.#l), (this.#l = null)),
      this.#i && (S(this.#i), (this.#i = null)),
      this.#s && (S(this.#s), (this.#s = null)),
      m && (q(this.#n), ln(), q(un())));
    var i = !1,
      s = !1;
    const f = () => {
      if (i) {
        fn();
        return;
      }
      ((i = !0),
        s && sn(),
        P.ensure(),
        (this.#_ = 0),
        this.#s !== null &&
          we(this.#s, () => {
            this.#s = null;
          }),
        (this.#e = this.has_pending_snippet()),
        (this.#l = this.#d(() => ((this.#v = !1), L(() => this.#u(this.#t))))),
        this.#c > 0 ? this.#p() : (this.#e = !1));
    };
    var u = v;
    try {
      (k(null), (s = !0), n?.(t, f), (s = !1));
    } catch (l) {
      he(l, this.#f && this.#f.parent);
    } finally {
      k(u);
    }
    r &&
      Ge(() => {
        this.#s = this.#d(() => {
          (P.ensure(), (this.#v = !0));
          try {
            return L(() => {
              r(
                this.#t,
                () => t,
                () => f,
              );
            });
          } catch (l) {
            return (he(l, this.#f.parent), null);
          } finally {
            this.#v = !1;
          }
        });
      });
  }
}
function mn(e, t, n, r) {
  const i = gt;
  if (n.length === 0 && e.length === 0) {
    r(t.map(i));
    return;
  }
  var s = w,
    f = d,
    u = yn();
  function l() {
    Promise.all(n.map((a) => bn(a)))
      .then((a) => {
        u();
        try {
          r([...t.map(i), ...a]);
        } catch (o) {
          (f.f & z) === 0 && he(o, f);
        }
        (s?.deactivate(), Ne());
      })
      .catch((a) => {
        he(a, f);
      });
  }
  e.length > 0
    ? Promise.all(e).then(() => {
        u();
        try {
          return l();
        } finally {
          (s?.deactivate(), Ne());
        }
      })
    : l();
}
function yn() {
  var e = d,
    t = v,
    n = I,
    r = w;
  return function (s = !0) {
    (Y(e), k(t), ce(n), s && r?.activate());
  };
}
function Ne() {
  (Y(null), k(null), ce(null));
}
function gt(e) {
  var t = T | A,
    n = v !== null && (v.f & T) !== 0 ? v : null;
  return (
    d === null || (n !== null && (n.f & F) !== 0) ? (t |= F) : (d.f |= ve),
    {
      ctx: I,
      deps: null,
      effects: null,
      equals: ht,
      f: t,
      fn: e,
      reactions: null,
      rv: 0,
      v: y,
      wv: 0,
      parent: n ?? d,
      ac: null,
    }
  );
}
function bn(e, t) {
  let n = d;
  n === null && Jt();
  var r = n.b,
    i = void 0,
    s = Pe(y),
    f = !v,
    u = new Map();
  return (
    On(() => {
      var l = ut();
      i = l.promise;
      try {
        Promise.resolve(e())
          .then(l.resolve, l.reject)
          .then(() => {
            (a === w && a.committed && a.deactivate(), Ne());
          });
      } catch (h) {
        (l.reject(h), Ne());
      }
      var a = w;
      if (f) {
        var o = !r.is_pending();
        (r.update_pending_count(1),
          a.increment(o),
          u.get(a)?.reject(le),
          u.delete(a),
          u.set(a, l));
      }
      const _ = (h, c = void 0) => {
        if ((a.activate(), c)) c !== le && ((s.f |= G), Oe(s, c));
        else {
          ((s.f & G) !== 0 && (s.f ^= G), Oe(s, h));
          for (const [p, O] of u) {
            if ((u.delete(p), p === a)) break;
            O.reject(le);
          }
        }
        f && (r.update_pending_count(-1), a.decrement(o));
      };
      l.promise.then(_, (h) => _(null, h || "unknown"));
    }),
    At(() => {
      for (const l of u.values()) l.reject(le);
    }),
    new Promise((l) => {
      function a(o) {
        function _() {
          o === i ? l(s) : a(i);
        }
        o.then(_, _);
      }
      a(i);
    })
  );
}
function $n(e) {
  const t = gt(e);
  return (It(t), t);
}
function wt(e) {
  var t = e.effects;
  if (t !== null) {
    e.effects = null;
    for (var n = 0; n < t.length; n += 1) S(t[n]);
  }
}
function En(e) {
  for (var t = e.parent; t !== null; ) {
    if ((t.f & T) === 0) return t;
    t = t.parent;
  }
  return null;
}
function Ze(e) {
  var t,
    n = d;
  Y(En(e));
  try {
    ((e.f &= ~Se), wt(e), (t = jt(e)));
  } finally {
    Y(n);
  }
  return t;
}
function mt(e) {
  var t = Ze(e);
  if ((e.equals(t) || ((e.v = t), (e.wv = Mt())), !Ee))
    if (D !== null) D.set(e, e.v);
    else {
      var n = ($ || (e.f & F) !== 0) && e.deps !== null ? V : b;
      E(e, n);
    }
}
let He = new Set();
const X = new Map();
let yt = !1;
function Pe(e, t) {
  var n = { f: 0, v: e, reactions: null, equals: ht, rv: 0, wv: 0 };
  return n;
}
function K(e, t) {
  const n = Pe(e);
  return (It(n), n);
}
function ee(e, t, n = !1) {
  v !== null &&
    (!C || (v.f & et) !== 0) &&
    _t() &&
    (v.f & (T | U | We | et)) !== 0 &&
    !H?.includes(e) &&
    rn();
  let r = n ? de(t) : t;
  return Oe(e, r);
}
function Oe(e, t) {
  if (!e.equals(t)) {
    var n = e.v;
    (Ee ? X.set(e, t) : X.set(e, n), (e.v = t));
    var r = P.ensure();
    (r.capture(e, n),
      (e.f & T) !== 0 &&
        ((e.f & A) !== 0 && Ze(e), E(e, (e.f & F) === 0 ? b : V)),
      (e.wv = Mt()),
      bt(e, A),
      d !== null &&
        (d.f & b) !== 0 &&
        (d.f & (Z | se)) === 0 &&
        (N === null ? Mn([e]) : N.push(e)),
      !r.is_fork && He.size > 0 && !yt && Tn());
  }
  return t;
}
function Tn() {
  yt = !1;
  const e = Array.from(He);
  for (const t of e) ((t.f & b) !== 0 && E(t, V), Te(t) && be(t));
  He.clear();
}
function ge(e) {
  ee(e, e.v + 1);
}
function bt(e, t) {
  var n = e.reactions;
  if (n !== null)
    for (var r = n.length, i = 0; i < r; i++) {
      var s = n[i],
        f = s.f,
        u = (f & A) === 0;
      (u && E(s, t),
        (f & T) !== 0
          ? (f & Se) === 0 && ((s.f |= Se), bt(s, V))
          : u && ((f & U) !== 0 && j !== null && j.add(s), re(s)));
    }
}
function de(e) {
  if (typeof e != "object" || e === null || Ye in e) return e;
  const t = Gt(e);
  if (t !== $t && t !== zt) return e;
  var n = new Map(),
    r = Vt(e),
    i = K(0),
    s = ne,
    f = (u) => {
      if (ne === s) return u();
      var l = v,
        a = ne;
      (k(null), st(s));
      var o = u();
      return (k(l), st(a), o);
    };
  return (
    r && n.set("length", K(e.length)),
    new Proxy(e, {
      defineProperty(u, l, a) {
        (!("value" in a) ||
          a.configurable === !1 ||
          a.enumerable === !1 ||
          a.writable === !1) &&
          tn();
        var o = n.get(l);
        return (
          o === void 0
            ? (o = f(() => {
                var _ = K(a.value);
                return (n.set(l, _), _);
              }))
            : ee(o, a.value, !0),
          !0
        );
      },
      deleteProperty(u, l) {
        var a = n.get(l);
        if (a === void 0) {
          if (l in u) {
            const o = f(() => K(y));
            (n.set(l, o), ge(i));
          }
        } else (ee(a, y), ge(i));
        return !0;
      },
      get(u, l, a) {
        if (l === Ye) return e;
        var o = n.get(l),
          _ = l in u;
        if (
          (o === void 0 &&
            (!_ || pe(u, l)?.writable) &&
            ((o = f(() => {
              var c = de(_ ? u[l] : y),
                p = K(c);
              return p;
            })),
            n.set(l, o)),
          o !== void 0)
        ) {
          var h = te(o);
          return h === y ? void 0 : h;
        }
        return Reflect.get(u, l, a);
      },
      getOwnPropertyDescriptor(u, l) {
        var a = Reflect.getOwnPropertyDescriptor(u, l);
        if (a && "value" in a) {
          var o = n.get(l);
          o && (a.value = te(o));
        } else if (a === void 0) {
          var _ = n.get(l),
            h = _?.v;
          if (_ !== void 0 && h !== y)
            return { enumerable: !0, configurable: !0, value: h, writable: !0 };
        }
        return a;
      },
      has(u, l) {
        if (l === Ye) return !0;
        var a = n.get(l),
          o = (a !== void 0 && a.v !== y) || Reflect.has(u, l);
        if (a !== void 0 || (d !== null && (!o || pe(u, l)?.writable))) {
          a === void 0 &&
            ((a = f(() => {
              var h = o ? de(u[l]) : y,
                c = K(h);
              return c;
            })),
            n.set(l, a));
          var _ = te(a);
          if (_ === y) return !1;
        }
        return o;
      },
      set(u, l, a, o) {
        var _ = n.get(l),
          h = l in u;
        if (r && l === "length")
          for (var c = a; c < _.v; c += 1) {
            var p = n.get(c + "");
            p !== void 0
              ? ee(p, y)
              : c in u && ((p = f(() => K(y))), n.set(c + "", p));
          }
        if (_ === void 0)
          (!h || pe(u, l)?.writable) &&
            ((_ = f(() => K(void 0))), ee(_, de(a)), n.set(l, _));
        else {
          h = _.v !== y;
          var O = f(() => de(a));
          ee(_, O);
        }
        var Q = Reflect.getOwnPropertyDescriptor(u, l);
        if ((Q?.set && Q.set.call(o, a), !h)) {
          if (r && typeof l == "string") {
            var Je = n.get("length"),
              Me = Number(l);
            Number.isInteger(Me) && Me >= Je.v && ee(Je, Me + 1);
          }
          ge(i);
        }
        return !0;
      },
      ownKeys(u) {
        te(i);
        var l = Reflect.ownKeys(u).filter((_) => {
          var h = n.get(_);
          return h === void 0 || h.v !== y;
        });
        for (var [a, o] of n) o.v !== y && !(a in u) && l.push(a);
        return l;
      },
      setPrototypeOf() {
        nn();
      },
    })
  );
}
var nt, Et, Tt, Rt;
function qe() {
  if (nt === void 0) {
    ((nt = window), (Et = /Firefox/.test(navigator.userAgent)));
    var e = Element.prototype,
      t = Node.prototype,
      n = Text.prototype;
    ((Tt = pe(t, "firstChild").get),
      (Rt = pe(t, "nextSibling").get),
      Qe(e) &&
        ((e.__click = void 0),
        (e.__className = void 0),
        (e.__attributes = null),
        (e.__style = void 0),
        (e.__e = void 0)),
      Qe(n) && (n.__t = void 0));
  }
}
function ie(e = "") {
  return document.createTextNode(e);
}
function _e(e) {
  return Tt.call(e);
}
function B(e) {
  return Rt.call(e);
}
function zn(e, t) {
  if (!m) return _e(e);
  var n = _e(g);
  return (n === null && (n = g.appendChild(ie())), q(n), n);
}
function Gn(e, t = !1) {
  if (!m) {
    var n = _e(e);
    return n instanceof Comment && n.data === "" ? B(n) : n;
  }
  if (t && g?.nodeType !== ct) {
    var r = ie();
    return (g?.before(r), q(r), r);
  }
  return g;
}
function Xn(e, t = 1, n = !1) {
  let r = m ? g : e;
  for (var i; t--; ) ((i = r), (r = B(r)));
  if (!m) return r;
  if (n && r?.nodeType !== ct) {
    var s = ie();
    return (r === null ? i?.after(s) : r.before(s), q(s), s);
  }
  return (q(r), r);
}
function Rn(e) {
  e.textContent = "";
}
function kn() {
  return !1;
}
function kt(e) {
  var t = v,
    n = d;
  (k(null), Y(null));
  try {
    return e();
  } finally {
    (k(t), Y(n));
  }
}
function An(e, t) {
  var n = t.last;
  n === null
    ? (t.last = t.first = e)
    : ((n.next = e), (e.prev = n), (t.last = e));
}
function J(e, t, n, r = !0) {
  var i = d;
  i !== null && (i.f & M) !== 0 && (e |= M);
  var s = {
    ctx: I,
    deps: null,
    nodes_start: null,
    nodes_end: null,
    f: e | A,
    first: null,
    fn: t,
    last: null,
    next: null,
    parent: i,
    b: i && i.b,
    prev: null,
    teardown: null,
    transitions: null,
    wv: 0,
    ac: null,
  };
  if (n)
    try {
      (be(s), (s.f |= at));
    } catch (l) {
      throw (S(s), l);
    }
  else t !== null && re(s);
  if (r) {
    var f = s;
    if (
      (n &&
        f.deps === null &&
        f.teardown === null &&
        f.nodes_start === null &&
        f.first === f.last &&
        (f.f & ve) === 0 &&
        ((f = f.first),
        (e & U) !== 0 && (e & oe) !== 0 && f !== null && (f.f |= oe)),
      f !== null &&
        ((f.parent = i),
        i !== null && An(f, i),
        v !== null && (v.f & T) !== 0 && (e & se) === 0))
    ) {
      var u = v;
      (u.effects ??= []).push(f);
    }
  }
  return s;
}
function xn() {
  return v !== null && !C;
}
function At(e) {
  const t = J(Ke, null, !1);
  return (E(t, b), (t.teardown = e), t);
}
function Sn(e) {
  return J(Be | Zt, e, !1);
}
function Nn(e) {
  P.ensure();
  const t = J(se | ve, e, !0);
  return (n = {}) =>
    new Promise((r) => {
      n.outro
        ? we(t, () => {
            (S(t), r(void 0));
          })
        : (S(t), r(void 0));
    });
}
function On(e) {
  return J(We | ve, e, !0);
}
function Dn(e, t = 0) {
  return J(Ke | t, e, !0);
}
function Zn(e, t = [], n = [], r = [], i = !1) {
  mn(r, t, n, (s) => {
    J(i ? Be : Ke, () => e(...s.map(te)), !0);
  });
}
function xt(e, t = 0) {
  var n = J(U | t, e, !0);
  return n;
}
function L(e, t = !0) {
  return J(Z | ve, e, !0, t);
}
function St(e) {
  var t = e.teardown;
  if (t !== null) {
    const n = Ee,
      r = v;
    (it(!0), k(null));
    try {
      t.call(null);
    } finally {
      (it(n), k(r));
    }
  }
}
function Nt(e, t = !1) {
  var n = e.first;
  for (e.first = e.last = null; n !== null; ) {
    const i = n.ac;
    i !== null &&
      kt(() => {
        i.abort(le);
      });
    var r = n.next;
    ((n.f & se) !== 0 ? (n.parent = null) : S(n, t), (n = r));
  }
}
function Cn(e) {
  for (var t = e.first; t !== null; ) {
    var n = t.next;
    ((t.f & Z) === 0 && S(t), (t = n));
  }
}
function S(e, t = !0) {
  var n = !1;
  ((t || (e.f & ot) !== 0) &&
    e.nodes_start !== null &&
    e.nodes_end !== null &&
    (Fn(e.nodes_start, e.nodes_end), (n = !0)),
    Nt(e, t && !n),
    De(e, 0),
    E(e, z));
  var r = e.transitions;
  if (r !== null) for (const s of r) s.stop();
  St(e);
  var i = e.parent;
  (i !== null && i.first !== null && Ot(e),
    (e.next =
      e.prev =
      e.teardown =
      e.ctx =
      e.deps =
      e.fn =
      e.nodes_start =
      e.nodes_end =
      e.ac =
        null));
}
function Fn(e, t) {
  for (; e !== null; ) {
    var n = e === t ? null : B(e);
    (e.remove(), (e = n));
  }
}
function Ot(e) {
  var t = e.parent,
    n = e.prev,
    r = e.next;
  (n !== null && (n.next = r),
    r !== null && (r.prev = n),
    t !== null &&
      (t.first === e && (t.first = r), t.last === e && (t.last = n)));
}
function we(e, t, n = !0) {
  var r = [];
  (Dt(e, r, !0),
    In(r, () => {
      (n && S(e), t && t());
    }));
}
function In(e, t) {
  var n = e.length;
  if (n > 0) {
    var r = () => --n || t();
    for (var i of e) i.out(r);
  } else t();
}
function Dt(e, t, n) {
  if ((e.f & M) === 0) {
    if (((e.f ^= M), e.transitions !== null))
      for (const f of e.transitions) (f.is_global || n) && t.push(f);
    for (var r = e.first; r !== null; ) {
      var i = r.next,
        s = (r.f & oe) !== 0 || ((r.f & Z) !== 0 && (e.f & U) !== 0);
      (Dt(r, t, s ? n : !1), (r = i));
    }
  }
}
function Pn(e) {
  Ct(e, !0);
}
function Ct(e, t) {
  if ((e.f & M) !== 0) {
    ((e.f ^= M), (e.f & b) === 0 && (E(e, A), re(e)));
    for (var n = e.first; n !== null; ) {
      var r = n.next,
        i = (n.f & oe) !== 0 || (n.f & Z) !== 0;
      (Ct(n, i ? t : !1), (n = r));
    }
    if (e.transitions !== null)
      for (const s of e.transitions) (s.is_global || t) && s.in();
  }
}
function Ft(e, t) {
  for (var n = e.nodes_start, r = e.nodes_end; n !== null; ) {
    var i = n === r ? null : B(n);
    (t.append(n), (n = i));
  }
}
let ae = !1;
function rt(e) {
  ae = e;
}
let Ee = !1;
function it(e) {
  Ee = e;
}
let v = null,
  C = !1;
function k(e) {
  v = e;
}
let d = null;
function Y(e) {
  d = e;
}
let H = null;
function It(e) {
  v !== null && (H === null ? (H = [e]) : H.push(e));
}
let R = null,
  x = 0,
  N = null;
function Mn(e) {
  N = e;
}
let Pt = 1,
  ye = 0,
  ne = ye;
function st(e) {
  ne = e;
}
let $ = !1;
function Mt() {
  return ++Pt;
}
function Te(e) {
  var t = e.f;
  if ((t & A) !== 0) return !0;
  if ((t & V) !== 0) {
    var n = e.deps,
      r = (t & F) !== 0;
    if ((t & T && (e.f &= ~Se), n !== null)) {
      var i,
        s,
        f = (t & xe) !== 0,
        u = r && d !== null && !$,
        l = n.length;
      if ((f || u) && (d === null || (d.f & z) === 0)) {
        var a = e,
          o = a.parent;
        for (i = 0; i < l; i++)
          ((s = n[i]),
            (f || !s?.reactions?.includes(a)) && (s.reactions ??= []).push(a));
        (f && (a.f ^= xe), u && o !== null && (o.f & F) === 0 && (a.f ^= F));
      }
      for (i = 0; i < l; i++)
        if (((s = n[i]), Te(s) && mt(s), s.wv > e.wv)) return !0;
    }
    (!r || (d !== null && !$)) && E(e, b);
  }
  return !1;
}
function Yt(e, t, n = !0) {
  var r = e.reactions;
  if (r !== null && !H?.includes(e))
    for (var i = 0; i < r.length; i++) {
      var s = r[i];
      (s.f & T) !== 0
        ? Yt(s, t, !1)
        : t === s && (n ? E(s, A) : (s.f & b) !== 0 && E(s, V), re(s));
    }
}
function jt(e) {
  var t = R,
    n = x,
    r = N,
    i = v,
    s = $,
    f = H,
    u = I,
    l = C,
    a = ne,
    o = e.f;
  ((R = null),
    (x = 0),
    (N = null),
    ($ = (o & F) !== 0 && (C || !ae || v === null)),
    (v = (o & (Z | se)) === 0 ? e : null),
    (H = null),
    ce(e.ctx),
    (C = !1),
    (ne = ++ye),
    e.ac !== null &&
      (kt(() => {
        e.ac.abort(le);
      }),
      (e.ac = null)));
  try {
    e.f |= je;
    var _ = e.fn,
      h = _(),
      c = e.deps;
    if (R !== null) {
      var p;
      if ((De(e, x), c !== null && x > 0))
        for (c.length = x + R.length, p = 0; p < R.length; p++) c[x + p] = R[p];
      else e.deps = c = R;
      if (!$ || ((o & T) !== 0 && e.reactions !== null))
        for (p = x; p < c.length; p++) (c[p].reactions ??= []).push(e);
    } else c !== null && x < c.length && (De(e, x), (c.length = x));
    if (_t() && N !== null && !C && c !== null && (e.f & (T | V | A)) === 0)
      for (p = 0; p < N.length; p++) Yt(N[p], e);
    return (
      i !== null &&
        i !== e &&
        (ye++, N !== null && (r === null ? (r = N) : r.push(...N))),
      (e.f & G) !== 0 && (e.f ^= G),
      h
    );
  } catch (O) {
    return vt(O);
  } finally {
    ((e.f ^= je),
      (R = t),
      (x = n),
      (N = r),
      (v = i),
      ($ = s),
      (H = f),
      ce(u),
      (C = l),
      (ne = a));
  }
}
function Yn(e, t) {
  let n = t.reactions;
  if (n !== null) {
    var r = Bt.call(n, e);
    if (r !== -1) {
      var i = n.length - 1;
      i === 0 ? (n = t.reactions = null) : ((n[r] = n[i]), n.pop());
    }
  }
  n === null &&
    (t.f & T) !== 0 &&
    (R === null || !R.includes(t)) &&
    (E(t, V), (t.f & (F | xe)) === 0 && (t.f ^= xe), wt(t), De(t, 0));
}
function De(e, t) {
  var n = e.deps;
  if (n !== null) for (var r = t; r < n.length; r++) Yn(e, n[r]);
}
function be(e) {
  var t = e.f;
  if ((t & z) === 0) {
    E(e, b);
    var n = d,
      r = ae;
    ((d = e), (ae = !0));
    try {
      ((t & U) !== 0 ? Cn(e) : Nt(e), St(e));
      var i = jt(e);
      ((e.teardown = typeof i == "function" ? i : null), (e.wv = Pt));
      var s;
      lt && an && (e.f & A) !== 0 && e.deps;
    } finally {
      ((ae = r), (d = n));
    }
  }
}
function te(e) {
  var t = e.f,
    n = (t & T) !== 0;
  if (v !== null && !C) {
    var r = d !== null && (d.f & z) !== 0;
    if (!r && !H?.includes(e)) {
      var i = v.deps;
      if ((v.f & je) !== 0)
        e.rv < ye &&
          ((e.rv = ye),
          R === null && i !== null && i[x] === e
            ? x++
            : R === null
              ? (R = [e])
              : (!$ || !R.includes(e)) && R.push(e));
      else {
        (v.deps ??= []).push(e);
        var s = e.reactions;
        s === null ? (e.reactions = [v]) : s.includes(v) || s.push(v);
      }
    }
  } else if (n && e.deps === null && e.effects === null) {
    var f = e,
      u = f.parent;
    u !== null && (u.f & F) === 0 && (f.f ^= F);
  }
  if (Ee) {
    if (X.has(e)) return X.get(e);
    if (n) {
      f = e;
      var l = f.v;
      return (
        (((f.f & b) === 0 && f.reactions !== null) || Lt(f)) && (l = Ze(f)),
        X.set(f, l),
        l
      );
    }
  } else if (n) {
    if (((f = e), D?.has(f))) return D.get(f);
    Te(f) && mt(f);
  }
  if (D?.has(e)) return D.get(e);
  if ((e.f & G) !== 0) throw e.v;
  return e.v;
}
function Lt(e) {
  if (e.v === y) return !0;
  if (e.deps === null) return !1;
  for (const t of e.deps) if (X.has(t) || ((t.f & T) !== 0 && Lt(t))) return !0;
  return !1;
}
function jn(e) {
  var t = C;
  try {
    return ((C = !0), e());
  } finally {
    C = t;
  }
}
const Ln = -7169;
function E(e, t) {
  e.f = (e.f & Ln) | t;
}
const Ht = new Set(),
  Ue = new Set();
function Jn(e) {
  for (var t = 0; t < e.length; t++) Ht.add(e[t]);
  for (var n of Ue) n(e);
}
let ft = null;
function Ae(e) {
  var t = this,
    n = t.ownerDocument,
    r = e.type,
    i = e.composedPath?.() || [],
    s = i[0] || e.target;
  ft = e;
  var f = 0,
    u = ft === e && e.__root;
  if (u) {
    var l = i.indexOf(u);
    if (l !== -1 && (t === document || t === window)) {
      e.__root = t;
      return;
    }
    var a = i.indexOf(t);
    if (a === -1) return;
    l <= a && (f = l);
  }
  if (((s = i[f] || e.target), s !== t)) {
    Wt(e, "currentTarget", {
      configurable: !0,
      get() {
        return s || n;
      },
    });
    var o = v,
      _ = d;
    (k(null), Y(null));
    try {
      for (var h, c = []; s !== null; ) {
        var p = s.assignedSlot || s.parentNode || s.host || null;
        try {
          var O = s["__" + r];
          O != null && (!s.disabled || e.target === s) && O.call(s, e);
        } catch (Q) {
          h ? c.push(Q) : (h = Q);
        }
        if (e.cancelBubble || p === t || p === null) break;
        s = p;
      }
      if (h) {
        for (let Q of c)
          queueMicrotask(() => {
            throw Q;
          });
        throw h;
      }
    } finally {
      ((e.__root = t), delete e.currentTarget, k(o), Y(_));
    }
  }
}
function qt(e) {
  var t = document.createElement("template");
  return ((t.innerHTML = e.replaceAll("<!>", "<!---->")), t.content);
}
function Ce(e, t) {
  var n = d;
  n.nodes_start === null && ((n.nodes_start = e), (n.nodes_end = t));
}
function Qn(e, t) {
  var n = (t & 2) !== 0,
    r,
    i = !e.startsWith("<!>");
  return () => {
    if (m) return (Ce(g, null), g);
    r === void 0 && (r = qt(i ? e : "<!>" + e));
    var s = n || Et ? document.importNode(r, !0) : r.cloneNode(!0);
    {
      var f = _e(s),
        u = s.lastChild;
      Ce(f, u);
    }
    return s;
  };
}
function er(e, t) {
  if (m) {
    ((d.nodes_end = g), ze());
    return;
  }
  e !== null && e.before(t);
}
const Hn = ["touchstart", "touchmove"];
function qn(e) {
  return Hn.includes(e);
}
function tr(e, t) {
  var n = t == null ? "" : typeof t == "object" ? t + "" : t;
  n !== (e.__t ??= e.nodeValue) && ((e.__t = n), (e.nodeValue = n + ""));
}
function Un(e, t) {
  return Ut(e, t);
}
function nr(e, t) {
  (qe(), (t.intro = t.intro ?? !1));
  const n = t.target,
    r = m,
    i = g;
  try {
    for (var s = _e(n); s && (s.nodeType !== Ie || s.data !== "["); ) s = B(s);
    if (!s) throw me;
    (Re(!0), q(s));
    const f = Ut(e, { ...t, anchor: s });
    return (Re(!1), f);
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
      f !== me && console.warn("Failed to hydrate: ", f),
      t.recover === !1 && en(),
      qe(),
      Rn(n),
      Re(!1),
      Un(e, t)
    );
  } finally {
    (Re(r), q(i));
  }
}
const fe = new Map();
function Ut(
  e,
  { target: t, anchor: n, props: r = {}, events: i, context: s, intro: f = !0 },
) {
  qe();
  var u = new Set(),
    l = (_) => {
      for (var h = 0; h < _.length; h++) {
        var c = _[h];
        if (!u.has(c)) {
          u.add(c);
          var p = qn(c);
          t.addEventListener(c, Ae, { passive: p });
          var O = fe.get(c);
          O === void 0
            ? (document.addEventListener(c, Ae, { passive: p }), fe.set(c, 1))
            : fe.set(c, O + 1);
        }
      }
    };
  (l(Kt(Ht)), Ue.add(l));
  var a = void 0,
    o = Nn(() => {
      var _ = n ?? t.appendChild(ie());
      return (
        gn(_, { pending: () => {} }, (h) => {
          if (s) {
            on({});
            var c = I;
            c.c = s;
          }
          if (
            (i && (r.$$events = i),
            m && Ce(h, null),
            (a = e(h, r) || {}),
            m &&
              ((d.nodes_end = g),
              g === null || g.nodeType !== Ie || g.data !== "]"))
          )
            throw ($e(), me);
          s && cn();
        }),
        () => {
          for (var h of u) {
            t.removeEventListener(h, Ae);
            var c = fe.get(h);
            --c === 0
              ? (document.removeEventListener(h, Ae), fe.delete(h))
              : fe.set(h, c);
          }
          (Ue.delete(l), _ !== n && _.parentNode?.removeChild(_));
        }
      );
    });
  return (Ve.set(a, o), a);
}
let Ve = new WeakMap();
function rr(e, t) {
  const n = Ve.get(e);
  return n ? (Ve.delete(e), n(t)) : Promise.resolve();
}
class Vn {
  anchor;
  #e = new Map();
  #t = new Map();
  #n = new Map();
  #r = !0;
  constructor(t, n = !0) {
    ((this.anchor = t), (this.#r = n));
  }
  #u = () => {
    var t = w;
    if (this.#e.has(t)) {
      var n = this.#e.get(t),
        r = this.#t.get(n);
      if (r) Pn(r);
      else {
        var i = this.#n.get(n);
        i &&
          (this.#t.set(n, i.effect),
          this.#n.delete(n),
          i.fragment.lastChild.remove(),
          this.anchor.before(i.fragment),
          (r = i.effect));
      }
      for (const [s, f] of this.#e) {
        if ((this.#e.delete(s), s === t)) break;
        const u = this.#n.get(f);
        u && (S(u.effect), this.#n.delete(f));
      }
      for (const [s, f] of this.#t) {
        if (s === n) continue;
        const u = () => {
          if (Array.from(this.#e.values()).includes(s)) {
            var a = document.createDocumentFragment();
            (Ft(f, a),
              a.append(ie()),
              this.#n.set(s, { effect: f, fragment: a }));
          } else S(f);
          this.#t.delete(s);
        };
        this.#r || !r ? we(f, u, !1) : u();
      }
    }
  };
  #f = (t) => {
    this.#e.delete(t);
    const n = Array.from(this.#e.values());
    for (const [r, i] of this.#n)
      n.includes(r) || (S(i.effect), this.#n.delete(r));
  };
  ensure(t, n) {
    var r = w,
      i = kn();
    if (n && !this.#t.has(t) && !this.#n.has(t))
      if (i) {
        var s = document.createDocumentFragment(),
          f = ie();
        (s.append(f), this.#n.set(t, { effect: L(() => n(f)), fragment: s }));
      } else
        this.#t.set(
          t,
          L(() => n(this.anchor)),
        );
    if ((this.#e.set(r, t), i)) {
      for (const [u, l] of this.#t)
        u === t ? r.skipped_effects.delete(l) : r.skipped_effects.add(l);
      for (const [u, l] of this.#n)
        u === t
          ? r.skipped_effects.delete(l.effect)
          : r.skipped_effects.add(l.effect);
      (r.oncommit(this.#u), r.ondiscard(this.#f));
    } else (m && (this.anchor = g), this.#u());
  }
}
function ir(e, t, ...n) {
  var r = new Vn(e);
  xt(() => {
    const i = t() ?? null;
    r.ensure(i, i && ((s) => i(s, ...n)));
  }, oe);
}
function sr(e) {
  return (t, ...n) => {
    var r = e(...n),
      i;
    if (m) ((i = g), ze());
    else {
      var s = r.render().trim(),
        f = qt(s);
      ((i = _e(f)), t.before(i));
    }
    const u = r.setup?.(i);
    (Ce(i, i), typeof u == "function" && At(u));
  };
}
export {
  Gn as a,
  ir as b,
  er as c,
  Jn as d,
  ee as e,
  Qn as f,
  te as g,
  K as h,
  zn as i,
  tr as j,
  sr as k,
  nr as l,
  Un as m,
  Bn as n,
  rr as o,
  de as p,
  Wn as r,
  Xn as s,
  Zn as t,
  $n as u,
};
