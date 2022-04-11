begin
    apex_util.set_workspace ('OCIARCADE');
    -- Enable ACL
    eba_cust_fw.set_preference_value (
        p_preference_name  => 'ACCESS_CONTROL_ENABLED',
        p_preference_value => 'Y' );
		    
    -- Set ACL Scope
    eba_cust_fw.set_preference_value (
        p_preference_name  => 'ACCESS_CONTROL_SCOPE',
        p_preference_value => 'PUBLIC_READONLY');

    -- Define Username Preference
    -- if instr(:APP_USER,'@') > 0 then
    eba_cust_fw.set_preference_value (
        p_preference_name  => 'USERNAME_FORMAT',
        p_preference_value => 'STRING');
    -- end if;
				    
    -- Add Users
    insert into eba_cust_users
        (username, access_level_id, account_locked)
	values ('OCIARCADE', 3, 'N');

    -- begin
    --     insert into eba_cust_users
    --     (username, access_level_id, account_locked)
    --     select
    --         c001 as username,
    --         n001 as access_level_id,
    --         'N'  as account_locked
    --     from
    --         apex_collections
    --     where
    --         collection_name = 'NEW_USERS'
    --     and
    --         lower(c001) not in (select distinct lower(username) from eba_cust_users);
    -- exception
    --   when others then
    --     null;
    -- end;

    -- Get rid of the collection
    -- apex_collection.delete_collection(p_collection_name => 'NEW_USERS');

    -- Load Sample Data
    -- if :P1000_LOAD_SAMPLE_YN = 'Y' then
    eba_cust_sample_data.create_sample_data();
    -- end if;

    -- Set Build Options
    for i in 1..apex_application.g_f01.count
    loop
        for c1 in ( select application_id, build_option_name, build_option_status
                    from apex_application_build_options
                    where apex_application.g_f01(i) = build_option_id
                       and application_Id = 100)
        loop
            if c1.build_option_status != apex_application.g_f03(i) then
                apex_util.set_build_option_status(  p_application_id => 100,
                                                    p_id => apex_application.g_f01(i),
                                                    p_build_status => upper(apex_application.g_f03(i)) );
            end if;
        end loop;
    end loop;

    -- Set First Run to No
    eba_cust_fw.set_preference_value (
        p_preference_name  => 'FIRST_RUN',
        p_preference_value => 'NO' );
end;
/
commit;
