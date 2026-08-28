# Lab 03 — CICS 3270 Interaction, AID, CECI and CEDF

## Objective
Extend Labs 01–02 without duplicating their source/JCL. The existing `CH01 -> CICSL01 -> L01MAPS/L01MAP` application is reused to study 3270 interaction, AID behaviour, CECI and CEDF.

## What was demonstrated
- Input in the existing BMS `UNPROT` field and initial cursor behaviour (`IC`).
- ENTER as an AID interaction.
- `DFHAC2001` after entering `TEST`, exposing the limitation of the current SEND/RETURN application without a receive/process cycle.
- CECI as an interactive CICS command interpreter.
- CEDF enabled for the terminal.
- A live execution showing `TRANSACTION: CH01`, `PROGRAM: CICSL01`, `TASK: 0000079`.
- CEDF stopping at `PROGRAM INITIATION`.
- CEDF stopping immediately before `EXEC CICS SEND MAP`, with `L01MAP` / `L01MAPS`.
- The resulting BMS screen.
- Troubleshooting of EDF shutdown and final confirmation `THIS TERMINAL: EDF MODE OFF`.

## Runtime path observed
```text
CH01
  -> TASK 0000079
  -> CICSL01
  -> EXEC CICS SEND MAP
  -> L01MAP / L01MAPS
  -> 3270 terminal
```

## Reuse, not duplication
Lab 01 owns the COBOL, BMS and build artifacts. Lab 02 already demonstrates CEDA/CEMT, installed resources and basic TASK observation. They are referenced here rather than copied.

## Scope
The lesson block introduces reentrancy/quasi-reentrancy conceptually. Advanced TCB, dispatching and threadsafe internals are deliberately outside this lab.

See `docs/` for the theory/walkthrough and `evidence/` for the supplied screenshots.
