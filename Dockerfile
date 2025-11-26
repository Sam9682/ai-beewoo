FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt/web2py

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# Download latest Web2py
RUN git clone --recursive https://github.com/web2py/web2py.git . && \
    mv handlers/wsgihandler.py .

# Create non-root user
RUN groupadd -g 1000 web2py && \
    useradd -r -u 1000 -g web2py web2py

# Copy application files
COPY ./web2py ./
COPY entrypoint.sh /usr/local/bin/

# Set permissions
RUN chown -R web2py:web2py /opt/web2py && \
    chmod +x /usr/local/bin/entrypoint.sh

# Environment variables
ENV WEB2PY_ROOT=/opt/web2py
ENV WEB2PY_PASSWORD=SecurePassword123!
ENV WEB2PY_ADMIN_SECURITY_BYPASS=false
ENV UWSGI_OPTIONS="--master --thunder-lock --enable-threads"

# Expose port
EXPOSE 8080

# Switch to non-root user
USER web2py

CMD ["entrypoint.sh", "http"]
