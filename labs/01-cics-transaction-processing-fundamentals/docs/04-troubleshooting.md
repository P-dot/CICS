# Troubleshooting

## DSECT RC=008

### Symptom

HLASM emitted `ASMA431W` continuation warnings and `ASMA141E` operation-code errors.

### Cause

BMS is processed as macro assembler source. Continuation indicators had not been placed correctly in the fixed-format source.

### Resolution

The BMS source was aligned correctly, with continuation indicators in column 72. Rebuild result:

```text
MAPASM   RC=0000
LINKMAP  RC=0000
DSECT    RC=0000
```

## COBOL RC=0012

### Symptom

Enterprise COBOL reported that `L01MAPO` was not defined.

### Cause

The CICS translator generated references to the BMS symbolic output structure, but `CICSL01` did not initially include the generated symbolic map.

### Resolution

Added:

```cobol
       COPY L01MAPS.
```

`IBMUSER.CICS.COPY` was already assigned as `SYSLIB` in the compile step. Final result:

```text
TRN      RC=0000
COBOL    RC=0000
LKED     RC=0000
```

These failures are retained as engineering evidence because they demonstrate diagnosis of the CICS/BMS build chain rather than only the final successful state.
