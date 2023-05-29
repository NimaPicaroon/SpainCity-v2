CREATE TABLE `ra_music_history`
(
    `id`                 INT(11)      NOT NULL AUTO_INCREMENT,
    `player_identifier`  VARCHAR(60)  NOT NULL DEFAULT '',
    `youtube_title`      VARCHAR(100) NULL     DEFAULT NULL,
    `youtube_url`        VARCHAR(100) NULL     DEFAULT NULL,
    `created_at`         DATETIME     NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    INDEX `FK_ra_music_history` (`player_identifier`)
);

CREATE TABLE `ra_permanent_entities`
(
    `id`                 INT(11)       NOT NULL AUTO_INCREMENT,
    `uuid`               VARCHAR(36)   NOT NULL DEFAULT '',
    `model`              VARCHAR(60)   NOT NULL DEFAULT 0.0,
    `x`                  DECIMAL(7, 2) NOT NULL DEFAULT 0.0,
    `y`                  DECIMAL(7, 2) NOT NULL DEFAULT 0.0,
    `z`                  DECIMAL(7, 2) NOT NULL DEFAULT 0.0,
    `heading`            DECIMAL(7, 2) NOT NULL DEFAULT 0.0,
    `player_identifier`  VARCHAR(60)   NOT NULL DEFAULT '',
    `public`             TINYINT(1)    NOT NULL DEFAULT 1,
    `created_at`         DATETIME      NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`)
);
