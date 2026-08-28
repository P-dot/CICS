# Definition versus runtime

The most useful observation in this lab was the difference between a resource being defined and being installed.

Initial inquiry:

```text
CEMT I TRANS(CH01)
NOT FOUND
```

The next check used:

```text
CEDA VIEW TRANSACTION(CH01) GROUP(LAB01)
```

The definition existed and referenced `CICSL01`.

Then:

```text
CEDA INSTALL GROUP(LAB01)
```

returned `INSTALL SUCCESSFUL`.

A subsequent:

```text
CEMT I TRANS(CH01)
```

returned normally.

Therefore the initial `NOT FOUND` represented runtime installation state, not loss of the stored definition.
