from contextlib import asynccontextmanager
import fastapi
from fastapi.staticfiles import StaticFiles
from schedule import router
import os
import json
import base64
from dotenv import load_dotenv
from database.database import engine, Base

load_dotenv()

import firebase_admin
from firebase_admin import credentials

def init_firebase():
    base64_config = os.getenv("FIREBASE_CONFIG_BASE64")
    if base64_config:
        decoded_bytes = base64.b64decode(base64_config)
        config_dict = json.loads(decoded_bytes)
        cred = credentials.Certificate(config_dict)
        firebase_admin.initialize_app(cred)
        print("Firebase инициализирован через Base64!")
    else:
        print("Base64 конфиг не найден, ищу файл...")
        cred = credentials.Certificate("firebase-adminsdk.json")
        firebase_admin.initialize_app(cred)

init_firebase()

from schedule import routes
from auth import auth_routes
from news import news_routes
from profiles import router as profile_router

os.makedirs("uploads", exist_ok=True)

@asynccontextmanager
async def lifespan(app: fastapi.FastAPI):
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield

app = fastapi.FastAPI(
    title="CampusHub",
    version="0.0.0",
    lifespan=lifespan
)


app.mount("/static", StaticFiles(directory="uploads"), name="static")
app.include_router(router)
app.include_router(auth_routes.router)
app.include_router(profile_router)
app.include_router(news_routes.router)
app.include_router(routes.router)