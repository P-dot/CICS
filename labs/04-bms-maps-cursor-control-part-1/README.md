# Lab 04 - Part 1: BMS Maps and Cursor Control

## Objective

Build and validate a CICS BMS screen on ADCD z/OS 1.11 and demonstrate the transition from static cursor positioning in the BMS map to dynamic cursor positioning controlled by the COBOL/CICS program.

This Part 1 stops deliberately at `SEND MAP`. `RECEIVE MAP` is reserved for Part 2, following the tutorial sequence.

## Environment

- z/OS: ADCD z/OS 1.11
- CICS region: CICSA
- CICS TS: 4.1
- COBOL: IBM Enterprise COBOL for z/OS 4.2
- User: IBMUSER
- CICS load library: `IBMUSER.CICS.LOAD`
- BMS source library: `IBMUSER.CICS.MAPS`
- symbolic copy library: `IBMUSER.CICS.COPY`
- JCL library: `IBMUSER.CICS.JCL`

## Resources

| Resource | Value |
|---|---|
| Transaction | `H404` |
| Program | `CICSL04` |
| Mapset | `L04MAPS` |
| Map | `L04MAP` |
| Group | `LAB01` |
| Input field | `USERNM` |
| Symbolic length field | `USERNML` |

> `CH04` was discarded. The final transaction used by the lab is `H404`.

## Learning path

### 1. Build the BMS map

The map defines a 24x80 3270 screen and an unprotected `USERNM` field. The BMS assembly produces both the physical map loaded by CICS and the symbolic map copied by COBOL.

### 2. Static cursor positioning

The initial map used:

```text
ATTRB=(UNPROT,IC)
```

`IC` places the cursor in the field as part of the map design.

### 3. Remove `IC`

For the dynamic phase the field becomes:

```text
ATTRB=(UNPROT)
```

During this change a fixed-format BMS continuation error caused `MAPASM RC=0008`. The continuation layout was corrected and the rebuild then completed with RC=0000.

### 4. Dynamic cursor positioning from COBOL

The program uses the symbolic map field generated for `USERNM`:

```cobol
MOVE -1 TO USERNML.

EXEC CICS
     SEND MAP('L04MAP')
          MAPSET('L04MAPS')
          CURSOR
          ERASE
          FREEKB
END-EXEC.
```

This moves cursor control out of the static BMS `IC` attribute and into application logic.

### 5. Compile and link-edit

An initial compile produced RC=0008 because `MOVE` started in COBOL Area A. After correcting fixed-format indentation, translation, compilation and link-edit all completed with RC=0000.

### 6. Refresh the running CICS program

After replacing the load module, the CICS program resource was inspected and refreshed:

```text
CEMT I PROG(CICSL04)
CEMT SET PROG(CICSL04) NEWCOPY
```

`NEWCOPY` completed with `RESPONSE: NORMAL`.

### 7. Runtime validation

Executing the final transaction:

```text
H404
```

displayed the Lab 04 BMS screen with the cursor positioned at `USER NAME`, proving dynamic cursor positioning after `IC` had been removed from the BMS field.

## Result

**PASS**

- BMS physical map generated: RC=0000
- symbolic map generated: RC=0000
- CICS/COBOL translation: RC=0000
- COBOL compilation: RC=0000
- link-edit: RC=0000
- `PROGRAM(CICSL04)` available in CICS
- `NEWCOPY`: `RESPONSE: NORMAL`
- transaction `H404` executes successfully
- cursor is dynamically positioned at `USER NAME`

## Errors deliberately preserved as learning evidence

Two failures were useful parts of the lab:

1. **BMS MAPASM RC=0008** - fixed-format continuation was damaged while removing `IC`.
2. **COBOL RC=0008 / IGYPS0009-E** - `MOVE` began in Area A instead of Area B.

Both were diagnosed, corrected and followed by clean RC=0000 builds.

## Scope boundary

Part 1 covers:

`BMS map -> physical/symbolic map -> SEND MAP -> static cursor -> dynamic cursor -> NEWCOPY -> runtime proof`

Part 1 does **not** implement `RECEIVE MAP`, COMMAREA, VSAM or DB2.

## Part 2

The next tutorial introduces **Program to Send & Receive a Map**. Part 2 will continue from this exact working baseline and introduce `RECEIVE MAP` and processing of data entered on the 3270 screen without duplicating Part 1.
