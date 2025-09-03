# employee-odev

Bu repo; test veritabanında **employee** tablosunu oluşturma, **Mockaroo** ile 50 kayıt ekleme, ardından **5 UPDATE** ve **5 DELETE** örneğini içerir.

```
.
├─ README.md
└─ sql/
   ├─ 01_create_table.sql
   ├─ 02_insert_from_mockaroo.sql   ← Mockaroo’dan aldığın INSERT’leri buraya koy (veya CSV ile içeri al)
   ├─ 03_updates.sql
   └─ 04_deletes.sql
```

---


### 1) Tabloyu oluştur

```sql
-- sql/01_create_table.sql
CREATE TABLE IF NOT EXISTS employee (
  id        INTEGER PRIMARY KEY,
  name      VARCHAR(50)  NOT NULL,
  birthday  DATE         NOT NULL,
  email     VARCHAR(100) NOT NULL UNIQUE
);
```

### 2) Veri ekle (Mockaroo ile 50 kayıt)

**) Mockaroo Şema**

* **id**: *Row Number*
* **name**: *Full Name*
* **birthday**: *Date*
* **email**: *Email Address*


```

### 3) UPDATE örnekleri (5 adet)

```sql
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
```

### 4) DELETE örnekleri (5 adet)

> Not: Silme işlemlerini **test** etmek için önce `BEGIN;` ile transaction başlatıp, sonucu beğenmezsen `ROLLBACK;` diyebilirsin. Onaylıyorsan `COMMIT;`.

```sql
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
```

