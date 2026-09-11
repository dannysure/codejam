CREATE TABLE IF NOT EXISTS compact_discs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    artist VARCHAR(30),
    tracks INT,
    price DOUBLE
);

CREATE TABLE IF NOT EXISTS tracks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cd_id INT NOT NULL,
    title VARCHAR(50),
    CONSTRAINT fk_tracks_compact_discs FOREIGN KEY (cd_id) REFERENCES compact_discs(id)
);
