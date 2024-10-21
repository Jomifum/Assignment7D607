# Load necessary library
library(stringi)

# Read raw JSON data
raw_json <- readLines("C:/Users/Dell/Downloads/jsonformatA7.js", warn = FALSE)

# Remove non-UTF-8 characters
cleaned_json <- stri_replace_all_fixed(raw_json, "\u0097", "", vectorize = TRUE) # Removing specific invalid character
cleaned_json <- iconv(cleaned_json, from = "UTF-8", to = "UTF-8//IGNORE") # Ignore invalid UTF-8

# Convert cleaned text back to a single string
cleaned_json <- paste(cleaned_json, collapse = "\n")

# Print cleaned JSON for inspection
print(head(cleaned_json, 20))



#Exporting the HTML format

# Load the rvest package
library(rvest)

# Import HTML data
html_data <- read_html("C:/Users/Dell/Downloads/htmlformatA7.html")

# Extract tables (if applicable)
tables <- html_data %>% html_table()

# Check if there are any tables extracted
if (length(tables) > 0) {
  # Print the first table
  print(tables[[1]])
} else {
  print("No tables found in the HTML file.")
}


#Exporting the XML format

# Load the xml2 and dplyr packages
library(xml2)
library(dplyr)
library(purrr)

# Import XML data
xml_data <- read_xml("C:/Users/Dell/Downloads/xmlformatA7.xml")

# Convert to a data frame (if needed)
xml_df <- xml_data %>% xml_find_all(".//Item") %>% 
  map_dfr(~{
    # Extract values
    category <- xml_text(xml_find_first(.x, "Category"))
    item_name <- xml_text(xml_find_first(.x, "ItemName"))
    item_id <- xml_text(xml_find_first(.x, "ItemID"))
    brand <- xml_text(xml_find_first(.x, "Brand"))
    price <- as.numeric(xml_text(xml_find_first(.x, "Price")))
    
    # Extract variations
    variations <- xml_find_all(.x, "Variation")
    variation_ids <- map_chr(variations, ~ xml_text(xml_find_first(.x, "VariationID")))
    variation_details <- map_chr(variations, ~ xml_text(xml_find_first(.x, "VariationDetails")))
    
    # Create tibble with a list column for variations
    tibble(
      Category = category,
      ItemName = item_name,
      ItemID = item_id,
      Brand = brand,
      Price = price,
      VariationID = list(variation_ids),
      VariationDetails = list(variation_details)
    )
  })

# Print the XML data frame
print(xml_df)

#Creating a parquet format

# Install the arrow package if it's not already installed
if (!requireNamespace("arrow", quietly = TRUE)) {
  install.packages("arrow")
}

# Load necessary libraries
library(arrow)

# Create a data frame with the inventory data
inventory_data <- data.frame(
  Category = c("Electronics", "Electronics", "Home Appliances", "Home Appliances", "Clothing", "Clothing", "Clothing", "Clothing", "Books", "Books", "Books", "Books", "Sports Equipment", "Sports Equipment"),
  ItemName = c("Smartphone", "Smartphone", "Refrigerator", "Washing Machine", "T-Shirt", "T-Shirt", "T-Shirt", "Jeans", "Fiction Novel", "Fiction Novel", "Non-Fiction Guide", "Non-Fiction Guide", "Basketball", "Tennis Racket"),
  ItemID = c(101, 101, 201, 202, 301, 301, 301, 302, 401, 401, 402, 402, 501, 502),
  Brand = c("TechBrand", "TechBrand", "HomeCool", "CleanTech", "FashionCo", "FashionCo", "FashionCo", "DenimWorks", "-", "-", "-", "-", "SportsGear", "RacketPro"),
  Price = c(699.99, 699.99, 899.99, 499.99, 19.99, 19.99, 19.99, 49.99, 14.99, 14.99, 24.99, 24.99, 29.99, 89.99),
  VariationID = c("101-A", "101-B", "201-A", "202-A", "301-A", "301-B", "301-C", "302-A", "401-A", "401-B", "402-A", "402-B", "501-A", "502-A"),
  VariationDetails = c("Color: Black, Storage: 64GB", "Color: White, Storage: 128GB", "Color: Stainless Steel, Capacity: 20 cu ft", "Type: Front Load, Capacity: 4.5 cu ft", "Color: Blue, Size: S", "Color: Red, Size: M", "Color: Green, Size: L", "Color: Dark Blue, Size: 32", "Format: Hardcover, Language: English", "Format: Paperback, Language: Spanish", "Format: eBook, Language: English", "Format: Paperback, Language: French", "Size: Size 7, Color: Orange", "Material: Graphite, Color: Black")
)

# Specify the path to save the Parquet file
parquet_file_path <- "C:/Users/Dell/Downloads/CUNYMartInventory.parquet"

# Write the data frame to a Parquet file
write_parquet(inventory_data, parquet_file_path)

# Read the Parquet file back to confirm it was saved correctly
parquet_data <- read_parquet(parquet_file_path)

# Print the Parquet data
print(parquet_data)



## Pros and Cons
#3JSON is human-readable, supports complex structures, and is widely used in web applications,
#though it has a larger file size and isn't optimized for analytics. HTML is good for visual
#presentation and easily displayed in browsers but isn't suitable for data analysis and can be
#verbose. XML supports hierarchical data and has a well-defined structure but is verbose and less
#human-readable. Parquet is efficient for large datasets, supports nested structures, and is
#optimized for analytics, but is not human-readable and requires specific libraries. If the goal is 
#efficient data storage and analytics, Parquet is the best choice because its optimized performance
#for large datasets and complex structures outweighs its lack of human readability, making it ideal
#for inventory analysis and other data-driven tasks.**