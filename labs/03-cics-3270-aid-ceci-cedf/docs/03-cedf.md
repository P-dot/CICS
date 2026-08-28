# CEDF

EDF was enabled for the terminal and CH01 was executed.

CEDF showed:
```text
TRANSACTION: CH01
PROGRAM: CICSL01
TASK: 0000079
STATUS: PROGRAM INITIATION
```

After CONTINUE, it showed:
```text
STATUS: ABOUT TO EXECUTE COMMAND
EXEC CICS SEND MAP
MAP('L01MAP')
MAPSET('L01MAPS')
TERMINAL
FREEKB
ERASE
```

Continuing executed the SEND MAP and displayed the BMS screen. This is the central evidence connecting transaction, program, task, EXEC CICS command, BMS map and terminal output.
