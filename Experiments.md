# Experimentos with first semantic

 Writes are forbidden. All rest is the same

## Zinc
- 5 paquetes de test
- 465 tests
- 133 error
- 4 failure

Que aprendimos del sandbox: 
Que aprendimos de la biblioteca y sus tests: 
Que aprendimos de Pharo:

## SUnit

- 296 green
- 62 red
- 10 yellow
- 9 deadlocks

Que aprendimos del sandbox: 
- el sandbox no tiene que holdear objetos strongly

Que aprendimos de la biblioteca y sus tests: 
- el test runner tiene problemas de concurrencia => que hacen que los tests no terminen
- Hay tests que intentan compilar codigo de manera global: agregar paquetes, classes, metodos
- Usa Singletons
- **puede afectar al sandbox** Los tests no pueden setear un time limit porque el sandbox no ownea el environment
- **puede afectar al sandbox** el sandbox tiene que soportar correctamente los test resources. Deberian ser read only, pero que pasa si son lazy initialized?
  - sandbox dentro del sandbox? (test resources setup outside, test inside)

Que aprendimos de Pharo:
- Locally "undeclaring" a class variable generates a global undeclared entry
- Inside a sandbox people may try to finish an outside process. Is this ok?
- Deprecations are global

## Collections
- 5945 green
- 32 red

Que aprendimos de la biblioteca y sus tests: 
- progress bar
- global state
- timeout/infinite recursions -> this is because of the stack overflow changes we did
- tests que no son tests pero "reglas de calidad"

## Clap
- 142 green
- 4 red

Que aprendimos de Pharo:
- Files require Finalization

## FileSystem
- 395 green
- 104 red
- 2 yellow

Que aprendimos de la biblioteca y sus tests: 
- tiene tests no repetibles, quiz

NOTA: Redo after fixing finalization + test resources.

## Enlumineur
- 294 green
- 4 red

Que aprendimos de la biblioteca y sus tests: 
- global state
- 
## Microdown
- 365 green
- 338 red
- 4 yellow

Que aprendimos de la biblioteca y sus tests: 
- Depends on Zinc
- Opens a UI window
- hay tests que atrapan Error genericamente y no distinguen nuestros write errors or stack overflow
- regex matcher in a global is stateful. Is it shareable?
- Morphic render! hits in a global cache of glyphs 


## Kernel
- 5945 green
- 32 red

Que aprendimos del sandbox: 


Que aprendimos de la biblioteca y sus tests: 

- Algunos tests esperan una excpetion particular de forma implicita.  

```testOneCanProceedWhenIntroducingCapitalizedInstanceVariables

	| class |
	[ class := classFactory make: [ :aBuilder | aBuilder slots: #(X Y) ] ]
		on: Exception
		do: [ :ex | ex resume ].
	self assert: (testingEnvironment keys includes: class name)
```

- Crea clases para testear announcements.. 
- ContexTests>>#tearDown Modifica method properties 
Que aprendimos de Pharo:





Kernel-Tests 

Que aprendimos? ProtoObject no anda con el sandbox, no lo podemos ownear.


## Refactoring
- 5945 green
- 32 red

Que aprendimos del sandbox: 
Que aprendimos de la biblioteca y sus tests: 
Que aprendimos de Pharo:

## Roassal
- 5945 green
- 32 red

Que aprendimos del sandbox: 
Que aprendimos de la biblioteca y sus tests: 
Que aprendimos de Pharo:

## AST, Opal
- 5945 green
- 32 red

Que aprendimos del sandbox: 
Que aprendimos de la biblioteca y sus tests: 
Que aprendimos de Pharo:


# Ideas

- Global state should start clean
- Class vars and inst class vars
- How to not affect the ones defined by Class and Behavior

- Are there tests that are green although they are not green? catch(Error) catches everything


# Scripties 

```|stackSize packageName | 
stackSize := 8.
packageName := 'Microdown-Tests'.
tests := (packageName asPackage testSuite tests flatCollect:[ :r | r class = TestSuite ifTrue:[ r tests ] ifFalse:[ {r} ]  ])  collect: [ : t |
	
	[t debug. nil ] on: Error, AssertionFailure, TestFailure   do: [  :e | t-> (( e signalerContext stackOfSize: stackSize) collect: [ : s | s selector  ] )] 
	 ]
.
tests := tests reject:#isNil.

tests := (tests groupedBy:#value ) sorted: #size asSortFunction reversed.

sorts := tests collect: [  : t | t first key debug  ]
```
