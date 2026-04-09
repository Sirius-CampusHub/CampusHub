from .forum_routes import forum_router

__all__ = ['forum_router']

"/forum/topics GET"
"/forum/topics?{title} POST"
"/topic/comments?{topic_id} GET"
"/topic/comments?{topic_id, content} POST"
