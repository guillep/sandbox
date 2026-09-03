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
- 963 green
- 557 red
- 11 yellow

Que aprendimos del sandbox: 
- still keep references when using pointersTo
- We add message sends on the instrumented method, so refective access (to the bytecode and literals) expose details

Que aprendimos de la biblioteca y sus tests: 

- Algunos tests esperan una excpetion particular de forma implicita.  

```testOneCanProceedWhenIntroducingCapitalizedInstanceVariables

	| class |
	[ class := classFactory make: [ :aBuilder | aBuilder slots: #(X Y) ] ]
		on: Exception
		do: [ :ex | ex resume ].
	self assert: (testingEnvironment keys includes: class name)
```

- Crea clases para testear announcements.
- Compila metodos para testear package de extension methods .Tocando el sources file stream (global)
- Testeando packages modifica packages previamente existentes (testHasProperty)
- ContexTests>>#tearDown Modifica method properties
- lint iterates the system and uses a global progress bar
- global undeclareds
- class properties
- the global undo manager listens to ProtocolAdded announcement, and the test raises it (testCompileClassifiedWithProtocolInstance)
- uses finalization

Que aprendimos de Pharo:
- Abstract SUnit test classes should run tests in subclasses when clicking on them?
- Should we ban extensions on test cases?
- *AFFECTS THE SANDBOX* reflection bug. When object is read only, object:instVarAt:put: fails with subscript out of bounds.

```
a := 1 @ 2.
a beReadOnlyObject.

"Ok"
a setX: 2 setY:  4.

"Ok"
a instVarAt: 1 put: 4.

"BUG"
a instVarNamed: #x put: 4.

"BUG"
a class slots first write: 4 to: a.

"Inherited from context"
```

- border #signalLowSpace signals a runtime semaphore
- Processor activeProcess evaluate: [ result := TestDynamicVariable value ] onBehalfOf: process.
- AnnouncementSet #, has a side effect!!!
- newAnonymousSubclass yields a class that raises (global) announcements when adding a method on them
- AST cache
- RecursionStopper wat
- testMultiProcessWaitOnSameDelay : If we own a process, shoyld we own all its contexts?
- testSteppingSendsDirectSend : step breaks the semantics of Pharo! Because you can leave a context suspended in a non normal place.
- if error in test/setup and in teardown, the teardown error hides the original error
- accessing a method sourceCode somehow fails, it will decompile the method...
- Monticello is listening package added events!!
- 

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
