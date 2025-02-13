Test Assignment: BFS Algorithm Implementation

This is a Flutter-based web application created as a test assignment. It demonstrates the implementation of the BFS (Breadth-First Search) algorithm for finding the shortest path.

Features:
Algorithm Visualization: The app visually demonstrates the BFS algorithm's functionality for finding the shortest path in a grid or graph.
API Integration: Fetches tasks and sends results to an API endpoint for processing.
Flutter Web Deployment: Fully deployed on GitHub Pages for web access.
Live Demo:
You can test the app here:
https://frolix.github.io/test-assignment/

Important Note:
For the app to function properly, the server that provides the API must include the following CORS header in its responses:

Access-Control-Allow-Origin: *
Without this header, the application will encounter CORS-related issues, and requests to the API will fail.

Running the App Locally:
If you'd like to run the application locally

Technologies Used

Flutter
A powerful framework for building cross-platform applications.
Used to create the user interface, manage state, and implement business logic.
Dart
A programming language optimized for building mobile, desktop, and web applications.
Used for writing algorithms, managing application logic, and interacting with APIs.
BLoC (Business Logic Component)
A state management architecture that separates UI from business logic.
Implemented using the flutter_bloc package to handle states and events (e.g., UrlBloc for URL validation and ProgressBloc for BFS algorithm progress).
HTTP Package
Used to perform RESTful API requests (GET/POST) for backend communication.
Equatable
Simplifies object comparisons, ensuring efficient state updates in the BLoC architecture.API Requirements:
The application communicates with an API for task fetching and result submission. The API must:

Support CORS for web requests.
Respond with structured JSON data.
If you have any questions or encounter issues, feel free to reach out! 😊

