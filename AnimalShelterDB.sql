# Часть 1. Создание структуры БД
# создание базы данных
DROP DATABASE IF EXISTS AnimalShelterDB;
CREATE DATABASE AnimalShelterDB;
USE AnimalShelterDB;

# создание таблиц и связей
# таблица видов животных
CREATE TABLE Species (
    id_species INT AUTO_INCREMENT PRIMARY KEY,
    species_name VARCHAR(50) NOT NULL UNIQUE
);

# таблица полов
CREATE TABLE Gender (
    id_gender INT AUTO_INCREMENT PRIMARY KEY,
    gender_name VARCHAR(20) NOT NULL UNIQUE
);

# таблица размеров
CREATE TABLE Size (
    id_size INT AUTO_INCREMENT PRIMARY KEY,
    size_name VARCHAR(20) NOT NULL UNIQUE
);

# таблица статусов
CREATE TABLE Statuses (
    id_status INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE
);

# таблица ролей сотрудников
CREATE TABLE Roles (
    id_role INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

# таблица пользователей
CREATE TABLE Users (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    id_role INT NOT NULL,
    FOREIGN KEY (id_role) REFERENCES Roles(id_role)
);

# таблица карточки питомцев
CREATE TABLE Animals (
    id_animal INT AUTO_INCREMENT PRIMARY KEY,
    animal_name VARCHAR(50) NOT NULL,
    id_species INT NOT NULL,
    breed VARCHAR(100) DEFAULT 'Метис',
    id_gender INT NOT NULL,
    age VARCHAR(50) NOT NULL,
    id_size INT NULL,
    color VARCHAR(100),
    distinctive_features TEXT,
    description TEXT,
    special_needs TEXT,
    arrival_date DATE NOT NULL,
    transfer_date DATE NULL, 
    id_status INT NOT NULL,
    id_main_photo INT NULL,
    
    # связи с родительскими таблицами
    FOREIGN KEY (id_species) REFERENCES Species(id_species),
    FOREIGN KEY (id_gender) REFERENCES Gender(id_gender),
    FOREIGN KEY (id_size) REFERENCES Size(id_size),
    FOREIGN KEY (id_status) REFERENCES Statuses(id_status)
);

# таблица фотографий питомцев
CREATE TABLE AnimalPhotos (
    id_photo INT AUTO_INCREMENT PRIMARY KEY,
    id_animal INT NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    is_main BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_animal) REFERENCES Animals(id_animal) ON DELETE CASCADE
);

# таблица договоров
CREATE TABLE Contract (
    id_contract INT AUTO_INCREMENT PRIMARY KEY,
    id_animal INT NOT NULL UNIQUE, 
    owner_name VARCHAR(150) NOT NULL,
    passport VARCHAR(20) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(255) NOT NULL,
    document_number INT NOT NULL,
    transfer_date DATE NOT NULL,
    FOREIGN KEY (id_animal) REFERENCES Animals(id_animal)
);

#  изменение структуры таблиц
ALTER TABLE Animals 
ADD FOREIGN KEY (id_main_photo) REFERENCES AnimalPhotos(id_photo) ON DELETE SET NULL; # дополнительно создаем связь для главного фото 

SHOW TABLES;

# вставка записей
# заполняем справочники
INSERT INTO Species (species_name) VALUES ('Собака'), ('Кошка');
INSERT INTO Gender (gender_name) VALUES ('Мальчик'), ('Девочка');
INSERT INTO Size (size_name) VALUES ('Маленький'), ('Средний'), ('Большой');
INSERT INTO Statuses (status_name) VALUES ('Ищет дом'), ('Пристроен');
INSERT INTO Roles (role_name) VALUES ('Волонтер'), ('Куратор'), ('Администратор');

# заполняем сотрудников
INSERT INTO Users (login, password, user_name, id_role) 
VALUES 
('aa', '123', 'Иванов И.А.', 1),
('ss', '456', 'Иванов П.В.', 2),
('dd', '789', 'Иванов А.Г.', 3);

# заполняем карточки животных
INSERT INTO Animals (animal_name, id_species, breed, id_gender, age, id_size, color, description, arrival_date, transfer_date, id_status) 
VALUES 
('Понка', 1, 'Метис', 2, '1 год', 3, 'Серый', 'Понка - из тех собак, которые готовы дарить ласку каждому...', '2025-11-24', NULL, 1),
('Спайк', 1, 'Метис', 1, '5 лет', 3, 'Серый', 'Спайк - пёс, полный энергии...', '2026-02-11', NULL, 1),
('Амира', 2, 'Метис', 2, '8 лет', NULL, 'Коричневый', 'Спокойный характер', '2026-09-24', NULL, 1),
('Бланка', 1, 'Метис', 2, '1 год', 2, 'Бежевый', 'Бланка - это сочетание скромности...', '2025-10-03', '2026-07-01', 2),
('Нильс', 1, 'Метис', 1, '3 года', 2, 'Серый', 'Небольшой бывшедомашний песик...', '2026-04-02', '2026-10-03', 2),
('Перса', 1, 'Метис', 2, '2 года', 3, 'Рыжий', 'Отличная охраница, игривая...', '2025-11-22', '2026-08-08', 2);

# заполняем фотографии
INSERT INTO AnimalPhotos (id_animal, file_path, is_main) 
VALUES 
(1, '/img/ponka_1.jpg', TRUE), 
(1, '/img/ponka_2.jpg', FALSE),
(2, '/img/spaik_1.jpg', TRUE),
(3, '/img/amira_1.jpg', TRUE),
(4, '/img/blanka_1.jpg', TRUE);

# назначаем главные фото в карточках животных (обновляем поле id_main_photo)
UPDATE Animals SET id_main_photo = 1 WHERE id_animal = 1;
UPDATE Animals SET id_main_photo = 3 WHERE id_animal = 2;
UPDATE Animals SET id_main_photo = 4 WHERE id_animal = 3;
UPDATE Animals SET id_main_photo = 5 WHERE id_animal = 4;

# заполняем договоры
INSERT INTO Contract (id_animal, owner_name, passport, phone, address, document_number, transfer_date) 
VALUES 
(4, 'Петров И.А.', '11', '44', 'Адрес 1', 1, '2026-07-01'),
(5, 'Петров П.В.', '22', '55', 'Адрес 2', 2, '2026-10-03'),
(6, 'Петров А.Г.', '33', '66', 'Адрес 3', 3, '2026-08-08');

# обновление записей
UPDATE Animals 
SET description = 'Спокойный характер. Любит играть с мячиком.' 
WHERE id_animal = 3;

# удаление записей
DELETE FROM AnimalPhotos 
WHERE id_photo = 2;

# создание пользователей и наделение их правами
# права волонтеров
CREATE USER IF NOT EXISTS 'volunteer_user'@'localhost' IDENTIFIED BY 'volunteer_pass';
GRANT SELECT, INSERT, UPDATE ON AnimalShelterDB.Animals TO 'volunteer_user'@'localhost';
GRANT SELECT, INSERT ON AnimalShelterDB.AnimalPhotos TO 'volunteer_user'@'localhost';
GRANT SELECT ON AnimalShelterDB.Species TO 'volunteer_user'@'localhost';
GRANT SELECT ON AnimalShelterDB.Gender TO 'volunteer_user'@'localhost';
GRANT SELECT ON AnimalShelterDB.Size TO 'volunteer_user'@'localhost';
GRANT SELECT ON AnimalShelterDB.Statuses TO 'volunteer_user'@'localhost';
# у администратора права на любые действия
CREATE USER IF NOT EXISTS 'admin_user'@'localhost' IDENTIFIED BY 'admin_pass';
GRANT ALL PRIVILEGES ON AnimalShelterDB.* TO 'admin_user'@'localhost';
FLUSH PRIVILEGES;

# выгрузка метаданных всех получившихся таблиц
DESCRIBE Species;
DESCRIBE Gender;
DESCRIBE Size;
DESCRIBE Statuses;
DESCRIBE Roles;
DESCRIBE Users;
DESCRIBE Animals;
DESCRIBE AnimalPhotos;
DESCRIBE Contract;




#Часть 2. Запросы

# неявное соединение таблиц с фильтром данных (WHERE) и сортировкой (ORDER BY)
# выводим список всех пристроенных животных, отсортированный по дате передачи (сначала новые)
SELECT
    a.animal_name AS "Кличка",
    s.species_name AS "Вид",
    st.status_name AS "Статус",
    a.transfer_date AS "Дата передачи"
FROM Animals a, Species s, Statuses st
WHERE a.id_species = s.id_species AND a.id_status = st.id_status AND st.status_name = 'Пристроен'
ORDER BY a.transfer_date DESC;

# явное соединение таблиц (JOIN)
# выводим карточки животных вместе с информацией о договоре
SELECT
    a.id_animal AS "Код животного",
    a.animal_name AS "Кличка",
    c.owner_name AS "ФИО владельца",
    c.phone AS "Телефон"
FROM Animals a
JOIN Contract c ON a.id_animal = c.id_animal;

# агрегирующие операции (SUM, AVG, COUNT, MAX, MIN)
# считаем общее количество животных, количество собак и кошек, а также находим самую раннюю и позднюю дату поступления
SELECT 
    COUNT(*) AS "Всего животных",
    SUM(CASE WHEN id_species = 1 THEN 1 ELSE 0 END) AS "Собак",
    SUM(CASE WHEN id_species = 2 THEN 1 ELSE 0 END) AS "Кошек",
    MIN(arrival_date) AS "Самая ранняя дата поступления",
    MAX(arrival_date) AS "Самая поздняя дата поступления"
FROM Animals;

# группировка GROUP BY и фильтрация HAVING
# выводим количество животных по каждому виду, оставив только те виды, у которых больше 1 животного
SELECT
    s.species_name AS "Вид животного",
    COUNT(a.id_animal) AS "Количество"
FROM Animals a
JOIN Species s ON a.id_species = s.id_species
GROUP BY s.species_name
HAVING COUNT(a.id_animal) > 1;

# вложенные подзапросы
# с оператором IN 
# животные, у которых есть договор
SELECT animal_name AS "Кличка", id_status AS "Статус"
FROM Animals
WHERE id_animal IN (SELECT id_animal FROM Contract);
# с оператором ALL 
# животные, поступившие позже, чем все животные с размером "Средний"
SELECT animal_name AS "Кличка", arrival_date AS "Дата поступления"
FROM Animals
WHERE arrival_date > ALL (SELECT arrival_date FROM Animals WHERE id_size = 2);

# использование «функций управления потоком» (IF, CASE)
# выводим кличку, вид и статуса, а также пометку, есть ли у животного главное фото
SELECT
    a.animal_name AS "Кличка",
    s.species_name AS "Вид",
    CASE
        WHEN a.id_status = 1 THEN 'Ищет нового хозяина'
        WHEN a.id_status = 2 THEN 'Нашел дом'
        ELSE 'Неизвестный статус'
    END AS "Текущее состояние",
    IF(
        a.id_main_photo IS NULL,
        'Фото не загружено',
        'Есть главное фото'
    ) AS "Наличие фото"
FROM Animals a
JOIN Species s ON a.id_species = s.id_species;

# представления (CREATE VIEW) и временное представление (WITH)
# представления (View)
CREATE OR REPLACE VIEW AdoptedAnimalsView AS
SELECT
    a.animal_name AS "Кличка",
    s.species_name AS "Вид",
    c.owner_name AS "ФИО владельца",
    c.transfer_date AS "Дата передачи"
FROM Animals a
JOIN Species s ON a.id_species = s.id_species
JOIN Contract c ON a.id_animal = c.id_animal
WHERE a.id_status = 2;

SELECT * FROM AdoptedAnimalsView;
# временное представление (WITH)
WITH AnimalStats AS (
    SELECT
        s.species_name AS species,
        COUNT(a.id_animal) AS total_count,
        SUM(CASE WHEN a.id_status = 2 THEN 1 ELSE 0 END) AS adopted_count
    FROM Animals a
    JOIN Species s ON a.id_species = s.id_species
    GROUP BY s.species_name
)
SELECT
    species AS "Вид",
    total_count AS "Всего",
    adopted_count AS "Пристроено",
    (total_count - adopted_count) AS "Осталось в приюте"
FROM AnimalStats;

# анализ и оптимизация запросов (EXPLAIN и CREATE INDEX)
# запрос до создания индекса
EXPLAIN
SELECT animal_name, arrival_date 
FROM Animals 
WHERE id_status = 1;

CREATE INDEX idx_animal_status ON Animals(id_status);
SHOW INDEX FROM Animals;

# механизм транзакций (START TRANSACTION)
# оформляем передачу животного, если произойдет ошибка, откатить.
START TRANSACTION;
# добавляем договор для Понки (id_animal = 1)
INSERT INTO Contract (id_animal, owner_name, passport, phone, address, document_number, transfer_date) 
VALUES (1, 'Сидоров С.С.', '4444 444444', '(999) 777-7777', 'г. Пермь, ул. Пермская, д. 4', 4, CURDATE());
# меняем статус Понки на "Пристроен" (id_status = 2) и обновляем дату передачи
UPDATE Animals 
SET id_status = 2, transfer_date = CURDATE() 
WHERE id_animal = 1;
# результат
SELECT a.animal_name, a.id_status, c.owner_name 
FROM Animals a JOIN Contract c ON a.id_animal = c.id_animal 
WHERE a.id_animal = 1;
COMMIT;

# операторы PREPARE, EXECUTE, DEALLOCATE
# запрос на поиск животных по статусу 
SET @status_id = 1; # ищем тех, кто ищет дом
PREPARE search_animals FROM
'SELECT
    a.id_animal AS "Код",
    a.animal_name AS "Кличка",
    s.species_name AS "Вид",
    st.status_name AS "Статус"
FROM Animals a
JOIN Species s ON a.id_species = s.id_species
JOIN Statuses st ON a.id_status = st.id_status
WHERE a.id_status = ?';

EXECUTE search_animals USING @status_id;
DEALLOCATE PREPARE search_animals;