package com.conygre.spring.boot.rest;

import com.conygre.spring.boot.entities.CompactDisc;
import com.conygre.spring.boot.services.CompactDiscService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CompactDiscControllerTest {

    @Mock
    private CompactDiscService service;

    @InjectMocks
    private CompactDiscController controller;

    @Test
    void findAllReturnsCatalogFromService() {
        List<CompactDisc> discs = List.of(new CompactDisc("Is This It", 13.99, "The Strokes", 11));
        when(service.getCatalog()).thenReturn(discs);

        Iterable<CompactDisc> result = controller.findAll();

        assertSame(discs, result);
        verify(service).getCatalog();
    }

    @Test
    void getCdByIdReturnsDiscFromService() {
        CompactDisc disc = new CompactDisc("Parachutes", 11.99, "Coldplay", 10);
        when(service.getCompactDiscById(11)).thenReturn(disc);

        CompactDisc result = controller.getCdById(11);

        assertSame(disc, result);
        verify(service).getCompactDiscById(11);
    }

    @Test
    void getByIdWith404ReturnsNotFoundWhenServiceDoesNotFindDisc() {
        when(service.getCompactDiscById(99)).thenReturn(null);

        ResponseEntity<CompactDisc> response = controller.getByIdWith404(99);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertNull(response.getBody());
        verify(service).getCompactDiscById(99);
    }

    @Test
    void getByIdWith404ReturnsDiscWhenServiceFindsDisc() {
        CompactDisc disc = new CompactDisc("Parachutes", 11.99, "Coldplay", 10);
        when(service.getCompactDiscById(11)).thenReturn(disc);

        ResponseEntity<CompactDisc> response = controller.getByIdWith404(11);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertSame(disc, response.getBody());
        verify(service).getCompactDiscById(11);
    }

    @Test
    void addCdDelegatesToService() {
        CompactDisc disc = new CompactDisc("Thriller", 9.99, "Michael Jackson", 12);

        controller.addCd(disc);

        verify(service).addNewCompactDisc(disc);
    }

    @Test
    void deleteCdByIdDelegatesToService() {
        controller.deleteCd(14);

        verify(service).deleteCompactDisc(14);
    }

    @Test
    void deleteCdByBodyDelegatesToService() {
        CompactDisc disc = new CompactDisc("Mezzanine", 12.99, "Massive Attack", 11);

        controller.deleteCd(disc);

        verify(service).deleteCompactDisc(disc);
    }
}
