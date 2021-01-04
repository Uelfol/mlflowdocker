#!/usr/bin/env bash

mlflow server --backend-store-uri "$BACKEND_URI" --default-artifact-root "$MLFLOW_SERVER_DEFAULT_ARTIFACT_ROOT" --host 0.0.0.0