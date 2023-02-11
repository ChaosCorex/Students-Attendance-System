# ssas

Students Attendance System

## Getting Started

A system that records student attendance using QR code scan and Facial Verification

It is a Cross platform flutter application that works on web and mobile to deliver different
features depending on the user. It's purpose is to be a system that simulates recording attendance
in universities used by Students, Professors and TAs, each in their own role.

The TAs use the web app to create new lectures on the system which generates a unique QR Code to be shown on screen projectors that can be scanned
by students to record attendance. The QR Code has a state to define how it works and prevent cheating.
The QR Code State is active if the QR Code is shown on the screen from the TAs side and inactive otherwise.
This prevents attendance cheating using screenshots. Further more, the addition of Facial Verification for the purpose
of student identification.

The Students use the mobile app to Scan the QR Code and review their attendance history.

There is also different administrator accounts for the purpose of managing adding users to the system
and adding/editing course information including academic year, semester, course description, hours/week,. etc.
