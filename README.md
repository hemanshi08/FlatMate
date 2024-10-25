# FlatMate

A comprehensive apartment management application built with Flutter.

## Description
FlatMate is a full-featured apartment management system, offering both user and admin functionalities to handle essential apartment-related activities. From managing maintenance requests and payments to organizing community events and addressing complaints, FlatMate simplifies apartment management for both residents and administrators.

## Features

### User Panel
- **Maintenance Requests**: View and make payments, download payment receipts.
- **Announcements**: Stay updated with community announcements.
- **Complaints**: Submit and track complaints.
- **Profile Management**: Update personal details and contact information.

### Admin Panel
- **Maintenance Management**: Create requests, track payment statuses, and view maintenance history.
- **Community Announcements**: Post announcements for all users.
- **Complaint Management**: View and address user complaints.
- **Expense Tracking**: Add and manage apartment-related expenses.
- **User & Admin Management**: Send emails with login credentials to new members and manage profiles.
- **Profile & Preferences**: Change personal information, contact details.

## Technologies Used

- **Flutter**: Main framework for mobile and desktop application development.
- **Firebase Realtime Database**: For storing data such as admin/user details, maintenance requests, and expenses.
- **Firebase Storage**: For uploading and managing receipt files and downloadable resources.
- **Shared Preferences**: Used to manage user sessions and store identifiers.
- **PDF Generation**: Custom PDF receipts generated within the app using `pdf` package.
- **Payment Integration**: Razorpay integration for handling user payments.
- **Internationalization**: `intl` package for currency and date formatting.
- **Path Provider**: For temporary file storage.
- **Firebase Authentication**: Provides secure user login sessions.

### Cross-Platform Support
- Android, iOS .

## Installation

To set up the project locally:

```bash
git clone https://github.com/hemanshi08/FlatMate
cd FlatMate
flutter pub get
flutter run
