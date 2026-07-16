from .database import SessionLocal, engine, Base
from .models import Stop, Route, RouteStop
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def seed_db():
    logger.info("Creating tables...")
    Base.metadata.create_all(bind=engine)

    db = SessionLocal()

    try:
        if db.query(Stop).first():
            logger.info("Database already seeded. Skipping.")
            return

        logger.info("Seeding stops...")
        stops = [
            Stop(stop_name="Ratnapark", latitude=27.7058, longitude=85.3148),
            Stop(stop_name="Tripureshwor", latitude=27.6946, longitude=85.3143),
            Stop(stop_name="Kalimati", latitude=27.6974, longitude=85.2974),
            Stop(stop_name="Kalanki", latitude=27.6931, longitude=85.2811),
            Stop(stop_name="Koteshwor", latitude=27.6811, longitude=85.3442),
            Stop(stop_name="Baneshwor", latitude=27.6922, longitude=85.3331),
            Stop(stop_name="Maitighar", latitude=27.6931, longitude=85.3217),
            Stop(stop_name="Putalisadak", latitude=27.7032, longitude=85.3214),
            Stop(stop_name="Jamal", latitude=27.7083, longitude=85.3150),
            Stop(stop_name="Lainchaur", latitude=27.7161, longitude=85.3148),
        ]
        db.add_all(stops)
        db.flush()

        stop_map = {stop.stop_name: stop.id for stop in stops}

        logger.info("Seeding routes...")
        routes = [
            Route(route_id="R1", route_number="01", direction="clockwise", origin_stop="Kalanki", destination_stop="Koteshwor", route_type="bus"),
            Route(route_id="R2", route_number="02", direction="loop", origin_stop="Ratnapark", destination_stop="Lainchaur", route_type="bus"),
        ]
        db.add_all(routes)
        db.flush()

        route_map = {route.route_id: route.id for route in routes}

        logger.info("Seeding route stops...")
        route_stops = [
            RouteStop(route_id=route_map["R1"], stop_id=stop_map["Kalanki"], stop_sequence=1, original_stop_name="Kalanki", is_major_stop=1),
            RouteStop(route_id=route_map["R1"], stop_id=stop_map["Maitighar"], stop_sequence=2, original_stop_name="Maitighar", is_major_stop=0),
            RouteStop(route_id=route_map["R1"], stop_id=stop_map["Koteshwor"], stop_sequence=3, original_stop_name="Koteshwor", is_major_stop=1),
            RouteStop(route_id=route_map["R2"], stop_id=stop_map["Ratnapark"], stop_sequence=1, original_stop_name="Ratnapark", is_major_stop=1),
            RouteStop(route_id=route_map["R2"], stop_id=stop_map["Tripureshwor"], stop_sequence=2, original_stop_name="Tripureshwor", is_major_stop=0),
            RouteStop(route_id=route_map["R2"], stop_id=stop_map["Kalimati"], stop_sequence=3, original_stop_name="Kalimati", is_major_stop=0),
            RouteStop(route_id=route_map["R2"], stop_id=stop_map["Kalanki"], stop_sequence=4, original_stop_name="Kalanki", is_major_stop=1),
        ]
        db.add_all(route_stops)

        db.commit()
        logger.info("Seeding complete.")

    except Exception as e:
        logger.error(f"Error seeding database: {e}")
        db.rollback()
    finally:
        db.close()


if __name__ == "__main__":
    seed_db()
