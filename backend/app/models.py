from sqlalchemy import Column, String, Text, Float, Integer, ForeignKey, BigInteger
from sqlalchemy.orm import relationship
from .database import Base


class Stop(Base):
    __tablename__ = "stops"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    stop_name = Column(String(100), nullable=False)
    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)
    is_active = Column(Integer, default=1)
    route_stops = relationship("RouteStop", back_populates="stop")
    
class Route(Base):
    __tablename__ = "routes"
    
    id = Column(Integer, primary_key=True, autoincrement=True)  # ← INTEGER (matches SQL)
    route_id = Column(String(100), nullable=False, unique=True) # ← The actual Route_ID
    operator_id = Column(Integer, ForeignKey("operators.id"))   # ← You have operators table
    route_number = Column(String(20), nullable=False)
    direction = Column(String(20), nullable=False)
    origin_stop = Column(String(100))
    destination_stop = Column(String(100))
    route_type = Column(String(20), default="bus")
    is_active = Column(Integer, default=1)
    
    
    # Relationships
    route_stops = relationship("RouteStop", back_populates="route", order_by="RouteStop.stop_sequence")


class RouteStop(Base):
    __tablename__ = "route_stops"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    route_id = Column(Integer, ForeignKey("routes.id"), nullable=False)      # ← INTEGER (matches SQL)
    stop_id = Column(Integer, ForeignKey("stops.id"), nullable=False)        # ← INTEGER (matches SQL)
    stop_sequence = Column(Integer, nullable=False)                          # ← Matches SQL column name
    original_stop_name = Column(String(100))
    is_major_stop = Column(Integer, default=0)
   
    
    route = relationship("Route", back_populates="route_stops")
    stop = relationship("Stop", back_populates="route_stops")


class Transfer(Base):
    __tablename__ = "transfers"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    from_stop_id = Column(Integer, ForeignKey("stops.id"), nullable=False)   # ← INTEGER (matches SQL)
    to_stop_id = Column(Integer, ForeignKey("stops.id"), nullable=False)     # ← INTEGER (matches SQL)
    walking_time_min = Column(Integer, default=3)
    walking_distance_m = Column(Integer, default=200)
    
    from_stop = relationship("Stop", foreign_keys=[from_stop_id])
    to_stop = relationship("Stop", foreign_keys=[to_stop_id])


class RoutingNode(Base):
    __tablename__ = "routing_nodes"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    stop_id = Column(Integer, ForeignKey("stops.id"), nullable=False)        # ← INTEGER (matches SQL)
    route_id = Column(Integer, ForeignKey("routes.id"), nullable=True)       # ← INTEGER (matches SQL)
    lat = Column(Float, nullable=False)
    lon = Column(Float, nullable=False)
    
    stop = relationship("Stop")
    route = relationship("Route")
    
    outgoing_edges = relationship(
        "RoutingEdge", 
        foreign_keys="RoutingEdge.source_id", 
        back_populates="source_node"
    )
    incoming_edges = relationship(
        "RoutingEdge", 
        foreign_keys="RoutingEdge.target_id", 
        back_populates="target_node"
    )


class RoutingEdge(Base):
    __tablename__ = "routing_edges"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    source_id = Column(Integer, ForeignKey("routing_nodes.id"), nullable=False)
    target_id = Column(Integer, ForeignKey("routing_nodes.id"), nullable=False)
    route_id = Column(Integer, ForeignKey("routes.id"), nullable=True)       # ← INTEGER (matches SQL)
    cost_time = Column(Float, nullable=False)
    cost_transfers = Column(Float, nullable=False)
    distance_km = Column(Float, nullable=False)
    is_transfer = Column(Integer, default=0)
    reverse_cost = Column(Float, default=-1.0)
    
    source_node = relationship("RoutingNode", foreign_keys=[source_id], back_populates="outgoing_edges")
    target_node = relationship("RoutingNode", foreign_keys=[target_id], back_populates="incoming_edges")
    route = relationship("Route")