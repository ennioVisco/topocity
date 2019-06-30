# topocity ![Status Badge - Travis CI](https://travis-ci.com/ennioVisco/topocity.svg?branch=master)
Towards topological representation of smart cities environment: a Putback BX approach towards **Bigraphs** from **CityGML**.
Powered by [BiGUL][5d8ff35d].

## Installation
Currently it is recommended to execute `topocity` via [Stack platform][45cc488c], since it is cross-platform, virtualizable, and takes care of all dependencies automatically.

:warning: _Note: Git is required by Stack to pull needed pacakges. In addition, drawing commands require [GraphViz][927a319c] installed system-wide._

After cloning/downloading this repository go to its directory and
launch it via command line:


```
stack ghci src/Lib.hs
```

## Usage Guidelines

To experiment with `topocity`, you can execute the following commands in the REPL. Note that input files are taken from the `in` directory while output files are generated into the `out` directory. To change this, change the paths in `Settings.hs` variables.

The following commands use some demo files provided with this repository, however other input can be used, despite currently there is a very limited support of CityGML features related to the current state of development of the [citygml4hs][4d6757c3] library.

### Loading the CityGML _Source_

```haskell
source = load "in.gml" "topo.gml"
```

### Showing the result of _Get_

```haskell
view = get source -- performs the forward BX: CityGML -> Bigraph
display view -- prints in stdout the internal representation of the graph
```

### Changing the _View_

Wrappers to simulate changes in the bigraph

```haskell
view'  = addBuilding "demo1" view
view'' = removeBuilding "bc8a0f2b5-031b-11e6-b420-2bdcc4ab5d7f" view'
display view'' -- prints in stdout the internal representation of the graph
```

### Reflecting the changes back to source with _Put_

```haskell
source' = put source view''  -- performs the putback BX: CityGML <- Bigraph
```

### Storing back the new _Source_

```haskell
store source' "out.gml" "tout.gml" -- Stores the new CityGML and ADE files
```

## Development

### Testing & Code Analysis
:warning: _Note: Unless otherwise specified, all commands are meant to be executed at the root of the project and require the [Stack platform][45cc488c]._

---
To run the code coverage of the testing platform run in your OS's CLI:

```sh
stack test --ghc-options "-fforce-recomp" --coverage
```

and of course to just run the tests you can skip the `--coverage` flag.

### Generate package dependency graph
In order to generate the dependency graph (in this case the trivial dependency on the `base` package has been excluded):

```sh
stack dot --no-include-base --external | dot -Tpng -o out/wreq.png
```

### Generate documentation

To generate the updated documentation, you can write in the same way:

```sh
stack haddock
```

While to generate the report of the Lines of Code (Windows-only), open a terminal at the `tools` directory and execute:
```sh
cloc.exe ../src ../test --report-file=reports/cloc_%DATE%.txt
```

[4d6757c3]: https://github.com/ennioVisco/citygml4hs "citygml4hs"

[927a319c]: https://www.graphviz.org/ "GraphViz"

[45cc488c]: https://haskellstack.org "Haskell Stack Website"

[5d8ff35d]: https://bitbucket.org/prl_tokyo/bigul/ "BiGUL: The Bidirectional Generic Update Language"
