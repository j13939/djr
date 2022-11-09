#!/bin/bash 

# set required versions
MIN_GIT_VERSION=1.7.9
MIN_JAVA_VERSION=1.8
MAX_JAVA_VERSION=1.8

# software download
FLEXDEPLOY_SOFTWARE_DOWNLOAD_URL=https://flexagon.com/downloads/completedistribution/Tomcat
FLEXDEPLOY_ALT_SOFTWARE_DOWNLOAD_URL=https://flexagon.com/downloads/completedistribution/Tomcat/Tomcat_Complete-${ALTERNATE_FLEXDEPLOY_SOFTWARE_VERSION}.zip

# minimum file system sizes in MB
MIN_WORKING_DIRECTORY_SIZE=10000
MIN_ARTIFACT_REPO_DIRECTORY_SIZE=10000
MIN_UPGRADE_BACKUP_DIRECTORY_SIZE=1000
MIN_INFLUX_DB_DIRECTORY_SIZE=2000
MIN_BACKUP_DATABASE_DIRECTORY_SIZE=10000

# size factor adjustment if running a POV, all minimum file system sizes will be adjusted by this factor
DIRECTORY_SIZE_FACTOR=.5

# max time to wait before killing the tomcat server in seconds
MAX_TIME_TO_WAIT_FOR_STOP=30
STOP_WAIT_TIME=2

# for error message
WARN=0
EXIT=1

# for different modes
STANDARD=0
POV=1

# install state
INSTALL=0
UPGRADE=1
UPGRADE_FROM_WLS=2

FLEXDEPLOY_DOWNLOAD_DIRECTORY=${FLEXDEPLOY_INSTALLER_HOME}/downloads
FLEXDEPLOY_DOWNLOAD_SOFTWARE=${FLEXDEPLOY_DOWNLOAD_DIRECTORY}/software
FLEXDEPLOY_DOWNLOAD_WALLETS=${FLEXDEPLOY_DOWNLOAD_DIRECTORY}/wallets
FLEXDEPLOY_DOWNLOAD_INFLUX_DB=${FLEXDEPLOY_DOWNLOAD_DIRECTORY}/influxdb
INFLUX_DB_FILE=influxdb2-2.2.0-linux-amd64.tar.gz
INFLUX_DB_CLIENT_FILE=influxdb2-client-2.2.1-linux-amd64.tar.gz
INFLUX_DB_DOWNLOAD_URL=https://dl.influxdata.com/influxdb/releases
INFLUX_DB_CONFIG=${INFLUX_DB_DIRECTORY}/config
INFLUX_DB_LOG_FILE=${INFLUX_DB_LOGS}/influxd.log
INFLUX_DB_VSM_DATA=${WORKING_DIRECTORY}/vsm

TEMP_DIR=${FLEXDEPLOY_INSTALLER_HOME}/temp
SOFTWARE_TEMP=${TEMP_DIR}/software
CONFIG_TEMP=${TEMP_DIR}/config
DRIVER_TEMP=${TEMP_DIR}/driver
WALLET_TEMP=${TEMP_DIR}/wallets
INFLUX_DB_TEMP=${TEMP_DIR}/influxdb
PLUGIN_TEMP=${SOFTWARE_TEMP}/application/plugins

MANIFEST_DIR=META-INF
MANIFEST_FILE=${MANIFEST_DIR}/MANIFEST.MF
DOWNLOAD_FILE=TomcatComplete.zip
TOMCAT_SERVER_XML=server.xml
TOMCAT_CONTEXT_XML=context.xml
CONTEXT_XML_ORACLE=context-oracle.xml
CONTEXT_XML_POSTGRES=context-postgresql.xml
TOMCAT_DIR=apache-tomcat-flexdeploy
TOMCAT_LIB=${TOMCAT_DIR}/lib
TOMCAT_LIBEXT=${TOMCAT_DIR}/libext
TOMCAT_CONF=${TOMCAT_DIR}/conf
TOMCAT_LOGS=${TOMCAT_DIR}/logs
TOMCAT_WEBAPP=${TOMCAT_DIR}/webapps
TOMCAT_BIN=${TOMCAT_DIR}/bin
FLEXDEPLOY_WAR=${TOMCAT_WEBAPP}/flexdeploy.war
DATABASE_WALLET_DIRECTORY=${FLEXDEPLOY_HOME}/.wallets

UPGRADE_BASE_DIRECTORY=${FLEXDEPLOY_HOME}/upgrade

LOG_DIR=${UPGRADE_BASE_DIRECTORY}/logs
LOG_FILE=${LOG_DIR}/log.txt
LOG_DATA_FILE=${LOG_DIR}/logData.txt

SETENV_FILE=setenv.sh
SETENVOVERRIDE_FILE=setenvoverride.sh
SETENVOVERRIDE_DIR=${FLEXDEPLOY_HOME}/${TOMCAT_BIN}

FLEXDEPLOY_DB_USER=fd_admin
DB_UTIL_CLASSPATH=${FLEXDEPLOY_INSTALLER_HOME}/scripts/jars/DatabaseManagement.jar:${FLEXDEPLOY_INSTALLER_HOME}/scripts/jars/flyway-core-4.2.0.jar:${FLEXDEPLOY_INSTALLER_HOME}/scripts/jars/postgresql-42.4.0.jar:${FLEXDEPLOY_HOME}/${TOMCAT_LIBEXT}/ojdbc8.jar

# this classpath uses the unzipped ojdbc8.jar as the prerequisites are prior to any content being layed down so instead of laying it down too early, just use this for the connection test only
PREREQ_DB_UTIL_CLASSPATH=${FLEXDEPLOY_INSTALLER_HOME}/scripts/jars/DatabaseManagement.jar:${FLEXDEPLOY_INSTALLER_HOME}/scripts/jars/flyway-core-4.2.0.jar:${FLEXDEPLOY_INSTALLER_HOME}/scripts/jars/postgresql-42.4.0.jar:${DRIVER_TEMP}/ojdbc8-full/ojdbc8.jar

# influxDB constants
ULIMIT_DESCRIPTOR_MAX=16384

SKIP_PLUGIN_SIZE_CHECK=0
SKIP_ARTIFACT_SIZE_CHECK=0