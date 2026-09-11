package com.conygre.spring.boot.services;

import com.conygre.spring.boot.entities.CompactDisc;
import com.conygre.spring.boot.repos.CompactDiscRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CompactDiscServiceImplTest {

    @Mock
    private CompactDiscRepository dao;

    @InjectMocks
    private CompactDiscServiceImpl service;

    @Test
    void getCatalogDelegatesToRepository() {
        List<CompactDisc> discs = List.of(new CompactDisc("White Ladder", 9.99, "David Gray", 10));
        when(dao.findAll()).thenReturn(discs);

        Iterable<CompactDisc> result = service.getCatalog();

        assertSame(discs, result);
        verify(dao).findAll();
    }

    @Test
    void getCompactDiscByIdReturnsDiscWhenPresent() {
        CompactDisc disc = new CompactDisc("Echo Park", 13.99, "Feeder", 12);
        when(dao.findById(14)).thenReturn(Optional.of(disc));

        CompactDisc result = service.getCompactDiscById(14);

        assertSame(disc, result);
        verify(dao).findById(14);
    }

    @Test
    void getCompactDiscByIdReturnsNullWhenMissing() {
        when(dao.findById(77)).thenReturn(Optional.empty());

        CompactDisc result = service.getCompactDiscById(77);

        assertNull(result);
        verify(dao).findById(77);
    }

    @Test
    void addNewCompactDiscClearsIdBeforeSaving() {
        CompactDisc disc = new CompactDisc("Mezzanine", 12.99, "Massive Attack", 11);
        disc.setId(42);
        when(dao.save(disc)).thenReturn(disc);

        CompactDisc result = service.addNewCompactDisc(disc);

        assertEquals(0, disc.getId());
        assertSame(disc, result);
        verify(dao).save(disc);
    }

    @Test
    void updateCompactDiscDelegatesToRepositorySave() {
        CompactDisc disc = new CompactDisc("Thriller", 9.99, "Michael Jackson", 12);
        disc.setId(5);
        when(dao.save(disc)).thenReturn(disc);

        CompactDisc result = service.updateCompactDisc(disc);

        assertSame(disc, result);
        verify(dao).save(disc);
    }

    @Test
    void deleteCompactDiscByIdLoadsAndDeletesRepositoryEntity() {
        CompactDisc disc = new CompactDisc("Spice World", 4.99, "Spice Girls", 11);
        when(dao.findById(16)).thenReturn(Optional.of(disc));

        service.deleteCompactDisc(16);

        verify(dao).findById(16);
        verify(dao).delete(disc);
    }

    @Test
    void deleteCompactDiscDelegatesDirectlyToRepository() {
        CompactDisc disc = new CompactDisc("Parachutes", 11.99, "Coldplay", 10);

        service.deleteCompactDisc(disc);

        verify(dao).delete(disc);
    }

    @Test
    void deleteCompactDiscByIdThrowsWhenRepositoryCannotFindEntity() {
        when(dao.findById(999)).thenReturn(Optional.empty());

        assertThrows(NoSuchElementException.class, () -> service.deleteCompactDisc(999));
        verify(dao).findById(999);
    }
}
