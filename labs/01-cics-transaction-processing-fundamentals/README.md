# Lab 01 — CICS Transaction Processing Fundamentals

## Objective

Turn the core introductory CICS concepts into a working z/OS lab: **TRANSACTION → TASK → PROGRAM** and **MAPSET → MAP → FIELD**.

The lab builds and executes a native COBOL/CICS transaction (`CH01`) that invokes program `CICSL01` and displays BMS map `L01MAP` from mapset `L01MAPS`.

## Environment

- IBM z/OS ADCD 1.11
- CICS TS 4.1 (`DFH410`)
- CICS region: `CICSA`
- Enterprise COBOL for z/OS 4.2 (`IGY420`)
- TSO/ISPF, JES2 and SDSF
- Working libraries: `IBMUSER.CICS.MAPS`, `COPY`, `SRC`, `JCL`, `LOAD`

## Concepts demonstrated

A CICS **transaction** is identified here by `CH01`. Its resource definition points to program `CICSL01`. When the transaction is invoked, CICS creates a **task**, executes the program, and the program issues `EXEC CICS SEND MAP`.

BMS is demonstrated through:

`L01MAPS (MAPSET) → L01MAP (MAP) → DFHMDF fields`

The BMS build produces a physical map for CICS and a symbolic map used by COBOL through `COPY L01MAPS`.

## Build flow

```text
IBMUSER.CICS.MAPS(L01MAPS)
          |
          +--> MAPASM --> LINKMAP --> IBMUSER.CICS.LOAD(L01MAPS)
          |
          +--> DSECT -------------> IBMUSER.CICS.COPY(L01MAPS)

IBMUSER.CICS.SRC(CICSL01)
          |
          +--> CICS Translator (TRN)
          +--> Enterprise COBOL
          +--> Link-edit + DFHELII
          |
          +--> IBMUSER.CICS.LOAD(CICSL01)
```

Validated results:

- `MAPASM RC=0000`
- `LINKMAP RC=0000`
- `DSECT RC=0000`
- `TRN RC=0000`
- `COBOL RC=0000`
- `LKED RC=0000`

## CICS resource definitions

```text
CEDA DEFINE PROGRAM(CICSL01) GROUP(LAB01)
CEDA DEFINE MAPSET(L01MAPS) GROUP(LAB01)
CEDA DEFINE TRANSACTION(CH01) GROUP(LAB01) PROGRAM(CICSL01)
CEDA INSTALL GROUP(LAB01)
```

The installation completed successfully. Executing `CH01` displayed the BMS screen with `CICS LAB 01`, `TRANSACTION PROCESSING FUNDAMENTALS`, an editable `USER NAME` field and `ENTER=CONTINUE`.

## Troubleshooting

Two useful failures were resolved during the build.

**BMS DSECT RC=008.** HLASM reported continuation errors because the BMS continuation indicator was not correctly positioned. The source was corrected to use fixed-format continuation with the indicator in column 72.

**COBOL RC=0012.** The CICS translator generated references to the symbolic output map (`L01MAPO`), but the program did not initially include the generated symbolic map. Adding `COPY L01MAPS.` resolved the undefined data-name errors. The final translation, compilation and link-edit all completed with RC=0000.

## Result

The final execution demonstrates the complete relationship:

```text
CH01
  -> TRANSACTION
  -> TASK created by CICS
  -> CICSL01
  -> EXEC CICS SEND MAP
  -> L01MAPS
  -> L01MAP
  -> BMS fields
  -> 3270 screen
```

## Scope boundary

This introductory lab intentionally stops after successful map display. `RECEIVE MAP`, COMMAREA, pseudo-conversational processing, VSAM, DB2 and CICS security belong to later labs.

## Repository contents

- `bms/` — BMS source
- `cobol/` — COBOL/CICS source
- `jcl/` — validated build jobs
- `docs/` — theory, build flow and troubleshooting
- `commands/` — CICS commands
- `evidence/screenshots/` — execution evidence
