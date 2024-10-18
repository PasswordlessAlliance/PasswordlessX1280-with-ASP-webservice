# Passwordless X1280

## Introduction to Passwordless X1280
Passwordless X1280 is a passwordless software provided free of charge by the Passwordless Alliance to B2C online services worldwide. Developed based on the international standard ITU X.1280, Passwordless X1280 consists of server software for online service providers and a mobile app for online service users.

When online service providers and users adopt Passwordless X1280, users no longer need to remember and enter passwords for online services. Instead, the online service presents an automatic password to the user, who verifies it using the mobile app to log in to the online service. Passwordless X1280 shifts the responsibility of password proof from the user to the online service’s automatic password proof method, allowing users to access online services conveniently and securely.

Moreover, it enables out-of-band biometric authentication for all B2C online services using the biometric sensors on the user’s smartphone, eliminating the need for separate biometric sensors on each user device. Passwordless X1280 meets the needs of usability, security, and cost-effectiveness for both B2C online services and users, providing a free passwordless software.

## Passwordless X1280 app
+ Manage Passwordless for multiple online services with one app
+ You can register and manage multiple online services with a single Passwordless X1280 app. Since a private key is issued to the Passwordless X1280 app for each online service account that supports Passwordless, it offers excellent security. Users can manage Passwordless for all their online services with one app.
+ You can download the Passwordless X1280 app by scanning the QR code image below with your mobile device's camera.
  ![image](https://github.com/user-attachments/assets/0b144f67-0257-4b24-bc09-1d1dd54e1f52)


## Project running environment
* Windows Server 2012 R2
* MS SQL Server 2012 SP4
* Internet Information Services (8.5.9600.16384)

## How to use
+ Project source
  + Add a site in IIS and place the project source in the document root folder.
  + Add index.asp to the default document.
  + Unzip the decrypt.zip file in the /decrypt folder to that location.
  + Access the site you added to your browser.
  + Make sure the screen in the screenshot below appears.
    ![image](https://github.com/user-attachments/assets/a5acdd5a-2da9-4b12-95d6-c5d0b19e7776)

+ Create an account on the sample project site
  + Click <b>create account</b>, enter your ID, password, and name, and then click <b>create</b> button.
    ![image](https://github.com/user-attachments/assets/9e833f39-760c-4ed8-bbb4-9bb9bbd71671)

+ Register for passwordless service
  + Click <b>passwordless</b>, then click <b>passwordless Reg/Unreg</b>, enter ID and password, and click <b>passwordless Reg/Unreg</b> button.
    ![image](https://github.com/user-attachments/assets/b60a6515-a1b2-4853-986a-25eba7596efb)

  + When the QR Code appears on the screen, launch the passwordless X1280 app, click the <b>[+]</b> in the upper right corner, turn on the camera, and scan the QR Code.
    ![image](https://github.com/user-attachments/assets/dfff4447-d0ff-444c-a4d0-e0b894b05bc2)

+ Passwordless X1280 login
  + On the login screen of the browser, enter only the ID without entering a password and click the login button. When a 6-digit number appears on the screen, check that the same number appears in the Passwordless X1280 app and click the OK button.
  + If the 6-digit number in your browser and the number in the Passwordless X1280 app are the same, this indicates that no tampering has occurred.
    ![image](https://github.com/user-attachments/assets/6e0691a7-a812-4c75-9b35-e4e43179b4b3)


## Passwordless Alliance
![image](https://github.com/user-attachments/assets/78ab716f-fb04-44fc-a584-5d060aff6d8c)

[https://www.passwordlessalliance.org](https://www.passwordlessalliance.org/)

Passwordless Alliance is providing Passwordless X1280 software for free to B2C online services worldwide. Join as a Passwordless Alliance member now and help create a world without passwords!
