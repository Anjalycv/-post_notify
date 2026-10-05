# Post Notify


This Flutter application demonstrates a clean, scalable implementation for fetching, displaying, and navigating paginated post data using **BLoC State Management** and **Clean Architecture** principles.

The app fetches posts from the `{JSON} Placeholder API` (`https://jsonplaceholder.typicode.com/posts`) and features dynamic pagination, offline/error handling, and system-level local notifications linked to deep-navigation details.

### Key Features

- **Paginated Posts Feed (Screen 1):**
    - Fetches post items dynamically with infinite scroll up to 100 items.
    - Displays post ID, title, and a preview snippet.
    - Native **Pull-to-Refresh** support.
    - Robust state handling for loading indicators, internet connectivity checks, and API failure retries.

- **Local Notifications Integration:**
    - Includes a **"Notify Me"** action on each post card.
    - Triggers local notifications populated with the post title and post ID payload.
    - Handles runtime notification permissions cleanly.

- **Post Details Page (Screen 2):**
    - Displays detailed post metrics (Post ID, User ID, full Title, and Body).
    - **Notification Navigation:** Tapping a notification directly opens the corresponding post details page whether the app is in the **foreground**, **background**, or launched from a **terminated state**.

### Architecture & Engineering Highlights

- **BLoC Pattern:** Enforces strict separation between presentation logic and business state transitions.
- **Clean Architecture Layering:** Segregates code into Data, Domain, and Presentation layers to ensure high testability, maintainability, and scalability.
- **Decoupled Business Logic:** Keeps raw API services, HTTP client logic, and platform notification dispatchers completely outside UI Widgets.

