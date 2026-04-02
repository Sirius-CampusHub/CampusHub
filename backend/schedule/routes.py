from typing import List

from fastapi import APIRouter
from .parser import Schedule  # Понадобится позже
from .app import SiriusScheduleClient
from .models import Day


router = APIRouter(
    prefix="/schedule",
    tags=["Schedule"],
)

@router.get("/")
def get_group_schedule(group: str = "ИОП-ИТ-24/1", week: int = 0) -> List[Day]:
    # schedule = Schedule()                     # Понадобится позже
    # return await schedule.group(group)        # Понадобится позже
    client = SiriusScheduleClient()
    return client.fetch_schedule(group, week)

