from pydantic_settings import BaseSettings, SettingsConfigDict
from typing import List


class Settings(BaseSettings):
    database_url: str

    allowed_origins: str = "http://localhost:3000,http://localhost:8080"

    model_config = SettingsConfigDict(
        env_file=".env"
    )

    @property
    def cors_origins(self) -> List[str]:
        return [origin.strip() for origin in self.allowed_origins.split(",")]


settings = Settings()