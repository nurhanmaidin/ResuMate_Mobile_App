# Resumate – AI Powered Resume Builder & Interview Trainer

Resumate is an AI-assisted resume development platform created as my **Final Year Project (FYP)**.  
The system helps users design professional resumes, practice interviews, and generate new resume drafts using artificial intelligence.

The production vision connects to real authentication, AI engines, and payment systems.  
For public GitHub release, all external services are replaced with safe **demo simulations** so anyone can run the project locally.

---

## 🎓 Project Background

This project was designed and developed independently by me as part of my university Final Year Project.

The goal was to build a modern, intelligent career-preparation tool that combines:

- Resume marketplace
- Live resume editing
- AI resume generation
- AI interview practice
- Profile & template management

while applying real software engineering architecture and UI/UX principles.

---

## ✨ Core Features

### 1. Resume Template Marketplace
Users can browse modern resume templates, preview them, save favorites, and unlock them (demo purchase).

### 2. Resume Editor
Edit content directly on top of a designed template and export to PDF.

### 3. AI Resume Generator
Users describe job role, skills, and experience → AI produces a resume draft.

### 4. AI Interviewer
Upload resume → AI asks personalized interview questions and follow-ups.

### 5. User Profile
Local profile system with editable details and profile picture.

### 6. Saved Templates
Bookmark templates and access them later.

---

## 🧠 Demo vs Production Version

To make the project public and safe:

| Feature | Production | GitHub Version |
|--------|-----------|----------------|
| Authentication | Firebase | Mock login |
| Google Sign-In | OAuth | Simulated |
| Password Reset | Email service | Simulated |
| Payments | Real gateway | Instant unlock |
| AI Generation | Cohere / Backend | Mock AI |
| File Storage | Cloud | Local |

This allows recruiters and developers to test the full application flow without requiring API keys or paid infrastructure.

---

## 🏗 Architecture Overview

The app follows separation of concerns:

```
UI Layer
↓
Service Layer (Auth / AI / Storage)
↓
Local Persistence (SharedPreferences / Files)
```

Production services were abstracted so they can easily be swapped between:

```
Real Service ↔ Mock Service
```

---

## 🛠 Tech Stack

- **Flutter** – UI framework
- **Dart** – language
- **SharedPreferences** – local data storage
- **Screenshot & Printing** – PDF export
- **File handling** – local resume operations
- **Stateful widgets** – dynamic updates
- **Mock AI engines** – simulation for demo

---

## 🚀 How To Run

### 1. Clone the repository
```bash
git clone https://github.com/yourusername/resumate.git
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Run the application
```bash
flutter run
```

---

## 🔐 Demo Login

Because this is a public demo:

You can log in with **any email and password**.

Example:
```
email: demo@resumate.app  
password: 123456
```

---

## 📦 What Recruiters Can Explore

You can fully test:

✅ login & signup flow  
✅ profile editing  
✅ browse templates  
✅ save favorites  
✅ unlock templates  
✅ resume editing  
✅ PDF export  
✅ AI interview simulation  
✅ AI resume generation simulation  

No backend required.

---

## 🎥 Suggested Demo Walkthrough

1. Login  
2. Browse templates  
3. Unlock one  
4. Edit resume  
5. Export to PDF  
6. Try AI Interview  
7. Try AI Resume Generator  
8. Edit profile  

---

## 🧩 Key Engineering Focus

This project demonstrates my understanding of:

- Service abstraction
- Offline-first architecture
- Secure open-source practices
- UI state synchronization
- Async workflows
- File generation
- Real-world product design thinking

---

## ⚠️ Important Notice

This repository runs in **Demo Mode**.

AI responses, payments, and authentication are simulated to prevent exposing private APIs and infrastructure.

---

## 👨‍💻 Author

Developed by **Muhamad Nurhan**  
Final Year Project – Software Engineering

---

## 📬 Contact

If you'd like to know more about the production architecture or design decisions, feel free to reach out.

---

⭐ If you find this project interesting, a star is always appreciated!
