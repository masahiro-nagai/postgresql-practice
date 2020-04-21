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