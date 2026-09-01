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
- 5977 green


## Clap

147 tests all green

## AST, Opal

7933 green

## FileSystem

## Enlumineur

## Kernel

Kernel-Tests 

Que aprendimos? ProtoObject no anda con el sandbox, no lo podemos ownear.

## Microdown

## Refactoring

## Roassal

# Ideas

- Global state should start clean
- Class vars and inst class vars
- How to not affect the ones defined by Class and Behavior

- 
