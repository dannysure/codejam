package com.conygre.spring.boot;

import org.junit.jupiter.api.Test;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Import;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class AppConfigTest {

    @Test
    void appConfigDeclaresExpectedSpringAnnotations() {
        assertNotNull(AppConfig.class.getAnnotation(SpringBootApplication.class));
        assertNotNull(AppConfig.class.getAnnotation(ComponentScan.class));

        Import importAnnotation = AppConfig.class.getAnnotation(Import.class);
        assertNotNull(importAnnotation);
        assertTrue(Arrays.asList(importAnnotation.value()).contains(SwaggerConfig.class));
    }

    @Test
    void appConfigExposesStandardMainMethod() throws NoSuchMethodException {
        Method mainMethod = AppConfig.class.getMethod("main", String[].class);

        assertTrue(Modifier.isPublic(mainMethod.getModifiers()));
        assertTrue(Modifier.isStatic(mainMethod.getModifiers()));
    }
}
