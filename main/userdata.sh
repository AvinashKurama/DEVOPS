#!/bin/bash
# This line specifies that the script should be interpreted using the Bash shell.

# Update package lists to get the latest package information.
sudo apt-get update

# Install Nginx and automatically answer "yes" to any prompts.
sudo apt-get install nginx -y

# Start the Nginx service.
sudo systemctl start nginx

# Enable the Nginx service to start on boot.
sudo systemctl enable nginx

# Create an HTML file with a different message.
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to My Website</title>
</head>
<body>
    <h1>Hello, this is my custom webpage!</h1>
    <p>This page was created by the user data script on $(hostname).</p>
</body>
</html>
EOF
