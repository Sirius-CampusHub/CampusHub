import fastapi
from schedule import router

app = fastapi.FastAPI(
    title="CampusHub",
    version="0.0.0"
)

app.include_router(router)
