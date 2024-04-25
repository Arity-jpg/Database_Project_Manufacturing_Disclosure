-- You wanted to search for the supplier_mail but just couldn't remember the name?
-- But you remembered, the mail started with an 'a', there might was the 'n' following up...
-- This function will reduce the rows of searching for the desired mail

-- STEP 1
-- returns searched input like an autofill when using the search bar 
-- works best with one or two characters
CREATE OR REPLACE FUNCTION search_in_supplier(varchar) RETURNS SETOF supplier_group
AS $$
-- give back everything
SELECT *
-- from this table
FROM supplier_group
-- where the supplier_mail is like the input plus any continuing character (%)
WHERE supplier_mail LIKE $1||'%';
$$ LANGUAGE SQL;

-- STEP 2
-- search_in_supplier(put your search value here)
Select *, LOWER(supplier_mail) FROM search_in_supplier('an') AS t1;

-- Sources
-- https://lms.hs-pforzheim.de/pluginfile.php/400413/mod_resource/content/0/4_4_relational_databases-procedures_triggers.pdf
-- https://www.postgresql.org/docs/current/functions-matching.html
