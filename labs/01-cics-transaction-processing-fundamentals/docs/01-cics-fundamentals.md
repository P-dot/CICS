# CICS Fundamentals

## Transaction, task and program

A transaction is the CICS request identified in this lab by `CH01`. The transaction definition associates that request with `CICSL01`.

A task is one execution instance created by CICS when the transaction is invoked. Transaction, task and program are therefore related but are not the same object.

## Lab flow

```text
3270 user -> CH01 -> CICS transaction -> task -> CICSL01 -> EXEC CICS -> BMS screen
```

The practical objective is to make these introductory concepts observable rather than leave them as definitions.
