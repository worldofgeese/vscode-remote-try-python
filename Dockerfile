# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.11-alpine as builder

EXPOSE 5000

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install pip requirements
WORKDIR /app
COPY /app/ .
COPY setup.py .
RUN pip install wheel && pip wheel . --wheel-dir=/app/wheels

FROM python:3.11-alpine

COPY --from=builder /app /app

COPY requirements.txt .
RUN pip install --no-index --find-links=/app/wheels -r requirements.txt

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app.wsgi:app"]
