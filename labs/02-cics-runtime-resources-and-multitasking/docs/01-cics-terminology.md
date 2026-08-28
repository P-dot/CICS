# CICS terminology used in Lab 02

This lab uses a small set of terms repeatedly.

## CICS region

The running CICS environment inside z/OS. Applications and installed resources operate inside this region.

## CEDA

Used in this lab for resource-definition work. `CEDA VIEW` showed that `CH01` still existed as a definition even when CEMT could not find it as an installed transaction. `CEDA INSTALL GROUP(LAB01)` installed the existing group.

## CEMT

Used for operational inquiry against the active region. The lab used CEMT to inspect SYSTEM, TRANSACTION, PROGRAM and TASK.

## Transaction, program and task

```text
TRANSACTION CH01
      |
      +--> PROGRAM CICSL01

When CH01 is requested:
      |
      +--> CICS creates a TASK
```

A transaction is a named operation/resource definition. A program is executable application logic known to CICS. A task is one execution instance.
