# The IDEA Cycle: 5W for DevOps

## What Is It?

The IDEA cycle implements DevOps principles through GitOps practice—and extends it with the annealing step where humans decide what to want next.

| Layer | What it is | What it gives you |
|-------|-----------|-------------------|
| **DevOps** | Principles, culture | Why we integrate dev and ops |
| **GitOps** | Practice, mechanics | Git as source of truth, reconciliation loops |
| **IDEA cycle** | Implementation pattern | The rhythm of how work moves through the system |

GitOps gives you the bottom half—WORK ↔ WORLD, equilibrium emerges, reconcile toward declared state. The IDEA cycle completes the loop—adds the top half where WORLD feeds back to WHAT, annealing applies, intent gets re-encoded.

GitOps asks: *"Does reality match declaration?"*
IDEA cycle adds: *"Should the declaration change?"*

## The 5Ws

**What** do you want?
**Want** defines the objective.
**Work** executes it.
**World** responds.
**Will**—what will you do next?

```
      WHAT ──── integrates intentions ────► WANT
        ▲                                     │
        │                                     │
        │                                     │
      apply              IDEA          delivers definitions
    annealing                                 │
        │                                     │
        │                                     ▼
      WORLD ◄──── equilibrium emerges ───── WORK
```

## The Four Edges

Each edge is a transition where something gets written down:

| Edge | Process | Artifact |
|------|---------|----------|
| WHAT → WANT | integrates intentions | specs, design docs, ADRs |
| WANT → WORK | delivers definitions | manifests, schemas, configs |
| WORK → WORLD | equilibrium emerges | events, metrics, logs |
| WORLD → WHAT | apply annealing | decisions, changes, commits |

IDEA is **whatever gets written at each transition**. Without artifacts, the cycle stalls in someone's head.

## CI/CD/CE/CA

The IDEA cycle maps to continuous practices:

- **CI** — Continuous Integration: WHAT → WANT (integrating intentions)
- **CD** — Continuous Delivery: WANT → WORK (delivering definitions)
- **CE** — Continuous Equilibrium: WORK → WORLD (equilibrium emerges)
- **CA** — Continuous Annealing: WORLD → WHAT (apply annealing)

## Two Motions

**Equilibrium** runs continuously, mechanically. Work and World find balance without judgment. GitOps handles this—reconcile toward declared state.

**Annealing** is cognitive, judgmental. Humans decide: is this the *right* equilibrium? This is where WILL lives. You observe the world, apply annealing, and choose what to want next.

## The Tool/Cognition Dichotomy

Tools and cognitive participants sit on different sides of the cycle:

| | Tools | Cognitive Participants |
|-|-------|------------------------|
| **Work on** | Equilibrium (bottom half) | Annealing (top half) |
| **Relationship to objective** | Optimize within it | Can change it |
| **Core question** | "Are we at equilibrium?" | "Is this the right equilibrium?" |

LLMs, Kubernetes operators, cloud infrastructure—all tools. They execute the bottom half. Humans (and future cognitive participants) own the top half: the WILL to change what you want.

## Erosion Chaos Engineering

Most systems don't fail from earthquakes. They fail from erosion—small cracks accumulating while everyone watches for big failures.

The IDEA cycle enables **erosion chaos engineering**: continuous small perturbations and observations across the event stream. Hundreds of small LLM tasks attached to events—writing docs, generating tests, analyzing drift. Not earthquake testing, but micro-seismology.

```
Too quiet  → system calcifies, drift accumulates silently
Too noisy  → chaos, no signal, can't anneal
Just right → continuous perturbation, continuous settling
```

## The Pragmatic Claim

DevOps teams that can't name their cycle can't improve it systematically. They fix symptoms. The 5W gives you the anatomy so you can say "we're good at CD but bad at CA" instead of "things feel off."

GitOps without the IDEA cycle: you reconcile forever toward a stale objective.
With the IDEA cycle: the objective itself is in the loop.

---

*The compound effect works both ways: small neglects accumulate into systemic rot, but small observations accumulate into systemic awareness.*
