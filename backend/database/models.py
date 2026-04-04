from sqlalchemy import Column, String, Text, DateTime
from datetime import datetime, timezone
import uuid
from .database import Base
import enum

class News(Base):
    __tablename__ = "news"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()), index=True)
    title = Column(String, nullable=False)
    content = Column(Text, nullable=False)
    image_url = Column(String, nullable=True)
    author_id = Column(String, nullable=False)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))



class UserRole(str, enum.Enum):
    student = "student"
    council = "council"

class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    role = Column(String, default="student")
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))