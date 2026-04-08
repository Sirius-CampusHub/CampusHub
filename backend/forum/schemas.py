from pydantic import BaseModel


class Topic(BaseModel):
    title: str | None
    topic_id: str | None
    responses_count: int = 0

class Topics(BaseModel):
    topics: list[Topic]

class CreateTopicRequest(BaseModel):
    title: str

class CreateCommentRequest(BaseModel):
    content: str
    topic_id: str

class Comment(BaseModel):
    content: str | None
    comment_id: str | None
    author: str | None = "anon"
