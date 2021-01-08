# Import Dates from CSV
Imports dates from a CSV file into an OpCon calendar.  The script supports doing this through the OpCon API or through traditional MSGIN.  If using the API option, you can also create a new calendar.

# Prerequisites
* OpCon 18.3+
* Powershell v5+
* <a href="https://github.com/SMATechnologies/opcon-rest-api-client-powershell">OpCon powershell module</a> (only if using the API option/s)

# Instructions
<B>Parameters</b>:
* path - Path to the csv file
* opconPath - [optional] Path to the OpCon API PS module
* msginPath - [optional] Path to the MSGIN folder
* url - [optional] URL to the OpCon API
* token - OpCon API token or password/token for MSGIN
* calendar - Name of the calendar to update or create
* extuser - [optional] Name of the user for MSGIN
* description - [optional] Description for the new calendar
* option - apiCreate, apiUpdate, msgin, test (for verifying the dates are correctly pulled from the CSV file)

```
powershell -ExecutionPolicy Bypass -File ".\CSV_ImportDates.ps1" -path "C:\dates.csv" -msginPath "C:\Program Files\OpConxps\SAM\MSGIN" -extuser "myUser" -token "12345" -calendar "Process XYZ"
```

# Disclaimer
No Support and No Warranty are provided by SMA Technologies for this project and related material. The use of this project's files is on your own risk.

SMA Technologies assumes no liability for damage caused by the usage of any of the files offered here via this Github repository.

# License
Copyright 2019 SMA Technologies

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

# Contributing
We love contributions, please read our [Contribution Guide](CONTRIBUTING.md) to get started!

# Code of Conduct
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](code-of-conduct.md)
SMA Technologies has adopted the [Contributor Covenant](CODE_OF_CONDUCT.md) as its Code of Conduct, and we expect project participants to adhere to it. Please read the [full text](CODE_OF_CONDUCT.md) so that you can understand what actions will and will not be tolerated.
