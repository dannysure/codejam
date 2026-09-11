# Fix a Performance Issue

## Introduction
This project is a React-based website with a known performance issue that you have been asked to fix. Below is the information provided to help you understand and resolve the problem.


## How to Run the Project

1. Install the dependencies:
   ```npm install```

2. Start the development server:
   ```npm run dev```

3. Open the application in your browser: http://localhost:5173


## Application Overview
At the top of the window is a **menu**. Clicking on the different items on the menu will allow you to navigate through the different pages of the application.

## The Problem
The problem occurs when you are on the **About** page - on this page, if you click the "**show credits**" button the application hangs for a few seconds, while the credits are displayed. 

### Observations:
* During this delay, if you try to navigate to a different page the application becomes unresponsive. 
* The menu should always be responsive - when you click to navigate the website should move to the required page immediately.

## Important notes

* There is an **intentional delay** built in to the `Credits.tsx` file on **line 22** - this is to simulate a slow running operation.
* **You must not remove or edit this delay**. Instead, find other ways to solve the problem to keep the menu responsive. 

## Your Task
* Investigate the issue and using AI tools, implement a solution that ensures the menu remains responsive, even when the credits are being displayed.

## Points
400 points

## Mark Scheme

* 200 points - fix the root problem
* 200 points - demonstrate that you understand the root cause of the problem and can explain to your instructor to their satisfaction that you understand the code that has been generated.

