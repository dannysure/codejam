package com.conygre.spring.boot.entities;

import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertTrue;

class CompactDiscTest {

    @Test
    void constructorPopulatesCoreFields() {
        CompactDisc disc = new CompactDisc("White Ladder", 9.99, "David Gray", 10);

        assertEquals("White Ladder", disc.getTitle());
        assertEquals(9.99, disc.getPrice());
        assertEquals("David Gray", disc.getArtist());
        assertEquals(10, disc.getTracks());
    }

    @Test
    void defaultConstructorStartsWithEmptyTrackTitles() {
        CompactDisc disc = new CompactDisc();

        assertNotNull(disc.getTrackTitles());
        assertTrue(disc.getTrackTitles().isEmpty());
    }

    @Test
    void settersAndGettersRoundTripValues() {
        CompactDisc disc = new CompactDisc();
        List<Track> tracks = List.of(new Track("Mama"), new Track("Wannabe"));

        disc.setId(16);
        disc.setTitle("Spice World");
        disc.setArtist("Spice Girls");
        disc.setPrice(4.99);
        disc.setTracks(11);
        disc.setTrackTitles(tracks);

        assertEquals(16, disc.getId());
        assertEquals("Spice World", disc.getTitle());
        assertEquals("Spice Girls", disc.getArtist());
        assertEquals(4.99, disc.getPrice());
        assertEquals(11, disc.getTracks());
        assertSame(tracks, disc.getTrackTitles());
    }
}
