CREATE TABLE `users` (
  `user_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_role` ENUM('User', 'Artist', 'Admin') NOT NULL DEFAULT 'User',
  `name` VARCHAR(255) NOT NULL,
  `bio` TEXT,
  `age` INT,
  `gender` TINYINT,
  `DOB` DATE,
  `country` VARCHAR(255), -- Changed from Countries to VARCHAR
  `region` VARCHAR(255), -- Changed from Regions to VARCHAR
  `email` VARCHAR(255) UNIQUE NOT NULL,
  `password` VARCHAR(255) NOT NULL
);

CREATE TABLE `artists` (
  `user_id` BIGINT UNSIGNED NOT NULL,
  `listens` INT DEFAULT 0,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_artists_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
);

CREATE TABLE `admins` (
  `user_id` BIGINT UNSIGNED NOT NULL,
  `projects` VARCHAR(255), -- VARCHAR requires a length
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_admins_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
);

CREATE TABLE `record_labels` (
  `record_label_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255),
  `description` TEXT
);

CREATE TABLE `albums` (
  `album_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(255) NOT NULL DEFAULT "Untitled Album",
  `format` ENUM('Album', 'Single', 'EP', 'LP', 'SP'),
  `release_date` DATE,
  `rating` INT,
  `artist_id` BIGINT UNSIGNED,
  `record_label_id` BIGINT UNSIGNED,
  CONSTRAINT `fk_albums_artists` FOREIGN KEY (`artist_id`) REFERENCES `artists` (`user_id`),
  CONSTRAINT `fk_albums_record_labels` FOREIGN KEY (`record_label_id`) REFERENCES `record_labels` (`record_label_id`)
);

CREATE TABLE `songs` (
  `song_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(255) NOT NULL DEFAULT "Untitled Song",
  `audio_format` ENUM('MP3', 'M4A', 'WAV') NOT NULL,
  `duration` INT DEFAULT 0,
  `listens` INT DEFAULT 0,
  `rating` INT,
  `album_id` BIGINT UNSIGNED,
  CONSTRAINT `fk_songs_albums` FOREIGN KEY (`album_id`) REFERENCES `albums` (`album_id`)
);

CREATE TABLE `song_artists` (
  `song_artist_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `song_id` BIGINT UNSIGNED,
  `artist_id` BIGINT UNSIGNED,
  CONSTRAINT `fk_song_artists_songs` FOREIGN KEY (`song_id`) REFERENCES `songs` (`song_id`),
  CONSTRAINT `fk_song_artists_artists` FOREIGN KEY (`artist_id`) REFERENCES `artists` (`user_id`)
);

CREATE TABLE `genres` (
  `genre_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT
);

CREATE TABLE `song_genres` (
  `song_genre_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `song_id` BIGINT UNSIGNED,
  `genre_id` BIGINT UNSIGNED,
  CONSTRAINT `fk_song_genres_songs` FOREIGN KEY (`song_id`) REFERENCES `songs` (`song_id`),
  CONSTRAINT `fk_song_genres_genres` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`genre_id`)
);

CREATE TABLE `subscription_plans` (
  `subscription_plan_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `subscription_plan_type` ENUM('Free', 'Individual', 'Student') DEFAULT 'Free',
  `description` TEXT,
  `term_length` INT DEFAULT 0,
  `price` FLOAT DEFAULT 0
);

CREATE TABLE `playlists` (
  `playlist_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT UNSIGNED,
  `title` VARCHAR(255) DEFAULT "Unititled Playlist",
  CONSTRAINT `fk_playlists_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
);

CREATE TABLE `playlist_songs` (
  `playlist_id` BIGINT UNSIGNED,
  `song_id` BIGINT UNSIGNED,
  `order` INT DEFAULT 1 AUTO_INCREMENT,
  PRIMARY KEY (`playlist_id`, `song_id`),
  CONSTRAINT `fk_playlist_songs_playlists` FOREIGN KEY (`playlist_id`) REFERENCES `playlists` (`playlist_id`),
  CONSTRAINT `fk_playlist_songs_songs` FOREIGN KEY (`song_id`) REFERENCES `songs` (`song_id`)
);

CREATE TABLE `listening_histories` (
  `listening_history_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `timestamp` TIMESTAMP DEFAULT NOT NULL CURRENT_TIMESTAMP,
  `user_id` BIGINT UNSIGNED,
  `song_id` BIGINT UNSIGNED,
  CONSTRAINT `fk_listening_histories_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_listening_histories_songs` FOREIGN KEY (`song_id`) REFERENCES `songs` (`song_id`)
);

CREATE TABLE `transactions` (
  `transaction_id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `payment_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `payment_source` INT NOT NULL, -- Consider changing to VARCHAR if storing payment method details
  `total` FLOAT NOT NULL,
  `user_id` BIGINT UNSIGNED,
  `subscription_plan_id` BIGINT UNSIGNED,
  CONSTRAINT `fk_transactions_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_transactions_subscription_plans` FOREIGN KEY (`subscription_plan_id`) REFERENCES `subscription_plans` (`subscription_plan_id`)
);
