# Lab 02 — CICS Runtime Resources and Multitasking

## Objective

Turn the introductory CICS runtime concepts from the lesson block into observable behavior on a running CICS region, without rebuilding the BMS and COBOL artifacts already completed in Lab 01.

This lab focuses on:

- the CICS region as the online transaction-processing environment;
- the difference between a stored resource definition and an installed runtime resource;
- CEDA versus CEMT;
- TRANSACTION versus PROGRAM versus TASK;
- observing a real CICS task;
- validating the existing `CH01 -> CICSL01` application after resource installation.

## Reuse instead of duplication

Lab 02 deliberately reuses the resources created in Lab 01:

- GROUP: `LAB01`
- TRANSACTION: `CH01`
- PROGRAM: `CICSL01`
- MAPSET: `L01MAPS`

No BMS source, COBOL source or build JCL is duplicated here. The new work is operational/runtime observation.

## Mental model

```text
z/OS
 |
 +-- CICS region
      |
      +-- stored resource definitions (managed with CEDA)
      |
      +-- installed/runtime resources (observed/controlled with CEMT)
      |
      +-- TRANSACTION CH01
      |       |
      |       +-- PROGRAM CICSL01
      |
      +-- TASKS = concrete executions of transactions
```

## Practical sequence

### 1. Inspect the CICS region

```text
CEMT I SYSTEM
```

The region responded normally. The evidence also showed `Maxtasks(005)`, a configured task limit for this region.

### 2. Check whether CH01 is installed

```text
CEMT I TRANS(CH01)
```

Initial result: `NOT FOUND`.

This did not prove that the definition was lost. It proved only that `CH01` was not currently available as an installed transaction in the active region.

### 3. Check the stored definition

```text
CEDA VIEW TRANSACTION(CH01) GROUP(LAB01)
```

`CH01` existed in group `LAB01` and referenced program `CICSL01`.

### 4. Install the existing group

```text
CEDA INSTALL GROUP(LAB01)
```

Result: `INSTALL SUCCESSFUL`.

No program was recompiled and no BMS map was regenerated. Existing definitions were installed into the active CICS region.

### 5. Verify the transaction at runtime

```text
CEMT I TRANS(CH01)
```

Result: `RESPONSE: NORMAL`. The installed transaction showed its relationship with `CICSL01`.

### 6. Verify the program resource

```text
CEMT I PROG(CICSL01)
```

Result: `RESPONSE: NORMAL`.

### 7. Observe a real task

```text
CEMT I TASK
```

The evidence showed a task such as:

```text
Tas(0000057) Tra(CEMT)
```

This is a concrete execution of the `CEMT` transaction. A transaction definition and a task are therefore not the same thing.

### 8. Execute the online application

After leaving CEMT, `CH01` was executed. The existing Lab 01 BMS screen was displayed successfully, confirming that the installed transaction/program/map resources were operational.

## Terminology

| Term | Meaning in this lab |
|---|---|
| CICS region | Running CICS environment in z/OS |
| CEDA | CICS transaction used here to view/install resource definitions |
| CEMT | Operational CICS transaction used here to inquire about the active region/resources |
| GROUP | Collection of related CICS resource definitions |
| TRANSACTION | Named CICS operation, e.g. `CH01` |
| PROGRAM | Program resource associated with the transaction, e.g. `CICSL01` |
| TASK | One concrete execution of a transaction |
| DEFINE | Create/store a resource definition |
| INSTALL | Make definitions available in the active region |
| INQUIRE | Query current runtime state |

## Key distinction

```text
CEDA VIEW
   |
   +--> Does the definition exist?

CEDA INSTALL
   |
   +--> Make the definition active in this region

CEMT INQUIRE
   |
   +--> What is active/running now?
```

The observed sequence was:

```text
CEMT I TRANS(CH01) -> NOT FOUND
CEDA VIEW ...      -> definition exists
CEDA INSTALL ...   -> INSTALL SUCCESSFUL
CEMT I TRANS(CH01) -> RESPONSE: NORMAL
```

## Multitasking observation

A TASK is not another definition. It is an execution instance. `CEMT I TASK` exposed a live task for CEMT itself. The short Lab 01 program sends a map and returns quickly, so its `CH01` task is not kept alive artificially just to capture it.

The lesson's multithreading reference is retained at conceptual level only. This lab does not introduce TCB internals, dispatching modes or other advanced execution topics that were outside the lesson scope.

## Result

Lab 02 demonstrates the operational lifecycle of existing CICS resources and connects:

```text
CICS REGION
   -> stored definition
   -> INSTALL
   -> TRANSACTION
   -> PROGRAM
   -> TASK
   -> online execution
```

## Evidence

`evidence/screenshots/` contains the original screenshots extracted from the supplied execution document, including the initial `NOT FOUND`, CEDA definition/install evidence, successful CEMT inquiries, task observation and final `CH01` screen.
