<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Hotel Reservation System</title>
  <style>
    :root {
      color-scheme: light;
      font-family: Arial, Helvetica, sans-serif;
      color: #1f2937;
      background: #f7f9fb;
    }

    body {
      margin: 0;
      min-height: 100vh;
      display: grid;
      place-items: center;
    }

    main {
      width: min(720px, calc(100% - 32px));
      padding: 32px;
      background: #ffffff;
      border: 1px solid #d9e2ec;
      border-radius: 8px;
      box-shadow: 0 18px 45px rgba(31, 41, 55, 0.08);
    }

    h1 {
      margin: 0 0 12px;
      font-size: clamp(2rem, 6vw, 3.25rem);
      line-height: 1.05;
    }

    p {
      margin: 0;
      max-width: 58ch;
      font-size: 1.05rem;
      line-height: 1.6;
    }
  </style>
</head>
<body>
  <main>
    <h1>Hotel Reservation System</h1>
    <p>
      This repository contains a Java servlet-based hotel reservation
      application. The Cloudflare deployment serves this static project page.
    </p>
  </main>
</body>
</html>
