talk
===

Notes on Craig Interpolation.

Goal: present _Applications of Craig Interpolation in Model Checking_
  however I think it will take a lot to explain this one.
 Even the examples are "deep" to me.


[Wikipedia](https://en.wikipedia.org/wiki/Craig_interpolation)
---

```
     A => B
     \exists C . A => C /\ C => B
     fvs(A) \cap fvs(B) \ne \emptyset
     fvs(C) \subset ( fvs(A) \cup fvs(B) )
    --------
    A => B
```

Example:
   A = ~(P /\ Q) => (~R /\ Q)
     = (P \/ ~R) /\ Q
   B = (T => P) \/ (T => ~R)

   C = (P \/ ~R)

Interpolants are meant to hide details.

Proof by induction on (fvs(A) - fsv(B))
  - 0 => A
  - pick x \in fvs(A), x \not\in fvs(B)
    -  C' =  A[TRUE / x] \/ A[FALSE / x]
    - Note C' => B
           A  => C'
           | fvs(C') - fvs(B) | = n
    - Inductive step: get interpolant for C' and B

Properties of Proof
  - exponentially more logical connectives
  - 



[kaharris](http://kaharris.org/teaching/481/lectures/lec17.pdf)
---
"the last deep theorem of first order logic"

Example
```
    A = P \/ (Q /\ R)
    B = P \/ ~~Q
    C = P \/ Q
```

Theorem: `|- A => B` implies an interpolant

(Classical proof)



[Brillout, Kroening, Ruemmer, Wahl](http://www.ccs.neu.edu/home/wahl/Publications/bkrw10a.pdf)
---
2010

Lazy abstraction with interpolants:
  - Find program path to an assertion
  - Express path as conjunction, invert the assertion condition
  - If program is GOOD, our conjunction should be unsatisfiable
  - Derive interpolants for each step in the path
  - Use interpolants as inductive invariants, sometimes
    (Depends on whether the node is a covering node)


[Tinelli, Craigfest](http://homepage.cs.uiowa.edu/~tinelli/talks/Craigfest.pdf)
---
- strong & lasting impacts
  - hardware / software specs : diaconescu, rosu+gougen, bicarregui
  - reasoning with large knowledge bases : amir mcilrath
  - type inference : jhala (printed)
  - combination of theorem provers for different theories : nelson + oppen 
  - checking finite + infinite state systems
- generalizations
  -

Interpolant summarizes and translates why A is inconsistent with B


[D'Silva Slides](http://www.cs.nyu.edu/~barrett/summerschool/dsilva.pdf)
---
```
  A = P /\ (P => Q)
  B = R => Q
  C = Q
```

- Can we generate invariants?
- Explore deeper executions without too much memory?
- Avoid redundant paths?

- Page 13 has a maybe good example
- "Craig's Theorem is about the last significant property of first-order logic
   that has come to light. Is there something deeper going on here, and if so,
   can we prove it?" - Van Bentham, 2008

[State of the Union](http://ranjitjhala.github.io/static/state_of_the_union.pdf)
---



[McMillan]()
---
2005
(The paper)

A B inconsistent,
 derive interpolant from `|- ~(A /\ B)`

So `A => ~B`

Past work: linear-size, linear-time interpolants for some proof systems


[McMillan](http://www.kenmcmil.com/pubs/TCS05.pdf)
---
2005, an interpolating theorem prover

- extend from prop.logic to FO
-        from finite to infinite state
- quantifier free formulas


[McMillan bio](http://research.microsoft.com/en-us/people/kenmcmil/)
---
Thesis: SMV


[Nelson Oppen Slides](people.mpi-inf.mpg.de/~sofronie/seminar-decproc10/slides/nelson-oppen.pdf)
---
Combined satisfiability : can I prove this if I know about integers and lists?
- Ghilardi extends this [link](http://link.springer.com/article/10.1007/s10817-004-6241-501)


[Beautiful Interpolation](http://pages.cs.wisc.edu/~aws/papers/cav13b.pdf)
---
Beautiful = Simple, looking for the simplest interpolants


[SMC](https://www.mpi-sws.org/~rupak/Papers/SoftwareModelChecking.pdf)
---

Example in p.28
