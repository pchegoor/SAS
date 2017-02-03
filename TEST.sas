option  debug=DBMS_SELECT sastrace=',,,d'
sastraceloc=saslog no$stsuffix fullstimer ;

Title;

Libname _ALL_ Clear;

/* Set global connection for all tables. */
libname VOLTBL teradata user="test" password="test123" server="T_DEV" connection=global;

/* Create a volatile tables */
proc sql;
   connect to teradata(user="test" password="test123" server="T_DEV"  connection=global);

 execute (CREATE VOLATILE TABLE TEMP (PAT_ID CHAR(1),
								       Amt INT) 
            ON COMMIT PRESERVE ROWS) by teradata;

     execute (COMMIT WORK) by teradata;


   Disconnect from Teradata;
quit;

/*  Insert data  into one of the above  table  */

Proc sql;
    connect to teradata(user="test" password="test123" server="T_DEV"  connection=global);

    execute (INSERT INTO TEMP VALUES('A',100)) by teradata;
    execute (INSERT INTO TEMP VALUES('B',200)) by teradata;
    execute (INSERT INTO TEMP VALUES('C',300)) by teradata;
    execute (INSERT INTO TEMP VALUES('D',400)) by teradata;
    execute (INSERT INTO TEMP VALUES('E',500)) by teradata;
    execute (INSERT INTO TEMP VALUES('',600)) by teradata;
	execute (INSERT INTO TEMP VALUES(NULL,NULL)) by teradata;
	execute (INSERT INTO TEMP VALUES('F',800)) by teradata;
	execute (INSERT INTO TEMP VALUES(NULL,NULL)) by teradata;
    execute (COMMIT WORK) by teradata;
   Disconnect from Teradata;

Quit;

Title1 '***** Result when generated Sql is passed to Teradata for Processing using distinct keyword *****'; 

Proc Sql;

Select  distinct  *   from    VOLTBL.TEMP  where   PAT_ID is NULL;
Quit;
