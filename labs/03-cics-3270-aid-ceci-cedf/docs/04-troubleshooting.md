# Troubleshooting

## TEST not recognized
After `TEST` was entered and ENTER pressed, CICS issued `DFHAC2001` because the existing application had already sent the map and returned; it did not contain the receive/process cycle needed to consume that input.

## THIS not recognized
After execution, EDF still showed ON. PF3 from the plain status context did not terminate EDF and `THIS` was interpreted as a transaction name. The failed attempt is intentionally retained.

## Final state
EDF was explicitly disabled with:
```text
CEDF ,OFF
```
The final evidence confirms:
```text
THIS TERMINAL: EDF MODE OFF
```
