FROM eboraas/apache:latest
MAINTAINER Volodymyr Melnyk <vovamelnik@gmail.com>
# Creating folders
RUN mkdir /var/www/folder1.net && mkdir /var/www/folder2.net && mkdir /etc/apache2/ssl
# Adding simple html
RUN echo "<h1 style='color: green;'>folder1</h1>" > /var/www/folder1.net/index.html
RUN echo "<h1 style='color: red;'>folder2</h1>" > /var/www/folder2.net/index.html
# Removing file ports and adding from host machine
RUN rm -rf /etc/apache2/ports.conf
ADD ports.conf /etc/apache2
# Adding certificate files
ADD folder1.net.crt /etc/apache2/ssl/folder1.net.crt
ADD folder1.net.key /etc/apache2/ssl/folder1.net.key
ADD folder2.net.crt /etc/apache2/ssl/folder2.net.crt
ADD folder2.net.key /etc/apache2/ssl/folder2.net.key
# Adding configs of virtual hosts
ADD folder1.net.conf /etc/apache2/sites-available/
ADD folder1.net.ssl.conf /etc/apache2/sites-available/
ADD folder2.net.conf /etc/apache2/sites-available/
ADD folder2.net.ssl.conf /etc/apache2/sites-available/
# Activating the virtual host
RUN a2ensite folder1.net.conf
RUN a2ensite folder1.net.ssl.conf
RUN a2ensite folder2.net.conf
RUN a2ensite folder2.net.ssl.conf
# Opening ports for linked containers
EXPOSE 80
EXPOSE 8080
EXPOSE 443
EXPOSE 4444
# The command that runs when the container starts
CMD service apache2 reload
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
