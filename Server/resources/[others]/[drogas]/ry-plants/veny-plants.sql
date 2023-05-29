CREATE TABLE IF NOT EXISTS `plants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coords` longtext COLLATE utf8mb4_turkish_ci DEFAULT NULL,
  `plantgender` int(11) DEFAULT NULL,
  `water` int(11) DEFAULT NULL,
  `fertilizer` int(11) DEFAULT NULL,
  `timestamp` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=UTF8MB4_TURKISH_CI;
