from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import text
from typing import List, Optional

from ..database import get_db
from ..schemas import StopSchema

router = APIRouter()


@router.get("/nearby", response_model=List[StopSchema])
def get_nearby_stops(
    lat: float,
    lng: float,
    radius_meters: int = Query(500, description="Search radius in meters"),
    db: Session = Depends(get_db),
):
    query = text("""
        SELECT id, stop_name AS name, latitude, longitude,
               COALESCE(area_name, '') AS area_name,
               COALESCE(district, '') AS district
        FROM stops
        WHERE ST_DWithin(
            geom::geography,
            ST_SetSRID(ST_MakePoint(:lng, :lat), 4326)::geography,
            :radius
        )
        AND is_active = 1
    """)

    results = db.execute(query, {"lng": lng, "lat": lat, "radius": radius_meters}).fetchall()
    return [
        StopSchema(
            id=row.id,
            name=row.name,
            latitude=row.latitude,
            longitude=row.longitude,
            area_name=row.area_name or None,
            district=row.district or None,
        )
        for row in results
    ]


@router.get("/", response_model=List[StopSchema])
def get_all_stops(
    limit: int = Query(100, description="Max results"),
    db: Session = Depends(get_db),
):
    query = text("""
        SELECT id, stop_name AS name, latitude, longitude,
               COALESCE(area_name, '') AS area_name,
               COALESCE(district, '') AS district
        FROM stops
        WHERE is_active = 1
        ORDER BY stop_name
        LIMIT :limit
    """)

    results = db.execute(query, {"limit": limit}).fetchall()
    return [
        StopSchema(
            id=row.id,
            name=row.name,
            latitude=row.latitude,
            longitude=row.longitude,
            area_name=row.area_name or None,
            district=row.district or None,
        )
        for row in results
    ]


@router.get("/search", response_model=List[StopSchema])
def search_stops(
    q: str = Query(..., min_length=1, description="Search query"),
    limit: int = Query(10, description="Max results"),
    db: Session = Depends(get_db),
):
    query = text("""
        SELECT id, stop_name AS name, latitude, longitude,
               COALESCE(area_name, '') AS area_name,
               COALESCE(district, '') AS district
        FROM stops
        WHERE is_active = 1
          AND (
            LOWER(stop_name) LIKE LOWER(:query)
            OR LOWER(COALESCE(area_name, '')) LIKE LOWER(:query)
            OR LOWER(COALESCE(district, '')) LIKE LOWER(:query)
          )
        ORDER BY stop_name
        LIMIT :limit
    """)

    results = db.execute(query, {"query": f"%{q}%", "limit": limit}).fetchall()
    return [
        StopSchema(
            id=row.id,
            name=row.name,
            latitude=row.latitude,
            longitude=row.longitude,
            area_name=row.area_name or None,
            district=row.district or None,
        )
        for row in results
    ]


@router.get("/{stop_id}", response_model=StopSchema)
def get_stop_by_id(stop_id: int, db: Session = Depends(get_db)):
    query = text("""
        SELECT id, stop_name AS name, latitude, longitude,
               COALESCE(area_name, '') AS area_name,
               COALESCE(district, '') AS district
        FROM stops
        WHERE id = :stop_id AND is_active = 1
    """)
    result = db.execute(query, {"stop_id": stop_id}).fetchone()
    if not result:
        raise HTTPException(status_code=404, detail="Stop not found")

    return StopSchema(
        id=result.id,
        name=result.name,
        latitude=result.latitude,
        longitude=result.longitude,
        area_name=result.area_name or None,
        district=result.district or None,
    )
