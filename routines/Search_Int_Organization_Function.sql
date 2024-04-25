-- You want to search for a parent organization by an ID:
CREATE OR REPLACE FUNCTION search_in_organization(input integer) RETURNS SETOF Parent_Organization
AS $$
-- give back everything
SELECT *
-- from this table
FROM parent_organization
-- where the parent_organization_id is like the input
WHERE parent_organization_id = input;
$$ LANGUAGE SQL;

-- STEP 2
-- search_in_organization(put your search ID here)
-- Select * can be replaced by any desired column of the respective table
SELECT * FROM search_in_organization(5) AS t1;

-- Sources
-- https://lms.hs-pforzheim.de/pluginfile.php/400413/mod_resource/content/0/4_4_relational_databases-procedures_triggers.pdf
-- https://www.postgresql.org/docs/current/functions-matching.html