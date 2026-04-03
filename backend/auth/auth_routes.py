import fastapi
from fastapi import APIRouter, Depends, HTTPException, Request
import firebase_admin
from firebase_admin import auth, credentials

router = APIRouter(
    prefix="/auth",
    tags=["Auth"],
)

def get_current_user(request: Request):
    auth_header = request.headers.get('Authorization')
    if not auth_header or not auth_header.startswith('Bearer '):
        raise HTTPException(status_code=401, detail="Отсутствует или неверный токен")

    token = auth_header.split(' ')[1]
    try:
        decoded_token = auth.verify_id_token(token)
        return decoded_token
    except Exception as e:
        raise HTTPException(status_code=401, detail=f"Недействительный токен: {str(e)}")


@router.post("/init")
async def init_new_user(user: dict = Depends(get_current_user)):
    uid = user.get("uid")

    try:
        auth.set_custom_user_claims(uid, {"role": "student"})
        return {"status": "ok", "message": "Роль успешно назначена"}
    except Exception as e:
        raise HTTPException(status_code=500, detail="Ошибка при назначении роли")


@router.post("/admin-action")
async def do_something_secret(user: dict = Depends(get_current_user)):
    role = user.get("role", "student")
    if role != "council":
        raise HTTPException(status_code=403, detail="Доступ запрещен. Только для студсовета.")

    return {"message": "Секретное действие выполнено"}