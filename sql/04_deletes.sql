-- sql/04_deletes.sql
-- 1) id’ye göre: 10’un katı olan id’leri sil
DELETE FROM employee WHERE (id % 10) = 0 RETURNING id, name;


-- 2) name’e göre: Z ile başlayanları sil (örnek)
DELETE FROM employee WHERE name ILIKE 'Z%' RETURNING id, name;


-- 3) birthday’e göre: 2004 sonrası doğumluları sil (>= 2005)
DELETE FROM employee WHERE birthday >= DATE '2005-01-01' RETURNING id, name, birthday;


-- 4) email’e göre: domain’i bulunmayan (bozuk) adresleri sil
DELETE FROM employee WHERE email NOT LIKE '%@%' RETURNING id, name, email;


-- 5) örnek ek kural: example.org uzantılıları sil
DELETE FROM employee WHERE email ILIKE '%@example.org' RETURNING id, name, email;
