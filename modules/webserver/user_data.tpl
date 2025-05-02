#!/bin/bash

# Update system packages
apt-get update -y
apt-get upgrade -y

# Install Apache and PHP
apt-get install -y apache2 php php-mysql

# Create a simple PHP info page
echo '<?php phpinfo(); ?>' > /var/www/html/info.php

# Create a database test page
cat > /var/www/html/dbtest.php << 'EOF'
<?php
$host = "${db_address}";
$username = "${db_username}";
$password = "${db_password}";
$database = "${db_name}";

echo "<h1>Database Connection Test</h1>";
echo "<p>Attempting to connect to MySQL database at: $host</p>";

try {
    $conn = new PDO("mysql:host=$host;dbname=$database", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "<p style='color:green;'>Connected successfully!</p>";
} catch(PDOException $e) {
    echo "<p style='color:red;'>Connection failed: " . $e->getMessage() . "</p>";
}
?>
EOF

# Create a simple welcome page
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>${environment} Web Server</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            line-height: 1.6;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        h1 {
            color: #333;
        }
        .links {
            margin-top: 20px;
        }
        .links a {
            display: inline-block;
            margin-right: 15px;
            text-decoration: none;
            color: #0066cc;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>${environment} Web Server</h1>
        <p>This server was provisioned using Terraform.</p>
        <div class="links">
            <a href="/info.php">PHP Info</a>
            <a href="/dbtest.php">Database Test</a>
        </div>
    </div>
</body>
</html>
EOF

# Restart Apache
systemctl restart apache2

echo "Setup complete!"