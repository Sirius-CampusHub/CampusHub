"""expand user limits

Revision ID: 0002_expand_user_limits
Revises: 0001_init_users_news
Create Date: 2024-05-24 15:00:00

"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = "0002_expand_user_limits"
down_revision = "0001_init_users_news"
branch_labels = None
depends_on = None


def upgrade() -> None:
    # 1. Изменяем display_name: с 18 до 30
    op.alter_column(
        "users",
        "display_name",
        existing_type=sa.String(length=18),
        type_=sa.String(length=30),
        existing_nullable=True,
    )

    # 2. Изменяем group_code: с 10 до 20
    op.alter_column(
        "users",
        "group_code",
        existing_type=sa.String(length=10),
        type_=sa.String(length=20),
        existing_nullable=True,
    )

    # 3. Изменяем telegram_handle: с 25 до 33
    op.alter_column(
        "users",
        "telegram_handle",
        existing_type=sa.String(length=25),
        type_=sa.String(length=33),
        existing_nullable=True,
    )


def downgrade() -> None:
    """
    При откате данные могут обрезаться, если они уже превышают старые лимиты.
    Postgres выдаст ошибку, если в поле будет строка длиннее нового (старого) лимита.
    """
    op.alter_column(
        "users",
        "telegram_handle",
        existing_type=sa.String(length=33),
        type_=sa.String(length=25),
        existing_nullable=True,
    )

    op.alter_column(
        "users",
        "group_code",
        existing_type=sa.String(length=20),
        type_=sa.String(length=10),
        existing_nullable=True,
    )

    op.alter_column(
        "users",
        "display_name",
        existing_type=sa.String(length=30),
        type_=sa.String(length=18),
        existing_nullable=True,
    )