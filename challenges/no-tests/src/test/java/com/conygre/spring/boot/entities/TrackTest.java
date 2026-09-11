package com.conygre.spring.boot.entities;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class TrackTest {

    @Test
    void fullConstructorPopulatesFields() {
        Track track = new Track(3, "Spice up your life", 16);

        assertEquals(3, track.getId());
        assertEquals("Spice up your life", track.getTitle());
        assertEquals(16, track.getCdId());
    }

    @Test
    void titleOnlyConstructorStoresTitle() {
        Track track = new Track("Mama");

        assertEquals("Mama", track.getTitle());
    }

    @Test
    void settersAndGettersRoundTripValues() {
        Track track = new Track();

        track.setId(2);
        track.setTitle("Wannabe");
        track.setCdId(16);

        assertEquals(2, track.getId());
        assertEquals("Wannabe", track.getTitle());
        assertEquals(16, track.getCdId());
    }
}
