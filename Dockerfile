FROM python:3.9-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        libjpeg-dev \
        zlib1g-dev \
        libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN grep -v '^feedparser==5.2.1$' requirements.txt > requirements.docker.txt
RUN pip install --no-cache-dir --upgrade "setuptools<58" "wheel<0.38"
RUN pip install --no-cache-dir --no-build-isolation "feedparser==5.2.1"
RUN pip install --no-cache-dir --use-deprecated=legacy-resolver -r requirements.docker.txt

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

COPY . .

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
