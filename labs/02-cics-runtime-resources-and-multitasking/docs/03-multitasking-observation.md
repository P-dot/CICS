# Multitasking observation

`CEMT I TASK` was used to observe a live CICS task.

The captured output included a task identifier and transaction:

```text
Tas(0000057) Tra(CEMT)
```

The task existed because CEMT itself was executing. This gives a direct distinction:

```text
CEMT = transaction
0000057 = one execution/task
```

The existing `CH01` application executes `CICSL01`, sends its BMS map and returns quickly. The lab intentionally does not modify the application to create an artificial long-running task.

The lesson also mentions multithreading. Lab 02 records that concept without expanding into TCB/dispatching internals, because those topics are outside this introductory block.
