from pydantic import BaseModel
from typing import Optional, List

# =============================================
# STOP SCHEMAS
# =============================================
class StopSchema(BaseModel):
    id: int
    name: str
    latitude: float
    longitude: float
    area_name: Optional[str] = None
    district: Optional[str] = None

class StopCreateSchema(BaseModel):
    stop_name: str
    latitude: float
    longitude: float
    area_name: Optional[str] = None
    district: Optional[str] = None


# =============================================
# ROUTE SCHEMAS
# =============================================
class RouteStopSchema(BaseModel):
    id: int
    route_id: int
    stop_id: int
    stop_sequence: int
    original_stop_name: Optional[str] = None
    is_major_stop: bool = False


class RouteSchema(BaseModel):
    id: int
    route_id: str
    route_number: str
    direction: str
    origin_stop: Optional[str] = None
    destination_stop: Optional[str] = None
    operator_name: Optional[str] = None
    route_type: Optional[str] = None


class RouteSearchRequest(BaseModel):
    source_stop_id: int
    destination_stop_id: int
    max_transfers: Optional[int] = 3
    max_walking_distance: Optional[int] = 500


class RouteLeg(BaseModel):
    from_stop: StopSchema
    to_stop: StopSchema
    route: Optional[RouteSchema] = None
    mode: str  # 'bus', 'walking', 'transfer'
    duration_minutes: int
    distance_km: float


class RouteSearchResult(BaseModel):
    legs: List[RouteLeg]
    total_duration: int
    total_distance: float
    transfers: int


class RouteSearchResponse(BaseModel):
    success: bool
    routes: List[RouteSearchResult]
    message: Optional[str] = None