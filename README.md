# SQL_Data_Cleaning
SQL scripts for cleaning and processing Nashville housing data.

This project showcases data cleaning techniques on a Nashville Housing dataset using SQL. The SQL scripts standardize dates, populate missing property addresses, break out address columns, and remove duplicate entries.

## Dataset Used
- **Nashville Housing Data**: Contains information about property sales, ownership, prices, and more in the Nashville area.

## SQL Queries
The project covers the following data cleaning tasks:
- **Standardizing Date Format**: Ensuring date fields are in a consistent format.
- **Populating Missing Property Addresses**: Using `ParcelID` to fill in missing property addresses.
- **Breaking Out Address Fields**: Splitting `PropertyAddress` and `OwnerAddress` into separate columns (e.g., Address, City, State).
- **Updating Boolean Fields**: Converting `Y/N` values to `Yes/No` in the `SoldAsVacant` column.
- **Removing Duplicate Rows**: Identifying and deleting duplicate records using `ROW_NUMBER`.
- **Exploratory Data Analysis**: Basic analysis of house prices, houses per land use, etc.

## Future Improvements
- Implementing more advanced data quality checks.
- Adding visualizations for deeper insights.
