-- loop over schemata, except public and empty

-- for each found, check name existance in schemata.db_schema_name

-- if not exists
--  extract some data from $name.parameters
--  insert appropriate lines in schemata and endpoints (same way as in the import script)

-- variation of this procedure: with a given parameter == schema name; then register this schema only
