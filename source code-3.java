/*
1- Java+PostgreSQL 

Person(ID, name, gender, parentID)

ID | name   | Gender | parentID
1  | Ali    | Erkek  | Null
2  | Ayşe   | Kadın  | Null
3  | Zeynep | Kadın  | 1
4  | Mustafa| Erkek  | 1
5  | Cafer  | Erkek  | 4
6  | Mithat | Erkek  | 5
7  | Nermin | Erkek  | 1
8  | Elif   | Kadın  | 5
9  | Senem  | Kadın  | 6

Verilerin PostgreSQL’deki yukarıdaki gibi bir tabloda saklandığını farzederek Java ile JDBC kutuphanesi 
kullanarak aşağıdaki şekilde bir console programı yazınız. Sorgulamalar kişilerin ID değerleri ile 
yapılacaktır.

Menu
0: çıkış
1: soy ağacı sorgula
2: soyundan gelenleri sorgula
Seçenek? 1


ID? 5
ID:5 (Cafer) soy ağacı:
4(Mustafa)
1(Ali)


Secenek? 2
ID? 5
5(Cafer)’in soyundan gelenler:
6 mithat
8 elif
9 senem


2- Java+MongoDB (5 puan)
Yukaridaki tabloyu bir collection olarak mongoDB’de manuel olarak oluşturunuz. Sonra yukarıdaki 
gibi “kişinin soy ağacı” ve “kişinin soyundan gelenleri” ID ile sorgulayan Java programını yazınız.
*/





----------------------------------------------------

PERSON CLASS TANIMLAMASI:

----------------------------------------------------

public class Person {
public int id;
public String name;
public String gender;
public int parentId;
public Person(int id, String name, String gender, int parentId){
this.id = id;
this.name = name;
this.gender = gender;
this.parentId = parentId;
}
public Person() {

}
}

----------------------------------------------------

JAVA + POSTEGRESQL KAYNAK KODLARI:

----------------------------------------------------

import java.sql.*;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.Scanner;
import Person;

public class PostgreSQLJDBC {

public static void main(String args[]) {

Scanner scanner = new Scanner(System.in);
Connection c = null;
Statement stmt = null;
try {
Class.forName("org.postgresql.Driver");
c = DriverManager
.getConnection("jdbc:postgresql://localhost:5432/vtys_odev5",
"postgres", "123");
c.setAutoCommit(false);
System.out.println("Opened database successfully");
int secenek = -1;
int inputId;

while(secenek != 0) {
System.out.println("PostgreSQL Menu");
System.out.println("0: Çıkış");
System.out.println("1: Soy Ağacı Sorgula");
System.out.println("2: Soyundan Gelenleri Sorgula");
secenek = scanner.nextInt();
switch(secenek) {
case 1 :
System.out.println("ID ? ");
inputId = scanner.nextInt();
System.out.println("Soy Ağacı");
soyAgaci(inputId, c);
break;
case 2 :
System.out.println("ID ? ");
inputId = scanner.nextInt();
System.out.println("Soyundan Gelenler");
soyundanGelenler(inputId, c);
break;
}
}
} catch (Exception e) {
e.printStackTrace();
System.err.println(e.getClass().getName()+": "+e.getMessage());
System.exit(0);
}
}

public static void soyAgaci(int id, Connection con) throws ClassNotFoundException{

String sql = "Select * From \"Person\" Where id in (Select \"parentId\" from 
erson\" Where id = ?)";
try{

PreparedStatement ps = con.prepareStatement(sql);
ps.setInt(1, id);
ResultSet rs = ps.executeQuery();
while(rs.next()){
Person person = new Person(rs.getInt("id"), rs.getString("name"),
getString("gender"), rs.getInt("parentId"));
System.out.println(person.id+" "+person.name+" "+person.gender+" 
erson.parentId);
soyAgaci(person.id,con);
 }
 }catch(SQLException e){
 System.out.println(e.getMessage());
 }
 }
 
 public static void soyundanGelenler(int id, Connection con) throws
ssNotFoundException{
 
 String sql = "Select * From \"Person\" Where \"parentId\" = ?";
 try{
 
 PreparedStatement ps = con.prepareStatement(sql);
 ps.setInt(1, id);
 ResultSet rs = ps.executeQuery();
 while(rs.next()){
 Person person = new Person(rs.getInt("id"), rs.getString("name"),
getString("gender"), rs.getInt("parentId"));
 System.out.println(person.id+" "+person.name+" "+person.gender+" 
erson.parentId);
 soyundanGelenler(person.id,con);
 }
 }catch(SQLException e){
 System.out.println(e.getMessage());
 }
 }
 }
 
 -------------------------------------------
 
 JAVA + MONGODB KAYNAK KODLARI:
 
 -------------------------------------------
 
 import com.mongodb.client.MongoDatabase;
 import com.mongodb.client.model.Filters;
 import com.mongodb.BasicDBObject;
 import com.mongodb.DBCursor;
 import com.mongodb.MongoClient;
 import com.mongodb.MongoCredential;
 import com.mongodb.client.FindIterable;
 import com.mongodb.client.MongoCollection;
 import com.mongodb.client.MongoCursor;
 import java.util.Scanner;
 import java.io.FilterOutputStream;
 import java.sql.Connection;
 import java.sql.PreparedStatement;
 import java.sql.ResultSet;
 import java.sql.SQLException;
 import java.util.function.Consumer;
 import java.util.logging.Level;
 import java.util.logging.Logger;
 import org.bson.Document;
 import org.bson.conversions.Bson;
 
 public class MongodbJDBC {
 
 public static void main(String[] args) throws ClassNotFoundException {
 
 Scanner scanner = new Scanner(System.in);
 Logger mongoLogger = Logger.getLogger( "org.mongodb.driver" );
 mongoLogger.setLevel(Level.SEVERE);
 // Creating a Mongo client 
 MongoClient mongo = new MongoClient( "localhost" , 27017 );
 // Creating Credentials 
 MongoCredential credential;
 credential = MongoCredential.createCredential("sampleUser", "vtys_odev5",
 "password".toCharArray());
 System.out.println("Connected to the database successfully");
 // Accessing the database 
 MongoDatabase database = mongo.getDatabase("vtys");
 MongoCollection<Document> collection = database.getCollection("Person");
 int secenek = -1;
 int inputId;
 while(secenek != 0) {
 System.out.println("MongoDB Menu");
 System.out.println("0: Çıkış");
 System.out.println("1: Soy Ağacı Sorgula");
 System.out.println("2: Soyundan Gelenleri Sorgula");
 secenek = scanner.nextInt();
 switch(secenek) {
 case 1 :
 System.out.println("ID ? ");
 inputId = scanner.nextInt();
 System.out.println("Soy Ağacı");
 soyAgaci(inputId, collection);
 break;
 case 2 :
 System.out.println("ID ? ");
 inputId = scanner.nextInt();
 System.out.println("Soyundan Gelenler");
 soyundanGelenler(inputId, collection);
 break;
 }
 }
 }
 
 public static void soyAgaci(int id, MongoCollection<Document> coll) throws
ssNotFoundException{
 try{
 Bson bsonFilter = Filters.eq("id", id);
 FindIterable<Document> findIt = coll.find(bsonFilter);
 for (Document document : findIt) {
 Person p = new
son(document.getInteger("id"),document.getString("name"),do
ent.getString("gender"),document.getInteger("parentId")
null ? 0 : document.getInteger("parentId") );
 System.out.println(p.name);
 if(document.getInteger("parentId") != null) {
 soyAgaci(p.parentId,coll);
 }
 }
 }catch(Exception e){
 System.out.println(e.getMessage());
 }
 }
 
 public static void soyundanGelenler(int id, MongoCollection<Document> coll)
ows ClassNotFoundException{
 try{
 
 Bson bsonFilter = Filters.in("parentId", id);
 FindIterable<Document> findIt = coll.find(bsonFilter);
 for (Document document : findIt) {
 Person p = new
son(document.getInteger("id"),document.getString("name"),docume
getString("gender"),document.getInteger("parentId"));
 System.out.println(p.name);
 soyundanGelenler(p.id,coll);
 }
 }catch(Exception e){
 System.out.println(e.getMessage());
 }
 }
 }