# topocity ![Status Badge - Travis CI](https://travis-ci.org/polaretto/topocity.svg?branch=master)
Putback BX between CityGML and Bigraphs, powered by BiGUL


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
