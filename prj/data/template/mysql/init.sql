CREATE DATABASE IF NOT EXISTS test CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE IF NOT EXISTS wordpress CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE IF NOT EXISTS sonar CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE USER IF NOT EXISTS 'HPACK_ID'@'%' IDENTIFIED BY 'HPACK_PW';
CREATE USER IF NOT EXISTS 'HPACK_ID'@'localhost' IDENTIFIED BY 'HPACK_PW';

GRANT ALL ON test.* TO 'HPACK_ID'@'%' WITH GRANT OPTION;
GRANT ALL ON *.* TO 'HPACK_ID'@'localhost' WITH GRANT OPTION;

