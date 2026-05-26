#!/bin/bash
set -a && source .env && set +a
python scripts/seed/seed.py
