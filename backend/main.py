import fastapi

from schedule import routes
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


app.include_router(routes.router)
app.include_router(auth_routes.router)

a = {
    'afbe8c76-1310-4bc9-b701-288403372333': {
        'id': 'afbe8c76-1310-4bc9-b701-288403372333',
        'last_name': 'Дымсков',
        'first_name_one': 'М',
        'first_name': 'Михаил',
        'middle_name': 'Андреевич',
        'middle_name_one': 'А',
        'fio': 'Дымсков Михаил Андреевич',
        'department_fio': 'Дымсков Михаил Андреевич (Направление "Финансовая математика и финансовые технологии")',
        'department': 'Направление "Финансовая математика и финансовые технологии"'
    },
    'cd0294e4-0ce9-4c8c-8b5d-441b00a3dbe7': {
        'id': 'cd0294e4-0ce9-4c8c-8b5d-441b00a3dbe7',
        'last_name': 'Федоров',
        'first_name_one': 'Г',
        'first_name': 'Глеб',
        'middle_name': 'Владимирович',
        'middle_name_one': 'В',
        'fio': 'Федоров Глеб Владимирович',
        'department_fio': 'Федоров Глеб Владимирович (Направление "Финансовая математика и финансовые технологии")',
        'department': 'Направление "Финансовая математика и финансовые технологии"'
    },
    '40a24e58-364e-4c05-b8c0-5aa14ec4e00b': {
        'id': '40a24e58-364e-4c05-b8c0-5aa14ec4e00b',
        'last_name': 'Попов',
        'first_name_one': 'Е',
        'first_name': 'Евгений',
        'middle_name': 'Викторович',
        'middle_name_one': 'В',
        'fio': 'Попов Евгений Викторович',
        'department_fio': 'Попов Евгений Викторович (Направление "Финансовая математика и финансовые технологии")',
        'department': 'Направление "Финансовая математика и финансовые технологии"'
    }
}
