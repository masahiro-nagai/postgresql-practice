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
FROM => WHERE => GROUP BY => SELECT の順番で処理される*/

--DISTINCTとGROUP BY はどちらも「その後に続く列について重複を排除する」
SELECT DISTINCT shohin_bunrui FROM Shohin;
SELECT shohin_bunrui FROM Shohin GROUP BY shohin_bunrui;
--「DISTINCTは重複を除外」、「GROUP BYは集約している」要件は違うので適した方を使う

SELECT shohin_bunrui,COUNT(*) FROM Shohin GROUP BY shohin_bunrui;
--ここから２行の列(衣類、事務用品)だけを選択する HAVING句が必要

SELECT shohin_bunrui,COUNT(*) FROM Shohin GROUP BY shohin_bunrui HAVING COUNT(*) = 2;