CREATE DATABASE wordpress;
CREATE USER 'wp_user'@'localhost' IDENTIFIED BY 'wp_pass';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost'
	IDENTIFIED BY 'wp_pass';
FLUSH PRIVILEGES;
