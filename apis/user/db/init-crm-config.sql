declare
    id number;
    l_cnt number := 0;
    P80_FLEX_TABLE varchar(32) := 'EBA_CUST_CONTACTS';
    P81_FLEX_COLUMN varchar(32) := 'CONTACT_FLEX_01';
    P84_ACTIVE_YN varchar(1) := 'Y';
    P81_REQUIRED_YN varchar(1) := 'N';
    P81_LABEL_TEMPLATE_ID varchar(32) := NULL;
    P81_FORM_LABEL_TEXT varchar(32) := 'OCI Arcade ID';
    P81_REPORT_LABEL_TEXT varchar(32) := 'OCI Arcade ID';
    P82_FORM_ELEMENT_TYPE varchar(32) := 'TEXT';
    P82_FORMAT_MASK varchar(32) := NULL;
    P82_LOV_TYPE varchar(32) := NULL;
    P82_LOV_QUERY clob := NULL;
    P82_LOV_DISPLAY_COL varchar(32) := NULL;
    P82_LOV_RETURN_COL varchar(32) := NULL;
    P82_WIDTH number := 30;
    P82_MAX_WIDTH number := 4000;
    P82_HEIGHT number := 1;
    P81_HELP_TEXT varchar(32) := NULL;
begin
    select application_id into id
    from apex_applications
    where application_name = 'Customer Tracker'
        and workspace = 'OCIARCADE';
    begin
        select tl.label_template_id into P81_LABEL_TEMPLATE_ID
        from apex_application_themes thm,
             apex_application_temp_label tl
        where thm.application_id = id
          and thm.ui_type_name = 'DESKTOP'
          and tl.application_id = thm.application_id
          and tl.theme_number = thm.theme_number
          and ((P81_REQUIRED_YN = 'Y'
                and tl.theme_class = 'Required Label'
                and tl.template_name not like '%Above')
            or (P81_REQUIRED_YN = 'N'
                and tl.theme_class = 'Optional Label'
                and tl.template_name not like '%Above'))
          and rownum = 1;
    exception
        when no_data_found then
            null;            
    end;

    -- Save the new flex column assignment
    update eba_cust_flex_registry
       set flexible_table = P80_FLEX_TABLE,
           flexible_column = P81_FLEX_COLUMN,
           active_yn = P84_ACTIVE_YN,
           is_required_yn = P81_REQUIRED_YN,
           label_template_id = case when instr(P81_LABEL_TEMPLATE_ID,',') > 0 then substr(P81_LABEL_TEMPLATE_ID, 1, instr(P81_LABEL_TEMPLATE_ID,',') - 1) else P81_LABEL_TEMPLATE_ID end,
           label_alignment = 'RIGHT-CENTER',
           form_label_text = P81_FORM_LABEL_TEXT,
           display_as = P82_FORM_ELEMENT_TYPE,
           format_mask = P82_FORMAT_MASK,
           lov_type = P82_LOV_TYPE,
           lov_sql_query = P82_LOV_QUERY,
           lov_display_col = P82_LOV_DISPLAY_COL,
           lov_return_col = P82_LOV_RETURN_COL,
           is_displayed_on_ir = 'Y',
           width = P82_WIDTH,
           max_width = P82_MAX_WIDTH,
           height = P82_HEIGHT,
           assigned_yn = 'Y',
           report_label_text = P81_REPORT_LABEL_TEXT,
           rpt_hdr_alignment = 'CENTER',
           help_text = P81_HELP_TEXT,
           default_value = null
     where flexible_table = P80_FLEX_TABLE
       and flexible_column = P81_FLEX_COLUMN
       and assigned_yn = 'N';

    -- Make sure the page map is up to date.
    eba_cust_flex_fw.populate_page_map_table();

    -- Set the new flex column to be displayed in IRRs
    for c1 in
    (
        select
            m.flex_table,
            m.page_id,
            m.region_static_id,
            m.flex_column_prefix,
            m.region_type
        from
            eba_cust_flex_page_map m,
            eba_cust_flex_registry r
        where
            m.flex_table = P80_FLEX_TABLE
        and
            m.flex_table = r.flexible_table
        and
            m.region_type in ('IR','CR')
    )
    loop
        eba_cust_flex_fw.flex_report_update (
            p_flex_table_name      => c1.flex_table,
            p_irr_region_static_id => c1.region_static_id,
            p_flex_column_prefix   => c1.flex_column_prefix,
            p_app_id               => id,
            p_page_id              => c1.page_id,
            p_region_type          => c1.region_type
        );
    end loop;

    -- delete the static LOV collection
    if apex_collection.collection_exists('STATIC_LOV_OPTS') then
        apex_collection.delete_collection(p_collection_name => 'STATIC_LOV_OPTS');
    end if;
	    
    -- Null the flex column data in the table containing the flex column to make sure there is no old data
    execute immediate( 'update ' || sys.dbms_assert.enquote_name(P80_FLEX_TABLE)
                      ||' set ' || sys.dbms_assert.enquote_name(P81_FLEX_COLUMN) || ' = null'
                      ||' where ' || sys.dbms_assert.enquote_name(P81_FLEX_COLUMN) || ' is not null'
                     );

end;
