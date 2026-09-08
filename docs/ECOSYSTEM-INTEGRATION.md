# CICS — Ecosystem Integration

## Purpose

This document defines the role of the `CICS` repository inside the broader z/OS Engineering Laboratory.

The repository is the online transaction-processing and CICS runtime layer of the ecosystem. It documents how CICS resources are defined, installed, observed and executed, how CICS programs interact with BMS maps and 3270 terminals, and how COBOL/CICS application logic is built and validated.

The repository records work that has actually been executed in the laboratory and clearly separates validated capabilities from future integration targets.

Master architecture:

https://github.com/P-dot/zos-adcd-hercules-engineering-lab

---

## 1. Position in the ecosystem

CICS sits above the core z/OS environment and acts as the online transaction-processing layer:

```text
z/OS
 |
 +-- TSO/ISPF
 |
 +-- CICS region
      |
      +-- stored resource definitions
      |
      +-- installed runtime resources
      |
      +-- TRANSACTION
      |      |
      |      v
      |     TASK
      |      |
      |      v
      |   PROGRAM
      |      |
      |      +--> BMS MAPSET / MAP / FIELD
      |      |
      |      +--> COBOL application logic
      |
      +-- 3270 terminal interaction
```

In the wider ecosystem, CICS is expected to integrate with:

```text
RACF
  |
CICS
  |
COBOL
  |
DB2 / VSAM
```

but only the currently validated portions are documented as complete.

---

## 2. Repository responsibility

The `CICS` repository owns the practical learning path for:

- CICS transaction-processing fundamentals;
- CICS region concepts;
- TRANSACTION, TASK and PROGRAM relationships;
- stored resource definitions versus installed runtime resources;
- CEDA;
- CEMT;
- CECI;
- CEDF;
- BMS mapsets, maps and fields;
- physical and symbolic maps;
- COBOL/CICS translation, compilation and link-edit;
- CICS program installation and refresh;
- `NEWCOPY`;
- 3270 AID interaction;
- static cursor positioning in BMS;
- dynamic cursor positioning from COBOL;
- CICS runtime observation;
- troubleshooting of CICS, BMS and COBOL/CICS build failures;
- preservation of runtime evidence.

---

## 3. What this repository does not own

The repository does not replace the neighboring specialized repositories.

### COBOL

General COBOL language fundamentals belong to:

```text
COBOL
```

The CICS repository contains COBOL/CICS source where needed to demonstrate transaction-processing behavior, but does not re-teach COBOL fundamentals.

### Db2

Relational-data concepts, SQL, catalog introspection and Db2-specific diagnostics belong to:

```text
DB2-
```

Future CICS/COBOL/Db2 work should be implemented as cross-repository integration.

### VSAM

VSAM organization, access method fundamentals, IDCAMS and data-set behavior belong to:

```text
vsam01
```

Future CICS/VSAM access belongs to an integration track.

### RACF

General authorization design, profile administration, audit and least-privilege work belong to:

```text
mainframe-racf-security-evidence
```

CICS security should integrate with RACF rather than duplicate the RACF learning path.

### JCL and JES2

General batch job construction belongs to:

```text
JCL_LABS
```

CICS build JCL is included only where required to assemble maps, translate/compile programs and link-edit load modules.

### Core z/OS engineering

System initialization, storage, JES2, SMF, WLM, recovery and other system-engineering topics belong to:

```text
zos-adcd-hercules-engineering-lab
```

---

## 4. Upstream dependencies

The validated CICS work depends on:

- an operational z/OS environment;
- a running CICS region;
- TSO/E and ISPF;
- JES2 and SDSF for build-job execution and result review;
- CICS build tooling;
- Enterprise COBOL;
- HLASM/BMS assembly;
- load libraries;
- CICS resource definitions.

Conceptually:

```text
TSO/ISPF
   |
   v
JCL / build jobs
   |
   +--> BMS assembly
   |
   +--> CICS translator
   |
   +--> COBOL compiler
   |
   +--> link-edit
   |
   v
load modules / maps
   |
   v
CICS region
```

---

## 5. Validated repository progression

The current repository contains four validated labs.

## Lab 01 — CICS Transaction Processing Fundamentals

Lab 01 establishes the basic CICS execution model:

```text
TRANSACTION
    |
    v
   TASK
    |
    v
 PROGRAM
```

and the BMS structure:

```text
MAPSET
   |
   v
  MAP
   |
   v
 FIELD
```

The practical application path is:

```text
transaction
   |
   v
COBOL/CICS program
   |
   v
EXEC CICS SEND MAP
   |
   v
BMS mapset / map
   |
   v
3270 screen
```

The lab validates:

- BMS map assembly;
- physical map generation;
- symbolic map generation;
- CICS translation;
- COBOL compilation;
- link-edit;
- CICS resource definition;
- resource installation;
- execution of the transaction;
- display of the BMS screen.

The final build completed successfully with clean return codes.

The lab also preserves useful failures:

- a BMS fixed-format continuation problem;
- undefined symbolic-map data references caused by a missing generated copybook.

These were diagnosed, corrected and followed by successful rebuilds.

### Validated relationship with COBOL

Lab 01 already demonstrates a real CICS-to-COBOL relationship:

```text
CICS TRANSACTION
      |
      v
COBOL/CICS PROGRAM
      |
      v
BMS SEND MAP
```

This integration is already validated.

---

## Lab 02 — CICS Runtime Resources and Multitasking

Lab 02 deliberately reuses the artifacts from Lab 01 instead of rebuilding them.

Its focus is runtime state.

The key distinction demonstrated is:

```text
stored resource definition
          |
          v
      CEDA VIEW
          |
          v
 definition exists
```

versus:

```text
installed runtime resource
          |
          v
      CEMT INQUIRE
          |
          v
 currently active state
```

The observed sequence was:

```text
CEMT I TRANS
     |
     v
NOT FOUND
     |
     v
CEDA VIEW
     |
     v
definition exists
     |
     v
CEDA INSTALL
     |
     v
INSTALL SUCCESSFUL
     |
     v
CEMT I TRANS
     |
     v
RESPONSE: NORMAL
```

The lab also demonstrates the difference between:

- TRANSACTION;
- PROGRAM;
- TASK.

A task is a concrete execution instance, not another stored definition.

This establishes CICS as a live runtime environment rather than merely a set of configuration definitions.

---

## Lab 03 — CICS 3270 Interaction, AID, CECI and CEDF

Lab 03 extends the same application without duplicating source or build material.

Validated topics include:

- 3270 input;
- AID behavior;
- ENTER handling;
- CECI;
- CEDF;
- transaction execution observation;
- program initiation;
- interception before `EXEC CICS SEND MAP`;
- task observation;
- EDF enable/disable workflow;
- runtime troubleshooting.

The observed execution path is:

```text
TRANSACTION
    |
    v
   TASK
    |
    v
 PROGRAM
    |
    v
EXEC CICS SEND MAP
    |
    v
MAP / MAPSET
    |
    v
3270 terminal
```

CEDF makes that path observable in real time.

The lab also exposes an important limitation of the current application: it sends a map and returns, but does not yet implement a receive/process cycle.

That limitation is preserved rather than hidden.

---

## Lab 04 — BMS Maps and Cursor Control — Part 1

Lab 04 Part 1 deepens the BMS/program relationship.

It validates the transition from static cursor positioning:

```text
BMS field
  |
  v
ATTRB=(UNPROT,IC)
```

to dynamic cursor positioning from application logic:

```text
COBOL/CICS program
      |
      v
symbolic length field = -1
      |
      v
SEND MAP ... CURSOR
      |
      v
cursor positioned by program logic
```

The lab demonstrates:

- BMS source modification;
- fixed-format troubleshooting;
- symbolic-map use;
- COBOL fixed-format correction;
- translation;
- compile;
- link-edit;
- program refresh;
- `NEWCOPY`;
- runtime validation.

The final transaction executes successfully with the cursor placed dynamically in the intended input field.

### Preserved failures

The lab intentionally retains:

- BMS assembly RC=0008 caused by damaged continuation formatting;
- COBOL RC=0008 caused by incorrect Area A/Area B placement.

Both were corrected and followed by clean builds.

---

## 6. Current validated capability map

The repository currently demonstrates:

```text
CICS region
   |
   +--> stored definitions
   |       |
   |       +--> CEDA VIEW
   |       +--> CEDA INSTALL
   |
   +--> runtime resources
   |       |
   |       +--> CEMT INQUIRE
   |       +--> CEMT SET
   |
   +--> TRANSACTION
   |       |
   |       v
   |      TASK
   |       |
   |       v
   |    PROGRAM
   |       |
   |       +--> EXEC CICS SEND MAP
   |       |
   |       +--> BMS symbolic map
   |
   +--> BMS
   |       |
   |       +--> MAPSET
   |       +--> MAP
   |       +--> FIELD
   |
   +--> 3270
   |       |
   |       +--> AID
   |       +--> cursor behavior
   |
   +--> CECI
   |
   +--> CEDF
```

---

## 7. Inputs consumed by the repository

The repository consumes:

- z/OS runtime services;
- a running CICS region;
- TSO/E;
- ISPF;
- JCL;
- JES2/SDSF;
- COBOL compiler;
- CICS translator;
- HLASM/BMS assembly support;
- CICS load libraries;
- CICS resource definitions;
- BMS source;
- COBOL/CICS source;
- 3270 terminal interaction.

---

## 8. Outputs produced by the repository

The repository produces:

- BMS source;
- physical maps;
- symbolic maps;
- COBOL/CICS source;
- load modules;
- build JCL;
- CICS command sequences;
- CEDA definitions/install evidence;
- CEMT runtime evidence;
- CECI/ CEDF execution evidence;
- screenshots;
- troubleshooting documentation;
- validated transaction execution;
- reusable application foundations for future Db2/VSAM integration.

---

## 9. Validated cross-repository integration

### CICS → COBOL

This is already validated.

The current path is:

```text
CICS transaction
       |
       v
COBOL/CICS program
       |
       v
EXEC CICS SEND MAP
       |
       v
BMS screen
```

The COBOL repository remains the source of truth for general COBOL fundamentals.

The CICS repository owns the CICS-specific application context.

---

## 10. Planned application integration

The following paths are architectural targets and must remain marked as planned until executed and evidenced.

### CICS → COBOL → Db2

Planned path:

```text
CICS
 |
 v
COBOL
 |
 v
Db2
```

Ownership remains separated:

```text
CICS   -> transaction/runtime layer
COBOL  -> application-language layer
DB2-   -> relational-data layer
```

Future work may introduce embedded SQL, Db2 access from the CICS program and transactional data processing.

---

### CICS → COBOL → VSAM

Planned path:

```text
CICS
 |
 v
COBOL
 |
 v
VSAM
```

VSAM organization and access fundamentals remain owned by `vsam01`.

The CICS repository should only document the transaction-processing side of the integration.

---

## 11. RECEIVE MAP and input-processing roadmap

The repository currently stops after successful `SEND MAP` behavior.

The next logical application step is:

```text
SEND MAP
   |
3270 user input
   |
AID
   |
RECEIVE MAP
   |
application processing
```

This is not yet validated in the current repository state.

The same applies to:

- pseudo-conversational flow;
- COMMAREA;
- multi-step transaction state handling.

These remain future work.

---

## 12. CEDA and CEMT boundary

The distinction between CEDA and CEMT is now a core repository concept.

```text
CEDA
 |
 +--> define / view / install resource definitions

CEMT
 |
 +--> inquire / control active runtime resources
```

This difference should remain explicit in later labs.

A stored definition does not automatically prove that the resource is currently active.

A runtime inquiry does not replace the stored-definition model.

---

## 13. CECI and CEDF role

The current repository demonstrates two different diagnostic/interactivity tools.

### CECI

CECI is used as an interactive CICS command interpreter.

Its role is exploratory and command-oriented.

### CEDF

CEDF is used to observe execution.

It exposes points such as:

```text
PROGRAM INITIATION
```

and:

```text
before EXEC CICS SEND MAP
```

This makes the transaction path visible while the application is running.

Neither tool replaces normal production monitoring or system-level observability.

---

## 14. BMS role in the ecosystem

BMS connects the CICS application to the 3270 presentation layer.

The validated build relationship is:

```text
BMS source
   |
   +--> physical map
   |
   +--> symbolic map
            |
            v
       COBOL/CICS
```

The symbolic map is therefore part of the interface between BMS and the application program.

Future RECEIVE MAP work will deepen this interface.

---

## 15. Build chain

The current CICS application build chain is:

```text
BMS
 |
 +--> assemble
 +--> link physical map
 +--> generate symbolic map

COBOL/CICS
 |
 +--> CICS translator
 +--> COBOL compile
 +--> link-edit
```

The final products are then consumed by the running CICS region.

This relationship depends on JCL/JES2 for batch execution, but general JCL teaching remains outside the CICS repository.

---

## 16. Program refresh and NEWCOPY

Lab 04 validates the operational need to refresh an already installed program after replacing its load module.

The observed path is:

```text
new load module
      |
      v
CEMT SET PROGRAM ... NEWCOPY
      |
      v
CICS uses refreshed program copy
```

This is a validated runtime-management concept.

---

## 17. Troubleshooting philosophy

The repository follows:

```text
Build
  |
Execute
  |
Observe
  |
Diagnose
  |
Correct
  |
Validate
  |
Document
```

Useful failures are retained.

Examples include:

- BMS continuation errors;
- COBOL fixed-format errors;
- missing symbolic map definitions;
- transaction not installed at runtime;
- EDF shutdown troubleshooting;
- application limitation after AID input without RECEIVE MAP.

The repository should continue documenting real failures rather than rewriting the path into artificial success.

---

## 18. Evidence discipline

A completed CICS lab should allow a reviewer to determine:

- what transaction/resource was involved;
- what definition existed;
- whether it was installed;
- what program ran;
- what task was observed;
- what CICS command was used;
- what build step succeeded or failed;
- what runtime result was observed;
- what correction was applied;
- what final validation proved completion.

Evidence should distinguish:

```text
definition state
```

from:

```text
runtime state
```

and:

```text
build success
```

from:

```text
successful online execution
```

---

## 19. Separation of validated and planned states

### Validated

Current validated capabilities include:

- TRANSACTION/TASK/PROGRAM relationship;
- BMS MAPSET/MAP/FIELD relationship;
- physical and symbolic map generation;
- CICS translator;
- COBOL compile/link;
- CEDA definition inspection;
- CEDA installation;
- CEMT runtime inquiry;
- task observation;
- CECI;
- CEDF;
- AID observation;
- SEND MAP;
- static cursor control;
- dynamic cursor control;
- NEWCOPY;
- real CICS/COBOL execution.

### Planned

Current planned capabilities include:

- RECEIVE MAP;
- pseudo-conversational processing;
- COMMAREA;
- CICS/VSAM integration;
- CICS/Db2 integration;
- CICS security integration with RACF;
- more advanced task/TCB/threadsafe internals;
- production-style recovery flows.

---

## 20. Relationship with COBOL

The intended division of responsibility is:

```text
COBOL repository
   |
   +--> syntax
   +--> data definitions
   +--> language fundamentals
   +--> compile/link/run fundamentals

CICS repository
   |
   +--> transaction processing
   +--> CICS commands
   +--> BMS
   +--> runtime resources
   +--> CICS-specific COBOL integration
```

The repositories should remain independently useful.

---

## 21. Relationship with DB2-

Future online integration should follow:

```text
CICS transaction
       |
       v
COBOL/CICS program
       |
       v
Db2 SQL
       |
       v
relational data
```

The CICS repository should document transaction/runtime behavior.

The Db2 repository should document SQL, data objects, integrity and Db2-specific diagnostics.

---

## 22. Relationship with VSAM

Future path:

```text
CICS
 |
 v
COBOL
 |
 v
VSAM
```

The CICS side should demonstrate:

- transaction invocation;
- command flow;
- runtime behavior;
- response handling.

The VSAM side should own organization, key/RBA/RRN semantics and data-set architecture.

---

## 23. Relationship with RACF

CICS security is a cross-cutting concern.

Future integration may include:

```text
RACF
  |
  v
CICS transaction/program/resource authorization
```

However, RACF profile design, access models and audit policy belong to the security repository.

CICS should document service impact and runtime behavior where security directly affects the application path.

---

## 24. Relationship with JCL_LABS

CICS labs use JCL to build maps and programs.

The intended relationship is:

```text
JCL_LABS
   |
   v
general batch/job concepts
   |
   v
CICS-specific build JCL
```

The CICS repository should not re-teach basic JOB/EXEC/DD semantics.

---

## 25. Relationship with the core engineering laboratory

The central z/OS engineering repository provides the system context.

Relevant shared areas may include:

- JES2;
- SDSF;
- started tasks;
- SMF;
- dumps;
- storage;
- WLM;
- system diagnostics.

Where later CICS work crosses those domains, the CICS repository should document the CICS-specific behavior and link to the core system concept.

---

## 26. Publication and security rules

Public material must be reviewed before publication.

Do not expose:

- passwords;
- credentials;
- private keys;
- tokens;
- private IP addresses;
- MAC addresses;
- host adapter identifiers;
- terminal/session identifiers when unnecessarily identifying the environment;
- sensitive host-side configuration;
- unnecessary infrastructure details.

Screenshots require the same security review as text.

A publication flow should include:

```text
source
  |
  +--> documentation review
  +--> screenshot review
  +--> IP/MAC scan
  +--> credential review
  |
  v
safe public evidence
```

---

## 27. Repository structure and publication units

Current publication units are:

```text
labs/
  01-cics-transaction-processing-fundamentals/
  02-cics-runtime-resources-and-multitasking/
  03-cics-3270-aid-ceci-cedf/
  04-bms-maps-cursor-control-part-1/
```

The progression is intentional.

Labs 02 and 03 reuse Lab 01 resources rather than duplicating them.

Lab 04 introduces a new BMS/application baseline and explicitly stops at Part 1 before RECEIVE MAP.

That boundary should remain clear.

---

## 28. Recommended integration branch model

Future cross-repository work should use short-lived branches such as:

```text
integration/cics-cobol-db2
integration/cics-cobol-vsam
integration/cics-racf-security
integration/end-to-end-online-transaction
```

Lifecycle:

```text
main
 |
 +--> integration branch
          |
          +--> implementation
          +--> evidence
          +--> security review
          +--> validation
          +--> documentation
          |
          v
         PR
          |
          v
        main
          |
          v
    delete branch
```

---

## 29. Current maturity

The repository has progressed through:

```text
Transaction fundamentals
        |
        v
Runtime resources
        |
        v
3270 / AID / CECI / CEDF
        |
        v
BMS cursor control
```

This is enough to establish a real CICS learning track.

The repository should not yet claim completion of:

```text
RECEIVE MAP
COMMAREA
pseudo-conversational applications
CICS + VSAM
CICS + DB2
CICS + RACF
```

Those remain next-stage integrations.

---

## 30. Target ecosystem role

The long-term role of `CICS` is:

> Provide the validated online transaction-processing, CICS runtime, 3270/BMS and transaction-resource layer consumed by COBOL application flows and future Db2/VSAM integrations inside the z/OS Engineering Laboratory.

In practical terms:

```text
           RACF
             |
             v
           CICS
             |
             v
           COBOL
          /     \
         v       v
       VSAM     DB2
```

CICS owns the online transaction/runtime layer.

The neighboring repositories retain ownership of their own technologies.

---

## 31. Current integration status

| Integration path | State |
|---|---|
| CICS TRANSACTION → TASK → PROGRAM | Validated |
| BMS MAPSET → MAP → FIELD | Validated |
| CICS → COBOL/CICS program | Validated |
| COBOL/CICS → SEND MAP → 3270 | Validated |
| CEDA definition → install | Validated |
| CEMT runtime inquiry/control | Validated |
| CECI interactive command use | Validated |
| CEDF runtime execution observation | Validated |
| Static BMS cursor control | Validated |
| Dynamic program-controlled cursor | Validated |
| Program refresh with NEWCOPY | Validated |
| RECEIVE MAP | Planned |
| COMMAREA | Planned |
| CICS → COBOL → VSAM | Planned |
| CICS → COBOL → Db2 | Planned |
| RACF-controlled CICS security path | Planned |
| End-to-end online transaction cycle | Planned |

---

## 32. Engineering rule

The repository should continue to follow one central rule:

> Document what CICS actually did, not what the lab was expected to do.

That means preserving useful build failures, runtime `NOT FOUND` states, diagnostic observations, execution limits and recovery steps when they explain the engineering process.

The result is not just a collection of CICS commands.

It is a progressive record of how CICS behaves as a transaction-processing subsystem inside a larger z/OS environment.
