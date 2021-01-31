BEGIN
  ORDS.enable_schema(
    p_enabled             => TRUE,
    p_schema              => 'OCIARCADE',
    p_url_mapping_type    => 'BASE_PATH',
    p_url_mapping_pattern => 'ociarcade',
    p_auto_rest_auth      => TRUE
  );
  COMMIT;
END;
/

BEGIN
  OAUTH.DELETE_CLIENT(p_name => 'ociarcade_api');
  COMMIT;
END;
/

BEGIN
  ORDS.CREATE_ROLE(p_role_name=>'ociarcade api');
  OAUTH.CREATE_CLIENT(
    p_name            => 'ociarcade_api',
    p_grant_type      => 'client_credentials',
    p_owner           => 'Name',
    p_description     => 'ociarcade oauth client user',
    p_support_email   => 'email@domain.com',
    p_privilege_names => '');
  OAUTH.GRANT_CLIENT_ROLE(
    p_client_name => 'ociarcade_api',
    p_role_name   => 'ociarcade api'
  );
  COMMIT;
END;
/

DECLARE
  l_priv_roles owa.vc_arr;
  l_priv_patterns owa.vc_arr;
BEGIN
  l_priv_roles(1) := 'oracle.dbtools.role.autorest.OCIARCADE';
  l_priv_roles(2) := 'ociarcade api';
  l_priv_roles(3) := 'oracle.dbtools.autorest.any.schema';
  l_priv_patterns(1) := '/metadata-catalog/*';

  ords.define_privilege(
    p_privilege_name     => 'oracle.dbtools.autorest.privilege.OCIARCADE',
    p_roles              => l_priv_roles,
    p_patterns           => l_priv_patterns,
    p_label              => 'oracle.dbtools.autorest.privilege.OCIARCADE',
    p_description        => 'oracle.dbtools.autorest.privilege.OCIARCADE'
  );
  COMMIT;
END;
/

SET COLSEP ,
SET HEADSEP OFF
SET PAGESIZE 0
SET TRIMSPOOL ON
SPOOL 'infra/db/client.csv'
SELECT client_id, client_secret FROM user_ords_clients;
SPOOL OFF;