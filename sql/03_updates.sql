-- sql/03_updates.sql
-- 1) id’ye göre: id çift olanların e‑postası even.example’a taşınsın
UPDATE employee
SET email = regexp_replace(email, '@.*$', '@even.example')
WHERE (id % 2) = 0
RETURNING id, name, email;


-- 2) name’e göre: A ile başlayanların doğum tarihine +1 gün
UPDATE employee
SET birthday = (birthday + INTERVAL '1 day')::date
WHERE name ILIKE 'A%'
RETURNING id, name, birthday;


-- 3) birthday’e göre: 1990’lar (1990–1999) doğumluların adına etiket ekle
UPDATE employee
SET name = name || ' (90s)'
WHERE birthday BETWEEN DATE '1990-01-01' AND DATE '1999-12-31'
RETURNING id, name, birthday;


-- 4) email’e göre: gmail → example.com’a normalize
UPDATE employee
SET email = regexp_replace(email, '@gmail\\.com$', '@example.com')
WHERE email ILIKE '%@gmail.com'
RETURNING id, name, email;


-- 5) email eksik/bozuk olanlar için ad+id’den e‑posta türet
UPDATE employee
SET email = lower(regexp_replace(name, '\\s+', '.', 'g')) || id || '@example.org'
WHERE email IS NULL OR email NOT LIKE '%@%'
RETURNING id, name, email;
