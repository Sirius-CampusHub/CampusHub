import fastapi

from schedule import router
from auth import  auth_routes

import os
import json
import base64
import firebase_admin
from firebase_admin import credentials
from dotenv import load_dotenv

load_dotenv()


def init_firebase():
    base64_config = os.getenv("FIREBASE_CONFIG_BASE64")

    if base64_config:
        decoded_bytes = base64.b64decode(base64_config)
        config_dict = json.loads(decoded_bytes)

        # Инициализируем через словарь (не через файл!)
        cred = credentials.Certificate(config_dict)
        firebase_admin.initialize_app(cred)
        print("Firebase инициализирован через Base64!")
    else:
        # Если вдруг строки нет, ищем файл (на всякий случай)
        print("Base64 конфиг не найден, ищу файл...")
        cred = credentials.Certificate("firebase-adminsdk.json")
        firebase_admin.initialize_app(cred)


init_firebase()

app = fastapi.FastAPI(
    title="CampusHub",
    version="0.0.0"
)

app.include_router(router)
app.include_router(auth_routes.router)
