// cspell configuration for English only
module.exports = {
  version: "0.2",
  language: "en-US", // Enforce English
  dictionaries: ["java", "maven", "bash"],
  words: [
    // Test framework terms
    "karate", "gherkin", "junit", "surefire",
    // Project-specific terms
    "dockercompose", "spotbugs",
    // Common tech abbreviations
    "checkstyle", "spotless", "gitignore"
  ],
  ignorePatterns: [
    "target/**",
    "*.jar",
    "*.class",
    "pom.xml"
  ]
};

