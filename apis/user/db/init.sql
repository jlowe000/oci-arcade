
-- Generated by ORDS REST Data Services 21.2.1.r1810913
-- Schema: OCIARCADE  Date: Wed Jul 28 03:35:53 2021 
--

BEGIN
  ORDS.ENABLE_SCHEMA(
      p_enabled             => TRUE,
      p_schema              => 'OCIARCADE',
      p_url_mapping_type    => 'BASE_PATH',
      p_url_mapping_pattern => 'ociarcade',
      p_auto_rest_auth      => TRUE);
	    
  ORDS.DEFINE_MODULE(
      p_module_name    => 'CRM',
      p_base_path      => '/crm/',
      p_items_per_page => 25,
      p_status         => 'PUBLISHED',
      p_comments       => NULL);

  ORDS.DEFINE_TEMPLATE(
	      p_module_name    => 'CRM',
	      p_pattern        => 'activities/',
	      p_priority       => 0,
	      p_etag_type      => 'HASH',
	      p_etag_query     => NULL,
	      p_comments       => NULL);

  ORDS.DEFINE_HANDLER(
	      p_module_name    => 'CRM',
	      p_pattern        => 'activities/',
	      p_method         => 'GET',
	      p_source_type    => 'json/collection',
	      p_mimes_allowed  => '',
	      p_comments       => NULL,
	      p_source         => 
	'SELECT *
	FROM EBA_CUST_ACTIVITY_REF');

  ORDS.DEFINE_HANDLER(
	      p_module_name    => 'CRM',
	      p_pattern        => 'activities/',
	      p_method         => 'POST',
	      p_source_type    => 'plsql/block',
	      p_mimes_allowed  => '',
	      p_comments       => NULL,
	      p_source         => 
	'INSERT INTO EBA_CUST_ACTIVITY_REF (CUSTOMER_ID, CONTACT_ID, ACTIVITY_ID, ACTIVITY_DATE, NOTES)
	SELECT CUSTOMER.ID, CONTACT.ID, ACTIVITY.ID, SYSDATE, :notes
	FROM EBA_CUST_CUSTOMERS CUSTOMER, EBA_CUST_CONTACTS CONTACT, EBA_CUST_ACTIVITIES ACTIVITY
	WHERE CUSTOMER.CUSTOMER_NAME = ''OCI Arcade''
	  AND CONTACT.NAME = :name
	  AND ACTIVITY.NAME = ''Play Pacman''');

  ORDS.DEFINE_TEMPLATE(
      p_module_name    => 'CRM',
      p_pattern        => 'users/',
      p_priority       => 0,
      p_etag_type      => 'HASH',
      p_etag_query     => NULL,
      p_comments       => NULL);

  ORDS.DEFINE_HANDLER(
      p_module_name    => 'CRM',
      p_pattern        => 'users/',
      p_method         => 'GET',
      p_source_type    => 'json/collection',
      p_mimes_allowed  => '',
      p_comments       => NULL,
      p_source         => 
'SELECT ID, NAME, NOTES as ARCADE_NAME FROM EBA_CUST_CONTACTS');

  ORDS.DEFINE_HANDLER(
      p_module_name    => 'CRM',
      p_pattern        => 'users/',
      p_method         => 'POST',
      p_source_type    => 'plsql/block',
      p_mimes_allowed  => '',
      p_comments       => NULL,
      p_source         => 
'BEGIN
INSERT INTO EBA_CUST_CONTACTS (ID, CUSTOMER_ID, NAME, NOTES)
SELECT EBA_CUST_SEQ.nextval, ID, :name, :arcade_id
FROM EBA_CUST_CUSTOMERS
WHERE CUSTOMER_NAME = ''OCI Arcade'';
END;');

  ORDS.DEFINE_TEMPLATE(
      p_module_name    => 'CRM',
      p_pattern        => 'users/:name',
      p_priority       => 0,
      p_etag_type      => 'HASH',
      p_etag_query     => NULL,
      p_comments       => NULL);

  ORDS.DEFINE_HANDLER(
      p_module_name    => 'CRM',
      p_pattern        => 'users/:name',
      p_method         => 'PUT',
      p_source_type    => 'plsql/block',
      p_mimes_allowed  => '',
      p_comments       => NULL,
      p_source         => 
'BEGIN
  UPDATE EBA_CUST_CONTACTS
    SET NOTES = :arcade_id
  WHERE
    NAME = :name;
END;');

  ORDS.DEFINE_HANDLER(
      p_module_name    => 'CRM',
      p_pattern        => 'users/:name',
      p_method         => 'GET',
      p_source_type    => 'json/item',
      p_mimes_allowed  => '',
      p_comments       => NULL,
      p_source         => 
'SELECT ID, NAME, NOTES as ARCADE_NAME
FROM EBA_CUST_CONTACTS
WHERE NAME = :name');
    
COMMIT;
END;
/

DECLARE
  l_priv_roles owa.vc_arr;
  l_priv_patterns owa.vc_arr;
BEGIN
  l_priv_roles(1) := 'ociarcade api';
  l_priv_roles(2) := 'SQL Developer';
  l_priv_patterns(1) := '/crm/*';

  ords.define_privilege(
    p_privilege_name     => 'privilege.OCIARCADE.CRM',
    p_roles              => l_priv_roles,
    p_patterns           => l_priv_patterns,
    p_label              => 'privilege.OCIARCADE.CRM',
    p_description        => 'privilege.OCIARCADE.CRM'
  );
  COMMIT;
END;
/
