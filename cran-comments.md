# STICr 1.1.0

## Changes

 * Update `validate_stic_data` to produce a data frame, rather than directly create a confusion matrix and plot.
 * Update documentation and defaults for `qaqc_stic_data` to require user input for certain arguments that previously had defaults, and change argument name to `inspect_deviation` to align with output code.

# STICr 1.0.0

## Resubmission

This is a resubmission of 'STICr' to CRAN with typographical errors to the description corrected following the initial submission. The package was rechecked on the test environments and updated below.

## Test environments
 * local windows 11 install, R 4.4.1
 * r-devel-macosx-arm64 | 4.4.0 | macosx | macOS 13.3.1 (22E261) | (on mac-builder)
 * r-devel-x86_64-w64-mingw32 | 2024-09-25 r87194 ucrt | Windows Server 2022 x64 (build 20348) | (on win-builder)
 * r-release-x86_64-w64-mingw32 | 4.4.1 | Windows Server 2022 x64 (build 20348) | (on win-builder)
 
## R CMD check results

### local windows 11 install

0 errors | 0 warnings | 0 notes

### r-devel-macosx-arm64

0 errors | 0 warnings | 0 notes

### r-devel-x86_64-w64-mingw32

0 errors | 0 warnings | 1 note

NOTE: 'Checking incoming CRAN feasibility' returns 1 note with three potential issues.

 1. New submission: This is correct.
 2. Misspelled words: The words (STIC, et, and al) are spelled correctly.
 3. Possibly invalid URL: The URL is valid.

### r-release-x86_64-w64-mingw32

0 errors | 0 warnings | 1 note

NOTE: 'Checking incoming CRAN feasibility' returns 1 note with two potential issues.

 1. New submission: This is correct.
 2. Misspelled words: The words (STIC, et, and al) are spelled correctly.
