import csv
import os
import sqlite3
import requests
from io import StringIO

DB_PATH = os.getenv("DB_PATH", "/data/ventes.db")