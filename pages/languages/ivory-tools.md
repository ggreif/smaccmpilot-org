# Ivory Language: Toolchain

The Ivory toolchain is made up of 3 packages found in the [Ivory repository][ivory-repo]:

* [`ivory`][ivory]
* [`ivory-backend-c`][ivory-backend-c]
* [`ivory-opts`][ivory-opts]

## Language Definition

The Ivory language is defined in the [`ivory`][ivory-package] package. Users
should only use the Ivory API exported by the
[`Ivory.Language`][ivory-lang-module] module.

Ivory's `Module` type is the unit of compilation. There are no tools for
user introspection of a `Module` value.

## C-language Compiler

The Ivory C-language compiler is defined in the
[`ivory-backend-c`][ivory-backend-c-package] package.

Most users will want to use the `compile` function from the
`Ivory.Compile.C.CmdlineFrontend` module. `compile` has type
`[Module] -> IO ()`: it takes a collection of Ivory modules and writes the
compiled C sources to the disk according to command line options
(i.e. `System.Environment.getArg`).

If you are building the Ivory compiler into some other sort of  Haskell
application, lower level primitives are exported by the `Ivory.Compile.C`
module.

The `compileWith` function from the `Ivory.Compile.C.CmdlineFrontend` module
extends `compile` with two additional optional arguments, a `SizeMap` (defined
by `Ivory.Opts.CFG`) which may aid in static analysis passes, and a `[IO
FilePath]` which specifies the search path for additional C source dependencies.

### Dependency Search Path

Some Ivory libraries require external definitions given by C source files.
Such a library should give a `SearchDir` module exporting a value `searchDir ::
IO FilePath`.

For example, the commonly used [`ivory-hw`][ivory-hw] package requires [a C
header][ivory-hw-supportfiles], which is installed as a cabal data-file. The
directory to find the installed support file is given by `searchDir` in the
module [`Ivory.HW.SearchDir`][ivory-hw-searchdir].

### Command Line Arguments

The command line arguments expected by `Ivory.Compile.C.CmdlineFrontend.compile`
can be found by running a compile program with the --help flag.

## Optimization Passes

Ivory optimization passes are implemented in the
[`ivory-opts`][ivory-opts] package.

Optimization passes are used by default by the
`Ivory.Compile.C.CmdlineFrontend.compile` compiler. Command line flags are
available to disable passes individually.

[ivory-repo]: http://github.com/GaloisInc/ivory/

[ivory]: http://github.com/GaloisInc/ivory/tree/master/ivory
[ivory-package]: http://github.com/GaloisInc/ivory/blob/master/ivory/ivory.cabal
[ivory-lang-module]: http://github.com/GaloisInc/ivory/blob/master/ivory/src/Ivory/Language.hs

[ivory-backend-c]: http://github.com/GaloisInc/ivory/tree/master/ivory-backend-c
[ivory-backend-c-package]: http://github.com/GaloisInc/ivory/blob/master/ivory-backend-c/ivory-backend-c.cabal

[ivory-opts]: http://github.com/GaloisInc/ivory/tree/master/ivory-opts
[ivory-opts-package]: http://github.com/GaloisInc/ivory/blob/master/ivory-opts/ivory-opts.cabal

[ivory-hw]: http://github.com/GaloisInc/ivory/tree/master/ivory-hw
[ivory-hw-supportfiles]: http://github.com/GaloisInc/ivory/blob/master/ivory-hw/support/ivory_hw_prim.h
[ivory-hw-searchdir]: http://github.com/GaloisInc/ivory/blob/master/ivory-hw/src/Ivory/HW/SearchDir.hs
