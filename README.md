# База данных для мессенджера

## Типовые запросы:
`Вывод всех сообщений от пользователя Sunday`: 

```sql
SELECT * FROM `messages`
JOIN `users` ON `users`.`id` = `messages`.`from_user`
WHERE `users`.`username` = 'Sunday';

```

`Вывод всех чатов пользователя Sunday`:

```sql
SELECT `chats`.* FROM `chats`
JOIN `chats_users` ON `chats_users`.`chat` = `chats`.`id`
JOIN `users` ON `users`.`id` = `chats_users`.`user`
WHERE `users`.`username` = 'Sunday';
```

`Вывод всех сообщений, отправленных пользователем Sunday в "Тестовый чат`:

```sql
SELECT `messages`.* FROM `messages`
JOIN `users` ON `users`.`id` = `messages`.`from_user`
JOIN `chats` ON `chats`.`id` = `messages`.`chat`
WHERE (
	  `users`.`id` != `messages`.`from_user` 
    AND
    `chats`.`name` = 'Тестовый чат'
);
```

`Вывод списка всех вложений, отправленных пользователем Sunday`:

```sql
SELECT `media`.*, `users`.`username` FROM `media`
JOIN `attachments` ON `attachments`.`media` = `media`.`id`
JOIN `users_photos` ON `users_photos`.`media` = `media`.`id`
JOIN `users` ON (
	  `users`.`id` = `attachments`.`from_user`
    OR 
    `users`.`id` = `users_photos`.`user`
)
WHERE `users`.`username` = 'Sunday';
```

`Вывод списка всех участников чата с названием 'Первый чат'`:

```sql
SELECT `users`.* FROM `users`
JOIN `chats_users` ON `chats_users`.`user` = `users`.`id`
JOIN `chats` ON `chats`.`id` = `chats_users`.`chat`
WHERE `chats`.`name` = 'Первый чат';
```

## Роли и пользователи
```sql
-- Создание роли для бэкенда
CREATE ROLE IF NOT EXISTS `backend`;

-- Разрешение на просмотр, добавление и редактирования пользователей.
GRANT SELECT, INSERT, UPDATE ON `users` TO `backend`;

-- Разрешение на просмотр, добавление и удаление media-файлов.
GRANT SELECT, INSERT, DELETE ON `media` TO `backend`;

-- Разрешение на просмотр, добавление и удаление вложений для сообщений.
GRANT SELECT, INSERT, DELETE ON `messages_attachments` TO `backend`;
GRANT SELECT, INSERT, DELETE ON `attachments` TO `backend`;

-- Разрешение на просмотр, добавление и удаление сообщений.
GRANT SELECT, INSERT, DELETE ON `messages` TO `backend`;

-- Разрешение на просмотр, добавление, удаление и редактирование связей пользователей с чатами.
GRANT ALL PRIVILEGES ON `chat_users` TO `backend`;

-- Разрешение на просмотр, добавление, удаление и редактирование пользовательских фото.
GRANT ALL PRIVILEGES ON `users_photos` TO `backend`;

-- Разрешение на просмотр, добавление, удаление и редактирование чатов.
GRANT ALL PRIVILEGES ON `chats` TO `backend`;

-- Создание пользователя:
CREATE USER IF NOT EXISTS 'backend'@'localhost' IDENTIFIED BY 'textGERoergk';

-- Назначение роли пользователю:
GRANT `backend` TO 'backend'@'localhost';

-- Устанавливается роль moderator как роль по умолчанию для пользователя 'moder':
SET DEFAULT ROLE `backend` TO 'backend'@'localhost';

-- Сохранение изменений
FLUSH PRIVILEGES;
```

## Хранимые процедуры, транзакции, условия, локальные переменные, обработчики исключений:

`Транзацкия отправки сообщения в чат`:

```sql
DELIMITER $$
CREATE PROCEDURE sendMessage(
  IN fromUserId BIGINT,
  IN chatIdTo BIGINT,
  IN message VARCHAR(255),
  OUT messageId BIGINT
)
BEGIN
    -- Объявление переменных
	DECLARE chatExists BOOL;
    DECLARE userInChat BOOL;
    DECLARE userExists BOOL;
    
	-- Проверка пользователя на существование в БД
    SELECT COUNT(`users`.`id`) > 0 INTO userExists
    FROM users WHERE id = fromUserId;
    
	-- Проверка чата на существование в БД
    SELECT COUNT(`chats`.`id`) > 0 INTO chatExists
    FROM chats WHERE id = chatIdTo;
    
	-- Проверка пользователя на наличие в участниках чата
    SELECT COUNT(`users`.`id`) > 0 INTO userInChat
    FROM `users`
    JOIN `chat_users` ON `user`.`id` = `chat_users`.`id`
    WHERE (
		    `chat_users`.`chat` = chatIdTo 
        AND 
        `chat_users`.`user` = fromUserId
	  );
    
    -- Начало транзакции
    START TRANSACTION;
    
	-- Условие на существование пользователя
    -- Если пользователь не существует - отображает исключение
    IF NOT userExists THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка: пользователь не найден!';
        ROLLBACK;
	END IF;
    
	-- Условие на существование чата
    -- Если чат не существует - отображает исключение
    IF NOT chatExists THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка: данный чат не существует!';
        ROLLBACK;
    END IF;
    
	-- Условие на проверку пользователя в участниках чата
    -- Если пользователь не является участником чата - отображает исключение
    IF NOT userInChat THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка: пользователь не находится в данном чате!';
        ROLLBACK;
	END IF;
    
	-- Добавление данных в такблицу сообщений
    INSERT INTO messages (
		from_user,
        chat,
        message
    ) VALUES (
		fromUserId,
        chatIdTo,
        message
    );

    COMMIT;
    SELECT LAST_INSERT_ID();
END $$
DELIMITER ;
```

`Транзакция для удаления сообщения`:

```sql
DELIMITER $$
CREATE PROCEDURE deleteMessage(
  IN chatId BIGINT,
  IN messageId BIGINT,
  IN fromUserId BIGINT
)
BEGIN
    -- Объявление переменных
	DECLARE chatExists BOOL;
    DECLARE userInChat BOOL;
    DECLARE userExists BOOL;
    DECLARE messageExists BOOL;
    
    -- Проверка пользователя на существование в БД
    SELECT COUNT(`users`.`id`) > 0 INTO userExists
    FROM users WHERE id = fromUserId;
    
    -- Проверка чата на существование в БД
    SELECT COUNT(`chats`.`id`) > 0 INTO chatExists
    FROM chats WHERE id = chatIdTo;
    
    -- Проверка пользователя на наличие в участниках чата
    SELECT COUNT(`users`.`id`) > 0 INTO userInChat
    FROM `users`
    JOIN `chat_users` ON `user`.`id` = `chat_users`.`id`
    WHERE (
		`chat_users`.`chat` = chatIdTo 
        AND 
        `chat_users`.`user` = fromUserId
	);
    
    -- Проверка на наличие сообщения от указанного пользователя
    SELECT COUNT(`messages`.`id`) > 0 INTO messageExists
    FROM `messages`
    WHERE `from_user` = fromUserId AND `id` = messageId;
    
    -- Начало транзакции
    START TRANSACTION;
    
    -- Условие на существование пользователя
    -- Если пользователь не существует - отображает исключение
    IF NOT userExists THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка: пользователь не найден!';
        ROLLBACK;
	END IF;
    
    -- Условие на существование чата
    -- Если чат не существует - отображает исключение
    IF NOT chatExists THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка: данный чат не существует!';
        ROLLBACK;
    END IF;
    
    -- Условие на проверку пользователя в участниках чата
    -- Если пользователь не является участником чата - отображает исключение
    IF NOT userInChat THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка: пользователь не находится в данном чате!';
        ROLLBACK;
	END IF;
    
    -- Условие на существование сообщение от указанного пользователя
    -- Если сообщение не существует - отображает исключение.
    IF NOT messageExists THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка: сообщение от данного отправителя не найдено!';
        ROLLBACK;
    END IF;
    
    -- Удаление сообщения по ID
	DELETE FROM messages WHERE id = messageId;

	COMMIT;
END $$
DELIMITER ;
```

## Представления:
`Представление для вывода пользователей, отправивщих сообщение за последние 7 дней.`:

```sql
CREATE VIEW afkUsers AS
SELECT `users`.* FROM `users`
JOIN `messages` ON `messages`.`from_user` = `users`.`id`
WHERE `messages`.`date_created` <= DATE(NOW() - INTERVAL 7 DAY);
```

## Триггеры 

`Триггер для автоматического проставления времени отправки сообщения`:

```sql
CREATE TRIGGER `messages_creation_timestamp` 
BEFORE INSERT ON `messages` 
FOR EACH ROW
SET NEW.`date_created` = NOW();
```

`Триггер для автоматического проставления даты создания чата`:

```sql
CREATE TRIGGER `chats_creation_timestamp` 
BEFORE INSERT ON `chats` 
FOR EACH ROW
SET NEW.`date_created` = NOW();
```

`Триггер для автоматического фиксирования даты регистрации и даты последней смены пароля пользователя`:

```sql
CREATE TRIGGER `users_registration_timestamp` 
BEFORE INSERT ON `users` 
FOR EACH ROW
SET
	NEW.`date_joined` = NOW(), 
  NEW.`date_password_changed` = NOW()
;
```

## Пользовательские функции
`Функция для вывода кол-во сообщений в чате`:

```sql
DELIMITER //
CREATE FUNCTION getChatMessagesCount(chatId INT)
RETURNS int
READS SQL DATA
BEGIN
    RETURN (
        SELECT COUNT(*) FROM `messages`
        WHERE `messages`.`chat` = chatId
    );
END //
DELIMITER ;
```


# Инструкция по запуску (MySQL Workbench):
1. Открыть MySQL Workbench
2. Открыть окно редактора кода
3. Вставить содержмиое файла `dump.sql` в редактор кода
4. Нажать кнопку запуска скрипта (кнопка с иконкой желтой молнии)
