	@echo OFF
<%0 set /p tab=
set tab=%tab:~0,1%

:main
goto default_options

:getopts
if /I %1 == -h goto usage
if /I %1 == -host set HOST=%2& shift
if /I %1 == -num-users set NUM_CLIENTS=%2& shift
if /I %1 == -hatch-rate set HATCH_RATE=%2& shift
if /I %1 == -num-requests set NUM_REQUESTS=%2& shift
if /I %1 == -web (
	set WEB_OPT=
	set NUM_REQUESTS_OPT=
)
shift
if not (%1) == () goto getopts
goto docker

:usage
echo Usage: run.bat [OPTIONS]
echo.
echo Performance tests against Ebiflow3
echo.
echo Options:
echo %tab%-h, %tab%%tab%%tab%Print usage.
echo %tab%-host, %tab%%tab%%tab%Host address (defaults to %HOST%).
echo %tab%-web, %tab%%tab%%tab%Enables web interface at localhost:8089 (disabled by default).
echo %tab%-num-users, %tab%%tab%Number of concurrent users (defaults to %NUM_CLIENTS%).
echo %tab%-hatch-rate, %tab%%tab%The rate per second in which users are spawned.
echo %tab%%tab%%tab%%tab%Only used if web console is disabled (defaults to 20% of number of users).
echo %tab%-num-requests, %tab%%tab%Number of requests to perform.
echo %tab%%tab%%tab%%tab%Only used if web console is disabled (defaults to %NUM_REQUESTS%).
exit 0

:default_options
set HOST=http://localhost
set WEB_OPT=--no-web
set NUM_CLIENTS=5
set /a HATCH_RATE=%NUM_CLIENTS% / 5 
set NUM_REQUESTS=50
set NUM_REQUESTS_OPT=-n %NUM_REQUESTS%
if (%1) == () goto docker
goto getopts

:docker
docker build -t perf-test .
if %errorlevel% neq 0 (
	exit /b %errorlevel%
)
set LOCUST_OPTS=-H %HOST% %WEB_OPT% -c %NUM_CLIENTS% -r %HATCH_RATE% %NUM_REQUESTS_OPT% --only-summary

docker run -it --rm -p 8089:8089 perf-test %LOCUST_OPTS%
exit /b %errorlevel%
