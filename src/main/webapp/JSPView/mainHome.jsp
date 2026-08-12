<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Aurora Airline System</title>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: Arial, sans-serif;
      }

      html,
      body {
        height: 100%;
        width: 100%;
      }

      body {
        background: url("https://png.pngtree.com/background/20231222/original/pngtree-3d-illustration-of-an-airplane-flying-in-the-sky-picture-image_6938099.jpg")
          no-repeat center center fixed;
        background-size: cover;
        display: flex;
        justify-content: center;
        align-items: center;
        color: #fff;
        text-align: center;
        position: relative;
      }

      /* Overlay with theme color */
      body::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(
          0,
          75,
          117,
          0.6
        ); /* theme color #004b75 with opacity */
        z-index: 0;
      }

      .hero-content {
        position: relative;
        z-index: 1;
        max-width: 700px;
        padding: 20px;
      }

      h1 {
        font-size: 60px;
        margin-bottom: 20px;
        font-weight: bold;
        text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.7);
      }

      p {
        font-size: 24px;
        margin-bottom: 30px;
        text-shadow: 1px 1px 6px rgba(0, 0, 0, 0.7);
      }

      .btn-get-started {
        display: inline-block;
        padding: 15px 40px;
        font-size: 20px;
        font-weight: bold;
        color: #fff;
        background-color: #004b75;
        border: 2px solid #fff;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.3s ease;
        text-decoration: none;
      }

      .btn-get-started:hover {
        background-color: #006699;
        border-color: #fff;
      }

      /* Dropdown container */
      .role-selection {
        display: none;
        margin-top: 20px;
        opacity: 0;
        transition: opacity 0.5s ease-in-out;
      }

      .role-selection.show {
        display: block;
        opacity: 1;
      }

      .role-selection select {
        padding: 10px 15px;
        font-size: 18px;
        border-radius: 6px;
        border: none;
        outline: none;
      }

      .role-selection button {
        margin-left: 10px;
        padding: 10px 20px;
        font-size: 18px;
        border: none;
        border-radius: 6px;
        background-color: #fff;
        color: #004b75;
        cursor: pointer;
        font-weight: bold;
        transition: 0.3s;
      }

      .role-selection button:hover {
        background-color: #f0f0f0;
      }

      h1 {
        font-size: 46px;
      }

      p {
        font-size: 18px;
      }

      .btn-get-started {
        font-size: 18px;
        padding: 12px 30px;
      }

      .title {
        font-size: 50px;
        line-height: 1.1;
        margin: 20px 0;
        color: var(--accent);
        position: relative;
        z-index: 1;
      }
    </style>
  </head>
  <body>
    <div class="hero-content">
      <h1>Aurora | Flight Reservation</h1>
      <p>"Fast, secure, and easy booking system"</p>
      <h2 class="title">Fly Smarter, Travel Easier</h2>

      <a
        href="javascript:void(0)"
        class="btn-get-started"
        onclick="showRoleSelection()"
        >Get Started ✈️</a
      >

      <div class="role-selection" id="roleSelection">
        <select id="role">
          <option value="">Select Role</option>
          <option value="user">User</option>
          <option value="admin">Admin</option>
        </select>
        <button onclick="goToRole()">Go</button>
      </div>
    </div>

    <script>
      function showRoleSelection() {
        const roleDiv = document.getElementById("roleSelection");
        roleDiv.classList.add("show"); // smooth fade-in
      }

      function goToRole() {
        const role = document.getElementById("role").value;
        if (role === "user") {
          window.location.href = "loginUser.jsp";
        } else if (role === "admin") {
          window.location.href = "loginAdmin.jsp";
        } else {
          alert("Please select a role.");
        }
      }
    </script>
  </body>
</html>
    