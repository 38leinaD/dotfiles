#!/usr/bin/env python
"""
title: Update openwebui tools via script
author: Daniel Platz
version: 0.0.1
"""
from typing import Dict
import requests
from requests.auth import HTTPBasicAuth
import json
import urllib.parse
import asyncio
import sys
import os

if len(sys.argv) < 2:
    print(f"Usage: {os.path.basename(__file__)} <FILE-TO-UPLOAD> <TOOL-ID>")
    quit(-1)

url = 'http://localhost:3000'
api_token = os.environ.get('OWUI_API_TOKEN')

if api_token == None:
    print(f"Please set environment variable OWUI_API_TOKEN with your openwebui JWT-token.")
    quit(-1)

auth_token = f"Bearer {api_token}"
file_to_upload = sys.argv[1]
tool_id = sys.argv[2]

print(f"Updating '{file_to_upload}' as tool '{tool_id}' in openwebui...")

response = requests.get(
    f"{url}/api/v1/tools/id/{tool_id}",
    headers={
        'Content-Type': 'application/json',
        'Authorization': auth_token
    }
)
response.raise_for_status()
tool = response.json()

with open('confluence.py', 'r') as file:
    file_content_to_upload = file.read()

response = requests.post(
    f"{url}/api/v1/utils/code/format",
    headers={
        'Content-Type': 'application/json',
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjE2MjQ1NWYxLWI1YTItNDFhYy1hMmY1LTFjOWNmZWYwMDFkNSJ9._NLl9D8j1YkjXQk2ViByMo-1f6Dvc__4NeUE1G-qDd0'
    },
    json={'code': file_content_to_upload}
)
response.raise_for_status()
formatted_code = response.json()['code']

response = requests.post(
    f"{url}/api/v1/tools/id/{tool_id}/update",
    headers={
        'Content-Type': 'application/json',
        'Authorization': auth_token
    },
    json={
        'access_control': None,
        'id': tool_id,
        'name': tool['name'],
        'meta': tool['meta'],
        'content': formatted_code
    }
)

response.raise_for_status()

print('\033[92mDone ' + u'\N{check mark}' + '\033[0m')