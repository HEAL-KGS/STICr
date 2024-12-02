## Package Style and Conventions

# Useful notes on creating an R package
- http://r-pkgs.had.co.nz/description.html
- http://r-pkgs.had.co.nz/vignettes.html
- http://r-pkgs.had.co.nz/check.html
- http://r-pkgs.had.co.nz/release.html
- https://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/
- https://github.com/ThinkR-open/prepare-for-cran
- http://www.masalmon.eu/2017/12/11/goodrpackages/

- To add a dependency: `devtools::use_package("packageName")`
- To style code: `styler:::style_active_pkg()`
- To check package: `devtools::check()`
- To generate documentation: `devtools::document()`
- To build vignettes: `devtools::build_vignettes()`
- To install package: `devtools::install("../STICr", build_vignettes = T)`

# Style
Goal: common style among all functions within the package. 
Solution: Use Hadley Wickham's guide http://r-pkgs.had.co.nz/style.html

When calling a function from a different package, make sure to explicitly
define the package (e.g. dplyr::summarize).

# Prepping for release
- Release steps: https://r-pkgs.org/release.html
- Set release: `usethis::use_release_issue()`
- Check on local machine: `devtools::check()`
- Check on CRAN win-builder, devel version: `devtools::check_win_devel()`
- Check on CRAN win-builder, release version: `devtools::check_win_release()`
- Check on mac, release version: `devtools::check_mac_release()`
- Update `cran-comments.md` and `NEWS.md`
- Submit to CRAN: `devtools::submit_cran()`
