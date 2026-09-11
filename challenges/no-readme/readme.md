# CompactDiscRestDataBoot

## Overview

CompactDiscRestDataBoot is a Spring Boot 2.5 REST application for managing a compact disc catalog.
It exposes CRUD-style HTTP endpoints for listing, retrieving, creating, and deleting CDs, and it also
serves a very simple browser page that renders the catalog in an HTML table.

The application uses:

- Java 11
- Spring Boot 2.5.3
- Spring Web
- Spring Data JPA
- MySQL
- Swagger / Springfox for API documentation

The main Spring Boot entry point is [AppConfig.java](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/src/main/java/com/conygre/spring/boot/AppConfig.java).

## What the Application Does

This application is primarily an API demo rather than a feature-rich end-user UI.

It supports:

- viewing the CD catalog
- retrieving a CD by ID
- retrieving a CD by ID with explicit 404 handling
- adding a new CD
- deleting a CD by ID
- deleting a CD by posting a CD object

The API controller is implemented in [CompactDiscController.java](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/src/main/java/com/conygre/spring/boot/rest/CompactDiscController.java).

The default home page is [index.html](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/src/main/resources/static/index.html), which simply calls the API and renders the returned data as a table.

## Prerequisites

Before running the application, make sure you have:

- JDK 11 or compatible JDK installed
- Maven installed
- MySQL installed and running on `localhost:3306`
- access to a MySQL user that matches the datasource settings in [application.properties](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/src/main/resources/application.properties)

## Configuration

The application reads database settings from [application.properties](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/src/main/resources/application.properties).

By default it expects:

- database: `conygre`
- host: `localhost`
- port: `3306`
- username: `root`
- password: configured locally by the developer

If port `8080` is already in use on your machine, uncomment or change the `server.port` line in [application.properties](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/src/main/resources/application.properties), for example:

```properties
server.port=8081
```

## Database Setup

The project includes a setup script at [createTables.sql](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/sql/createTables.sql).

It creates:

- the `conygre` database
- the `compact_discs` table
- the `tracks` table
- sample seed data

### Option 1: run the SQL script

Run the SQL in [createTables.sql](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/sql/createTables.sql) using MySQL Workbench or the MySQL command line client.

### Option 2: run the commands manually

```sql
CREATE DATABASE IF NOT EXISTS conygre;
USE conygre;

CREATE TABLE compact_discs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    artist VARCHAR(30),
    tracks INT,
    price DOUBLE
);

CREATE TABLE tracks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cd_id INT NOT NULL,
    title VARCHAR(50),
    FOREIGN KEY (cd_id) REFERENCES compact_discs(id)
);
```

Then insert sample data from [createTables.sql](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/sql/createTables.sql) if you want the UI and API to show records immediately.

## Running the Application

From the [no-readme/](C:/Users/Administrator/Downloads/codejam/challenges/no-readme) directory:

```powershell
mvn spring-boot:run
```

Or build and run the JAR:

```powershell
mvn clean package
java -jar target\CompactDiscRestDataBoot-0.0.1-SNAPSHOT.jar
```

If you need a different port at startup, you can override it:

```powershell
mvn spring-boot:run "-Dspring-boot.run.arguments=--server.port=8081"
```

## Accessing the Application

If using the default port:

- Home page: `http://localhost:8080/`
- API root: `http://localhost:8080/api/compactdiscs`
- Swagger UI: `http://localhost:8080/swagger-ui.html`

If using port 8081 instead:

- Home page: `http://localhost:8081/`
- API root: `http://localhost:8081/api/compactdiscs`
- Swagger UI: `http://localhost:8081/swagger-ui.html`

## REST Endpoints

### 1. Get all compact discs

**Request**

```http
GET /api/compactdiscs
```

**Description**

Returns the full CD catalog.

### 2. Get a compact disc by ID

**Request**

```http
GET /api/compactdiscs/{id}
```

**Description**

Returns a single CD object for the supplied ID.

### 3. Get a compact disc by ID with explicit 404 handling

**Request**

```http
GET /api/compactdiscs/404/{id}
```

**Description**

Returns:

- `200 OK` with a CD if the ID exists
- `404 Not Found` if the ID does not exist

### 4. Add a new compact disc

**Request**

```http
POST /api/compactdiscs
Content-Type: application/json
```

**Example body**

```json
{
  "title": "Sweet Caroline",
  "artist": "Neil Diamond",
  "price": 13.99,
  "tracks": 1
}
```

There is also a sample request file at [postcd.rest](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/rest/postcd.rest).

### 5. Delete a compact disc by ID

**Request**

```http
DELETE /api/compactdiscs/{id}
```

There is also a sample request file at [deletecd.rest](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/rest/deletecd.rest).

### 6. Delete a compact disc by request body

**Request**

```http
DELETE /api/compactdiscs
Content-Type: application/json
```

**Example body**

```json
{
  "id": 14,
  "title": "Echo Park",
  "artist": "Feeder",
  "price": 13.99,
  "tracks": 12
}
```

## Example API Responses

Example response from `GET /api/compactdiscs`:

```json
[
  {
    "id": 9,
    "title": "Is This It",
    "artist": "The Strokes",
    "price": 13.99,
    "tracks": 11,
    "trackTitles": []
  }
]
```

## Swagger Documentation

Swagger is enabled in [SwaggerConfig.java](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/src/main/java/com/conygre/spring/boot/SwaggerConfig.java).

Once the app is running, open:

```text
http://localhost:8080/swagger-ui.html
```

or the equivalent URL for your chosen port.

## Static Demo Pages

In addition to the API, the project contains a few static demo pages under [static/](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/src/main/resources/static):

- [index.html](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/src/main/resources/static/index.html)
- [listcds.html](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/src/main/resources/static/listcds.html)
- [promisefetch.html](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/src/main/resources/static/promisefetch.html)
- [constructorfunctionajax.html](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/src/main/resources/static/constructorfunctionajax.html)
- [temp.html](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/src/main/resources/static/temp.html)

These are useful for exploring the API, but they are lightweight examples rather than a polished front end.

## Troubleshooting

### Application starts but the page is blank or shows an error popup

Most likely causes:

- MySQL is not running
- the datasource password in [application.properties](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/src/main/resources/application.properties) is wrong
- the `conygre` database or `compact_discs` table has not been created

### Port 8080 is already in use

Use a different port:

```powershell
mvn spring-boot:run "-Dspring-boot.run.arguments=--server.port=8081"
```

or set:

```properties
server.port=8081
```

### API returns database errors

Make sure you have executed [createTables.sql](C:/Users/Administrator/Downloads/codejam/challenges/no-readme/sql/createTables.sql) and that the configured MySQL user has access to the `conygre` database.
