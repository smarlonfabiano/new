#!/bin/bash

# Security Vulnerability Assessment Script
# =======================================
#
# This script scans a codebase for common security vulnerabilities and potential attack vectors.
# It provides a comprehensive report of findings and recommendations for remediation.
#
# Usage: ./security_scan.sh [directory_to_scan]
#
# If no directory is specified, it will scan the current directory.

# Set text colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner function
print_banner() {
    echo -e "${BLUE}"
    echo "============================================================"
    echo "                Security Vulnerability Scanner               "
    echo "============================================================"
    echo -e "${NC}"
}

# Function to print section headers
print_section() {
    echo -e "\n${YELLOW}[$1]${NC}"
    echo "------------------------------------------------------------"
}

# Function to print findings
print_finding() {
    local severity=$1
    local message=$2
    
    case $severity in
        "HIGH")
            echo -e "${RED}[HIGH] $message${NC}"
            ;;
        "MEDIUM")
            echo -e "${YELLOW}[MEDIUM] $message${NC}"
            ;;
        "LOW")
            echo -e "${GREEN}[LOW] $message${NC}"
            ;;
        *)
            echo -e "$message"
            ;;
    esac
}

# Check if a directory was provided
if [ -z "$1" ]; then
    SCAN_DIR="."
else
    SCAN_DIR="$1"
fi

# Verify the directory exists
if [ ! -d "$SCAN_DIR" ]; then
    echo -e "${RED}Error: Directory '$SCAN_DIR' does not exist.${NC}"
    exit 1
fi

print_banner
echo "Scanning directory: $SCAN_DIR"
echo "Started at: $(date)"
echo

# =======================================
# VULNERABILITY #1: HARDCODED CREDENTIALS
# =======================================
# Description: Hardcoded credentials in source code are a significant security risk.
# Attackers who gain access to the source code can easily extract these credentials.
# This check looks for potential passwords, API keys, tokens, and other secrets.
# Risk: HIGH - Exposed credentials can lead to unauthorized access to systems and data.

print_section "Checking for Hardcoded Credentials"

# Common patterns for credentials
grep -r -E "password|passwd|pwd|secret|key|token|api_key|apikey|auth|credential" \
    --include="*.{js,py,php,rb,java,cs,go,sh,xml,json,yaml,yml,conf,cfg,ini,env}" \
    "$SCAN_DIR" 2>/dev/null | grep -v "security_scan.sh" | while read -r line; do
    print_finding "HIGH" "Potential hardcoded credential: $line"
done

# =======================================
# VULNERABILITY #2: SQL INJECTION
# =======================================
# Description: SQL injection occurs when user input is directly incorporated into SQL queries.
# Attackers can manipulate these inputs to execute arbitrary SQL commands.
# Risk: HIGH - Can lead to unauthorized data access, data manipulation, or complete system compromise.

print_section "Checking for SQL Injection Vulnerabilities"

# Look for SQL query construction patterns
grep -r -E "SELECT .* FROM .* WHERE .*\$|UPDATE .* SET .*\$|INSERT INTO .*\$|DELETE FROM .*\$" \
    --include="*.{js,py,php,rb,java,cs,go}" \
    "$SCAN_DIR" 2>/dev/null | grep -v "prepared" | grep -v "parameterized" | while read -r line; do
    print_finding "HIGH" "Potential SQL injection: $line"
done

# =======================================
# VULNERABILITY #3: CROSS-SITE SCRIPTING (XSS)
# =======================================
# Description: XSS allows attackers to inject malicious scripts into web pages viewed by users.
# These scripts can steal cookies, session tokens, or redirect users to malicious sites.
# Risk: HIGH - Can lead to session hijacking, credential theft, and phishing attacks.

print_section "Checking for Cross-Site Scripting (XSS) Vulnerabilities"

# Look for unescaped output in web templates/code
grep -r -E "innerHTML|document\.write|eval\(|setTimeout\(" \
    --include="*.{js,html,php,jsp,asp,cshtml}" \
    "$SCAN_DIR" 2>/dev/null | while read -r line; do
    print_finding "HIGH" "Potential XSS vulnerability: $line"
done

# =======================================
# VULNERABILITY #4: COMMAND INJECTION
# =======================================
# Description: Command injection occurs when user input is passed to system shell commands.
# Attackers can inject additional commands to be executed by the operating system.
# Risk: HIGH - Can lead to complete system compromise and remote code execution.

print_section "Checking for Command Injection Vulnerabilities"

# Look for system command execution
grep -r -E "system\(|exec\(|popen\(|subprocess|child_process|shell_exec|passthru\(|eval\(" \
    --include="*.{js,py,php,rb,java,cs,go,sh}" \
    "$SCAN_DIR" 2>/dev/null | while read -r line; do
    print_finding "HIGH" "Potential command injection: $line"
done

# =======================================
# VULNERABILITY #5: INSECURE DESERIALIZATION
# =======================================
# Description: Insecure deserialization occurs when untrusted data is deserialized by an application.
# Attackers can manipulate serialized objects to achieve code execution or DoS attacks.
# Risk: HIGH - Can lead to remote code execution and application compromise.

print_section "Checking for Insecure Deserialization"

# Look for deserialization functions
grep -r -E "pickle\.loads|unserialize\(|ObjectInputStream|yaml\.load|Marshal\.load|eval\(" \
    --include="*.{py,php,java,rb,js}" \
    "$SCAN_DIR" 2>/dev/null | while read -r line; do
    print_finding "HIGH" "Potential insecure deserialization: $line"
done

# =======================================
# VULNERABILITY #6: INSECURE FILE OPERATIONS
# =======================================
# Description: Insecure file operations can lead to path traversal, arbitrary file read/write.
# Attackers can access sensitive files or overwrite critical system files.
# Risk: HIGH - Can lead to information disclosure or system compromise.

print_section "Checking for Insecure File Operations"

# Look for file operations with potential path traversal
grep -r -E "open\(|fopen\(|FileInputStream|readFile|writeFile" \
    --include="*.{py,php,java,rb,js,go,cs}" \
    "$SCAN_DIR" 2>/dev/null | grep -E "\.\.|\/tmp\/|\/var\/|\/etc\/" | while read -r line; do
    print_finding "MEDIUM" "Potential insecure file operation: $line"
done

# =======================================
# VULNERABILITY #7: INSECURE CRYPTOGRAPHY
# =======================================
# Description: Weak cryptographic algorithms or improper implementation can compromise data security.
# Attackers can decrypt sensitive data or bypass authentication mechanisms.
# Risk: MEDIUM - Can lead to information disclosure and authentication bypass.

print_section "Checking for Insecure Cryptography"

# Look for weak crypto algorithms
grep -r -E "MD5|SHA1|DES|RC4|ECB mode" \
    --include="*.{py,php,java,rb,js,go,cs,c,cpp}" \
    "$SCAN_DIR" 2>/dev/null | while read -r line; do
    print_finding "MEDIUM" "Potential weak cryptography: $line"
done

# =======================================
# VULNERABILITY #8: INSECURE DIRECT OBJECT REFERENCES (IDOR)
# =======================================
# Description: IDOR occurs when an application provides direct access to objects based on user input.
# Attackers can manipulate these references to access unauthorized data.
# Risk: MEDIUM - Can lead to unauthorized data access and data leakage.

print_section "Checking for Insecure Direct Object References"

# Look for URL patterns with IDs
grep -r -E "\/api\/.*\/[0-9]+|\/user\/[0-9]+|\/account\/[0-9]+" \
    --include="*.{js,py,php,rb,java,cs,go,html}" \
    "$SCAN_DIR" 2>/dev/null | while read -r line; do
    print_finding "MEDIUM" "Potential IDOR vulnerability: $line"
done

# =======================================
# VULNERABILITY #9: CROSS-SITE REQUEST FORGERY (CSRF)
# =======================================
# Description: CSRF forces authenticated users to execute unwanted actions on web applications.
# Attackers can trick users into performing actions without their knowledge.
# Risk: MEDIUM - Can lead to unauthorized actions performed on behalf of authenticated users.

print_section "Checking for CSRF Vulnerabilities"

# Look for forms without CSRF tokens
grep -r -E "<form" --include="*.{html,php,jsp,asp,cshtml}" "$SCAN_DIR" 2>/dev/null | 
    grep -v -E "csrf|token|nonce" | while read -r line; do
    print_finding "MEDIUM" "Potential CSRF vulnerability (form without token): $line"
done

# =======================================
# VULNERABILITY #10: SECURITY MISCONFIGURATION
# =======================================
# Description: Security misconfigurations include default credentials, verbose error messages,
# exposed sensitive files, and unnecessary features enabled.
# Risk: MEDIUM - Can provide attackers with information to plan further attacks.

print_section "Checking for Security Misconfigurations"

# Check for config files with potential issues
find "$SCAN_DIR" -type f -name "*.conf" -o -name "*.config" -o -name "*.ini" -o -name "*.json" -o -name "*.xml" -o -name "*.yml" -o -name "*.yaml" 2>/dev/null | 
    xargs grep -l -E "debug|development|test|password|secret|key" 2>/dev/null | while read -r file; do
    print_finding "MEDIUM" "Potential security misconfiguration in config file: $file"
done

# =======================================
# VULNERABILITY #11: SENSITIVE DATA EXPOSURE
# =======================================
# Description: Sensitive data exposure occurs when an application does not adequately protect sensitive information.
# This includes PII, financial data, healthcare information, and credentials.
# Risk: HIGH - Can lead to data breaches, identity theft, and fraud.

print_section "Checking for Sensitive Data Exposure"

# Look for potential PII data patterns
grep -r -E "social security|ssn|credit card|passport|driver license|birth date|address|phone number" \
    --include="*.{js,py,php,rb,java,cs,go,html,txt}" \
    "$SCAN_DIR" 2>/dev/null | while read -r line; do
    print_finding "HIGH" "Potential sensitive data exposure: $line"
done

# =======================================
# VULNERABILITY #12: BROKEN AUTHENTICATION
# =======================================
# Description: Broken authentication occurs when authentication mechanisms are implemented incorrectly.
# This includes weak passwords, improper session management, and insecure credential storage.
# Risk: HIGH - Can lead to account takeover and unauthorized access.

print_section "Checking for Broken Authentication"

# Look for weak authentication mechanisms
grep -r -E "login|authenticate|password|session" \
    --include="*.{js,py,php,rb,java,cs,go}" \
    "$SCAN_DIR" 2>/dev/null | grep -v "bcrypt\|scrypt\|pbkdf2\|argon2" | while read -r line; do
    print_finding "HIGH" "Potential broken authentication: $line"
done

# =======================================
# VULNERABILITY #13: PROMPT INJECTION
# =======================================
# Description: Prompt injection is a vulnerability specific to AI systems where malicious input
# can manipulate the AI to perform unintended actions or reveal sensitive information.
# Risk: MEDIUM - Can lead to AI system manipulation and information disclosure.

print_section "Checking for Prompt Injection Vulnerabilities"

# Look for potential prompt injection patterns
grep -r -E "ignore all previous instructions|disregard|system prompt|pretend to be|you are now|you're now|act as if" \
    --include="*.{txt,md,html,js,py,php}" \
    "$SCAN_DIR" 2>/dev/null | while read -r line; do
    print_finding "MEDIUM" "Potential prompt injection attempt: $line"
done

# =======================================
# VULNERABILITY #14: DEPENDENCY VULNERABILITIES
# =======================================
# Description: Using outdated or vulnerable dependencies can introduce security issues.
# Attackers can exploit known vulnerabilities in these dependencies.
# Risk: MEDIUM - Can lead to various security issues depending on the vulnerability.

print_section "Checking for Dependency Vulnerabilities"

# Check for package files
find "$SCAN_DIR" -name "package.json" -o -name "requirements.txt" -o -name "Gemfile" -o -name "pom.xml" -o -name "build.gradle" 2>/dev/null | 
    while read -r file; do
    print_finding "MEDIUM" "Dependency file found (should be checked with a dedicated tool): $file"
done

# =======================================
# VULNERABILITY #15: LOGGING AND MONITORING ISSUES
# =======================================
# Description: Insufficient logging and monitoring can prevent detection of attacks and breaches.
# Proper logging is essential for incident response and forensic analysis.
# Risk: LOW - Can lead to delayed detection of security incidents.

print_section "Checking for Logging and Monitoring Issues"

# Look for logging statements
grep -r -E "log\.|logger\.|console\.log|print|echo|puts" \
    --include="*.{js,py,php,rb,java,cs,go}" \
    "$SCAN_DIR" 2>/dev/null | grep -v "error\|exception\|fail\|warn" | wc -l | 
    while read -r count; do
    if [ "$count" -lt 10 ]; then
        print_finding "LOW" "Potentially insufficient logging detected (only $count log statements found)"
    fi
done

# =======================================
# SUMMARY AND RECOMMENDATIONS
# =======================================

print_section "Summary and Recommendations"

echo "This security scan provides an initial assessment of potential vulnerabilities."
echo "False positives are possible, and manual review is recommended for all findings."
echo
echo "General Security Recommendations:"
echo "1. Implement input validation for all user inputs"
echo "2. Use parameterized queries for database operations"
echo "3. Implement proper authentication and session management"
echo "4. Apply the principle of least privilege"
echo "5. Keep all dependencies and libraries updated"
echo "6. Implement proper error handling and logging"
echo "7. Use HTTPS for all communications"
echo "8. Implement Content Security Policy (CSP)"
echo "9. Use secure coding practices and follow OWASP guidelines"
echo "10. Conduct regular security audits and penetration testing"
echo
echo "Scan completed at: $(date)"
echo -e "${BLUE}============================================================${NC}"

exit 0