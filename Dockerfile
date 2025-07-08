FROM rocker/shiny:4.4.3 AS base 

# Remove default example apps from Shiny Server
RUN rm -rf /srv/shiny-server/*

# Install system-level dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    gdal-bin \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    proj-bin \
    libcurl4-gnutls-dev \
    libssl-dev \
    libudunits2-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfontconfig1-dev \
    && rm -rf /var/lib/apt/lists/*

# Create directory for R package restoration
RUN mkdir /renv

# Copy lockfile and restore R packages using renv
COPY renv.lock /renv/renv.lock
RUN cd /renv && \
    Rscript -e 'install.packages(c("renv", "remotes"))' && \
    Rscript -e 'renv::restore()'

# Create directory for local R package source
RUN mkdir /app

# Copy R package source files into image
COPY inst /app/inst
COPY man /app/man
COPY R /app/R
COPY .Rbuildignore /app
COPY DESCRIPTION /app
COPY NAMESPACE /app

# Install the golem app as local R package
RUN cd /app && \
    Rscript -e 'remotes::install_local(upgrade = "never")'

# Create the database directory
RUN mkdir /opt/db

# Access to /opt/db
RUN chmod -R 777 /opt/db
## RUN chmod 777 /opt/db/transaction_db.sqlite

# Set environment variables for Shiny server
ENV R_SHINY_PORT=3838
ENV R_SHINY_HOST=0.0.0.0

# Write env vars to .Renviron so they're accessible in R
RUN env | grep R_SHINY_PORT > /home/shiny/.Renviron && \
    env | grep R_SHINY_HOST >> /home/shiny/.Renviron

# Runtime stage: prepares Shiny app environment for execution
FROM base AS shiny

## set user
USER shiny

# Create app directory and copy Shiny app script
RUN mkdir -p /home/shiny/app
COPY app.R /home/shiny/app/app.R
WORKDIR /home/shiny/app

# Expose default Shiny port
EXPOSE 3838

# Default command to run the Shiny app
CMD ["/usr/local/bin/Rscript", "/home/shiny/app/app.R"]
