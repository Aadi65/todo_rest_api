📝 Todo REST API Test App
This Flutter app is a simple yet functional Todo CRUD application using the crudcrud.com REST API for backend operations. Users can create, read, update, and delete todos seamlessly.

🚀 Features
✅ Add new todo items

✏️ Edit existing todos

❌ Delete todo items

📡 Fetch todos from a live REST API

💜 Clean and responsive UI using Flutter Material components

📲 Compatible with Android & iOS

🔧 Tech Stack
Frontend: Flutter (Dart)

Backend: crudcrud.com (temporary REST API for testing)

State Management: Stateful Widgets

HTTP Client: http package

📸 Screenshots
(Add screenshots of your Home screen, Add/Edit screen, etc.)

📂 Project Structure
bash
Copy
Edit
lib/
├── main.dart
├── screens/
│   ├── homescreen.dart       # Displays all todos
│   └── addpageScreen.dart    # Add/Edit todo page
📬 API Endpoint
You can get your own temporary API key at https://crudcrud.com
Example endpoint used in this app:

bash
Copy
Edit
https://crudcrud.com/api/<your-api-key>/todos
⚠️ Note: This endpoint expires after 24 hours for free use

🛠️ Getting Started
Clone the repo
git clone https://github.com/your-username/todo_rest_api.git

Install dependencies
flutter pub get

Update API Key
Replace the API key in the code with your own from crudcrud.com

Run the app
flutter run

📚 Resources
Flutter Documentation

HTTP Package

crudcrud.com - Temporary test API
