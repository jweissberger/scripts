#!/usr/bin/env python3

## Author: Josh Allan 2024

import os
import fnmatch


items = []

directory = os.getcwd()

# Iterate through the directory
for root, dirs, files in os.walk(directory):
    for filename in fnmatch.filter(files, "*.*"):
        file_path = os.path.join(root, filename)
        try:
            with open(file_path, "r", encoding="utf-8", errors="ignore") as file:
                for line in file:
                    for item in items:
                        if item in line:
                            print(f"Match found in {file_path}: {line.strip()}")
        except Exception as e:
            print(f"Could not read {file_path}: {e}")
