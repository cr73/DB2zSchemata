--
--An implementation of the SQL Information Schema. DB2 12 for z/OS
--
-- Copyright (c) 2017 Sibaya Technical Support Ltd.
-- 
--5.80 VIEWS view 6.70 base table
--
--Drop
--  view INFORMATION_SCHEMA.VIEWS_S
--;
--Drop
--  view INFORMATION_SCHEMA.VIEWS
--;
  Create view INFORMATION_SCHEMA.VIEWS as
    Select
      current server as TABLE_CATALOG,
      V.CREATOR as TABLE_SCHEMA,
      V.NAME as TABLE_NAME,
      V.STATEMENT as VIEW_DEFINITION,
      case V.CHECK
        when 'C'
        then 'CASCADED'
        when 'Y'
        then 'LOCAL'
        else 'NONE'
      end as CHECK_OPTION,
      case (
          Select count(*)
            from SYSIBM.SYSCOLUMNS C
            where C.TBCREATOR = V.CREATOR
              and C.TBNAME = V.NAME
              and C.UPDATES = 'Y'
          )
        when 0
        then 'NO'
        else 'YES'
      end as IS_UPDATABLE,
      case (
          Select count(*)
            from SYSIBM.SYSCOLUMNS C
            where C.TBCREATOR = V.CREATOR
              and C.TBNAME = V.NAME
              and C.UPDATES = 'Y'
          )
        when 0
        then 'NO'
        else 'YES'
      end as IS_INSERTABLE_INTO,
      case (
          Select count(*)
            from SYSIBM.SYSTRIGGERS T
            where T.TBOWNER = V.CREATOR
              and T.TBNAME = V.NAME
              and T.TRIGTIME = 'I'
              and T.TRIGEVENT = 'U'
          )
        when 0
        then 'NO'
        else 'YES'
      end as IS_TRIGGER_UPDATABLE,
      case (
          Select count(*)
            from SYSIBM.SYSTRIGGERS T
            where T.TBOWNER = V.CREATOR
              and T.TBNAME = V.NAME
              and T.TRIGTIME = 'I'
              and T.TRIGEVENT = 'D'
          )
        when 0
        then 'NO'
        else 'YES'
      end as IS_TRIGGER_DELETABLE,
      case (
          Select count(*)
            from SYSIBM.SYSTRIGGERS T
            where T.TBOWNER = V.CREATOR
              and T.TBNAME = V.NAME
              and T.TRIGTIME = 'I'
              and T.TRIGEVENT = 'I'
          )
        when 0
        then 'NO'
        else 'YES'
      end as IS_TRIGGER_INSERTABLE_INTO
      from SYSIBM.SYSVIEWS V
      where V.TYPE = 'V'
  ;
--5.81 short name view
  Create view INFORMATION_SCHEMA.VIEWS_S as
    Select 
      TABLE_CATALOG as TABLE_CATALOG,
      TABLE_SCHEMA as TABLE_SCHEMA,
      TABLE_NAME as TABLE_NAME,
      VIEW_DEFINITION as VIEW_DEFINITION,
      CHECK_OPTION as CHECK_OPTION,
      IS_UPDATABLE as IS_UPDATABLE,
      IS_INSERTABLE_INTO as IS_INSERTABLE_INTO,
      IS_TRIGGER_UPDATABLE as IS_TRIG_UPDATABLE,
      IS_TRIGGER_DELETABLE as IS_TRIG_DELETABLE,
      IS_TRIGGER_INSERTABLE_INTO as IS_TRIG_INS_INTO
      from INFORMATION_SCHEMA.VIEWS
  ;
--Grants
  Grant
    Select
      on INFORMATION_SCHEMA.VIEWS
      to PUBLIC
  ;
  Grant
    Select 
      on INFORMATION_SCHEMA.VIEWS_S
      to PUBLIC
  ;
--Tests
  Select *
    from INFORMATION_SCHEMA.VIEWS
  ;
  Select *
    from INFORMATION_SCHEMA.VIEWS_S
  ;
  Commit;
--End