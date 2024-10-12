from flask import Flask
import time

app = Flask(__name__)

# Эндпоинт для проверки готовности
@app.route('/ready')
def readiness():
    return "I'm ready!", 200

# Эндпоинт для проверки живучести
@app.route('/healthz')
def liveness():
    return "I'm alive!", 200

# Основной роут
@app.route('/')
def hello():
    return "Hello, Kubernetes!", 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
