@echo off
if %1. ==. goto end
if not exist %1 (
    type nul > %1
) else (
    copy /b %1+,, %1 > nul
)