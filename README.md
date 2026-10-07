# CICS Transaction Processing Engineering Labs

> **Online transaction processing, runtime resource management, 3270/BMS application flow, COBOL/CICS integration, diagnostics, and evidence on IBM z/OS.**

This repository is the **CICS transaction-processing domain** of the [IBM z/OS Mainframe Engineering Portfolio](https://github.com/P-dot).

The repository documents work executed and validated in a running CICS environment. It focuses on transaction execution, resource definitions versus runtime state, BMS/3270 interaction, COBOL/CICS application behavior, operational commands, debugging, program refresh, and preserved troubleshooting evidence.

**Validated capabilities and planned integrations are deliberately separated.**

---

## Navigate

| Destination | Purpose |
|---|---|
| [Labs](labs/) | Practical CICS progression |
| [Lab 01 — Transaction Processing Fundamentals](labs/01-cics-transaction-processing-fundamentals/README.md) | TRANSACTION → TASK → PROGRAM, BMS build and first online execution |
| [Lab 02 — Runtime Resources and Multitasking](labs/02-cics-runtime-resources-and-multitasking/README.md) | CEDA definitions, installation, CEMT runtime state and task observation |
| [Lab 03 — 3270, AID, CECI and CEDF](labs/03-cics-3270-aid-ceci-cedf/README.md) | Terminal interaction and live execution observation |
| [Lab 04 — BMS Maps and Cursor Control, Part 1](labs/04-bms-maps-cursor-control-part-1/README.md) | Static/dynamic cursor control, build troubleshooting and NEWCOPY |
| [Ecosystem Integration](docs/ECOSYSTEM-INTEGRATION.md) | Detailed ownership, dependencies, validated capabilities and roadmap |

---

## Repository Role

| Attribute | Scope |
|---|---|
| Engineering domain | Online Transaction Processing |
| Platform | IBM z/OS |
| Primary technology | CICS Transaction Server |
| Application layer | COBOL/CICS |
| Presentation layer | 3270 / BMS |
| Resource management | CEDA / CEMT |
| Interactive diagnostics | CECI / CEDF |
| Operational lifecycle | Define → Build → Install → Execute → Observe → Diagnose → Correct → Validate |

This repository owns the **CICS-specific runtime and transaction-processing context**. General COBOL, Db2, VSAM, JCL/JES2, RACF, and core z/OS engineering remain owned by their specialized repositories.

---

## Architecture at a Glance

```text
                         z/OS
                          |
                    CICS region
                          |
                     TRANSACTION
                          |
                          v
                         TASK
                          |
                          v
                       PROGRAM
                      /       \
                     /         \
             COBOL/CICS       BMS
                 logic      MAPSET
                              |
                             MAP
                              |
                            FIELD
                              |
                              v
                         3270 terminal
```

The current application path demonstrated by the labs is:

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
BMS map / mapset
       |
       v
3270 screen
```

For the full domain model, ownership boundaries, build chain, inputs/outputs, and integration roadmap, see [Ecosystem Integration](docs/ECOSYSTEM-INTEGRATION.md).

---

## Validated Capabilities

The current repository demonstrates:

```text
CICS REGION
   |
   +--> Resource definitions
   |      +--> CEDA VIEW
   |      +--> CEDA INSTALL
   |
   +--> Runtime resources
   |      +--> CEMT INQUIRE
   |      +--> CEMT SET
   |
   +--> TRANSACTION
   |      |
   |      v
   |     TASK
   |      |
   |      v
   |    PROGRAM
   |
   +--> BMS
   |      +--> MAPSET
   |      +--> MAP
   |      +--> FIELD
   |      +--> physical map
   |      +--> symbolic map
   |
   +--> 3270 / AID
   |
   +--> CECI
   +--> CEDF
   |
   +--> SEND MAP
   +--> static cursor control
   +--> dynamic cursor control
   +--> NEWCOPY
```

The repository also demonstrates a real **CICS → COBOL/CICS** execution relationship. It does not yet claim a completed CICS→Db2, CICS→VSAM, or RACF-controlled CICS application path.

---

## Lab Progression

| Lab | Engineering focus | Key evidence | State |
|---|---|---|---|
| [01](labs/01-cics-transaction-processing-fundamentals/README.md) | Transaction-processing fundamentals | BMS physical/symbolic map generation; CICS translation; COBOL compile/link; installed resources; successful `CH01` execution | Validated |
| [02](labs/02-cics-runtime-resources-and-multitasking/README.md) | Definition state vs runtime state | `NOT FOUND` → CEDA definition → INSTALL → CEMT `RESPONSE: NORMAL`; live TASK observation | Validated |
| [03](labs/03-cics-3270-aid-ceci-cedf/README.md) | 3270/AID and runtime observation | CECI; CEDF; program initiation; TASK observation; interception before `SEND MAP`; EDF shutdown verification | Validated |
| [04](labs/04-bms-maps-cursor-control-part-1/README.md) | BMS and program-controlled cursor | Static `IC`; dynamic cursor; preserved RC=0008 failures; corrected RC=0000 build; `NEWCOPY`; successful `H404` | Validated |

The sequence is intentionally cumulative. Labs 02 and 03 reuse the Lab 01 application rather than duplicating its BMS, COBOL, and build artifacts. Lab 04 establishes a new working baseline and deliberately stops before `RECEIVE MAP`.

---

## Definition State Is Not Runtime State

One of the most important validated operational distinctions is:

```text
CEDA VIEW
   |
   +--> Does the stored definition exist?

CEDA INSTALL
   |
   +--> Make definitions available in the active region

CEMT INQUIRE
   |
   +--> What is active now?
```

Lab 02 demonstrates this directly:

```text
CEMT I TRANS(CH01)  -> NOT FOUND
        |
        v
CEDA VIEW           -> definition exists
        |
        v
CEDA INSTALL        -> INSTALL SUCCESSFUL
        |
        v
CEMT I TRANS(CH01)  -> RESPONSE: NORMAL
```

A stored resource definition is therefore not evidence that the resource is currently installed in the active CICS region.

---

## Build and Runtime Chain

The validated application build path is:

```text
BMS source
   |
   +--> assemble
   +--> physical map
   +--> symbolic map
                 |
                 v
             COBOL/CICS source
                 |
                 +--> CICS translator
                 +--> COBOL compiler
                 +--> link-edit
                 |
                 v
              load module
                 |
                 v
              CICS region
                 |
                 +--> install / refresh
                 |
                 v
             transaction execution
```

Lab 04 also validates the runtime refresh path:

```text
new load module
      |
      v
CEMT SET PROG(...) NEWCOPY
      |
      v
refreshed program copy
      |
      v
runtime validation
```

---

## Evidence and Troubleshooting

The repository follows the portfolio engineering workflow:

```text
BUILD
  ↓
EXECUTE
  ↓
OBSERVE
  ↓
DIAGNOSE
  ↓
CORRECT
  ↓
VALIDATE
  ↓
DOCUMENT
```

Useful failures are retained when they explain CICS behavior or the build/runtime boundary. Current examples include BMS fixed-format continuation failures, COBOL fixed-format failures, missing symbolic-map references, resources defined but not installed, and EDF shutdown troubleshooting.

A successful build alone is not treated as proof of successful online execution. Likewise, the existence of a stored definition is not treated as proof of active runtime state.

---

## Validated vs Planned

| Capability / integration | Status |
|---|---|
| TRANSACTION → TASK → PROGRAM | **VALIDATED** |
| BMS MAPSET → MAP → FIELD | **VALIDATED** |
| CICS → COBOL/CICS program | **VALIDATED** |
| COBOL/CICS → SEND MAP → 3270 | **VALIDATED** |
| CEDA definition inspection / installation | **VALIDATED** |
| CEMT runtime inquiry / control | **VALIDATED** |
| CECI interactive command use | **VALIDATED** |
| CEDF execution observation | **VALIDATED** |
| Static and dynamic cursor control | **VALIDATED** |
| Program refresh with NEWCOPY | **VALIDATED** |
| RECEIVE MAP | **PLANNED** |
| Pseudo-conversational processing | **PLANNED** |
| COMMAREA | **PLANNED** |
| CICS → COBOL → VSAM | **PLANNED** |
| CICS → COBOL → Db2 | **PLANNED** |
| RACF-controlled CICS security path | **PLANNED** |
| Production-style recovery flows | **PLANNED** |

This boundary is intentional: the public portfolio should describe what the laboratory evidence proves, not what a tutorial or architecture diagram merely expects to happen.

---

## Related Engineering Domains

| Domain | Repository | Relationship |
|---|---|---|
| Portfolio | [P-dot](https://github.com/P-dot) | Global engineering map |
| Core z/OS | [zos-adcd-hercules-engineering-lab](https://github.com/P-dot/zos-adcd-hercules-engineering-lab) | System environment, JES2, SDSF and shared operational context |
| COBOL | [COBOL](https://github.com/P-dot/COBOL) | General application-language fundamentals |
| Db2 | [DB2-](https://github.com/P-dot/DB2-) | Relational data and Db2-specific diagnostics |
| VSAM | [vsam01](https://github.com/P-dot/vsam01) | Access methods and data-set architecture |
| JCL / JES2 | [JCL_LABS](https://github.com/P-dot/JCL_LABS) | General batch/job construction |
| RACF / Security | [mainframe-racf-security-evidence](https://github.com/P-dot/mainframe-racf-security-evidence) | Authorization, audit and security boundaries |
| Integrated application path | [mainframe-cobol-db2-cics-devops-lab](https://github.com/P-dot/mainframe-cobol-db2-cics-devops-lab) | Cross-domain application integration |

Cross-repository links describe ownership and engineering relationships. They do not imply that every possible integration path is already implemented.

---

## Repository Structure

```text
CICS/
├── README.md
├── docs/
│   └── ECOSYSTEM-INTEGRATION.md
└── labs/
    ├── 01-cics-transaction-processing-fundamentals/
    │   ├── bms/
    │   ├── cobol/
    │   ├── commands/
    │   ├── docs/
    │   ├── evidence/
    │   └── jcl/
    ├── 02-cics-runtime-resources-and-multitasking/
    ├── 03-cics-3270-aid-ceci-cedf/
    └── 04-bms-maps-cursor-control-part-1/
```

The root README is the navigation and domain overview. Each lab owns its detailed implementation and evidence. `docs/ECOSYSTEM-INTEGRATION.md` owns the deeper cross-repository architecture and roadmap.

---

## Next Engineering Step

The current application path ends after successful `SEND MAP` behavior. The next planned application boundary is:

```text
SEND MAP
   |
   v
3270 user input
   |
   v
AID
   |
   v
RECEIVE MAP
   |
   v
application processing
```

`RECEIVE MAP` must remain marked as planned until it is executed, evidenced, and validated in the laboratory.

---

## Security and Publication Standard

Before publication, source, command output, configuration fragments, and screenshots should be reviewed for credentials, tokens, private IP addresses, MAC addresses, host adapter identifiers, unnecessary terminal/session identifiers, and other host-specific information that does not need to be public.

The same review applies to screenshots and copied console output.

---

## Continue Through the Portfolio

[Portfolio Home](https://github.com/P-dot) ·
[Core z/OS Engineering](https://github.com/P-dot/zos-adcd-hercules-engineering-lab) ·
[COBOL](https://github.com/P-dot/COBOL) ·
[Db2](https://github.com/P-dot/DB2-) ·
[VSAM](https://github.com/P-dot/vsam01) ·
[RACF Security](https://github.com/P-dot/mainframe-racf-security-evidence)

> Part of the **IBM z/OS Mainframe Engineering Portfolio** — an independent hands-on environment focused on systems, operations, development, security, automation, diagnostics, recovery, and integration.


---

## z/OS Engineering Academy

**Academy role:** Transaction School — online execution linking programs, data, security and recovery.

[Start the Academy](https://github.com/P-dot/P-dot/blob/main/docs/ACADEMY.md) · [Course Catalog](https://github.com/P-dot/P-dot/blob/main/docs/COURSES.md) · [Curriculum Graph](https://github.com/P-dot/P-dot/blob/main/docs/CURRICULUM.md) · [Cross-Domain Relationships](https://github.com/P-dot/P-dot/blob/main/docs/RELATIONSHIPS.md)

> Learn the concept → execute the lab → interpret the evidence → understand the subsystem boundary → continue to the next connected course.
