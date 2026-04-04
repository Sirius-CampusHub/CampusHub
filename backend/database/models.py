from sqlalchemy import Column, String, Text, DateTime
from datetime import datetime, timezone
import uuid
from .database import Base
import enum

USER_AVATAR_EMOJI_MAX_LEN = 16
USER_DISPLAY_NAME_MAX_LEN = 18
USER_BIO_MAX_LEN = 200
USER_TELEGRAM_HANDLE_MAX_LEN = 25
USER_GROUP_CODE_MAX_LEN = 10


def _utc_now_naive() -> datetime:
    """UTC wall time without tzinfo — matches PostgreSQL TIMESTAMP WITHOUT TIME ZONE + asyncpg."""
    return datetime.now(timezone.utc).replace(tzinfo=None)


class News(Base):
    __tablename__ = "news"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()), index=True)
    title = Column(String, nullable=False)
    content = Column(Text, nullable=False)
    image_url = Column(String, nullable=True)
    author_id = Column(String, nullable=False)
    created_at = Column(DateTime, default=_utc_now_naive)


class UserRole(str, enum.Enum):
    student = "student"
    council = "council"

class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    role = Column(String, default="student")
    created_at = Column(DateTime, default=_utc_now_naive)

    avatar_emoji = Column(String(USER_AVATAR_EMOJI_MAX_LEN), nullable=True)
    display_name = Column(String(USER_DISPLAY_NAME_MAX_LEN), nullable=True)
    group_code = Column(String(USER_GROUP_CODE_MAX_LEN), nullable=True)
    bio = Column(String(USER_BIO_MAX_LEN), nullable=True)
    telegram_handle = Column(String(USER_TELEGRAM_HANDLE_MAX_LEN), nullable=True)
    username = Column(String(64), nullable=True, unique=True, index=True)