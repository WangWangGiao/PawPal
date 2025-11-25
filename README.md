# pawpal

This is the first part of a continuos project series to develop for PawPal Pet Adoption & Donation Application using Flutter (frontend) and PHP + MYSQL (backend).

Login Process

• The user need to have an account first

• The user need to insert all the required information (Email and Password) to login.

• The user can tick the Remember Me feature to auto login for the next time.

Register Process

• The user need to insert all the required information (Username, Email, Password, Confirm Password, and Phone Number).

• Once all the information is valid and it will pop up a showdialog to confirm again to register or not.

• The information will insert into the database once user press on register.

Home Page

• After successful login, showing the account information on the screen.

• Provide a simple logout function to disable auto login function.

Basic Validation Approach

• Check for empty value - If the user does not input anything in the TextFormField and presses the Login/SignUp button, it will showing the error text to warning user.

• Check email address - If the user fill the invalid email address, it will showing the error text to warning user for enter a valid email address.

• Check password length - If the user insert less than 6 characters on password TextFormField, it will showing the error text to warning user to enter at least 6 characters word.

• Check email duplicate - If the user register account using the duplicate email (The email already been register before), it will showing the error text to warning user.

<table>
  <tr>
    <td align="center">
      <img src="https://github.com/WangWangGiao/my-project-assets/blob/main/Pawpal_SplashScreen.png?raw=true" alt="SplashScreen" width="250"/>
      <br>
      <b>SplashScreen</b>
    </td>
    <td align="center">
      <img src="https://github.com/WangWangGiao/my-project-assets/blob/main/Pawpal_LoginPage.png?raw=true" alt="HomeBefore" width="250"/>
      <br>
      <b>Login Page</b>
    </td>
    <td align="center">
      <img src="https://github.com/WangWangGiao/my-project-assets/blob/main/Pawpal_RegisterPage.png?raw=true" alt="HomeAfterCalculation" width="250"/>
      <br>
      <b>Register Page</b>
    </td>
  </tr>
</table>
