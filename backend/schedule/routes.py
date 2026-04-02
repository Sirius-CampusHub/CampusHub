from typing import List

from fastapi import APIRouter, HTTPException
from .parser import Schedule  # Понадобится позже
from .app import SiriusScheduleClient
from .models import Day


router = APIRouter(
    prefix="/schedule",
    tags=["Schedule"],
)

@router.get("/")
def get_group_schedule(group: str = "ИОП-ИТ-24/1", week_offset: int = 0) -> List[Day]:
    if abs(week_offset) > 10:
        return HTTPException(status_code=400, detail="week_offset must be integer number in range [-10, 10]")
    # schedule = Schedule()                     # Понадобится позже
    # return await schedule.group(group)        # Понадобится позже
    client = SiriusScheduleClient()
    return client.fetch_schedule(group, week_offset)

