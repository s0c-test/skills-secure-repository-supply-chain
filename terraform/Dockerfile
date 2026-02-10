# ❌ VULNERABILITY 1: Outdated Base Image
# node:10 is End-of-Life (EOL) and contains hundreds of vulnerabilities.
# Snyk will recommend upgrading to a newer version like node:20-bookworm-slim.
FROM node:10

# ❌ VULNERABILITY 2: Running as Root (High)
# By default, containers run as root. If compromised, the attacker has root access.
# Snyk will suggest using the 'USER' instruction.
WORKDIR /app

# ❌ VULNERABILITY 3: Installing unnecessary, vulnerable tools
# 'curl' and 'vim' add to the attack surface. 
# Older versions of these tools often have their own CVEs.
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

COPY . .

# ❌ VULNERABILITY 4: Hardcoded Sensitive Information (Critical)
# Snyk 'Container' and 'Code' will both flag hardcoded secrets.
ENV API_KEY="12345-ABCDE-SECRET-KEY"
ENV APP_DEBUG=true

# ❌ VULNERABILITY 5: Excessive Privileges
# Exposing low-numbered ports sometimes requires specific capabilities.
EXPOSE 80

CMD ["node", "index.js"]
