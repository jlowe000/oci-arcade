DECLARE
  TYPE_ID NUMBER;
BEGIN
  INSERT INTO EBA_CUST_CUSTOMERS (CUSTOMER_NAME, CUSTOMER_NAME_UPPER, CATEGORY_ID, STATUS_ID)
  VALUES('OCI Arcade','OCI ARCADE',2,5);

  INSERT INTO EBA_CUST_ACTIVITY_TYPES (NAME)
  VALUES('Game');

  SELECT ID INTO TYPE_ID
  FROM EBA_CUST_ACTIVITY_TYPES
  WHERE NAME = 'Game';

  INSERT INTO EBA_CUST_ACTIVITIES (NAME,DESCRIPTION,TYPE_ID)
  VALUES('Play Pacman','Playing Pacman with OCI Arcade',TYPE_ID);
END;
/
commit;
