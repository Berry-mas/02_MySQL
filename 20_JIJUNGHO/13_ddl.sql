-- =============================
-- DDL
-- =============================
-- 데이터 정의 언어 Data Definition Language
-- 데이터베이스 객체(Object)를 만들고(CREATE), 수정하고(ALTER), 삭제(DROP)하는 구문
-- ROLLBACK, COMMIT등 TCL을 사용하지 않고, 자동커밋된다. DML(INSERT, UPDATE, DELETE)과 혼용시 주의해야 한다.

SHOW VARIABLES LIKE 'autocommit';
SET AUTOCOMMIT = off;

-- ===============================
-- CREATE
-- ===============================
-- 테이블 생성을 위한 구문
-- IF NOT EXISTS를 적용하면 기존에 존재하는 테이블이라도 에러가 발생하지 않는다.

-- 테이블의 컬럼 설정
-- column_name data_type(length) [NOT NULL] [DEFAULT value] [AUTO_INCREMENT] column_constraint;

-- https://dev.mysql.com/doc/refman/8.3/en/innodb-introduction.html
CREATE TABLE product1
(
    id        INT COMMENT '상품아이디',
    name      varchar(100) COMMENT '상품명',
    create_at datetime COMMENT '등록일'
) ENGINE = INNODB COMMENT '상품테이블';

-- 테이블별 스토리지 엔진 확인
SHOW TABLE STATUS LIKE 'product1';

-- 테이블구조확인
DESCRIBE product1;
DESC product1;

-- ===============================
-- COMMENT
-- ===============================
# 테이블 comment 설정
-- CREATE TABLE 테이블명 (
--     ...
-- ) COMMENT = 'table comment';

-- ALTER TABLE 테이블명 COMMENT = 'table comment';

# 컬럼 comment 설정
-- CREATE TABLE 테이블명 (
--  컬럼명 INT COMMENT 'column1 comment',
-- );

-- ALTER TABLE 테이블명
-- MODIFY [컬럼명] [데이터타입] [제약조건] COMMENT 'column1 comment';

# DEFAULT
-- 컬럼에 null 대신 기본값 적용
-- 컬럼 타입이 DATE일 시 current_date만 가능
-- 컬럼 타입이 DATETIME일 시 current_time과 current_timestamp, now() 모두 사용가능
-- IF NOT EXISTS : 같은 테이블이 있으면 추가하지 않고, 없으면 추가 (중복확인)

CREATE TABLE IF NOT EXISTS tbl_rent
(
    rent_id          INT AUTO_INCREMENT PRIMARY KEY,
    constractor_name varchar(255) DEFAULT '익명',
    car_name         varchar(255) DEFAULT '람보르기니',
    rent_date        datetime     DEFAULT (CURRENT_DATE),
    rent_time        time         DEFAULT (CURRENT_TIME),
    created_at       datetime     DEFAULT (CURRENT_TIMESTAMP)
) ENGINE = INNODB;

INSERT INTO
    tbl_rent
VALUES
    (NULL, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);

SELECT *
  FROM
      tbl_rent;

INSERT INTO
    tbl_rent(constractor_name)
VALUES
    ('지정호');

# AUTO_INCREMENT
-- INSERT시 PK(PRIMARY KEY) 컬럼에 자동으로 번호를 발생 (중복되지않게) 시켜 저장할 수 있다.
-- PK컬럼이 아닌 컬럼은 사용할 수 없다.

CREATE TABLE IF NOT EXISTS product2
(
    id         int PRIMARY KEY AUTO_INCREMENT COMMENT '상품아이디',
    name       varchar(255) COMMENT '상품명',
    created_at datetime DEFAULT NOW() COMMENT '등록일'
) ENGINE = INNODB COMMENT '상품테이블';

-- ===============================
-- ALTER
-- ===============================
-- 테이블에 추가/변경/수정/삭제하는 모든 것은 ALTER 명령어를 사용해서 적용한다.

# 변경항목
-- ADD    : 컬럼 추가, 제약조건추가
-- MODIFY : 컬럼 자료형 변경, 컬럼 DEFAULT값 변경
-- RENAME : 컬럼명 변경, 제약조건 이름변경
-- DROP   : 컬럼 삭제, 제약조건 삭제

DESC product2;

-- ADD [컬럼명] [자료형] [제약조건] [ALTER] [기존컬럼]
ALTER TABLE product2
    ADD price INT NOT NULL AFTER name;

-- DROP 컬럼명 삭제
ALTER TABLE product2
    DROP COLUMN price;

-- 컬럼명 변경
-- CHANGE [COLUMN] [이전컬럼명] [새컬럼명] [자료형] [제약조건]
ALTER TABLE product2
    CHANGE COLUMN name prod_name char(100) NOT NULL;

-- 컬럼 순서 변경
-- MODIFY [컬럼명] [자료형] ALTER [기존컬럼] (자료형은 필수)
ALTER TABLE product2
    MODIFY COLUMN prod_name char(100) AFTER created_at;

-- 컬럼 디폴트값 변경
-- ALTER TABLE [테이블명] ALTER COLUMN 컬럼명 SET DEFAULT 디폴트값;
ALTER TABLE product2
    ALTER COLUMN prod_name SET DEFAULT '무명';

-- 컬럼 자료형 변경
-- ALTER TABLE [테이블명] MODIFY [컬럼명] [자료형]
-- 해당 쿼리 실행 시 default값 초기화되는 이유
ALTER TABLE product2
    MODIFY prod_name varchar(100);

DESC product2;

-- 열 제약 조건 추가 및 삭제
ALTER TABLE product2
    ADD PRIMARY KEY (id);

ALTER TABLE product2
    DROP PRIMARY KEY;

-- ===============================
-- DROP
-- ===============================
-- 테이블을 삭제하기 위한 구문

-- 테이블 삭제
DROP TABLE product2;

-- product1이 존재하면 삭제, 존재하지 않으면 삭제 안됨
DROP TABLE IF EXISTS product1;

-- 힌반에 2개의 테이블 삭제
DROP TABLE IF EXISTS encore_bank,kb_bank;