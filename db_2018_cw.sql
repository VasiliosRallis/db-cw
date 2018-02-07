-- Q1 returns (name,father,mother)
/*SELECT person_child.name, person_child.father, person_child.mother
FROM person AS person_child
JOIN person AS person_father
ON person_child.father = person_father.name
JOIN person AS person_mother
ON person_mother.name = person_child.mother 
WHERE person_child.dod < person_father.dod AND person_child.dod < person_mother.dod
ORDER BY name;*/

/*
SELECT name
FROM person
WHERE EXISTS (SELECT *
              FROM person AS person_father, person AS person_mother
              WHERE person.father = person_father.name
              AND person.mother = person_mother.name
              AND person.dod < person_mother.dod
              AND person.dod < person_father.dod)
ORDER BY name;
*/
                                      
-- Q2 return (name)
/*SELECT name
FROM monarch
WHERE house IS NOT NULL
UNION
SELECT name
FROM prime_minister;
*/
-- Q3 returns (name)
/*SELECT monarch.name 
FROM person JOIN monarch ON person.name = monarch.name
WHERE EXISTS (SELECT *
              FROM monarch AS monarch_successor
              WHERE monarch_successor.accession < person.dod
              AND monarch_successor.accession > monarch.accession)
AND monarch.house IS NOT NULL;
*/

-- Q4 returns (house,name,accession)
/*SELECT house, name, accession
FROM monarch
WHERE  accession < ALL(SELECT monarch_successor.accession
                    FROM monarch AS monarch_successor
                    WHERE (monarch.house <> monarch_successor.house) IS NOT TRUE
                    AND monarch_successor.name <> monarch.name)
ORDER BY accession;
*/

-- Q5 returns (first_name,popularity)

;

-- Q6 returns (house,seventeenth,eighteenth,nineteenth,twentieth)

; 

-- Q7 returns (father,child,born)

;

-- Q8 returns (monarch,prime_minister)

;
