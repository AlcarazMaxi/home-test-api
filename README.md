# API Automation Tests — Karate + Java 17 + Maven

[![API Tests](https://github.com/AlcarazMaxi/api-tests/workflows/API%20Tests/badge.svg)](https://github.com/AlcarazMaxi/api-tests/actions)

## Overview

This repository contains comprehensive API automation tests for the demo application using **Karate Framework**, **Java 17**, and **Maven**.

## Features

- ✅ **Gherkin syntax**: BDD-style test scenarios
- ✅ **Schema validation**: JSON schema checks
- ✅ **Positive & negative tests**: Full coverage
- ✅ **Idempotency checks**: Safe retry validation
- ✅ **Data-driven testing**: Multiple test data sets
- ✅ **Parallel execution**: Fast test runs
- ✅ **HTML reports**: Beautiful Karate reports
- ✅ **Checkstyle & SpotBugs**: Code quality and static analysis
- ✅ **Spotless**: Code formatting
- ✅ **cspell**: English spelling enforcement
- ✅ **Docker support**: Containerized test execution
- ✅ **CI/CD ready**: GitHub Actions workflows

## Prerequisites

- **Java**: JDK 17 or higher
- **Maven**: 3.9.x or higher
- **Docker**: For running the demo app
- **OS**: Windows, macOS, or Linux

See [RUNBOOK.md](../RUNBOOK.md) for detailed installation instructions.

## Quick Start

### 1. Verify Java and Maven

```bash
java -version   # Should show 17.x.x
mvn -v          # Should show 3.9.x
```

### 2. Start the Demo App

```bash
docker run -d --name demo-app -p 3100:3100 automaticbytes/demo-app:latest
```

### 3. Run Tests

**All tests**:

**Windows (CMD)**:
```cmd
mvn clean test
```

**Windows (PowerShell)**:
```powershell
mvn clean test
```

**macOS/Linux**:
```bash
mvn clean test
```

**By tag**:

**Windows (CMD)**:
```cmd
mvn test -Dkarate.options="--tags @smoke"
```

**Windows (PowerShell)**:
```powershell
mvn test "-Dkarate.options=--tags @smoke"
```

**macOS/Linux**:
```bash
mvn test -Dkarate.options="--tags @smoke"
```

**Single scenario**:
```bash
mvn test -Dkarate.options="src/test/resources/features/inventory.feature:10"
```

### 4. View Reports

**Karate HTML report**: Open `target/karate-reports/karate-summary.html`

**Windows (CMD)**:
```cmd
start target\karate-reports\karate-summary.html
```

**macOS**:
```bash
open target/karate-reports/karate-summary.html
```

**Linux**:
```bash
xdg-open target/karate-reports/karate-summary.html
```

### 5. Run Quality Gates

**Format code**:
```bash
mvn spotless:apply
```

**Check style**:
```bash
mvn checkstyle:check
```

**Run SpotBugs**:
```bash
mvn spotbugs:check
```

**Spell checker**:
```bash
npx cspell "src/**/*.{java,feature,md}"
```

## Project Structure

```
api-tests/
├── .github/
│   └── workflows/
│       └── api-tests.yml                # CI/CD workflow
├── src/
│   ├── main/
│   │   └── resources/
│   │       └── checkstyle.xml           # Checkstyle config
│   └── test/
│       ├── java/
│       │   ├── runners/
│       │   │   └── TestRunner.java      # JUnit runner
│       │   └── utils/
│       │       └── TestUtils.java       # Utility functions
│       └── resources/
│           ├── features/
│           │   ├── inventory.feature    # Inventory tests
│           │   ├── inventory-negative.feature  # Negative tests
│           │   └── inventory-schema.feature    # Schema tests
│           ├── schemas/
│           │   └── inventory-schema.json       # JSON schema
│           ├── test-data/
│           │   └── inventory.json       # Test data
│           └── karate-config.js         # Karate configuration
├── scripts/
│   └── setup.bat                        # Setup script (Windows)
├── pom.xml                              # Maven configuration
├── spotbugs-exclude.xml                 # SpotBugs exclusions
├── cspell.config.cjs                    # cspell configuration
├── Dockerfile                           # Docker image for tests
├── .gitignore                           # Git ignore rules
└── README.md                            # This file
```

## Maven Profiles

### Default Profile (dev)

```bash
mvn clean test
```

### Performance Profile

```bash
mvn clean test -Pperf
```

Runs tests with:
- Thread count: 5
- Iterations: 100

## Test Tags

Tests are organized with tags for selective execution:

- `@smoke`: Critical API tests
- `@regression`: Full regression suite
- `@negative`: Negative/error tests
- `@schema`: Schema validation tests
- `@idempotent`: Idempotency checks

## Environment Variables

Set `BASE_URL` to override the default API endpoint:

**Windows (CMD)**:
```cmd
set BASE_URL=http://localhost:3100/api
mvn clean test
```

**Windows (PowerShell)**:
```powershell
$env:BASE_URL="http://localhost:3100/api"
mvn clean test
```

**macOS/Linux**:
```bash
export BASE_URL=http://localhost:3100/api
mvn clean test
```

## CI/CD

GitHub Actions workflow (`.github/workflows/api-tests.yml`) runs on:
- Push to `main` or `develop`
- Pull requests

**Matrix testing**:
- **OS**: Ubuntu, macOS, Windows

## Docker

**Build image**:
```bash
docker build -t api-tests .
```

**Run tests in container**:
```bash
docker run --rm --network=host api-tests
```

## Troubleshooting

### Windows

- **Multiple JDKs**: Set `JAVA_HOME` in System Environment Variables
- **PowerShell quoting**: Use double quotes around `-Dkarate.options="--tags @smoke"`
- **Docker not running**: Start Docker Desktop

### macOS

- **Java not found**: Add `export JAVA_HOME=$(/usr/libexec/java_home -v 17)` to `~/.zshrc`
- **Homebrew permissions**: Run `sudo chown -R $(whoami) /usr/local/lib/pkgconfig`

### Linux

- **Docker permission denied**: Add user to docker group: `sudo usermod -aG docker $USER`
- **Port already in use**: Kill process: `sudo lsof -ti:3100 | xargs sudo kill -9`

For more details, see [RUNBOOK.md](../RUNBOOK.md) Section 11.

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Commit changes: `git commit -am 'Add my feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Create a Pull Request

## License

MIT License. See [LICENSE](LICENSE) file for details.

## Support

For issues or questions, please open a GitHub issue or contact the QA team.

---

**Happy Testing!** 🥋
