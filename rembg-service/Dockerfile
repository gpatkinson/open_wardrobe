FROM python:3.11-slim

WORKDIR /app

# Install system dependencies (including HEIC support)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    libheif-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Pre-download the U2-Net model during build
RUN python -c "from rembg import remove; from PIL import Image; remove(Image.new('RGB', (10, 10)))"

# Copy application code
COPY app.py .

# Expose port
EXPOSE 5000

# Run with gunicorn for production
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--timeout", "120", "--workers", "2", "app:app"]

