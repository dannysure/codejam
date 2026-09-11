INSERT INTO compact_discs (id, title, artist, tracks, price)
SELECT 9, 'Is This It', 'The Strokes', 11, 13.99
WHERE NOT EXISTS (SELECT 1 FROM compact_discs WHERE id = 9);

INSERT INTO compact_discs (id, title, artist, tracks, price)
SELECT 10, 'Just Enough Education to Perform', 'Stereophonics', 11, 10.99
WHERE NOT EXISTS (SELECT 1 FROM compact_discs WHERE id = 10);

INSERT INTO compact_discs (id, title, artist, tracks, price)
SELECT 11, 'Parachutes', 'Coldplay', 10, 11.99
WHERE NOT EXISTS (SELECT 1 FROM compact_discs WHERE id = 11);

INSERT INTO compact_discs (id, title, artist, tracks, price)
SELECT 12, 'White Ladder', 'David Gray', 10, 9.99
WHERE NOT EXISTS (SELECT 1 FROM compact_discs WHERE id = 12);

INSERT INTO compact_discs (id, title, artist, tracks, price)
SELECT 13, 'Greatest Hits', 'Penelope', 14, 14.99
WHERE NOT EXISTS (SELECT 1 FROM compact_discs WHERE id = 13);

INSERT INTO compact_discs (id, title, artist, tracks, price)
SELECT 14, 'Echo Park', 'Feeder', 12, 13.99
WHERE NOT EXISTS (SELECT 1 FROM compact_discs WHERE id = 14);

INSERT INTO compact_discs (id, title, artist, tracks, price)
SELECT 15, 'Mezzanine', 'Massive Attack', 11, 12.99
WHERE NOT EXISTS (SELECT 1 FROM compact_discs WHERE id = 15);

INSERT INTO compact_discs (id, title, artist, tracks, price)
SELECT 16, 'Spice World', 'Spice Girls', 11, 4.99
WHERE NOT EXISTS (SELECT 1 FROM compact_discs WHERE id = 16);

INSERT INTO tracks (id, cd_id, title)
SELECT 1, 16, 'Mama'
WHERE NOT EXISTS (SELECT 1 FROM tracks WHERE id = 1);

INSERT INTO tracks (id, cd_id, title)
SELECT 2, 16, 'Wannabe'
WHERE NOT EXISTS (SELECT 1 FROM tracks WHERE id = 2);

INSERT INTO tracks (id, cd_id, title)
SELECT 3, 16, 'Spice up your life'
WHERE NOT EXISTS (SELECT 1 FROM tracks WHERE id = 3);
