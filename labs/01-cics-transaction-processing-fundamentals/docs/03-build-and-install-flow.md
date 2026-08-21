# Build and Install Flow

## BMS

`L01MAP.jcl` performs:

1. `MAPASM` — assembles the BMS source with `SYSPARM(MAP)`.
2. `LINKMAP` — link-edits the physical map into `IBMUSER.CICS.LOAD(L01MAPS)`.
3. `DSECT` — generates the symbolic map into `IBMUSER.CICS.COPY(L01MAPS)`.

Final result: all three steps RC=0000.

## COBOL/CICS

`L01COB.jcl` performs:

1. `TRN` — translates `EXEC CICS` statements.
2. `COBOL` — compiles with Enterprise COBOL 4.2.
3. `LKED` — link-edits the program and includes `DFHELII`.

Final result: all three steps RC=0000.

## CEDA

Resources are defined in group `LAB01`:

- PROGRAM `CICSL01`
- MAPSET `L01MAPS`
- TRANSACTION `CH01`, associated with `CICSL01`

`CEDA INSTALL GROUP(LAB01)` makes the definitions active in the CICS region. `CH01` then executes the program and displays the map.
