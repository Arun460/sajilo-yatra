from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from ..database import get_db
from ..schemas import RouteSearchResponse
from ..services.routing_engine import find_routes

router = APIRouter()


@router.get("/find", response_model=RouteSearchResponse)
def find_routes_api(
    origin_lat: float,
    origin_lng: float,
    dest_lat: float,
    dest_lng: float,
    preference: str = "fastest",
    db: Session = Depends(get_db),
):
    routes = find_routes(db, origin_lat, origin_lng, dest_lat, dest_lng, preference)
    return RouteSearchResponse(success=True, routes=routes, message=None)
