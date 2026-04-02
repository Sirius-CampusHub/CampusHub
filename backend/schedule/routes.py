from fastapi import APIRouter
from .parser import Schedule
from .app import SiriusScheduleClient


router = APIRouter(
    prefix="/schedule",
    tags=["Schedule"],
)

@router.get("/")
async def get_group_schedule(group: str = "ИОП-ИТ-24/1", week: int = 0):
    # schedule = Schedule()
    # return await schedule.group(group)
    client = SiriusScheduleClient()
    return client.fetch_schedule(group, week)

