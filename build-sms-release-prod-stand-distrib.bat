rem Сборка приложения для стенда PROD в ООО "СоюзМедСервис" из веток, имя которых указано в первом параметре запуске скрипта
if [%1] == [] goto :NO_BRANCH_NAME

set BRANCH_NAME=%1
set EFR_BACKEND_BASE_PATH=/efrapi
set EFR_BACKEND_TIMEOUT=50000
set EFR_PROXY_BASE_PATH=
set BACKEND_SERVER_HOST=192.168.33.201
set BACKEND_SERVER_HOST_2=192.168.33.202
set API_GATEWAY_PORT=8081
set EFR_PRESENTATION_BASE_PATH=/efr
set DB_HOST=192.168.33.205
set DB_HOST_2=192.168.33.206
set ES_CLUSTER_NAME=prod-systemjournal

set MAIL_SERVER_HOST=localhost
set MAIL_SERVER_FROM=test@example.org
set MAIL_SERVER_USERNAME=username
set MAIL_SERVER_PASSWORD=password
set MAIL_SERVER_SMTP_PORT=587

set WAR_SETTINGS_DIR=_sms-prod-stand
set DISTRIB_DIR_NAME=_distrib_sms_%BRANCH_NAME:/=_%_prod

call _build-distrib.bat %BRANCH_NAME%
goto END

:NO_BRANCH_NAME
echo "Branch name must be specified"

:END