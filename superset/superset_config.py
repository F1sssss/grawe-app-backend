# Superset specific config
ROW_LIMIT = 5000

# We added

SESSION_COOKIE_SAMESITE = None
ENABLE_PROXY_FIX = True
PUBLIC_ROLE_LIKE_GAMMA = True
FEATURE_FLAGS = {
    "EMBEDDED_SUPERSET": True
}
SQLALCHEMY_DATABASE_URI = 'postgresql://postgres:postgres@db:5432/superset'
TALISMAN_ENABLED = False
ENABLE_CORS = True
CORS_OPTIONS = {
  'supports_credentials': True,
  'allow_headers': ['*'],
  'resources':['*'],
  'origins': ["*"]
}
SESSION_COOKIE_SAMESITE = None
SESSION_COOKIE_SECURE = False
SESSION_COOKIE_HTTPONLY = False
WTF_CSRF_ENABLED = False

# Flask App Builder configuration
# Your App secret key will be used for securely signing the session cookie
# and encrypting sensitive information on the database
# Make sure you are changing this key for your deployment with a strong key.
# Alternatively you can set it with `SUPERSET_SECRET_KEY` environment variable.
# You MUST set this for production environments or the server will not refuse
# to start and you will see an error in the logs accordingly.
SECRET_KEY = '27893u1298sj189sj1298uej29m3u13p12mp31283u129083m1'

# The SQLAlchemy connection string to your database backend
# This connection defines the path to the database that stores your
# superset metadata (slices, connections, tables, dashboards, ...).
# Note that the connection information to connect to the datasources
# you want to explore are managed directly in the web UI
# The check_same_thread=false property ensures the sqlite client does not attempt
# to enforce single-threaded access, which may be problematic in some edge cases
SQLALCHEMY_DATABASE_URI = 'postgresql://superset:superset@host.docker.internal:5432/superset'

FEATURE_FLAGS = {
    "EMBEDDED_SUPERSET": True
}

HTTP_HEADERS = {'X-Frame-Options': 'ALLOWALL'}

# Flask-WTF flag for CSRF
# WTF_CSRF_ENABLED = True
# Add endpoints that need to be exempt from CSRF protection
WTF_CSRF_EXEMPT_LIST = []
# A CSRF token that expires in 1 year
WTF_CSRF_TIME_LIMIT = 60 * 60 * 24 * 365
GUEST_ROLE_NAME = "Gamma"

DATA_CACHE_CONFIG = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_KEY_PREFIX": "superset_results",  # make sure this string is unique to avoid collisions
    "CACHE_REDIS_URL": "redis://:Grawe123$@192.168.1.64:6379/1",
    "CACHE_DEFAULT_TIMEOUT": 35000,  # 60 seconds * 60 minutes * 24 hours
}

# FILTER_STATE_CACHE_CONFIG = {
#     'CACHE_TYPE': 'RedisCache',
#     'CACHE_DEFAULT_TIMEOUT': 86400,
#     'CACHE_KEY_PREFIX': 'superset_filter_cache',
#     'CACHE_REDIS_URL': 'redis://localhost:6379'
# }