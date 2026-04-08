# Milawa on Jitawa

Running the [Milawa](https://www.kookamara.com/jared/milawa/index.html) self-verifying proof checker on the [Jitawa](https://www.cl.cam.ac.uk/~mom22/jitawa/) verified Lisp runtime.

## Background

### Milawa

Milawa is a self-verifying theorem prover created by [Jared Davis](https://www.kookamara.com/jared/milawa/index.html) as part of his dissertation. It is a "reflective" proof checker — a simple proof checker that can verify the soundness of extensions to itself.

- [Milawa home page](https://www.kookamara.com/jared/milawa/index.html) — includes links to the dissertation (long) and defense slides (pictures!)
- [Milawa in ACL2 Books](https://github.com/acl2/acl2/tree/master/books/projects/milawa)

#### Building Milawa with ACL2

Some of the details in the Milawa README are outdated. With [acl2-jupyter](https://github.com/jimwhite/acl2-jupyter) or [Kestrel's acl2-docker](https://github.com/KestrelInstitute/acl2-docker) you just need:

```bash
cd $ACL2_SYSTEM_BOOKS
make build/Makefile-features
cd projects/milawa/ACL2
make -j $(nproc)
```

This is the first stage of the self-verified prover. On a Mac Studio (`-j 20`) it takes less than 10 minutes, which is a lot less than the hours it took in 2009.

### Jitawa

Jitawa is a verified Lisp runtime for x86-64 created by [Magnus Myreen](https://www.cl.cam.ac.uk/~mom22/jitawa/). It is the second stage of the self-verified prover — the verified runtime that executes the Milawa proof checker. The x86 machine code in Jitawa has been formally verified using the HOL4 theorem prover.

- [Jitawa home page](https://www.cl.cam.ac.uk/~mom22/jitawa/)
- [Jitawa manual](https://www.cl.cam.ac.uk/~mom22/jitawa/jitawa-manual.html)
- [HOL4 compiler for Milawa](https://github.com/HOL-Theorem-Prover/HOL/tree/master/examples/theorem-prover/milawa-prover)

The original link to the Jitawa x86 sources on the Jitawa home page has been broken since 2017. The source archive is available from the Wayback Machine:

- [jitawa-2012-feb-13.zip (Wayback Machine)](https://web.archive.org/web/20170516140434/http://www.cl.cam.ac.uk/~mom22/jitawa/jitawa-2012-feb-13.zip)

#### DAG notation for S-expressions

An interesting feature from the [Jitawa manual](https://www.cl.cam.ac.uk/~mom22/jitawa/jitawa-manual.html) is its optimised abbreviation mechanism for representing very large inputs efficiently using a DAG notation for s-expressions:

```lisp
> '(#1=(a #2=c) #2# #1# #1#)
((A C) C (A C) (A C))
```

This DAG notation may be applicable to other systems that deal with large structured expressions (e.g. ACL2 Axe DAG - https://www.kestrel.edu/research/axe/).

## Repository Structure

| File | Description |
|------|-------------|
| `core.lisp` | Milawa's core proof checker |
| `100.events` | Sample proof events for testing |
| `jit_exec.s` | x86-64 assembly — JIT execution engine |
| `verified_code.s` | Verified x86-64 machine code (compiled from HOL4) |
| `wrapper.c` | C wrapper for the Jitawa runtime |
| `milawa2-jitawa.sh` | Script to run Milawa on Jitawa |
| `Makefile` | Build system |
| `.devcontainer/` | Dev container configuration |

## Building and Running

### Prerequisites

An x86-64 Linux system with GCC. A dev container configuration is included for convenience.

### Build

```bash
make
```

### Test

```bash
make test
```

This runs `milawa2-jitawa.sh 100.events`, which loads the Milawa core and verifies the sample proof events using the Jitawa runtime.

## Origins

This repository was originally created by [Melvin Zhang](https://github.com/melvinzhang/milawa-on-jitawa).

Dev container support added by [Jim White](https://github.com/jimwhite/milawa-on-jitawa).
