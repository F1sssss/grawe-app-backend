import os

# Superset specific config
ROW_LIMIT = 5000

# Session configuration
SESSION_COOKIE_SAMESITE = None
ENABLE_PROXY_FIX = True
PUBLIC_ROLE_LIKE_GAMMA = True

# Feature flags
FEATURE_FLAGS = {
    "EMBEDDED_SUPERSET": os.environ.get("SUPERSET_FEATURE_EMBEDDED_SUPERSET", "true").lower() == "true"
}

# Database URI - Use environment variables
SQLALCHEMY_DATABASE_URI = os.environ.get("SQLALCHEMY_DATABASE_URI", "postgresql://superset:superset@host.docker.internal:5432/superset")

# Security settings
TALISMAN_ENABLED = False
ENABLE_CORS = True
CORS_OPTIONS = {
    'supports_credentials': True,
    'allow_headers': ['*'],
    'resources': ['*'],
    'origins': ["*"]
}
SESSION_COOKIE_SECURE = False
SESSION_COOKIE_HTTPONLY = False
WTF_CSRF_ENABLED = False

# Secret key from environment variable
SECRET_KEY = os.environ.get("SECRET_KEY", "27893u1298sj189sj1298uej29m3u13p12mp31283u129083m1")

# CSRF configuration
WTF_CSRF_EXEMPT_LIST = []
WTF_CSRF_TIME_LIMIT = 60 * 60 * 24 * 365
GUEST_ROLE_NAME = "Gamma"

# Redis cache configuration - Use environment variables
redis_password = os.environ.get("REDIS_PASSWORD", "Grawe123$")
redis_host = os.environ.get("REDIS_HOST", "192.168.192.1")
redis_port = os.environ.get("REDIS_PORT", "6379")
redis_db = os.environ.get("SUPERSET_REDIS_DB", "1")

DATA_CACHE_CONFIG = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_KEY_PREFIX": "superset_results",
    "CACHE_REDIS_URL": f"redis://:{redis_password}@{redis_host}:{redis_port}/{redis_db}",
    "CACHE_DEFAULT_TIMEOUT": 35000,
}

# Headers configuration
HTTP_HEADERS = {'X-Frame-Options': 'ALLOWALL'}