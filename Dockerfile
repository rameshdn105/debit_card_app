# Step 1: Use Ubuntu as the base image
FROM ubuntu:20.04

# Step 2: Set non-interactive mode for apt-get to prevent prompts
ENV DEBIAN_FRONTEND=noninteractive

# Step 3: Update Ubuntu packages and install dependencies (OpenJDK, wget, and other utilities)
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    wget \
    tar \
    curl \
    && rm -rf /var/lib/apt/lists/*  # Clean up apt cache

# Step 4: Set environment variables for Java and Tomcat locations
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV CATALINA_HOME=/opt/tomcat

# Step 5: Download and install Apache Tomcat
RUN wget -q https://downloads.apache.org/tomcat/tomcat-9/v9.0.56/bin/apache-tomcat-9.0.56.tar.gz && \
    tar -xzf apache-tomcat-9.0.56.tar.gz -C /opt && \
    mv /opt/apache-tomcat-9.0.56 /opt/tomcat && \
    rm apache-tomcat-9.0.56.tar.gz

# Step 6: Copy the WAR file generated by your build (from GitHub Actions workspace) to Tomcat's webapps folder
COPY debitcardapp.war $CATALINA_HOME/webapps/

# Step 7: Expose the port Tomcat listens on (default for Tomcat is 8080)
EXPOSE 8080

# Step 8: Set the default command to run Tomcat
CMD ["sh", "-c", "$CATALINA_HOME/bin/catalina.sh run"]
