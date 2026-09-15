# =============================================================================
# Highridge / NXU Assignment — Step 6
# Unzip "Employee Profile.zip" (created by the Python notebook) and display
# the employee data it contains, using base R.
# =============================================================================

zip_path <- "Employee Profile.zip"
extract_dir <- "Employee Profile"

unzip_and_display <- function(zip_file, out_dir) {
  # 1. Make sure the zip file actually exists before doing anything else
  if (!file.exists(zip_file)) {
    stop(sprintf(
      "Could not find '%s'. Run the Python notebook first — it generates this zip in Step 5.",
      zip_file
    ))
  }

  # 2. Unzip it, wrapped in error handling in case the archive is corrupt
  #    or unreadable
  result <- tryCatch({
    unzip(zip_file, exdir = ".")
    TRUE
  }, warning = function(w) {
    message(paste("Warning while unzipping:", conditionMessage(w)))
    TRUE
  }, error = function(e) {
    message(paste("Failed to unzip archive:", conditionMessage(e)))
    FALSE
  })

  if (!isTRUE(result)) {
    return(invisible(NULL))
  }

  # 3. Confirm the extracted folder actually exists
  if (!dir.exists(out_dir)) {
    stop(sprintf("Expected folder '%s' was not found after unzipping.", out_dir))
  }

  # 4. Find CSV files inside the extracted folder
  csv_files <- list.files(out_dir, pattern = "\\.csv$", full.names = TRUE)

  if (length(csv_files) == 0) {
    message(sprintf("No CSV files found inside '%s'.", out_dir))
    return(invisible(NULL))
  }

  # 5. Read and display each CSV file, handling any read errors individually
  #    so one bad file doesn't stop the rest from displaying
  for (csv_file in csv_files) {
    cat("\n", strrep("=", 60), "\n", sep = "")
    cat("File:", csv_file, "\n")
    cat(strrep("=", 60), "\n")

    employee_data <- tryCatch({
      read.csv(csv_file, stringsAsFactors = FALSE)
    }, error = function(e) {
      message(paste("Could not read", csv_file, "-", conditionMessage(e)))
      NULL
    })

    if (!is.null(employee_data)) {
      print(employee_data)
    }
  }
}

unzip_and_display(zip_path, extract_dir)
