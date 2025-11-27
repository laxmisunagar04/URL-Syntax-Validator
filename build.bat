@echo off
echo Building URL Validator...
echo.

echo Cleaning previous builds...
del lex.yy.c 2>nul
del url_parser.tab.c 2>nul
del url_parser.tab.h 2>nul
del url_validator.exe 2>nul

echo Step 1: Generating parser with bison...
bison -d -v url_parser.y
if not exist url_parser.tab.c (
    echo ERROR: Bison failed!
    pause
    exit /b 1
)

echo Step 2: Generating lexer with flex...
flex url_lexer.l
if not exist lex.yy.c (
    echo ERROR: Flex failed!
    pause
    exit /b 1
)

echo Step 3: Compiling with GCC...
gcc -o url_validator url_parser.tab.c lex.yy.c
if not exist url_validator.exe (
    echo ERROR: Compilation failed!
    pause
    exit /b 1
)

echo.
echo ✅ Build successful! Testing now...
echo.
url_validator