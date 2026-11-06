@REM ----------------------------------------------------------------------------
@REM AtelierCampus Maven Wrapper Script
@REM ----------------------------------------------------------------------------
@echo off
setlocal

set "MAVEN_HOME=C:\Users\samer\.m2\wrapper\dists\apache-maven-3.9.14\ed7edd442f634ac1c1ef5ba2b61b6d690b5221091f1a8e1123f5fadcc967520d"
if not defined JAVA_HOME (
    set "JAVA_HOME=C:\Program Files\Microsoft\jdk-17.0.21.21-hotspot"
)

if exist "%MAVEN_HOME%\bin\mvn.cmd" (
    "%MAVEN_HOME%\bin\mvn.cmd" %*
) else (
    mvn %*
)

