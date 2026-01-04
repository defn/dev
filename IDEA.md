# The IDEA Cycle: 6W for DevOps

## What Is It?

The IDEA cycle implements DevOps principles through GitOps practice—and extends it with the reflective steps where humans analyze gaps and decide what to want next.

| Layer          | What it is             | What it gives you                               |
| -------------- | ---------------------- | ----------------------------------------------- |
| **DevOps**     | Principles, culture    | Why we integrate dev and ops                    |
| **GitOps**     | Practice, mechanics    | Git as source of truth, reconciliation loops    |
| **IDEA cycle** | Implementation pattern | The rhythm of how work moves through the system |

GitOps gives you the bottom half—WORK ↔ WORLD, equilibrium emerges, reconcile toward declared state. The IDEA cycle completes the loop—adds the left side where WORLD feeds through WHY and WILL back to WHAT, annealing applies, intent gets re-encoded.

GitOps asks: _"Does reality match declaration?"_
IDEA cycle adds: _"Why did it settle here, and what will we do about it?"_

## The 6Ws

```
    WHAT ──────────────────────────────► WANT
      ▲                                    │
      │                                    │
    WILL                                   │
      ▲                                    │
      │                                    ▼
    WHY ◄─────────────────────────────── WORK
      ▲                                    │
      │                                    │
      └──────────── WORLD ◄────────────────┘
```

## The Six Edges

| Edge                | Mode        | Continuous Practice |
| ------------------- | ----------- | ------------------- |
| What do you Want?   | Intent      | CI                  |
| Want defines Work   | Definition  | CI                  |
| Work produces World | Execution   | CD (Delivery)       |
| World prompts Why   | Application | CD (Deployment)     |
| Why informs Will    | Analysis    | CE                  |
| Will shapes What    | Planning    | CA                  |

IDEA is **whatever gets written at each transition**. Without artifacts, the cycle stalls in someone's head.

## CI/CD/CE/CA

- **CI** — Continuous Integration: WHAT → WANT (intent + definition). Lattice validation and tests confirm the change integrates with the system as intended.
- **CD** — Continuous Delivery/Deployment: WANT → WORK → WORLD (execution + application). Build, package, deploy to production, observe response.
- **CE** — Continuous Equilibrium: WORLD → WHY (analysis). Analyze why the system settled where it did. Is this the right equilibrium?
- **CA** — Continuous Annealing: WHY → WILL → WHAT (planning). Plan the perturbation to anneal toward a different equilibrium.

## Two Motions

**Equilibrium** runs continuously, mechanically. Work and World find balance without judgment. GitOps handles this—reconcile toward declared state. CE analyzes whether the equilibrium point is correct.

**Annealing** is cognitive, judgmental. Given CE's analysis, CA plans what to do about it. This may produce a single change or a plan spanning multiple IDEA cycles.

## The Tool/Cognition Dichotomy

|                               | Tools                    | Cognitive Participants       |
| ----------------------------- | ------------------------ | ---------------------------- |
| **Work on**                   | Equilibrium (right side) | Annealing (left side)        |
| **Relationship to objective** | Optimize within it       | Can change it                |
| **Core question**             | "Are we at equilibrium?" | "Why here? What will we do?" |

LLMs, Kubernetes operators, cloud infrastructure—all tools. They execute the right side. Humans (and future cognitive participants) own the left side: the WHY to understand gaps and the WILL to change what you want.

## Why and Will: The Reflective Steps

**WHY** is the pivot between observation and action. It asks "why did the system settle here?" regardless of trigger:

- Post-mortem after incident (4 Whys technique)
- Drift detected during normal operation
- User feedback revealing expectation mismatch
- Cost or performance gaps

**WILL** is where plans form. A single WHY analysis may produce:

- A single IDEA cycle (fix this one thing)
- Multiple sequenced cycles (refactor, then migrate, then deprecate)
- No action (equilibrium is acceptable, adjust expectations)

```
WHY → WILL
        │
        ├→ IDEA cycle 1 (refactor)
        ├→ IDEA cycle 2 (migrate)
        └→ IDEA cycle 3 (deprecate)
```

## 6W vs 4 Whys

The 6W is what you ask during development and operation—proactive rhythm. The 4 Whys is a technique for the WHY step when triggered by incident—reactive analysis.

Good 6W practice reduces 4 Whys frequency. The WHY step during normal operation catches drift before it compounds into incidents. When incidents do occur, 4 Whys output feeds back into WILL, improving what you observe next time.

## Erosion Chaos Engineering

Most systems don't fail from earthquakes. They fail from erosion—small cracks accumulating while everyone watches for big failures.

The IDEA cycle enables **erosion chaos engineering**: continuous small perturbations and observations across the event stream. Hundreds of small LLM tasks attached to events—writing docs, generating tests, analyzing drift. Not earthquake testing, but micro-seismology.

```
Too quiet  → system calcifies, drift accumulates silently
Too noisy  → chaos, no signal, can't anneal
Just right → continuous perturbation, continuous settling
```

## The Pragmatic Claim

DevOps teams that can't name their cycle can't improve it systematically. They fix symptoms. The 6W gives you the anatomy so you can say "we're good at CD but bad at CE" instead of "things feel off."

GitOps without the IDEA cycle: you reconcile forever toward a stale objective.
With the IDEA cycle: the objective itself is in the loop.

---

_The compound effect works both ways: small neglects accumulate into systemic rot, but small observations accumulate into systemic awareness._
