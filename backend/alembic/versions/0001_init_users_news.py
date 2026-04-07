"""init users and news

Revision ID: 0001_init_users_news
Revises:
Create Date: 2026-04-07

"""

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = "0001_init_users_news"
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        "users",
        sa.Column("id", sa.String(), primary_key=True, nullable=False),
        sa.Column("email", sa.String(), nullable=True),
        sa.Column("role", sa.String(), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=True),
        sa.Column("avatar_emoji", sa.String(length=16), nullable=True),
        sa.Column("display_name", sa.String(length=18), nullable=True),
        sa.Column("group_code", sa.String(length=10), nullable=True),
        sa.Column("bio", sa.String(length=200), nullable=True),
        sa.Column("telegram_handle", sa.String(length=25), nullable=True),
    )
    op.create_index("ix_users_id", "users", ["id"])
    op.create_index("ix_users_email", "users", ["email"], unique=True)

    op.create_table(
        "news",
        sa.Column("id", sa.String(), primary_key=True, nullable=False),
        sa.Column("title", sa.String(), nullable=False),
        sa.Column("content", sa.Text(), nullable=False),
        sa.Column("image_url", sa.String(), nullable=True),
        sa.Column("author_id", sa.String(), nullable=False),
        sa.Column("created_at", sa.DateTime(), nullable=True),
    )
    op.create_index("ix_news_id", "news", ["id"])


def downgrade() -> None:
    op.drop_index("ix_news_id", table_name="news")
    op.drop_table("news")

    op.drop_index("ix_users_email", table_name="users")
    op.drop_index("ix_users_id", table_name="users")
    op.drop_table("users")

