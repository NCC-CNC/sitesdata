# Use the official Rocker Shiny base image with R 4.4.3
# Rocker provides pre-configured R images
FROM rocker/shiny:4.4.3 AS base

# Remove default example Shiny apps that come with the base image
RUN rm -rf /srv/shiny-server/*

# Install system-level dependencies and libraries
RUN apt-get update && apt-get install -y \
    # Allows adding external package repositories
    software-properties-common \
    # GDAL binaries and command-line tools
    gdal-bin \
    # GDAL development libraries
    libgdal-dev \
    # Geometry engine libraries
    libgeos-dev \
    # Cartographic projection library
    libproj-dev \
    # Projection command-line tools
    proj-bin \
    # Libraries for handling network requests in R
    libcurl4-gnutls-dev \
    # SSL support
    libssl-dev \
    # Units conversion library
    libudunits2-dev \
    # Text rendering libraries
    libharfbuzz-dev \
    libfribidi-dev \
    libfontconfig1-dev \
    # Clean up package lists to reduce image size
    && rm -rf /var/lib/apt/lists/*

# Create a directory for managing R package dependencies
RUN mkdir /renv

# Copy the renv lock file into the container
# This file specifies exact versions of R packages to install
COPY renv.lock /renv/renv.lock

# Install renv and remotes packages
# Then restore the exact package versions from the lock file
RUN cd /renv && \
    # Install package management tools
    Rscript -e 'install.packages(c("renv", "remotes"))' && \
    # Restore packages to match the locked versions
    Rscript -e 'renv::restore()'

# Create a directory for the application
RUN mkdir /app

# Copy various application components into the container
# This includes documentation, R scripts, package configuration
COPY inst /app/inst
COPY man /app/man
COPY R /app/R
COPY .Rbuildignore /app
COPY DESCRIPTION /app
COPY NAMESPACE /app

# Install the local R package
# The 'upgrade = "never"' prevents automatic package upgrades
RUN cd /app && \
    Rscript -e 'remotes::install_local(upgrade = "never")'

# Default command if no other command is specified
# Drops into a bash shell
CMD ["/bin/bash"]

# Start of the Shiny server image stage
FROM base AS shiny

# Switch to the 'shiny' user for security
# Prevents running the app as root
USER shiny

# Expose the default Shiny server port
EXPOSE 3838

# Set environment variables for Shiny server configuration
ENV R_SHINY_PORT=3838
ENV R_SHINY_HOST=0.0.0.0

# Write environment variables to .Renviron file
# This allows R to read these configuration settings
RUN env | grep R_SHINY_PORT > /home/shiny/.Renviron && \
    env | grep R_SHINY_HOST >> /home/shiny/.Renviron

# Create a directory for the Shiny app
RUN mkdir /home/shiny/app

# Copy the Shiny app R script
COPY app.R /home/shiny/app/app.R

# Set the working directory to the app folder
WORKDIR /home/shiny/app

# Command to start the Shiny app
CMD ["/usr/local/bin/Rscript", "/home/shiny/app/app.R"]
