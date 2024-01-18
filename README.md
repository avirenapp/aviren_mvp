# aviren_mvp

<p align="center"><img src="https://github.com/avirenapp/aviren_mvp/assets/48215209/d7d4c0bf-637f-496c-9efe-3f71605af818"></p>

This is Aviren, an application designed to tackle the challenges of depression and suicide among younger generations. Our mission is to provide services that harness handcrafted models and personalize Language Learning Models to adapt to each user's unique behavioral patterns, ensuring a tailored approach to mental health support. Join us on the journey as we combine technology and passion to create a brighter future for the younger generations.

Inquiries: avirenapp@gmail.com

## Team
- Anders Willard Leo - Hacker
- Brian Altan - Hustler
- Kenneth Bryan - Hacker
- Terris Alvin - Hipster

## App Installation
https://drive.google.com/file/d/13zlPhxFVMejGRYWzE1z_Ks5glhbSKs9y/view?usp=sharing

## How to Run the Project
### Application
**Requirements**:
- Flutter
- Dart
- Android Studio

**Steps**:
- Clone project:

```bash
git clone https://github.com/avirenapp/aviren_mvp.git
```

- Navigate to the project folder:

```bash
cd aviren_mvp
```

- Install dependencies:

```bash
flutter pub get
```

- Run the project:

```bash
flutter run
```

### Backend
**Requirements**:
- Python
- Code Editor

**Steps**:
- Install dependencies:

```bash
pip install google-generativeai
pip install requests
pip install flask
pip install firestore
```

- Open https://makersuite.google.com/app/apikey and create a new API key
![image](https://github.com/avirenapp/aviren_mvp/assets/48215209/41ccbdfc-f563-4144-8c80-cc3ecbc306a4)

- Copy the API key and replace **REDACTED** in every file in the backend folder
![image](https://github.com/avirenapp/aviren_mvp/assets/48215209/3dbdcd9c-909a-45e5-a0cd-b082ef1e9091)

- Host all the python files on a web hosting service or your local machine
- Replace **REDACTED** on ``chatbot.py`` with the actual path to your ``service.json`` file
![image](https://github.com/avirenapp/aviren_mvp/assets/48215209/f6a165e6-84dc-48e7-926d-d6e842ed7d24)

- Replace **REDACTED** with ```HostURL/generate``` on the python file and botpage.dart
![image](https://github.com/avirenapp/aviren_mvp/assets/48215209/a435e8a8-327a-4f60-962a-d54c0a935479)
![image](https://github.com/avirenapp/aviren_mvp/assets/48215209/7077a549-6731-4856-b318-ea061a99ed85)

**Setting up ``check.py``**
- Replace **/PATH/** with the actual path to your ``service.json`` file
![checkpy1](https://github.com/avirenapp/aviren_mvp/assets/155055015/4d07b707-3eea-4315-919f-af5d962417aa)
- Replace **REDACTED** with ```HostURL/generate``` (actual endpoint) on the python file
![checkpy2](https://github.com/avirenapp/aviren_mvp/assets/155055015/5d66da26-14f2-4025-b5a8-99681aee58c9)
![checkpy3](https://github.com/avirenapp/aviren_mvp/assets/155055015/6f46204b-5621-4370-ace1-b273ea67fe70)

- Host the ``check.py`` script either on a web hosting service or your local machine, ensuring that scheduled tasks are enabled to run the script at regular intervals of every X seconds

  
## Application Demo
### Loading Page

<img width="400" height="889" src="https://github.com/avirenapp/aviren_mvp/blob/main/screenshots/loadingpage.jpg">

### Login Page

<img width="400" height="889" src="https://github.com/avirenapp/aviren_mvp/blob/main/screenshots/loginpage.jpg">

### Homepage

<img width="400" height="889" src="https://github.com/avirenapp/aviren_mvp/blob/main/screenshots/homepage.jpg">

### Mailbox

<img width="400" height="889" src="https://github.com/avirenapp/aviren_mvp/blob/main/screenshots/receiveletter.jpg">

### Reply Letter

<img width="400" height="889" src="https://github.com/avirenapp/aviren_mvp/blob/main/screenshots/sendletter.jpg">

### House

<img width="400" height="889" src="https://github.com/avirenapp/aviren_mvp/blob/main/screenshots/housepage.jpg">

### Chatbot

<img width="400" height="889" src="https://github.com/avirenapp/aviren_mvp/blob/main/screenshots/conversation1.jpg">
<img width="400" height="889" src="https://github.com/avirenapp/aviren_mvp/blob/main/screenshots/conversation2.jpg">


