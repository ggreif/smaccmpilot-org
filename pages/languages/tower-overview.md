# Tower Language Overview

[Tower][tower] is a language for composing Ivory programs into real-time tasks.

Tower is both a specification language and a code generator. A Tower program
describes communication channels and tasks, and provides an Ivory implementation
of each task. Tower compiles the specification for the program and delegates
code generation to an operating-system specific backend.

We have prepared a [user guide to the Tower language][tower-userguide], as well
as [code documentation][tower-haddock].

[tower-userguide]: tower-userguide.html
[tower-haddock]: http://smaccmpilot.org/haddock/tower/Ivory-Tower.html

### Code Generation Backends

At this time, Tower has [a backend][tower-freertos] for the [FreeRTOS][]
operating system, and [a backend][tower-aadl] for an [AADL][] description of the
system, designed for use with an external code generator.

Users who want to use Tower for embedded systems will want to use the FreeRTOS
backend. We have prepared a [tutorial on using Tower with FreeRTOS for the
STM32F4 microcontroller][tower-tutorial].

[tower]: http://github.com/GaloisInc/tower
[tower-freertos]: http://github.com/GaloisInc/tower/tree/master/tower-freertos
[tower-aadl]: http://github.com/GaloisInc/tower/tree/master/tower-aadl
[FreeRTOS]: http://freertos.org
[AADL]: https://www.sei.cmu.edu/architecture/research/model-based-engineering/aadl.cfm

[tower-tutorial]: tower-tutorial.html

### Tower Examples

Simple examples and tests of the Tower framework are found in
[`tower-examples`][examples]. The [Simple][] example contains a number of
trivial tasks demonstrating each type of communication primitive.

[examples]: https://github.com/GaloisInc/tower/tree/master/tower-examples
[Simple]: https://github.com/GaloisInc/tower/blob/master/tower-examples/examples/Simple.hs

