# PHYTedge Modbus Plugin Documentation

This repository contains comprehensive documentation for the PHYTedge Modbus Plugin, which enables seamless integration and data exchange between Modbus energy meters and various IoT cloud platforms, including AWS IoT Core, Cumulocity, and Thingsboard.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Documentation Structure](#documentation-structure)
- [How to Build the Documentation](#how-to-build-the-documentation)
- [How to View the Documentation in Your Browser](#how-to-view-the-documentation-in-your-browser)
- [Platform-Specific Guides](#platform-specific-guides)
- [Support](#support)

## Overview
The PHYTedge Modbus Plugin provides step-by-step instructions for connecting and configuring your energy meter devices with supported IoT platforms. The documentation covers prerequisites, configuration, certificate management, and troubleshooting tips for each platform.

## Features
- Detailed setup guides for AWS IoT Core, Cumulocity, and Thingsboard
- Visual walkthroughs with annotated screenshots
- Configuration and certificate management instructions
- Platform-specific troubleshooting notes

## Documentation Structure
- `source/` — reStructuredText (`.rst`) source files for each platform and topic
- `build/html/` — Generated HTML documentation (after build)
- `Makefile` / `make.bat` — Build scripts for Unix/Windows

## How to Build the Documentation
1. Ensure you have [Sphinx](https://www.sphinx-doc.org/) installed:
   ```bash
   pip install sphinx
   ```
2. From the project root, build the HTML documentation:
   ```bash
   make html
   ```
   This will generate the HTML files in the `build/html/` directory.

## How to View the Documentation in Your Browser
After building the documentation, open the main page in your web browser:

- **Linux/macOS/Windows:**
  1. Navigate to the `build/html/` directory:
     ```bash
     cd build/html
     ```
  2. Open `index.html` in your preferred browser. For example:
     ```bash
     xdg-open index.html   # Linux
     open index.html       # macOS
     start index.html      # Windows (cmd)
     ```

Alternatively, you can double-click the `index.html` file in your file manager to open it.

## Platform-Specific Guides
- **AWS IoT Core:** See `source/aws.rst`
- **Cumulocity:** See `source/cumulocity.rst`
- **Thingsboard:** See `source/thingsboard.rst`

Each guide provides:
- Account setup and prerequisites
- Device and certificate configuration
- Platform dashboard navigation
- Troubleshooting notes

## Support
For questions or support, please contact the PHYTEC India team or refer to the notes in each platform's documentation section.

---

© 2025 PHYTEC India. All rights reserved.
