-- PostgreSQL veri tabanı kullanıldı.


--SORU 1. (10puan-IN/EXISTS/=SOME/ALL) ‘Ali KURT’ adlı doktorun çalıştığı hastanenin kaydını 
--(hospital tablosundaki tüm sütunları) döndüren sorguyu IN, EXISTS ve SOME/ALL ile 3 farklı şekilde veriniz.


SELECT *
FROM hastane
WHERE hid IN
(SELECT hid
FROM doktor
WHERE adi='Ali Kurt');


SELECT * 
FROM hastane k 
WHERE EXISTS 
(SELECT adi FROM doktor 
WHERE k.hid=doktor.hid 
AND doktor.adi = 'Ali Kurt' );


SELECT * 
FROM hastane k 
WHERE hid = 
SOME 
(SELECT hid 
FROM doktor 
WHERE adi= 'Ali Kurt');


-- SORU 2. (10puan-EXISTS) ‘Ali KURT’ adlı doktorun çalışMAdığı hastanelerin kayıtlarını (hospital 
-- tablosundaki tüm sütunları) döndüren sorguyu NOT IN, NOT EXISTS ve SOME/ALL ile 3 farklı şekilde veriniz.


SELECT *
FROM hastane h
WHERE h.hid NOT IN
(SELECT hid
FROM doktor
WHERE adi='Ali Kurt');


SELECT *
FROM hastane k
WHERE NOT EXISTS
(SELECT k.*
FROM doktor m
WHERE k.adi='Ali Kurt' AND k.hid = m.did);


SELECT *
FROM hastane k
WHERE k.hid !=ALL
(SELECT m.hid
FROM doktor m
WHERE m.adi='Ali Kurt');


-- SORU 3. (10puan-UNION/EXCEPT/INTERSECT)
-- a. Hem ‘Biontech’ (testType.name alanını kullanınız) hem de ‘Moderna’ (testType.name alanını 
-- kullanınız) testinden Negatif sonuç alan hastaların kayıtlarını INTERSECT ile listeleyiniz.
-- b. Bir Türk (testType.origin=’tr’) veya Alman (testType.origin=’gr’) aşısından Positif sonuç alan 
-- hastaların kayıtlarını UNION ile listeleyiniz. 
-- c. Hiç test yaptırmamış olan hastaların kayılarını EXCEPT/MINUS ile listeleyiniz.



SELECT h.*
FROM hasta h, test_turu k , test t
WHERE h.pid=t.pid AND k.tid=t.tid AND t.sonuc='Neg' AND k.adi='Biontech'
INTERSECT
SELECT h.*
FROM hasta h, test_turu k ,test t
WHERE h.pid=t.pid AND k.tid=t.tid AND t.sonuc='Neg' AND k.adi='Moderna';



SELECT h.* ,k.orijin AS uretimYeri
FROM hasta h, test_turu k , test t
WHERE h.pid=t.pid AND k.tid=t.tid AND t.sonuc='Pos' AND k.orijin='de'
UNION
SELECT h.* ,k.orijin AS uretimYeri
FROM hasta h, test_turu k ,test t
WHERE h.pid=t.pid AND k.tid=t.tid AND t.sonuc='Pos' AND k.orijin='tr';



SELECT *
FROM hasta
EXCEPT
(SELECT hasta.*
FROM hasta,test
WHERE test.pid=hasta.pid);



-- Soru 4. . (10puan-GROUP BY-HAVING) Testleri orijin (testType.orgin) ülkelerine göre gruplayarak; 
-- sadece doğruluk oranı (testType.accuracy > 80) yüzde 80’in üzerinde olan testler verileri/kayıtları 
-- kullanılarak ve ‘tr’ haricindeki ülkeler için olmak üzere; her ülke için kaç test yapıldığı (test 
-- tablosundan bulunur), testler için toplam kaç para ödendiği (testType.price), yapılan testlerin yüzde 
-- kaçının positif, yüzde kaçının negatif geldiğini listeleyiniz.




-- Soru 5. (10puan-UNIQUE) Aynı isimli testten (testType.name) iki ya da daha fazla yaptırmamış (yani 
-- isim bakımından farklı testleri yaptırmış) olan hastaların kayıtlarını UNIQUE ile listeleyiniz.


SELECT h.*
FROM hasta h, (SELECT pid,adi,COUNT(*)
FROM test_turu k,test t
WHERE t.tid=k.tid
GROUP BY adi,pid
HAVING COUNT(*)<2) istenen
WHERE istenen.pid=h.pid;


-- Soru 6. (10puan WITH/FROM altsorgu) Hasta başı ortalama test sayısından daha fazla test yaptıran 
-- hastaların hid’lerini listeleyiniz. Bunu yaparken ilk iki adımı yani “hasta başı test sayısını” bir WITH alt 
-- sorgusuyla, “bunların ortalamasını” başka bir WITH sorgusuyla yazınız.



WITH hasta_basi_test_sayisi(pid,toplam_test) AS 
(SELECT pid,COUNT(tid)
FROM test
GROUP BY pid),
ortalama_test_sayisi(ortalama) AS 
(SELECT AVG(hasta_basi_test_sayisi.toplam_test)
FROM hasta_basi_test_sayisi)
SELECT distinct hbts.pid,hbts.toplam_test,ots.ortalama
FROM hasta_basi_test_sayisi hbts, ortalama_test_sayisi ots ,test t
WHERE hbts.toplam_test > ots.ortalama;



-- Soru 7. (10puan SELECT alt sorgusu) Hastane kayılarını listeyiniz. Fakat kayıtları listelerken her 
-- hastanedeki doktor ve yatan hasta sayılarını SELECT’in içerisine birer adet alt sorgu ekleyerek 
-- hesaplattırınız. (SELECT *, (alt-sorgu1) doktor-sayısı, (alt-sorgu2) hasta-sayısı FROM hastane)


SELECT DISTINCT k.*, (SELECT COUNT(pid)
FROM hasta_kabul
WHERE hasta_kabul.hid=k.hid) AS hasta_sayisi,
(SELECT COUNT(pid)
FROM hasta_kabul
WHERE hasta_kabul.hid=k.hid) AS doktor_sayisi
FROM hastane k;



-- Soru 8. (10puan-HAVING altsorgusu) Uzmanlık alanı ‘dahiliye’ (specialty=’dahiliye’) olan en az bir 
-- (yani herhangi bir) doktora sahip hastaneler için hid ve o hastanede çalışan tüm doktorların sayısını 
-- listeleyiniz (HAVING içerisinde söz konusu hastanenin dahiliye uzmanı çalıştırıp7çalıştırmadığı 
-- kontrolünün yapılması gerekmektedir.)



SELECT COUNT(m.did) toplam_doktor_sayisi , k.hid hastane_id
FROM hastane k,doktor m
WHERE k.hid=m.hid
GROUP BY k.hid HAVING COUNT((SELECT doktor.did FROM doktor
WHERE doktor.uzmanlik_alani = 'Dahiliye' AND k.hid=doktor.hid))>0;



-- Soru 9. (10puan-VIEWS) statistics (date, noOfTests, noOfPositives, noOfDeaths, noOfEntubed) [ 
-- istatistik (tarih, gunlukTestSayisi, gunlukPositifSayisi, gunlukOlumSayisi, gunlukEntubeSayisi) ] 
-- şeklinde bir view oluşturunuz. Bu view’i oluşturmak için önce test tablosundaki test kayıtlarını 
-- date(tarih) alanına göre GROUP BY yaparak günlük positif ve negatif sayıları bulunabilir. Sonra 
-- admitted tablosundaki kayıtlar admissionDate alanına göre GROUP BY yapılarak gunlukOlumSayisi, 
-- gunlukEntubeSayisi bulunabilir. Son adımda önceki iki adımda elde edilen sonuçlar gruplamanın 
-- yapılda tarih alanı üzerinden join edilir. Bazı günlerde test, bazı günlerde de olum/entube 
-- olamayacağı düşünülerek bu join işleminin FULL OUTER JOIN olması gerekmektedir.




-- Soru 10. ‘Ali KURT’ adlı hastanın son testinden sonra test yaptıran hastaların kayıtlarını listeleyiniz. 
-- (Bir alt sorguda Ali KURT’un test tarihlerini döndürünüz. Hastaların test tarihini bu alt sorgudaki 
-- tarihlerle >SOME/ALL operatörünü kullanarak karşılaştırınız)



select h.*,t.tarih
from hasta h,test t
where h.pid=t.pid and t.tarih>all
(select t.tarih
from test t
where t.pid=(select pid
from hasta
where hasta.adi='Ali Kurt'))