<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Admin Login - Flight Reservation System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family: Arial, sans-serif; }
  html, body { height:100%; width:100%; }

  body {
    display: flex;
    flex-direction: column;
    min-height: 100vh;
    background-color: #f4f7fb;
    color: #003366;
    align-items: center;
  }
  
   .btn-register {
            width: 100%;
            background-color: #004575; /* red-600 */
            color: white;
            font-weight: 600;
            margin-top: 20px ;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            height : 70%;
        }

        .btn-register:hover {
            background-color: #0056b3; /* indigo-700 */
        }
        
         .card {
            background-color: white;      /* bg-white */
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.25); /* shadow-2xl */
            border-radius: 1rem;          /* rounded-lg */
            max-width: 36rem;             /* max-w-xl ≈ 576px */
            width: 100%;
            padding: 1rem 2rem;                /* p-8 */
            margin: auto;    
            height : 350px;           /* center if needed */
           
        }
        
         .error-message {
            color: #dc2626;       /* Tailwind text-red-600 */
            font-weight: 600;     /* font-semibold */
            margin-bottom: 1rem;  /* mb-4 */
            text-align: center;   /* text-center */
            font-size: 1rem;      /* optional, adjust if needed */
        }
        
        div{
        	margin : 10px 15px;
        	height : 60px;
        }
    </style>
</head>
<body>

  <div class="card">
    <h1 class="text-3xl font-semibold text-center mb-3">Admin Login</h1>

    <!-- Display error message from servlet -->
    <c:if test="${not empty errorMessage}">
      <p class="text-red-600 font-semibold mb-4 text-center">${errorMessage}</p> 
    </c:if>

    <!-- Login Form -->
   <form action="${pageContext.request.contextPath}/adminController" method="post" class="space-y-5">
    <input type="hidden" name="action" value="loginAdminForm"/>

    <div>
        <label for="email" class="block text-gray-700 font-medium mb-1">Email</label>
        <input type="text" id="email" name="email" placeholder="Enter your email"
               class="w-full border border-gray-300 rounded-md p-3 focus:outline-none focus:ring-2 focus:ring-indigo-400" required />
    </div>

    <div>
        <label for="password" class="block text-gray-700 font-medium mb-1">Password</label>
        <input type="password" id="password" name="password" placeholder="Enter your password"
               class="w-full border border-gray-300 rounded-md p-3 focus:outline-none focus:ring-2 focus:ring-indigo-400" required />
    </div>

    <div>
        <button type="submit" class="btn-register">Login</button>
    </div>
</form>
   

 </div>
</body>
</html>