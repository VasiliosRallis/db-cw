-- Q1 returns (name,father,mother)
SELECT name, father, mother
FROM person
WHERE EXISTS (SELECT *
              FROM person AS person_father, person AS person_mother
              WHERE person.father = person_father.name
              AND person.mother = person_mother.name
              AND person.dod < person_mother.dod
              AND person.dod < person_father.dod)
ORDER BY name;

-- Q2 return (name)
SELECT name
FROM monarch
WHERE house IS NOT NULL
UNION
SELECT name
FROM prime_minister
ORDER BY name;

-- Q3 returns (name)
SELECT monarch.name 
FROM person JOIN monarch ON person.name = monarch.name
WHERE EXISTS (SELECT *
              FROM monarch AS monarch_successor
              WHERE monarch_successor.accession < person.dod
              AND monarch_successor.accession > monarch.accession)
AND monarch.house IS NOT NULL
ORDER BY monarch.name;

-- Q4 returns (house,name,accession)
SELECT house, name, accession
FROM monarch
WHERE  accession <= ALL(SELECT monarch_successor.accession
                    FROM monarch AS monarch_successor
                    WHERE (monarch.house = monarch_successor.house) IS TRUE)
AND monarch.house IS NOT NULL
ORDER BY accession;

-- Q5 returns (first_name,popularity)
SELECT first_names.first_name,
       COUNT(first_names.name) AS popularity
FROM (SELECT SUBSTRING(name FROM 1 FOR (CASE WHEN POSITION(' ' IN name) = 0
                                  THEN LENGTH(name)
                                  ELSE POSITION(' ' IN name) - 1 END)) AS first_name,
			          name
                                  FROM person) AS first_names
GROUP BY first_names.first_name
HAVING COUNT(first_names.name) > 1
ORDER BY popularity DESC, first_names.first_name;

-- Q6 returns (house,seventeenth,eighteenth,nineteenth,twentieth)
SELECT house,
       COUNT(CASE WHEN accession BETWEEN DATE('1600-01-01') AND DATE('1699-12-31') THEN accession END) AS seventeenth,
       COUNT(CASE WHEN accession BETWEEN DATE('1700-01-01') AND DATE('1799-12-31') THEN accession END) AS eighteenth,
       COUNT(CASE WHEN accession BETWEEN DATE('1800-01-01') AND DATE('1899-12-31') THEN accession END) AS nineteenth,
       COUNT(CASE WHEN accession BETWEEN DATE('1900-01-01') AND DATE('1999-12-31') THEN accession END) AS twentieth
FROM monarch
WHERE house IS NOT NULL
GROUP BY house
ORDER BY house;

-- Q7 returns (father,child,born)
SELECT person.name AS father, fathers.child, fathers.born
FROM person LEFT JOIN (SELECT father, name as child,
                       RANK() OVER
                            (PARTITION BY father ORDER BY dob ASC) AS born 
                       FROM person
                       WHERE father IS NOT NULL) AS fathers ON person.name = fathers.father
WHERE person.gender = 'M'
ORDER BY person.name, fathers.born;

-- Q8 returns (monarch,prime_minister)
SELECT DISTINCT myMonarch.name AS monarch,
                CASE WHEN (myPrimeMinister.entry BETWEEN DATE(myMonarch.accession) AND DATE(myMonarch.deccession))
                       OR (myMonarch.accession BETWEEN DATE(myPrimeMinister.entry) AND DATE(myPrimeMinister.exit))
                     THEN myPrimeMinister.name END AS prime_minister
FROM (SELECT name, entry,
      LEAD(entry, 1, '9999-01-01') OVER(ORDER BY entry) AS exit
      FROM prime_minister) AS myPrimeMinister,
     (SELECT name, accession,
      LEAD(accession, 1, '9999-01-01') OVER(ORDER BY accession) AS deccession
      FROM monarch
      WHERE monarch.house IS NOT NULL) AS myMonarch
WHERE CASE WHEN (myPrimeMinister.entry BETWEEN myMonarch.accession AND myMonarch.deccession)
             OR (myMonarch.accession  BETWEEN myPrimeMinister.entry AND myPrimeMinister.exit)
            THEN myPrimeMinister.name END IS NOT NULL
ORDER BY monarch, prime_minister;
