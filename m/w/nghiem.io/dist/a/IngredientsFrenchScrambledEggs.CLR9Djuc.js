import {
  d as E,
  f as I,
  a as $,
  s as a,
  b as B,
  t as j,
  c as y,
  e as f,
  g as e,
  h as C,
  i as n,
  n as F,
  r,
  j as l,
  u as v,
} from "./snippet.CogwZscX.js";
const L = "5";
typeof window < "u" && ((window.__svelte ??= {}).v ??= new Set()).add(L);
var N = I(
  "<li> <button>-</button> <button>+</button> <!></li> <li> </li> <li> </li>",
  1,
);
function P(g, b) {
  let t = C(3),
    p = v(() => 2 * e(t)),
    m = v(() => 2 * e(t));
  function h() {
    f(t, e(t) + 1);
  }
  function w() {
    f(t, e(t) - 1);
  }
  var o = N(),
    s = $(o),
    d = n(s),
    c = a(d);
  c.__click = w;
  var _ = a(c, 2);
  _.__click = h;
  var x = a(_, 2);
  (B(x, () => b.children ?? F), r(s));
  var i = a(s, 2),
    S = n(i);
  r(i);
  var u = a(i, 2),
    k = n(u);
  (r(u),
    j(() => {
      (l(
        d,
        `Eggs
  ${e(t) ?? ""} `,
      ),
        l(S, `Butter ${e(p) ?? ""} Tbsp`),
        l(k, `Salt ${e(m) ?? ""} g`));
    }),
    y(g, o));
}
E(["click"]);
export { P as default };
