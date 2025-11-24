# Use Python 3.13 to match your previous setup
FROM python:3.13-slim

# 1. Install system dependencies (The part that was failing before)
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    libtesseract-dev \
    gcc \
    libgl1 \
    && rm -rf /var/lib/apt/lists/*

# 2. Set up the working directory
WORKDIR /app

# 3. Copy requirements and install Python dependencies
COPY requirements.txt .
# installing gunicorn directly here just in case it's missing from requirements
RUN pip install --no-cache-dir -r requirements.txt gunicorn

# 4. Copy the rest of your code
COPY . .

# 5. The command to start your server
# REPLACE 'app:app' with 'your_filename:your_flask_variable'
# Example: If your file is main.py and you do "app = Flask(__name__)", use "main:app"
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:10000"]