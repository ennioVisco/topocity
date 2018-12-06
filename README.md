# topocity ![Status Badge - Travis CI](https://travis-ci.org/polaretto/topocity.svg?branch=master)
Putback BX between **CityGML** and **Bigraphs**, powered by BiGUL


## Demo
After installing the dependencies, execute the following commands in the REPL:

### Loading the CityGML _Source_

```haskell
source = load "in.gml" "topo.gml"
```

### Showing the result of _Get_

```haskell
view = source >>> getSync
display view -- prints the result
```

### Changing the _View_

```haskell
view'  = view >>> addBuilding "demo1"
view'' = view' >>> removeBuilding "bc8a0f2b5-031b-11e6-b420-2bdcc4ab5d7f"
display view'' -- prints the result
```

### Reflecting the changes back to source with _Put_

```haskell
source' = source &&& view'' >>> putSync
```

### Storing back the new _Source_

```haskell
store source' "out.gml" "tout.gml"
```

## Development

### Testing & Code Analysis
:warning: _Note: Unless otherwise specified, all commands are intended to be executed in the root of the project and require the [Stack platform][45cc488c]._

---
To run the code coverage of the testing platform run in your OS's CLI:

```sh
stack test --ghc-options "-fforce-recomp" --coverage
```

and of course to just run the tests you can skip the `--coverage` flag.

### Generate documentation

To generate the updated documentation, you can write in the same way:

```sh
stack haddock
```

While to generate the report of the Lines of Code (Windows-only), open a terminal at the `tools` directory and execute:
```sh
cloc.exe ../src ../test --report-file=reports/cloc_%DATE%.txt
```

[45cc488c]: https://haskellstack.org "Haskell Stack Website"
