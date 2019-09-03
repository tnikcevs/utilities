-- Procedure that drops all tables with preserving database (good for new db imports)
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `dropAllTables`()
BEGIN

  DECLARE tableName NVARCHAR(255);

  DECLARE done INT DEFAULT FALSE;

  DECLARE tableCursor CURSOR FOR SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = (SELECT DATABASE());

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  SET FOREIGN_KEY_CHECKS = 0;

  OPEN tableCursor;

  read_loop: LOOP

    FETCH tableCursor INTO tableName;

    IF done THEN
      LEAVE read_loop;
    END IF;

    SET @s = CONCAT('DROP TABLE ', tableName);

    PREPARE dropStmt FROM @s;
    EXECUTE dropStmt;
    DEALLOCATE PREPARE dropStmt;

  END LOOP;

  CLOSE tableCursor;

  SET FOREIGN_KEY_CHECKS = 1;
END$$
DELIMITER ;
