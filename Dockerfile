FROM python:3.11-slim-buster

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "DASHSCOPE_API_KEY=${api_key}" >> /etc/environment
RUN echo "OPENAI_API_KEY=${api_key}" >> /etc/environment

RUN apt-get update && \
    apt-get install -y ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /service

ADD . /service

RUN pip install --no-cache-dir -r requirements.txt

RUN chmod +x entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/service/entrypoint.sh"]

CMD ["uvicorn", "sebastian.main:app", "--host", "0.0.0.0", "--port", "8000", "--loop", "asyncio"]