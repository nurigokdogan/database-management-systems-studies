-- MySQL veri tabanı kullanıldı.
-- SORU 1. ‘Ali KURT’ (name) adlı öğrencinin sid’sini ve notlarını (grade) listeleyiniz?

SELECT 
student.sid, take.grade
 FROM 
student,take 
WHERE
 student.sid=take.sid and student.fname='Ali' and student.lname='Kurt';



-- SORU 2. ‘Ayşe KURT’ (name) adlı öğrencinin aldığı, fakat ‘Ali KURT’ adlı öğrencinin almadığı derslerin kayıtlarını (yani course tablosunun tüm sütunlarını) listeleyiniz. (EXCEPT kullanınız gerekiyor)?

 SELECT
course. *
 FROM 
take, student, course
    WHERE
     take.sid = student.sid and student.fname="Ayse" and student.lname = "Kurt" and take.cid = course.cid
   EXCEPT
   SELECT course. * from take, student ,course
   WHERE
 take.sid=student.sid and student.fname = "Ali"
    and student.lname = "Kurt" and take.cid = course.cid;



-- SORU 3. Öğrencilerin sid’lerini ve aldıkları derslerin sayısını, not ortalamasını, en yüksek ve en düşük notlarını listeleyiniz?

SELECT 
sid, count(cid), avg(grade), max(grade), min(grade)
FROM
take 
GROUP BY 
sid;



-- SORU 4. Bölümlerin did’leri, öğrenci sayılarını öğrenci sayılarına göre azalan sırada listeleyiniz (İlişkisel cebirle yazmayınız)?

SELECT
department. did, count(student.sid) as OgrSayisi
 FROM
 student, department 
WHERE
student.did=department.did 
GROUP BY
department.did 
ORDER BY
 OgrSayisi DESC;



-- SORU 5. 2’den fazla ders veren hocaların sid’leri, verdikleri ders sayısı ve derslerini alan öğrencilerin sayılarını listeleyiniz?

SELECT
distinct(IkidenBuyuk.tid), IkidenBuyuk.* ,count(sid) 
FROM
(SELECT 
tid,count(cid)
FROM
teach 
GROUP BY
 tid having count(cid)>2) IkidenBuyuk,take 
WHERE
take.cid= IkidenBuyuk.tid 
GROUP BY
sid;



-- SORU 6. ‘Bilgisayar Müh’ (department.name) adlı bölümdeki öğrencilerden ‘Elektrik Müh’ (department.name) adlı bölümdeki derslerden alanlarının (take tablosunu kullan) kayıtlarını (student tablosundaki tüm alanları listele) listeleyiniz?

SELECT*FROM
student
WHERE
did=1 				
in(SELECT
 take.sid
 FROM
 take, course 
WHERE
take.cid=course.cid and course.did=2);



-- SORU 7. Her dersteki öğrenci sayılarının ortalamalarını (take tablosundan her dersi kaç öğrencinin aldığı bulunacak, sonra da bu sayıların ortalamaları bulunacak) bulup, bu ortalamadan daha fazla öğrencisi olan derslerin kayıtlarını listeleyiniz. (önce ortalamadan daha fazla öğrencisi olan derslerin cid’leri bulunacak, sonra bu cid’lerden yola çıkarak course tablosundaki ders kayıtları bulunacak)?

SELECT
course.*, count(take.sid) OgrSayisi 
FROM
take, course 
WHERE
take.cid = course.cid 
GROUP BY
take.cid having count(take.sid) >
(SELECT 
avg(ORTALAMA)
FROM 
(SELECT
 count(sid) as ORTALAMA 
FROM
take
GROUP BY 
cid ) as tablo);



-- SORU 8. GROUP BY kullanmadan iki farklı ders alan öğrencilerin kayıtlarını listeleyiniz. (2 farklı ders alan dendiği için take tablosunun 2 defa kullanılması gerekiyor! Sınıfta örnek yapmıştık. Slidelarda da örnek var. NOT: önce bu öğrencilerin sid’leri bir (alt) sorgu ile bulunacak sonra bu sid’ler üzerinden student tablosundaki kayıtlara yani tüm sütunlara ulaşılacak)?

SELECT * FROM
student, (
SELECT
distinct(
SELECT
count(cid) 
FROM
take 
WHERE
take.sid = ogrenci.sid) DersSayisi, ogrenci.sid 
FROM
take,take ogrenci having DersSayisi > 2) ogrenci 
WHERE
ogrenci.sid = student.sid;



-- SORU 9. Hiç ders vermeyen (take tablosunda bu hocaya ait kayıt yok demektir) hocaları listeleyiniz?

 SELECT * FROM 
teacher
EXCEPT
SELECT
teacher.* 
FROM
teacher,teach 
WHERE	
 teacher.tid=teach.tid;



-- SORU 10. Ders veren hocaların kayıtlarını (teacher tablosundaki tüm sütunları) listeleyiniz. (Yani take tablosunda tid geçen tüm hocalar)?

SELECT
teacher.*
 FROM 
teacher, teach 
WHERE
teacher.tid=teach.tid 
GROUP BY
teacher.tid;


 