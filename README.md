# Bash Script: Automatic Folder Organizer

This Bash script organizes files in a folder based on extensions defined in a configuration file. Files are sorted into subfolders corresponding to their categories, and a report is generated with information about the organization.

## Features

- Organizes files in a folder based on their extensions.
- Uses an `extension.txt` file to define categories and associated extensions.
- Copies files to a new folder before organizing them.
- Generates an `info.txt` file containing the number of files per category and additional details (date, user, etc.).

## Prerequisites

- **Bash**: The script is designed to run in a Bash terminal.
- An `extension.txt` file with the following format:
  ```plaintext
  Category1: extension1, extension2
  Category2: extension3, extension4
  ```

## Installation

* Download the script and make it executable:
```bash
chmod +x organizer.sh
```
* Prepare an extension.txt file with the necessary categories and extensions.

## Usage

* Run the script in the terminal:
```bash
./organizer.sh
```
* Follow the on-screen instructions:
    - Provide the path to the folder you want to organize.
    - Provide the path to the extension.txt file.

* Files will be copied to a new folder named Files_\<user\> inside the target folder and then sorted into subfolders.

## The info.txt File

An info.txt file will be generated in the Files_<user> folder. It contains:

* The number of files in each category.
* The total number of files.
* The date of organization.
* The username of the person running the script.

## Warnings
Files will be moved to the corresponding subfolders.
Ensure you have the necessary permissions to access the specified files and folders.

## Contributions

Contributions are welcome! If you find a bug or want to add a feature, feel free to open an issue or submit a pull request.

## License

This project is distributed under the MIT License. See the LICENSE file for more details.
