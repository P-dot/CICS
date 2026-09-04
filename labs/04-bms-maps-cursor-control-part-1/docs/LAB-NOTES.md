# Lab notes

## Final resource mapping

- `H404` -> `CICSL04`
- `CICSL04` -> `SEND MAP('L04MAP') MAPSET('L04MAPS')`
- `L04MAPS` physical map -> `IBMUSER.CICS.LOAD`
- `L04MAPS` symbolic map -> `IBMUSER.CICS.COPY`
- dynamic cursor selector -> `MOVE -1 TO USERNML` + `CURSOR`

## Important corrections

### Transaction name
The initial `CH04` definition was not retained. The final lab transaction is `H404`.

### BMS fixed format
Removing `IC` disturbed continuation formatting and produced assembler RC=0008. Correct fixed-format continuation restored clean assembly.

### COBOL fixed format
`MOVE -1 TO USERNML.` initially began in Area A and produced `IGYPS0009-E`. Moving it to Area B produced RC=0000.

## Final evidence

The final runtime evidence shows:
- `CEMT SET PROG(CICSL04) NEWCOPY`
- `RESPONSE: NORMAL`
- successful execution of the Lab 04 screen
- cursor positioned at the `USER NAME` field

## Publication note
Do not publish screenshots containing host/network-sensitive information. Review IP addresses, MAC addresses, adapter identifiers and host-specific network data before GitHub publication.
