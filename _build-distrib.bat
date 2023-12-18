rem Сборка приложения из веток, имя которых указано в первом параметре запуска скрипта
set BRANCH_NAME=%1

set AUTH-SERVICE-COMMIT=HEAD
set API-GATEWAY-COMMIT=HEAD
set INSURANCE-SERVICE-COMMIT=HEAD
set REGISTRATION-SERVICE-COMMIT=HEAD
set WEB-PRESENTATION-APP-COMMIT=HEAD
set WEB-PRESENTATION-CUSTOMERS-APP-COMMIT=HEAD

set SETTINGS_DIR=%CD%\_settings

rmdir %DISTRIB_DIR_NAME% /s /q
call cleanup.cmd

rem Create distrib
mkdir %DISTRIB_DIR_NAME%

rem Clone repositories
git clone -b %BRANCH_NAME% git@github.com:smed-service-rshb/auth-service.git
cd auth-service
git checkout %BRANCH_NAME%
echo auth-service branch/commit: >> ../%DISTRIB_DIR_NAME%/release_notes.txt
git rev-parse --abbrev-ref HEAD >> ../%DISTRIB_DIR_NAME%/release_notes.txt
git rev-parse HEAD >> ../%DISTRIB_DIR_NAME%/release_notes.txt
echo . >> ../%DISTRIB_DIR_NAME%/release_notes.txt
cd ..

git clone -b %BRANCH_NAME% git@github.com:smed-service-rshb/api-gateway.git
cd api-gateway
git checkout %BRANCH_NAME%
echo api-gateway branch/commit: >> ../%DISTRIB_DIR_NAME%/release_notes.txt
git rev-parse --abbrev-ref HEAD >> ../%DISTRIB_DIR_NAME%/release_notes.txt
git rev-parse HEAD >> ../%DISTRIB_DIR_NAME%/release_notes.txt
echo . >> ../%DISTRIB_DIR_NAME%/release_notes.txt
cd ..

git clone -b %BRANCH_NAME% git@github.com:smed-service-rshb/insurance-service.git
cd insurance-service
git checkout %BRANCH_NAME%
echo insurance-service branch/commit: >> ../%DISTRIB_DIR_NAME%/release_notes.txt
git rev-parse --abbrev-ref HEAD >> ../%DISTRIB_DIR_NAME%/release_notes.txt
git rev-parse HEAD >> ../%DISTRIB_DIR_NAME%/release_notes.txt
echo . >> ../%DISTRIB_DIR_NAME%/release_notes.txt
cd ..

rem Делаем запрос только последнего коммита, чтобы не ждать загрузки всего репозитория
git clone -b %BRANCH_NAME% git@github.com:smed-service-rshb/common-dict.git
cd common-dict
git checkout %BRANCH_NAME%
echo common-dict branch/commit: >> ../%DISTRIB_DIR_NAME%/release_notes.txt
git rev-parse --abbrev-ref HEAD >> ../%DISTRIB_DIR_NAME%/release_notes.txt
git rev-parse HEAD >> ../%DISTRIB_DIR_NAME%/release_notes.txt
echo . >> ../%DISTRIB_DIR_NAME%/release_notes.txt
cd ..

git clone -b %BRANCH_NAME% git@github.com:smed-service-rshb/web-presentation-app.git
cd web-presentation-app
git checkout %BRANCH_NAME%--hard %WEB-PRESENTATION-APP-COMMIT%
echo web-presentation-app branch/commit: >> ../%DISTRIB_DIR_NAME%/release_notes.txt
git rev-parse --abbrev-ref HEAD >> ../%DISTRIB_DIR_NAME%/release_notes.txt
git rev-parse HEAD >> ../%DISTRIB_DIR_NAME%/release_notes.txt
echo . >> ../%DISTRIB_DIR_NAME%/release_notes.txt
cd ..

rem Build projects
cd auth-service
echo D|xcopy %SETTINGS_DIR%\%WAR_SETTINGS_DIR%\auth-service\activemq-transport.properties auth-service-app\src\main\resources /Y
echo D|xcopy %SETTINGS_DIR%\%WAR_SETTINGS_DIR%\auth-service\hibernate.properties auth-service-app\src\main\resources /Y
echo D|xcopy %SETTINGS_DIR%\%WAR_SETTINGS_DIR%\auth-service\update.properties auth-service-app\src\main\resources /Y
echo D|xcopy %SETTINGS_DIR%\%WAR_SETTINGS_DIR%\auth-service\efr-logging.properties auth-service-app\src\main\resources /Y
call mvn clean package
cd ..

cd api-gateway
echo D|xcopy %SETTINGS_DIR%\%WAR_SETTINGS_DIR%\api-gateway\activemq-transport.properties app\src\main\resources /Y
echo D|xcopy %SETTINGS_DIR%\%WAR_SETTINGS_DIR%\api-gateway\jboss-web.xml app\src\main\webapp\WEB-INF /Y
call mvn clean package
cd ..

cd insurance-service
echo D|xcopy %SETTINGS_DIR%\%WAR_SETTINGS_DIR%\insurance-service\activemq-transport.properties insurance-service-app\src\main\resources /Y
echo D|xcopy %SETTINGS_DIR%\%WAR_SETTINGS_DIR%\insurance-service\hibernate.properties insurance-service-app\src\main\resources /Y
echo D|xcopy %SETTINGS_DIR%\%WAR_SETTINGS_DIR%\insurance-service\application.properties insurance-service-app\src\main\resources /Y
echo D|xcopy %SETTINGS_DIR%\%WAR_SETTINGS_DIR%\insurance-service\efr-logging.properties insurance-service-app\src\main\resources /Y
call mvn clean package
cd ..

cd common-dict
echo D|xcopy %SETTINGS_DIR%\%WAR_SETTINGS_DIR%\common-dict\activemq-transport.properties common-dict-app\src\main\resources /Y
echo D|xcopy %SETTINGS_DIR%\%WAR_SETTINGS_DIR%\common-dict\hibernate.properties common-dict-app\src\main\resources /Y
echo D|xcopy %SETTINGS_DIR%\%WAR_SETTINGS_DIR%\common-dict\dict-update.properties common-dict-app\src\main\resources /Y
echo D|xcopy %SETTINGS_DIR%\%WAR_SETTINGS_DIR%\common-dict\efr-logging.properties common-dict-app\src\main\resources /Y
call mvn clean package
cd ..

cd web-presentation-app
call npm run build
cd ..

echo F|xcopy auth-service\auth-service-app\target\*.war .\%DISTRIB_DIR_NAME%\auth-service.war
echo F|xcopy api-gateway\app\target\api-gateway.war .\%DISTRIB_DIR_NAME%\api-gateway.war
echo F|xcopy insurance-service\insurance-service-app\target\*.war .\%DISTRIB_DIR_NAME%\insurance-service.war
echo F|xcopy common-dict\common-dict-app\target\*.war .\%DISTRIB_DIR_NAME%\common-dict.war
cd %DISTRIB_DIR_NAME%
mkdir nginx
cd nginx
mkdir nginx-static
cd ..
mkdir db-scripts
mkdir wildfly
cd ..

echo D|xcopy web-presentation-app\build\static .\%DISTRIB_DIR_NAME%\nginx\nginx-static /S
ren .\%DISTRIB_DIR_NAME%\nginx\nginx-static\index.html.tpl index.html
echo D|xcopy %SETTINGS_DIR%\start-page .\%DISTRIB_DIR_NAME%\nginx\nginx-static /S
echo D|xcopy %SETTINGS_DIR%\flyway .\%DISTRIB_DIR_NAME%\db-scripts\_flyway /S

echo D|xcopy auth-service\auth-service-app\build\scripts .\%DISTRIB_DIR_NAME%\db-scripts\auth_service /S
echo D|xcopy %SETTINGS_DIR%\%WAR_SETTINGS_DIR%\auth-service\flyway.conf .\%DISTRIB_DIR_NAME%\db-scripts\auth_service /S
echo D|xcopy %SETTINGS_DIR%\migrate-db.bat .\%DISTRIB_DIR_NAME%\db-scripts\auth_service /S
echo D|xcopy %SETTINGS_DIR%\migrate-db .\%DISTRIB_DIR_NAME%\db-scripts\auth_service /S
echo D|xcopy %SETTINGS_DIR%\baseline-db.bat .\%DISTRIB_DIR_NAME%\db-scripts\auth_service /S
echo D|xcopy %SETTINGS_DIR%\baseline-db .\%DISTRIB_DIR_NAME%\db-scripts\auth_service /S

echo D|xcopy insurance-service\insurance-service-app\build\scripts .\%DISTRIB_DIR_NAME%\db-scripts\insurance_service /S
echo D|xcopy %SETTINGS_DIR%\%WAR_SETTINGS_DIR%\insurance-service\flyway.conf .\%DISTRIB_DIR_NAME%\db-scripts\insurance_service /S
echo D|xcopy %SETTINGS_DIR%\migrate-db.bat .\%DISTRIB_DIR_NAME%\db-scripts\insurance_service /S
echo D|xcopy %SETTINGS_DIR%\migrate-db .\%DISTRIB_DIR_NAME%\db-scripts\insurance_service /S
echo D|xcopy %SETTINGS_DIR%\baseline-db.bat .\%DISTRIB_DIR_NAME%\db-scripts\insurance_service /S
echo D|xcopy %SETTINGS_DIR%\baseline-db .\%DISTRIB_DIR_NAME%\db-scripts\insurance_service /S

echo D|xcopy common-dict\common-dict-app\build\scripts .\%DISTRIB_DIR_NAME%\db-scripts\common_dict /S
echo D|xcopy %SETTINGS_DIR%\%WAR_SETTINGS_DIR%\common-dict\flyway.conf .\%DISTRIB_DIR_NAME%\db-scripts\common_dict /S
echo D|xcopy %SETTINGS_DIR%\migrate-db.bat .\%DISTRIB_DIR_NAME%\db-scripts\common_dict /S
echo D|xcopy %SETTINGS_DIR%\migrate-db .\%DISTRIB_DIR_NAME%\db-scripts\common_dict /S
echo D|xcopy %SETTINGS_DIR%\baseline-db.bat .\%DISTRIB_DIR_NAME%\db-scripts\common_dict /S
echo D|xcopy %SETTINGS_DIR%\baseline-db .\%DISTRIB_DIR_NAME%\db-scripts\common_dict /S

echo D|xcopy %SETTINGS_DIR%\nginx .\%DISTRIB_DIR_NAME%\nginx /S
echo D|xcopy %SETTINGS_DIR%\wildfly .\%DISTRIB_DIR_NAME%\wildfly /S

jjs prepare-nginx-settings.js
jjs prepare-index-html.js
jjs prepare-wildfly-settings.js
