       IDENTIFICATION DIVISION.
       PROGRAM-ID. CICSL04.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       COPY L04MAPS.

       PROCEDURE DIVISION.
           MOVE -1 TO USERNML.

           EXEC CICS
                SEND MAP('L04MAP')
                     MAPSET('L04MAPS')
                     CURSOR
                     ERASE
                     FREEKB
           END-EXEC.

           EXEC CICS
                RETURN
           END-EXEC.

           GOBACK.
