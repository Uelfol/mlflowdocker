FROM python:3.10.13-slim

# build variables.
ENV DEBIAN_FRONTEND noninteractive
ENV MLFLOW_SERVER_HOST 0.0.0.0
ENV MLFLOW_SERVER_DEFAULT_ARTIFACT_ROOT "wasbs://pocdemo@mflowpoc2.blob.core.windows.net"
ENV AZURE_STORAGE_ACCESS_KEY ""
ENV BACKEND_URI ""

# install Microsoft SQL Server requirements.
ENV ACCEPT_EULA=Y
RUN apt-get update -y && apt-get update \
  && apt-get install -y --no-install-recommends curl gcc g++ gnupg unixodbc-dev
  
# Add SQL Server ODBC Driver 17 for Ubuntu 18.04
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
  && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends --allow-unauthenticated msodbcsql17 mssql-tools \
  && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile \
  && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

# Set the working directory to /
WORKDIR /

# Copy the directory contents into the container at /
COPY . /

RUN apt-get update
RUN pip install -r requirements.txt

# clean the install.
RUN apt-get -y clean

ENTRYPOINT ["./startup.sh"]