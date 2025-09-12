# Home Care App

The Home Care App is your all-in-one platform to connect users with trusted and verified home service professionals. Whether you need a plumber, electrician, carpenter, or technician, Home Care ensures reliability and quality with a few taps.

## 🚀 Features

### For Users:


- 📅 Book service slots
- ⭐ Rate and give feedback
- 🧾 View booking history

### For Service Providers:

- ✅ Register and verify profile
- 📥 Receive and manage booking requests
- 📊 Track performance and ratings

## 🛠️ Tech Stack

- **Frontend:** Flutter
- **Backend:** PHP (XAMPP)
- **Database:** MySQL

## 🗂️ Project Structure

```
lib/
├── ser_provider/       # Stateless widgets for service provider screens
├── users/              # Stateless widgets for user screens
├── models/             # Data models (User, ServiceProvider, Booking, etc.)
├── widgets/            # Reusable UI components
```

# HomeCare App – PHP Backend

## connection.php
```php
<?php
    $con = mysqli_connect("localhost","root","","homecare_app");
?>
```
## usersignup.php
```php
<?php
    include('connection.php');

    $username = $_POST['username'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    $phone_no = $_POST['phone_no'];
    $address = $_POST['address'];

    $sql = "INSERT INTO user(username,email,password,phone_no,address) VALUES ('$username','$email','$password','$phone_no','$address')";

    if(mysqli_query($con,$sql))
    {
        $json['message'] = 'success';
    }
    else
    {
        $json['message'] = 'failed';
    }

    echo json_encode($json);
?>
```
## userlogin.php
```php
<?php
    include("connection.php");

    // $email= "vishal@gmail.com";
    // $password = "vishal123";

    $email= $_POST['email'];
    $password = $_POST['password'];

    $sql = "SELECT * FROM user WHERE email ='$email' and password ='$password'";
    
    $result = mysqli_query($con,$sql);

    if (mysqli_num_rows($result)>0)
    {
        $row = mysqli_fetch_assoc($result);
        $data['message'] = 'success';
        $data['userInfo'] = $row;
    }
    else
    {
        $data['message'] = 'failed';
    }

    echo json_encode($data);
?>
```

