from typing import List

from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import func

from auth.auth_routes import get_current_user, require_council_role
from .schemas import Comment as CommentScheme, CreateCommentRequest
from database.models import Topics, Comments, User
from database.database import get_db

topic_router = APIRouter(
    prefix="/topic",
    tags=["comments inside topic"],
)


async def _get_db_user(db: AsyncSession, uid: str) -> User | None:
    result = await db.execute(select(User).where(User.id == uid))
    return result.scalar_one_or_none()


@topic_router.get("/comments", response_model=List[CommentScheme])
async def get_all_news(
        topic_id: str,
        user: dict = Depends(get_current_user),
        db: AsyncSession = Depends(get_db)
):
    comments_schemas = await db.execute(select(Comments).where(Comments.topic_id == topic_id))
    comments_models = comments_schemas.scalars().all()

    comments_schemas = []
    for comment in comments_models:
        comments_schemas.append({
            "content": comment.content,
            "comment_id": comment.id,
            "author": comment.user_id
        })

    return comments_schemas


@topic_router.post("/comments", response_model=CommentScheme)
async def create_topic(
        request: CreateCommentRequest,
        user: dict = Depends(require_council_role),
        db: AsyncSession = Depends(get_db)
):
    new_comment = Comments(content=request.content, topic_id=request.topic_id, user_id=user.get("uid"))
    db.add(new_comment)
    await db.commit()
    await db.refresh(new_comment)

    user = await _get_db_user(db, new_comment.user_id)

    return {
        "content": new_comment.content,
        "comment_id": new_comment.id,
        "author": user.display_name
    }
