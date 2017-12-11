--
--An implementation of the SQL Information Schema. DB2 12 for z/OS
--
-- Copyright (c) 2017 Sibaya Technical Support Ltd.
-- 
--5.63 TABLES view 6.53 base table
--
--Drop view
--  INFOTMATION_SCHEMA.TABLES_S
--;                                                                    
--Drop view
--  INFOTMATION_SCHEMA.TABLES
--;                                                                    
  Create view INFORMATION_SCHEMA.TABLES as
    Select
      current server as TABLE_CATALOG,
      T.CREATOR as TABLE_SCHEMA,
      T.NAME as TABLE_NAME,
      case T.TYPE
        when 'T'
        then 'BASE TABLE'
        when 'V'
        then 'VIEW'
        when 'G'
        then 'GLOBAL TEMPORARY'
--      when ?
--      then 'LOCAL TEMPORARY'
        when 'H'
        then 'SYSTEM VERSIONED'
      end as TABLE_TYPE,
      cast(null as varchar(256)) as SELF_REFERENCING_COLUMN_NAME,
      cast(null as varchar(256)) as REFERENCE_GENERATION,
      cast(null as varchar(256)) as USER_DEFINED_TYPE_CATALOG,
      cast(null as varchar(256)) as USER_DEFINED_TYPE_SCHEMA,
      cast(null as varchar(256)) as USER_DEFINED_TYPE_NAME,
      case T.TYPE
        when 'T'
        then 'YES'
        when 'G'
        then 'YES'
        when 'H'
        then 'YES'
        else 'NO'
      end as IS_INSERTABLE_INTO,
      'NO' as IS_TYPED,
      case T.TYPE
        when 'G'
        then 'DELETE'
        else cast(null as varchar(256))
      end as COMMIT_ACTION
      from SYSIBM.SYSTABLES T
      where T.TYPE in ('T', 'V', 'G', 'H')
  ;
--5.81 short name view
  Create view INFORMATION_SCHEMA.TABLES_S as
    Select
      TABLE_CATALOG as TABLE_CATALOG,
      TABLE_SCHEMA as TABLE_SCHEMA,
      TABLE_NAME as TABLE_NAME,
      TABLE_TYPE as TABLE_TYPE,
      SELF_REFERENCING_COLUMN_NAME as SELF_REF_COL_NAME,
      REFERENCE_GENERATION as REF_GENERATION,
      USER_DEFINED_TYPE_CATALOG as UDT_CATALOG,
      USER_DEFINED_TYPE_SCHEMA as UDT_SCHEMA,
      USER_DEFINED_TYPE_NAME as UDT_NAME,
      IS_INSERTABLE_INTO as IS_INSERTABLE_INTO,
      IS_TYPED as IS_TYPED,
      COMMIT_ACTION as COMMIT_ACTION
      from INFORMATION_SCHEMA.TABLES
  ;
--Grants
  Grant
    Select
      on INFORMATION_SCHEMA.TABLES
      to PUBLIC
  ;
  Grant 
    Select 
      on INFORMATION_SCHEMA.TABLES_S
      to PUBLIC
  ;
--Tests
  Select *
    from INFORMATION_SCHEMA.TABLES
  ;
  Select *
    from INFORMATION_SCHEMA.TABLES_S
  ;
  Commit;
--End