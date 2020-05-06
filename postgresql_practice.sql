--SQL Server PostgreSQL
-- DML�F�f�[�^�o�^
BEGIN TRANSACTION;
INSERT INTO Shohin VALUES ('0001', 'Tシャツ', '衣服', 1000, 500,'2009-09-20');
INSERT INTO Shohin VALUES ('0002', '穴あけパンチ', '事務用品', 500, 320, '2009-09-11');
INSERT INTO Shohin VALUES ('0003', 'カッターシャツ', '衣服',4000,2800, NULL);
INSERT INTO Shohin VALUES ('0004', '包丁', 'キッチン用品', 3000, 2800, '2009-09-20');
INSERT INTO Shohin VALUES ('0005', '圧力鍋', 'キッチン用品', 6800, 5000, '2009-01-15');
INSERT INTO Shohin VALUES ('0006', 'フォーク', 'キッチン用品', 500, NULL, '2009-09-20');
INSERT INTO Shohin VALUES ('0007', 'おろしがね', 'キッチン用品', 880, 790, '2008-04-28');
INSERT INTO Shohin VALUES ('0008', 'ボールペン', '事務用品', 100, NULL, '2009-11-11');
COMMIT;

/*このSELECT文は、
結果から重複分を無くします*/
SELECT DISTINCT shohin_id,shohin_tanka FROM Shohin;

--DD:テーブル作成
CREATE TABLE Chars(chr CHAR(3) NOT NULL,PRIMARY KEY (chr));
--DML:データ登録
BEGIN TRANSACTION;
INSERT INTO Chars VALUES ('1');
INSERT INTO Chars VALUES ('2');
INSERT INTO Chars VALUES ('3');
INSERT INTO Chars VALUES ('10');
INSERT INTO Chars VALUES ('111');
INSERT INTO Chars VALUES ('222');

COMMIT;
--NULLは除外して足される。
SELECT SUM (hanbai_tanka),SUM(shiire_tanka) FROM Shohin;

/*半角スペースの入れ忘れしないように
SUM同様NULLは除外されるので販売単価の分母は８、仕入単価の分母は６*/
SELECT AVG (hanbai_tanka), AVG (shiire_tanka) FROM Shohin;

--日付にはSUMやAVG関数は使えない。文字型にはMAXやMIN関数は使えない。
SELECT MAX (torokubi), MIN (torokubi) FROM Shohin;

--重複値を除外する。DISTINCTは必ず括弧内に書かなければならない。
SELECT COUNT (DISTINCT shohin_bunrui) FROM Shohin;

--値の種類を数える時は引数にDISTINCTを付けなければならない。
SELECT DISTINCT COUNT (shohin_bunrui) FROM Shohin;

--足された数値を除外しようとしているから無理！
SELECT DISTINCT SUM (hanbai_tanka) FROM Shohin;

--重複している販売単価を除外してから足している！
SELECT SUM (DISTINCT hanbai_tanka) FROM Shohin;

--商品分類ごとの行数を数える
--     商品分類の行数を数えて出力  商品テーブルの   商品分類ごとに
SELECT shohin_bunrui, COUNT(*) FROM Shohin GROUP BY shohin_bunrui;

SELECT shohin_bunrui, shohin_mei, hanbai_tanka, shiire_tanka, torokubi, COUNT(*) FROM Shohin GROUP BY shohin_bunrui;

/*WHERE句と GROUP BY句を併用する時の処理順序
FROM => WHERE => GROUP BY => SELECT の順番で処理される
記述の順番ではない！*/

--DISTINCTとGROUP BY はどちらも「その後に続く列について重複を排除する」
SELECT DISTINCT shohin_bunrui FROM Shohin;
SELECT shohin_bunrui FROM Shohin GROUP BY shohin_bunrui;
--「DISTINCTは重複を除外」、「GROUP BYは集約している」要件は違うので適した方を使う

SELECT shohin_bunrui,COUNT(*) FROM Shohin GROUP BY shohin_bunrui;
--ここから２行の列(衣類、事務用品)だけを選択する HAVING句が必要

SELECT shohin_bunrui,COUNT(*) FROM Shohin GROUP BY shohin_bunrui HAVING COUNT(*) = 2;

SELECT shohin_bunrui,AVG(hanbai_tanka) FROM Shohin GROUP BY shohin_bunrui;
--販売単価の平均2500円以上のみを表示
SELECT shohin_bunrui,AVG(hanbai_tanka) FROM Shohin GROUP BY shohin_bunrui HAVING AVG(hanbai_tanka) >= 2500;
--WHERE句で条件設定してもERRORになってしまう。
SELECT shohin_bunrui,AVG(hanbai_tanka) FROM Shohin WHERE AVG(hanbai_tanka) >= 2500 GROUP BY shohin_bunrui;

--集約化(GROUPBY)された時点で商品名という列は無くなっているからエラーになる。
SELECT shohin_bunrui,COUNT(*) FROM Shohin GROUP BY shohin_bunrui HAVING shohin_mei='ボールペン';
--上のコードがしたかったことはこういうことかなー
SELECT shohin_mei FROM Shohin WHERE shohin_mei = 'ボールペン';

--これではランダムに出力されてしまう。
SELECT shohin_id,shohin_mei,hanbai_tanka,shiire_tanka FROM Shohin;

--文末にORDERBY句を付けて順序を指定する                                    ↓ソートキー
SELECT shohin_id,shohin_mei,hanbai_tanka,shiire_tanka FROM Shohin ORDER BY hanbai_tanka;
SELECT shohin_id,shohin_mei,hanbai_tanka,shiire_tanka FROM Shohin ORDER BY shohin_id;
SELECT shohin_id,shohin_mei,hanbai_tanka,shiire_tanka FROM Shohin ORDER BY shohin_id DESC;
--並び順は指定しなければ昇順に並ぶ DESCで降順に並び替えられる
--ソートキーは複数選択も可能
SELECT shohin_id,shohin_mei,hanbai_tanka,shiire_tanka FROM Shohin ORDER BY hanbai_tanka,shohin_id;

--NULLは先頭か末尾にまとめて表示される
SELECT shohin_id,shohin_mei,hanbai_tanka,shiire_tanka FROM Shohin ORDER BY shiire_tanka;

--ソートキー(ORDERBYで指定したキー)は表示用の別名も使える
SELECT shohin_id,shohin_mei,hanbai_tanka,shiire_tanka AS "仕入れ値" FROM Shohin ORDER BY "仕入れ値";
/*重要！SQLの処理の順番！
①FROM=>②WHERE=>③GROUPBY=>④HAVING=>⑤SELECT=>⑥ORDERBY

 書き方の順番
①SELECT=>②FROM>③WHERE=>④GROUPBY=>⑤HAVING=>⑥ORDERBY
*/
--ORDEBYには集約関数も使える。SELECT句に含まれない物も使える。
SELECT shohin_bunrui,COUNT(*) FROM Shohin GROUP BY shohin_bunrui ORDER BY COUNT(*) DESC;
SELECT shohin_bunrui,COUNT(*) FROM Shohin GROUP BY shohin_id ORDER BY shohin_id;
SELECT shohin_mei,hanbai_tanka,shiire_tanka FROM Shohin ORDER BY shohin_id;

--ORDEBYは列番号を指定出来る。下の２つのコードは同じ意味だが、わかりにくので列番号は使わない
SELECT shohin_id,shohin_mei,hanbai_tanka,shiire_tanka FROM Shohin ORDER BY hanbai_tanka DESC, shohin_id;
SELECT shohin_id,shohin_mei,hanbai_tanka,shiire_tanka FROM Shohin ORDER BY 3 DESC, 1;

SELECT shohin_bunrui,SUM(hanbai_tanka),SUM(shiire_tanka) FROM Shohin GROUP BY shohin_bunrui HAVING SUM(hanbai_tanka) > SUM(shiire_tanka) * 1.5;

--下２つは同じ意味のコード 全選択を*で表すか全て書くかの違い
SELECT shohin_id,shohin_mei,shohin_bunrui,hanbai_tanka,shiire_tanka,torokubi FROM Shohin ORDER BY torokubi DESC, hanbai_tanka;

SELECT * FROM Shohin ORDER BY torokubi DESC, hanbai_tanka;

SELECT ○○ FROM テーブル名 WHERE 条件 GROUP BY 集約キー HAVING 条件 ORDER BY ソートキー;

--INSERT文 登録方法学習のために新規テーブルShohinInsテーブルを作成
CREATE TABLE ShohinIns
(shohin_id CHAR(4) NOT NULL,
 shohin_mei VARCHAR(100) NOT NULL,
 shohin_bunrui VARCHAR(32) NOT NULL,
 hanbai_tanka INTEGER DEFAULT 0, --販売単価の初期値を０に設定 DEFAULT＜デフォルト値＞
 shiire_tanka INTEGER ,
 torokubi DATE ,
 PRIMARY KEY (shohin_id));

--INSERT INTO テーブル名 (列リスト) VALUES(値リスト); 列リストは省略可能
 INSERT INTO ShohinIns (shohin_id, shohin_mei, shohin_bunrui, hanbai_tanka, shiire_tanka,torokubi) VALUES ('0001', 'Tシャツ','衣服', 1000, 500, '2009-09-20');

 /*列リスト省略の書き方
INSERT INTO VALUES(値リスト); でOK！ 列リストの順番通りに値を書く*/
INSERT INTO ShohinIns (shohin_id, shohin_mei, shohin_bunrui, hanbai_tanka, shiire_tanka,torokubi) VALUES ('0005','圧力鍋','キッチン用品',6800,5000,'2009-01-15');
INSERT INTO ShohinIns VALUES ('0005','圧力鍋','キッチン用品',6800,5000,'2009-01-15');
--上記２つの文章は同じことを意味している。

/*hanbai_tanka列にはDEFAULT値が設定されている
DEFAULT値を挿入する場合の書き方は２種類,明示的にする,暗黙的にする*/
--明示的なデフォルト値,暗黙的なデフォルト値の順に書く
INSERT INTO ShohinIns (shohin_id, shohin_mei, shohin_bunrui, hanbai_tanka, shiire_tanka,torokubi) VALUES ('0007', 'おろしがね', 'キッチン用品', DEFAULT, 790, '2009-04-28');
INSERT INTO ShohinIns (shohin_id, shohin_mei, shohin_bunrui,  shiire_tanka,torokubi) VALUES ('0007', 'おろしがね', 'キッチン用品', 790, '2009-04-28');
--該当列にDEFAULTと明記するか、列リストと値リストの両方を削除して書くかの２通り
--列名を省略するとデフォルト値orNULLが使われる

--他のテーブルからデータをコピーする方法 Shohinテーブルのコピーテーブルを作って説明
CREATE TABLE ShohinCopy
(shohin_id CHAR(4) NOT NULL,
 shohin_mei VARCHAR(100) NOT NULL,
 shohin_bunrui VARCHAR(32) NOT NULL,
 hanbai_tanka INTEGER ,
 shiire_tanka INTEGER ,
 torokubi DATE ,
 PRIMARY KEY(shohin_id));

/*商品データをShohinテーブルからコピーする場合
INSERT INTO コピーを貼り付けるテーブル名 (列リスト) SELECT コピーするテーブル列リスト FROM コピーするテーブル名; */
INSERT INTO ShohinCopy(shohin_id, shohin_mei , shohin_bunrui, hanbai_tanka , shiire_tanka , torokubi) SELECT shohin_id, shohin_mei , shohin_bunrui, hanbai_tanka , shiire_tanka , torokubi FROM Shohin;

--SELECT文のバリエーション説明のためにShohinBunruiテーブルを作成
CREATE TABLE ShohinBunrui
(shohin_bunrui VARCHAR(32) NOT NULL,
 sum_hanbai_tanka INTEGER ,
 sum_shiire_tanka INTEGER ,
 PRIMARY KEY (shohin_bunrui));

 --Shohinテーブルから商品分類ごとに、販売単価の合計と仕入れ単価の合計をShohinBunruiテーブに挿入
INSERT INTO ShohinBunrui (shohin_bunrui,sum_hanbai_tanka,sum_shiire_tanka) SELECT shohin_bunrui, SUM(hanbai_tanka), SUM(shiire_tanka) FROM Shohin GROUP BY shohin_bunrui;
--GROUP BYしないと

--ShohinBunruiへの挿入行の確認
SELECT * FROM ShohinBunrui;
--INSERT文内のSELECT文では、どんなSQL構文も使用出来る。

--DELETEではWHERE句を用いて条件設定が可能。HAVINGは抽出する形を変えるだけなのでDELETEは出来ない
DELETE FROM Shohin WHERE hanbai_tanka >= 4000;

UPDATE Shohin SET torokubi = '2009-10-10';
--キッチン用品の販売単価を１０倍に更新する。
UPDATE Shohin SET hanbai_tanka = hanbai_tanka * 10 WHERE shohin_bunrui = 'キッチン用品';
--UPDATE文でもNULLを値として使える。NOT NULL制約がかかっている列には無理。
UPDATE Shohin SET torokubi = NULL WHERE shohin_id = '0008';

--UPDATE文のSET句には複数の列を更新の対象とすることが出来る。
UPDATE Shohin SET hanbai_tanka = hanbai_tanka * 10 WHERE shohin_bunrui = 'キッチン用品';
UPDATE Shohin SET shiire_tanka = shiire_tanka /2 WHERE shohin_bunrui = 'キッチン用品';
--上記２つの文を１つに求める方法を２つ カンマで区切る方法とカッコで囲む方法。何列でもOK
UPDATE Shohin SET hanbai_tanka = hanbai_tanka * 10, shiire_tanka = shiire_tanka / 2 WHERE shohin_bunrui = 'キッチン用品'

UPDATE Shohin SET (hanbai_tanka, shiire_tanka) = (hanbai_tanka * 10, shiire_tanka / 2) WHERE shohin_bunrui = 'キッチン用品';

--複数の操作をまとめた処理 トランザクション
--ワンセットで行うべき処理で活用する

UPDATE Shohin SET hanbai_tanka =hanbai_tanka - 1000 WHERE shohin_mei ='カッターシャツ';
UPDATE Shohin SET hanbai_tanka= hanbai_tanka + 1000 WHERE shohin_mei ='Tシャツ';
/*このようにカッターシャツの値引きをするけどその分をTシャツで補填しようという
指示があった場合に片方だけしか実行しなかったら問題になってしまう。そこでトランザクション！*/

--トランザクション開始文(DBMSによって違うMySQLはSTART TRANSACTION, Oracleは不要)
BEGIN TRANSACTION;
  --カッターシャツの販売単価を１０００円引き
  UPDATE Shohin SET hanbai_tanka=hanbai_tanka - 1000 WHERE shohin_mei = 'カッターシャツ';
  --Tシャツの販売単価を１０００円値上げ
  UPDATE Shohin SET hanbai_tanka=hanbai_tanka + 1000 WHERE shohin_mei = 'Tシャツ';
--トランザクション終了文 COMMIT(上書き保存)やROLLBACK(処理の取り消し)
COMMIT;

--商品差益テーブルを作成、商品テーブルからコピーして差益を登録
CREATE TABLE ShohinSaeki
(shohin_id CHAR(4) NOT NULL,
 shohin_mei VARCHAR(100) NOT NULL,
 hanbai_tanka INTEGER,
 shiire_tanka INTEGER,
 saeki INTEGER,
 PRIMARY KEY(shohin_id));

 INSERT INTO ShohinSaeki (shohin_id,shohin_mei,hanbai_tanka,shiire_tanka,saeki) SELECT shohin_id,shohin_mei,hanbai_tanka,shiire_tanka,hanbai_tanka - shiire_tanka FROM Shohin;

--おろしがねの販売単価を3000円に変更し、商品差益を出し直す
BEGIN TRANSACTION;
 UPDATE ShohinSaeki SET hanbai_tanka = 3000 WHERE shohin_mei = 'おろしがね';
 UPDATE ShohinSaeki SET saeki = hanbai_tanka - shiire_tanka WHERE shohin_mei = 'おろしがね';
COMMIT;

--相関サブクエリ
SELECT shohin_mei,shohin_bunrui,hanbai_tanka 
FROM Shohin AS S1 
WHERE hanbai_tanka > (SELECT AVG(hanbai_tanka) 
FROM Shohin AS S2 
--各商品の販売単価と平均単価を、同じ商品分類の中で行う (<テーブル名>.<列名>で書く必要がある)
WHERE S1.shohin_bunrui = S2.shohin_bunrui 
GROUP BY shohin_bunrui);
/*商品分類ごとの平均販売単価より高い販売単価の商品名、商品分類、販売単価を表示する。*/

--サブクエリの応用問題。列名の作成で使ってみる。
CREATE VIEW AvgTankaByBunrui AS SELECT shohin_id,shohin_mei,shohin_bunrui,hanbai_tanka,(SELECT AVG(hanbai_tanka) FROM Shohin AS S1 WHERE S1.shohin_bunrui = S2.shohin_bunrui GROUP BY shohin_bunrui)AS avg_hanbai_tanka FROM Shohin AS S2;