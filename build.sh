#!/bin/bash
docker build --tag hanomi/vera-otus-mia-d1 .
docker run -p 8000:8080 hanomi/vera-otus-mia-d1



