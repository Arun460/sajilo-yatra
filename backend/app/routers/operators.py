from fastapi import APIRouter

router = APIRouter()


@router.get("")
@router.get("/")
def list_operators():
    return [
        {
            "id": 1,
            "name": "Sajha Yatayat",
            "description": "Public bus operator",
        },
        {
            "id": 2,
            "name": "Mahanagar Yatayat",
            "description": "City bus operator",
        },
    ]
