package com.conygre.spring.boot.repos;

import com.conygre.spring.boot.entities.CompactDisc;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

@DataJpaTest
@ActiveProfiles("test")
class CompactDiscRepositoryTest {

    @Autowired
    private CompactDiscRepository repository;

    @Test
    void saveAndFindByIdRoundTripsEntity() {
        CompactDisc saved = repository.save(new CompactDisc("Origin of Symmetry", 12.49, "Muse", 11));

        Optional<CompactDisc> reloaded = repository.findById(saved.getId());

        assertTrue(reloaded.isPresent());
        assertEquals("Origin of Symmetry", reloaded.get().getTitle());
        assertEquals("Muse", reloaded.get().getArtist());
        assertEquals(11, reloaded.get().getTracks());
        assertEquals(12.49, reloaded.get().getPrice());
    }

    @Test
    void findByArtistReturnsOnlyMatchingRows() {
        repository.save(new CompactDisc("A Rush of Blood to the Head", 10.99, "Coldplay", 11));
        repository.save(new CompactDisc("Parachutes", 11.99, "Coldplay", 10));
        repository.save(new CompactDisc("Mezzanine", 12.99, "Massive Attack", 11));

        List<CompactDisc> coldplayDiscs = new ArrayList<>();
        repository.findByArtist("Coldplay").forEach(coldplayDiscs::add);

        assertEquals(2, coldplayDiscs.size());
        assertTrue(coldplayDiscs.stream().allMatch(cd -> "Coldplay".equals(cd.getArtist())));
    }

    @Test
    void findByArtistReturnsEmptyCollectionWhenNoRowsMatch() {
        repository.save(new CompactDisc("White Ladder", 9.99, "David Gray", 10));

        List<CompactDisc> discs = new ArrayList<>();
        repository.findByArtist("No Match").forEach(discs::add);

        assertTrue(discs.isEmpty());
    }

    @Test
    void deleteRemovesPersistedEntity() {
        CompactDisc saved = repository.save(new CompactDisc("Echo Park", 13.99, "Feeder", 12));
        int id = saved.getId();
        assertNotNull(id);

        repository.delete(saved);

        assertFalse(repository.findById(id).isPresent());
    }
}
