from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .config import settings
from .routers import route_finder, stops
from .seed import seed_db

app = FastAPI(
    title="Sajilo Yatra API", 
    description="Transit API for Kathmandu",
    version="1.0"
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include Routers
app.include_router(route_finder.router, prefix="/api/routes", tags=["Route Finder"])
app.include_router(stops.router, prefix="/api/stops", tags=["Stops"])

# =============================================
# ROOT ENDPOINT
# =============================================
@app.get("/")
def root():
    return {
        "message": "Sajilo Yatra API is running!",
        "status": "healthy",
        "version": "1.0",
        "endpoints": {
            "stops": {
                "/api/stops/": "Get all stops",
                "/api/stops/search?q=Kathmandu": "Search stops by name or area",
                "/api/stops/nearby?lat=27.7&lng=85.3": "Find nearby stops",
                "/api/stops/{id}": "Get stop by ID"
            },
            "routes": {
                "/api/routes/find?source=1&dest=2": "Find routes between stops"
            }
        }
    }

# =============================================
# STARTUP
# =============================================
@app.on_event("startup")
def startup_event():
    print("🚀 Starting Sajilo Yatra API...")
    print("📦 Initializing database and seeding...")
    seed_db()
    print("✅ Startup complete!")
    print("📍 Server running at http://localhost:8000")
    print("📚 API docs at http://localhost:8000/docs")