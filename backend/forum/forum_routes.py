from typing import List

from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import func

from auth.auth_routes import get_current_user, require_council_role
from .schemas import Topic as TopicScheme, CreateTopicRequest
from database.models import Topics, Comments
from database.database import get_db

forum_router = APIRouter(
    prefix="/forum",
    tags=["forum"],
)


@forum_router.get("/topics", response_model=List[TopicScheme])
async def get_topics(
        user: dict = Depends(get_current_user),
        db: AsyncSession = Depends(get_db)
):
    result = await db.execute(select(Topics))
    topics = result.scalars().all()

    # Подсчитываем комментарии для каждого топика
    topics_with_counts = []
    for topic in topics:
        comment_count_result = await db.execute(
            select(func.count(Comments.id)).where(Comments.topic_id == topic.id)
        )
        comment_count = comment_count_result.scalar() or 0

        topics_with_counts.append({
            "title": topic.title,
            "topic_id": topic.id,
            "responses_count": comment_count
        })

    return topics_with_counts


@forum_router.post("/topics", response_model=TopicScheme)
async def create_topic(
        request: CreateTopicRequest,
        user: dict = Depends(require_council_role),
        db: AsyncSession = Depends(get_db)
):
    title = request.title.strip()
    if not 1 < len(title) < 50:
        raise HTTPException(status_code=400, detail="Title is invalid")
    new_topic = Topics(title=title)
    db.add(new_topic)
    await db.commit()
    await db.refresh(new_topic)

    return {
        "title": new_topic.title,
        "topic_id": new_topic.id,
        "responses_count": 0
    }
