#!/bin/bash
docker build --tag hanomi/vera-otus-mia-d1 .
docker run -p 8080:8080 hanomi/vera-otus-mia-d1



