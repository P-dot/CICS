       IDENTIFICATION DIVISION.
       PROGRAM-ID. CICSL01.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       COPY L01MAPS.

       PROCEDURE DIVISION.

           EXEC CICS
               SEND MAP('L01MAP')
                    MAPSET('L01MAPS')
                    ERASE
                    FREEKB
           END-EXEC.

           EXEC CICS
               RETURN
           END-EXEC.

           GOBACK.
