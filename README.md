# Sandbox

An experimental Pharo project that explores isolated execution domains using dynamic ownership. A `Sandbox` runs a block in a domain that tracks objects created there and mediates selected writes, aiming to prevent changes to objects owned by the surrounding image. This is a work in progress.

> **Warning: Be careful. This project may not be stable.** Its behavior and coverage are experimental, and the notes in [`Experiments.md`](Experiments.md) document known failing tests and unresolved interactions with Pharo libraries and global state. Do not rely on it to safely run untrusted code or protect important data.

## General architecture

Execution is controlled by a domain, active per process. Entering `Sandbox do:` pushes that sandbox onto the current process's domain stack; leaving the block, including through an exception, restores the previous domain. Processes created from a block inside a non-default domain inherit that domain.

When domain support is activated, compiler instrumentation is enabled and the system is recompiled.
Instrumentation adds checks to instrumented operations: when the process is in the default domain, the operation follows its usual path; otherwise it asks the current domain to handle the operation.

- Object allocations are instrumented to track dynamic ownership.
- Writes to objects are controlled

Only writes to owned objects are allowed.
Other writes are rejected.

This does not currently mediate every possible operation. Some access paths, including class variable writes, still bypass domain handling, and VM, library, and image-wide state may be shared. Do not treat this as a complete isolation boundary.

## Installation and usage

You need a Pharo image with Metacello and the Tonel format available. This repository does not currently declare a specific supported Pharo version; use a compatible image and treat the result as experimental.

In a Pharo Playground, load the baseline from the repository's `main` branch:

```smalltalk
Metacello new
  baseline: 'Domains';
  repository: 'github://guillep/sandbox:main';
  load.
```

After loading, activate domain support. This recompiles the system so compiled methods include the domain checks. It can take a while and affects the whole system.

```smalltalk
Domain activate.
```

To turn it off, evaluate `Domain deactivate.`. This also recompiles the system.

A minimal usage example, after loading and activating the baseline:

```smalltalk
point := Point new.
Sandbox do: [ :sandbox |
  point setX: 1 setY: 17.
].
```

The sandbox is expected to mediate that write because `point` belongs to the surrounding image. Review the current implementation and experiment notes before relying on specific behavior.

## Test integration

The project extends Pharo's `TestExecutionEnvironment` so that each test case runs inside `Sandbox do:` when the sandbox instrumentation is active. The test environment, watchdog process, services, test case, and parametrized test values are marked as owned by the sandbox before the test runs.

Unresolved test boundary: Test resources are made available before entering the sandbox because they may contain shared or lazily initialized state.

To try the integration, load the project, evaluate `Domain activate.`, then run a test suite with Pharo's usual SUnit test runner. The project does not provide a stable compatibility guarantee for arbitrary test packages.